`default_nettype none
`timescale 1ns / 1ps

module bitorder(
    input wire clk,
    input wire rst, 
    input wire axiiv, 
    input wire [1:0] axiid,
    output logic axiov,
    output logic [1:0] axiod
);
  
    typedef enum {SEND_RECEIVE, RECEIVE_SEND, IDLE_RECEIVE, RECEIVE_IDLE} buffer_states;
    buffer_states state;

    logic [2:0] receive_counter; 
    logic [2:0] transmit_counter;
    logic [7:0] buffer1, buffer2;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= RECEIVE_IDLE;
            receive_counter <= 3'b0;
            transmit_counter <= 3'b0;
        end else begin
            if (state == RECEIVE_IDLE) begin
                buffer2 <= 8'b0;
                axiov <= 1'b0;
                transmit_counter <= 3'b0;
                if (axiiv && (receive_counter < 3)) begin
                    buffer1 <= {axiid[1], axiid[0], buffer1[7:2]};
                    receive_counter <= receive_counter + 1;
                end else if (axiiv & receive_counter == 3) begin
                    buffer1 <= {axiid[1], axiid[0], buffer1[7:2]};
                    state <= SEND_RECEIVE;
                    receive_counter <= 0;
                end else if (~axiiv) begin
                    buffer1 <= 8'b0;
                    receive_counter <= 3'b0;
                end
            end else if (state == SEND_RECEIVE) begin
                if (transmit_counter < 3) begin
                    // transmit data from buffer 1
                    axiod <= buffer1[7:6];
                    buffer1 <= {buffer1[5:0], 2'b0};   
                    axiov <= 1'b1;                 
                    transmit_counter <= transmit_counter + 1;
                end
                if (axiiv && (receive_counter < 3)) begin 
                    // read in data to buffer 2 
                    buffer2 <= {axiid[1], axiid[0], buffer2[7:2]};
                    receive_counter <= receive_counter + 1;
                end else if (~axiiv) begin
                    // transition states when buffer 1 is done transmitting
                    if (transmit_counter == 3) begin
                        axiod <= buffer1[7:6];
                        buffer1 <= {buffer1[5:0], 2'b0}; 
                        axiov <= 1'b1;
                        buffer2 <= 8'b0;
                        receive_counter <= 4;
                        transmit_counter <= 4;
                    end else if (transmit_counter == 4 && receive_counter == 4) begin
                        state <= IDLE_RECEIVE;
                        axiov <= 1'b0;
                        receive_counter <= 0;
                        transmit_counter <= 0;
                    end
                end else if (receive_counter == 3 && axiiv && transmit_counter == 3) begin
                    // transition states to R/S
                    buffer2 <= {axiid[1], axiid[0], buffer2[7:2]};
                    axiod <= buffer1[7:6];
                    buffer1 <= {buffer1[5:0], 2'b0};   
                    axiov <= 1'b1;                 
                    state <= RECEIVE_SEND;
                    receive_counter <= 3'b0;
                    transmit_counter <= 3'b0;
                end
            end else if (state == RECEIVE_SEND) begin
                if (transmit_counter < 3) begin
                    // transmit data from buffer 2
                    axiod <= buffer2[7:6];
                    buffer2 <= {buffer2[5:0], 2'b0};   
                    axiov <= 1'b1;                 
                    transmit_counter <= transmit_counter + 1;
                end
                if (axiiv && (receive_counter < 3)) begin
                    // read in data to buffer 1
                    buffer1 <= {axiid[1], axiid[0], buffer1[7:2]};
                    receive_counter <= receive_counter + 1;
                end else if (~axiiv) begin
                    // transition states when buffer 2 is done transmitting
                    if (transmit_counter == 3) begin
                        axiod <= buffer2[7:6];
                        buffer2 <= {buffer2[5:0], 2'b0};   
                        axiov <= 1'b1;
                        buffer1 <= 8'b0;
                        receive_counter <= 4;
                        transmit_counter <= 4;
                    end else if (transmit_counter == 4 && receive_counter == 4) begin
                        state <= RECEIVE_IDLE;
                        axiov <= 1'b0;
                        receive_counter <= 0;
                        transmit_counter <= 0;
                    end
                end else if (receive_counter == 3 && axiiv && transmit_counter == 3) begin
                    // transition states to S/R
                    axiod <= buffer2[7:6];
                    buffer2 <= {buffer2[5:0], 2'b0};   
                    buffer1 <= {axiid[1], axiid[0], buffer1[7:2]};
                    axiov <= 1'b1;                 
                    receive_counter <= 0;
                    transmit_counter <= 0;
                    state <= SEND_RECEIVE;
                end
            end else if (state == IDLE_RECEIVE) begin
                axiov <= 1'b0;
                buffer1 <= 8'b0;
                transmit_counter <= 3'b0;
                if (axiiv && (receive_counter < 3)) begin
                    buffer2 <= {axiid[1], axiid[0], buffer2[7:2]};
                    receive_counter <= receive_counter + 1;
                end else if (receive_counter == 3) begin
                    state <= RECEIVE_SEND;
                    buffer2 <= {axiid[1], axiid[0], buffer2[7:2]};
                    receive_counter <= 0;
                end else if (~axiiv) begin
                    buffer2 <= 8'b0;
                    receive_counter <= 3'b0;
                end
            end
        end
    end
endmodule

`default_nettype wire
