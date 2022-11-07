`default_nettype none
`timescale 1ns / 1ps

module cksum(
    input wire clk, 
    input wire rst,
    input wire axiiv, 
    input wire [1:0] axiid,
    output logic done, 
    output logic kill
);
    logic crc_rst, crc_done, lfsr_start, prev_axiiv;
    logic [1:0] lfsr_in;
    logic [31:0] cksum;
    assign crc_rst = ((rst) || ((prev_axiiv && ~axiiv) && ~rst));
    assign lfsr_start = ((~prev_axiiv && axiiv) && ~rst);

    crc32 lfsr (
        .clk(clk), 
        .rst(crc_rst), 
        .axiiv(axiiv), 
        .axiid(axiid), 
        .axiov(crc_done), 
        .axiod(cksum));


    always_ff @(posedge clk) begin
        if (rst) begin
            done <= 1'b0;
            kill <= 1'b0; 
            prev_axiiv <= 0;
        end else begin
            prev_axiiv <= axiiv; 
        end
      
        if ((~prev_axiiv && axiiv) && ~rst) begin
            kill <= 1'b0;
            done <= 1'b0;
        end
        

      if ((prev_axiiv && ~axiiv) && ~rst) begin
            done <= 1'b1;
            if (cksum != 32'h38FB2284) begin
                kill <= 1'b1;
            end 
        end
    end 
endmodule

`default_nettype wire
