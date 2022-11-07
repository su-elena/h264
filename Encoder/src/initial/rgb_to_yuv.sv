`default nettype none
`timescale 1ns / 1ps

module rgb_to_yuv (clk, rst, r, g, b, y, u, v);

    input wire clk, rst, valid_in;
    input wire [6:0] r, g, b;
    output logic [6:0] y, u, v;

    always_ff @(posedge clk) begin
        
    end
endmodule

`default nettype wire