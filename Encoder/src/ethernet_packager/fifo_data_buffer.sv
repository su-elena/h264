`default nettype none
`timescale 1ns / 1ps


module fifo_data_buffer (
    input wire [7:0] byte_in;
    input wire valid_in; 
    output logic axiov;
    output logic [1:0] axiod
);
    
    xilinx_true_dual_port_read_first_1_clock_ram 

endmodule

`default nettype wire