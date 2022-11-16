`default_nettype none
`timescale 1ns / 1ps

module transmit (
    input wire clk,
    input wire btnc,
    output logic eth_rstn,
    output logic eth_txen,
    output wire eth_refclk, 
    output logic [1:0] eth_txd
);
    bitorder bitorder();
    fifo_data_buffer buffer();

    always_ff @(posedge clk) begin
        
    end

endmodule

`default_nettype wire