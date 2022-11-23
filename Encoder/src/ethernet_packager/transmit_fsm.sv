`default_nettype none
`timescale 1ns / 1ps

module transmit (
    input wire clk,
    input wire byte_in, 
    input wire valid_in,
    input wire btnc,
    output logic eth_rstn,
    output logic eth_txen,
    output wire eth_refclk, 
    output logic [1:0] eth_txd
);  

    logic buffer_valid;
    logic [1:0] buffer_out;


    fifo_data_buffer buffer(
        .clk(clk),
        .rst(btnc),
        .valid_in(valid_in),
        .byte_in(byte_in),
        .axiov(buffer_valid),
        .axiod(buffer_out)
    );

    bitorder bitorder(
        .clk(clk),
        .rst(btnc),
        .axiiv(buffer_valid),
        .axiid(buffer_out),
        .axiov(eth_txen),
        .axiod(eth_txd)
    );

    always_ff @(posedge clk) begin
        
    end
endmodule

`default_nettype wire