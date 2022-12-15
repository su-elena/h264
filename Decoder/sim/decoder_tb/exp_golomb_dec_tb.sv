`default_nettype none
`timescale 1ns / 1ps


module exp_golomb_enc_tb;
  logic clk;
  logic rst;
	logic [15:0] axiid;
	logic axiiv;
	logic axiov;
	logic[8:0] axiod;
  logic [7:0] dout;
  logic byte_available;
  logic ready;
  //My Ether State Machine Module
  exp_golomb_decoder exp_golomb_dec(
    //Inputs
    .clk(clk),
    .rst(rst),
    .axiid(axiid),
    .axiiv(axiiv),
    .axiov(axiov),
    .axiod(axiod));

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("exp_golomb_decoder.vcd");
    $dumpvars(0, exp_golomb_enc_tb);
    $display("Starting Sim");
    clk = 0;
    rst = 0;
    
    #30;
    rst = 1;
    #20;
    rst = 0;
    #80;
    axiiv = 0;
    #20;
    axiiv = 1;
    axiid = 15'b000_0000_0000_0011;
    #20;
    axiiv = 0;
    #100;
    axiiv = 1;
    axiid = 15'b000_0000_0010_0100;
    #20;
    axiiv = 0;
    #100;
    axiiv = 1;
    axiid = 15'b000_0000_0010_0101;
    #20;
    axiiv = 0;
    #40
    axiiv = 1;
    axiid = 15'b000_0000_0010_0110;
    #20;
    axiiv = 0;
    #40
    axiiv = 1;
    axiid = 15'b000_0000_0010_0111;
    #20;
    axiiv = 0;
    #40
    axiiv = 1;
    axiid = 15'b000_0000_1000_1000;
    #20;
    axiiv = 0;
    #40
    axiiv = 1;
    axiid = 15'b000_0000_1000_1001;
    #20;
    axiiv = 0;
    #40  
     // axiiv = 0;
    // #40;
    // axiid = 2;
    // axiiv = 1;
    // #20;
    // axiiv = 0;
    // #40;
    // axiid = 3;
    // axiiv = 1;
    // #20;
    // axiiv = 0;
    // #40;
    // axiid = 4;
    // axiiv = 1;
    // #20;
    // axiiv = 0;
    // #40;
    // axiid = 5;
    // axiiv = 1;
    // #20;
    // axiiv = 0;
    // #40;
    // axiid = 6;
    // axiiv = 1;
    // #80;

    $display("Finishing Sim");
    $finish;
    end
  
endmodule //ether_tb

`default_nettype wire
