`default_nettype none
`timescale 1ns / 1ps
// initially: first BRAM for write-ins, second for readouts. write pixels into first BRAM until it is full; swap BRAM roles.

module macroblock_gen (
    input wire clk, 
    input wire rst, 
    input wire valid_in, 
    input wire [23:0] pixel_in,
    output wire valid_out,
    output wire [15:0][15:0] macroblock [23:0]
    );

    xilinx_true_dual_port_read_first_1_clock_ram #(
        .RAM_WIDTH(24),
        .RAM_DEPTH(76800)
    ) bram_buffer (
        .addra(write_counter),
        .addrb(write_counter),
        .dina(pixel_in),
        .dinb(0),
        .clka(clk),
        .wea(1),
        .web(0),
        .ena(1),
        .enb(1),
        .rsta(rst),
        .rstb(rst),
        .regcea(1),
        .regceb(1),
        .douta(),
        .doutb(data_out)
    );

    logic [23:0] write_counter;

    always_ff @(posedge clk) begin
        
    end
endmodule

`default_nettype wire