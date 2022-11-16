`default nettype none
`timescale 1ns / 1ps

// goal: output a continual stream of dibits: preamble, SFD, header, data. 
// Stream is in MSB/MSb format, for input into bitorder.

module fifo_data_buffer (
    input wire clk, rst, valid_in,
    input wire [7:0] byte_in,
    output logic axiov,
    output logic [1:0] axiod
);

    typedef enum {IDLE, HARDCODED_OUT, DATA_OUT} states;
    states state;

    logic [47:0] source_addr, dest_addr;
    logic [15:0] ethertype;
    logic [175:0] hardcoded;
    logic [11:0] write_counter, read_counter, initial_count;
    logic [2:0] dibit_counter;
    logic buffer_full, buffer_empty, buffer_ready, transmit_flag;
    logic [7:0] byte_out;

    assign buffer_full = (write_counter == 1499);
    assign source_addr = 48'hF00DDEADBEEF;
    assign dest_addr = 48'hF00DDEADBEEF;
    assign ethertype = 16'h0800;
    assign hardcoded = {56'h55555555555555, 8'hD5, dest_addr, source_addr, ethertype};

    xilinx_true_dual_port_read_first_1_clock_ram #(
        .RAM_WIDTH(8),
        .RAM_DEPTH(1500)
    ) bram_buffer (
        .addra(write_counter),
        .addrb(read_counter),
        .dina(byte_in),
        .dinb(),
        .clka(clk),
        .wea(~buffer_full && buffer_ready),
        .web(0),
        .ena(1),
        .enb(1),
        .rsta(rst),
        .rstb(rst),
        .regcea(1),
        .regceb(1),
        .douta(),
        .doutb(byte_out)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
           state <= IDLE;
           buffer_ready <= 1'b1;
        end

        else if (valid_in) begin
            //increment the write address when we receive new bytes
            write_counter <= write_counter + 1;
            transmit_flag <= 1'b1;
            if (write_counter == 1500) begin
                buffer_full <= 1'b1;
            end
        end else if (~valid_in) begin
            //disable writes
            buffer_ready <= 1'b0;
            write_counter <= 0;
        end

        if (state == IDLE) begin
            // no transmission
            axiov <= 1'b0;
            initial_count <= 0;
            read_counter <= 1'b0;
            dibit_counter <= 3'b0;
            if (transmit_flag) begin
                state <= HARDCODED_OUT; 
            end
        end else if (state == HARDCODED_OUT) begin
            axiov <= 1'b1;
            if (initial_count < 88) begin
                initial_count <= initial_count + 1;
                hardcoded <= {hardcoded[175:0], hardcoded[176:175]};
                axiod <= hardcoded[176:175];
            end else if (initial_count == 88) begin
                initial_count <= 0;
                state <= DATA_OUT;
            end
        end else if (state == DATA_OUT) begin
            if (read_counter == write_counter) begin
                if (dibit_counter < 3) begin
                    dibit_counter <= dibit_counter + 1;
                    axiod <= byte_out[7:6];
                    byte_out <= {byte_out[5:0], byte_out[7:6]};
                end else if (dibit_counter == 3) begin
                    state <= IDLE;
                    buffer_ready <= 1'b1;
                end
            end
        end
    end
endmodule

`default nettype wire