`default_nettype none
`timescale 1ns / 1ps


module cavlc_encoder_tb;
  logic clk;
  logic rst;
//   logic axiid;
  logic axiiv;
  logic axiov;
  logic [20:0] axiod;
//   logic [7:0] dout;
  //
  logic [3:0]num_coeff;
  logic [1:0]t1_s;
//N_upper
  logic nu_valid;
  logic [1:0]nu;
//N_left
  logic nl_valid;
  logic [1:0]nl;
//Chroma_DC
  logic is_chroma_DC;
//   logic byte_available;
//   logic ready;
  //My Ether State Machine Module
  cavlc_encoder cavlc_encoder(
    //Inputs
    .clk(clk),
    .rst(rst),
    .axiiv(axiiv),
    // .axiid(axiid), //TBD TBD TBD TBD!!!!!!
    .axiov(axiov),
    .axiod(axiod),

    .num_coeff(num_coeff),
    .t1_s(t1_s),
    //N_upper
    .nu_valid(nu_valid),
    .nu(nu),
    //N_left
    .nl_valid(nl_valid),
    .nl(nl),
    //Chroma_DC
    .is_chroma_DC(is_chroma_DC));


    //To Write variables
    // num_coeff
    // t1_s
    // nu_valid
    // nu
    // nl_valid
    // nl
    // is_chroma_DC
    // axiiv
    // axiid


    // .clk(clk),
    // .rst(rst),
    // .axiid(axiid),
    // .axiiv(axiiv),
    // .byte_available(byte_available),
    // .dout(dout),
    // .ready(ready),
    // //Outputs
    // .axiov(axiov),
    // .axiod(axiod));

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("cavlc_encoder_tb.vcd");
    $dumpvars(0, cavlc_encoder_tb);
    $display("Starting Sim");
    clk = 0;
    rst = 0;
    
    #30;
    rst = 1;
    #20;
    rst = 0;
    // #20;
    // axiid = 0;
    // axiiv = 1;
    // num_coeff = ;
    // t1_s =  ;
    // nu_valid = ;
    // nu = ;
    // nl_valid =  ;
    // nl = ;
    // is_chroma_DC = ;
    // // axiiv = ;
    // // axiid = ;
    // #20;
    // axiiv = 0;
    #80;
    // axiid = 0;
    //Basic Example #1
    axiiv = 1;
    num_coeff = 0;
    t1_s =  0;
    nu_valid =  0;
    nu = 2;
    nl_valid =  0 ;
    nl = 2;
    is_chroma_DC = 0;    
    // #80;
    #80;
    axiiv =0;
    #80;
    //Basic example #2
    axiiv = 1;
    num_coeff = 1;
    t1_s =  0;
    nu_valid =  0;
    nu = 2;
    nl_valid =  0 ;
    nl = 2;
    is_chroma_DC = 0;  
    #80;
    axiiv =0;

    #80;
    //Both Nl and Nu valid
    axiiv = 1;
    num_coeff = 2;
    t1_s =  0;
    nu_valid =  0;
    nu = 2;
    nl_valid =  0;
    nl = 2;
    is_chroma_DC = 0; 
    #80;
    axiiv =0;
 
    #80;
    axiiv = 1;
    num_coeff = 2;
    t1_s =  0;
    nu_valid =  1;
    nu = 1;
    nl_valid =  1 ;
    nl = 2;
    is_chroma_DC = 0;  
    #80;
    // // byte_available =0;

    // #20;
    // // byte_available =1;
    // // dout = 8'b11110000;


    // #20;
    // // byte_available =0;


    // #20;
    // // byte_available =1;
    // // dout = 8'b00001111;



    // #20;
    // // ready = 1;
    // #20;
    // // ready = 0;
    // // byte_available =0;
    // axiid = 1;
    // axiiv = 1;
    // #20;
    // byte_available = 1;
    // dout = 8'b10000001;
    // #20;
    // byte_available = 0;
    // #20;
    // byte_available = 1;
    // dout =  8'b01111110;
    // #20;
    // byte_available =0;
    // #20;
    // byte_available =1;
    // dout = 8'b11110000;
    // #20;
    // byte_available =0;
    // #20;
    // byte_available =1;
    // dout = 8'b00001111;
    // #40;
    // ready = 1;
    // #20
  
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
