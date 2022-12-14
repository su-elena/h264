`default_nettype none
`timescale 1ns / 1ps

module rgb_to_yuv (clk, rst, valid_in, r, g, b, y, cr, cb, valid_out);

    input wire clk, rst, valid_in;
    input wire [8:0] r, g, b;
    output logic [23:0] pixel_out;
    output logic valid_out;

    logic [23:0] y, cb, cr;
    logic prev_valid; 

    always_ff @(posedge clk) begin
        prev_valid <= valid_in;
        valid_out <= prev_valid;
        pixel_out <= {y[7:0], cb[7:0], cr[7:0]};
        if (rst) begin
            valid_out <= 1'b0;
        end else if (valid_in) begin
            y <= 16 + (((r << 6) + (r << 1) + (g << 7) + g + (b << 4) + (b << 3) + b) << 8);
            cb <=  128 + ((-((r << 5) + (r << 2) + (r << 1)) - ((g << 6) + (g << 3) + (g << 1)) + (b << 7) - (b << 4)) >> 8);
            cr <= 128 + (((r << 7) - (r << 4) - ((g << 6) + (g << 5) - (g << 1)) - (b << 4) + (b << 1)) >> 8);
        end
    end
endmodule

`default_nettype wire