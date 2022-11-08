`default_nettype none
`timescale 1ns / 1ps

// This module takes in input data and computes the FCS, which is generated
// by running CRC32-BZIP2 over the entirety of the input data. Data comes
// in dibits: MSB, MSb. 

module fcs_gen (
    input wire clk, rst, axiiv,
    input wire [1:0] axiid,
    output logic [31:0] cksum,
    output logic axiov
);

    logic crc_rst, crc_done, prev_axiiv;
    logic [31:0] fcs;
    assign crc_rst = ((rst) || ((prev_axiiv && ~axiiv) && ~rst));

    crc32 fcs_gen (
        .clk(clk), 
        .rst(crc_rst), 
        .axiiv(axiiv), 
        .axiid(axiid), 
        .axiov(crc_done), 
        .axiod(fcs));

    always_ff @(posedge clk) begin
        if (rst) begin
            axiov <= 1'b0;
            prev_axiiv <= 0;
        end else begin
            prev_axiiv <= axiiv; 
        end
      
        if ((~prev_axiiv && axiiv) && ~rst) begin
            axiov <= 1'b0;
        end
        
        if ((prev_axiiv && ~axiiv) && ~rst) begin
            axiov <= 1'b1;
            cksum <= fcs; 
        end
    end
endmodule

`default_nettype wire

