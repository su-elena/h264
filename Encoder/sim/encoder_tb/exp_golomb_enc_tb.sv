`default_nettype none
`timescale 1ns / 1ps


module exp_golomb_enc_tb;
  logic clk;
  logic rst;
	logic [8:0] axiid;
	logic axiiv;
	logic axiov;
	logic[15:0] axiod;
  logic [7:0] dout;
  logic byte_available;
  logic ready;
  //My Ether State Machine Module
  exp_golomb_enc_look_up exp_golomb_enc(
    //Inputs
    .clk(clk),
    .rst(rst),
    .axiid(axiid),
    .axiiv(axiiv),
    .byte_available(byte_available),
    .dout(dout),
    .ready(ready),
    //Outputs
    .axiov(axiov),
    .axiod(axiod));

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("exp_golomb_encoder.vcd");
    $dumpvars(0, exp_golomb_enc_tb);
    $display("Starting Sim");
    clk = 0;
    rst = 0;
    
    #30;
    rst = 1;
    #20;
    rst = 0;
    #20;
    ready = 0;
    axiid = 0;
    axiiv = 1;
    #20;
    byte_available = 1;
    dout = 8'b10000001;
    #20;
    byte_available = 0;
    #20;
    byte_available = 1;
    dout =  8'b01111110;
    #20;
    byte_available =0;
    #20;
    byte_available =1;
    dout = 8'b11110000;
    #20;
    byte_available =0;
    #20;
    byte_available =1;
    dout = 8'b00001111;
    #20;
    ready = 1;
    #20;
    ready = 0;
    byte_available =0;
    axiid = 1;
    axiiv = 1;
    #20;
    byte_available = 1;
    dout = 8'b10000001;
    #20;
    byte_available = 0;
    #20;
    byte_available = 1;
    dout =  8'b01111110;
    #20;
    byte_available =0;
    #20;
    byte_available =1;
    dout = 8'b11110000;
    #20;
    byte_available =0;
    #20;
    byte_available =1;
    dout = 8'b00001111;
    #40;
    ready = 1;
    #20
  
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
