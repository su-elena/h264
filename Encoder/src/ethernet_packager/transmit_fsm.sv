`default_nettype none
`timescale 1ns / 1ps

module transmit(
    input wire clk,
    input wire rst,
    output logic axiov,
    output logic [1:0] axiod
);

    logic [31:0] cksum_buffer;

    typedef enum {IDLE, PREAMBLE, HEADER, DATA, FCS} states;
    states prev_state, state, next_state;
    logic [6:0] counter;

    always_ff @(posedge clk) begin
        prev_state <= state;

        if (rst) begin
            state <= IDLE;
        end

        if (state == )
    end
endmodule

`default nettype wire