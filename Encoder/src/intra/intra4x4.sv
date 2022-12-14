`default_nettype none
`timescale 1ns / 1ps

module intra4x4 (
    input wire clk,
    input wire rst,
    input wire [15:0][15:0] macroblock [23:0],
    input wire valid_in,
    output wire [15:0][15:0] residuals [23:0],
    output wire valid_out
);

endmodule
`default_nettype wire

