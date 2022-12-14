`default_nettype none
`timescale 1ns / 1ps

module transmit (
    input wire clk,
    input wire [7:0] byte_in, 
    input wire valid_in,
    input wire rst,
    output logic eth_rstn,
    output logic eth_txen,
    output wire eth_refclk, 
    output logic [1:0] eth_txd
);  

    logic buffer_valid, buffer_done, prev_buffer, flag, state, crc_done;
    logic [1:0] buffer_out, bitorder_in;
    logic [8:0] index;
    logic [31:0] fcs;


    fifo_data_buffer buffer(
        .clk(clk),
        .rst(btnc),
        .valid_in(valid_in),
        .byte_in(byte_in),
        .axiov(buffer_valid),
        .buffer_done(buffer_done),
        .axiod(buffer_out)
    );

    crc32 fcs_gen (
        .clk(clk), 
        .rst(crc_rst), 
        .axiiv(buffer_valid), 
        .axiid(buffer_out), 
        .axiov(crc_done), 
        .axiod(fcs));

    bitorder bitorder(
        .clk(clk),
        .rst(btnc),
        .axiiv(buffer_valid),
        .axiid(buffer_out),
        .axiov(eth_txen),
        .axiod(eth_txd)
    );

    always_comb begin
        if (~prev_buffer && buffer_done) begin
            flag = 1'b1;
        end else begin
            flag = 1'b0;
        end
    end

    always_ff @(posedge clk) begin
        prev_buffer <= buffer_done;
        if (rst || state) begin
            buffer_valid <= 1'b0;
            eth_txen <= 1'b0;
            index <= 63;
        end else if (flag) begin
            if (index > 1) begin
                eth_txd <= fcs[index -: 2];
                eth_txen <= 1'b1;
                index <= index - 2;
            end else if (index == 1) begin
                eth_txd <= fcs[index -: 2];
                eth_txen <= 1'b1;
                state <= 1'b1;
            end
        end
    end
endmodule

`default_nettype wire