`default_nettype none
`timescale 1ns / 1ps

module ether(
	input wire clk, 
    input wire rst, 
    input wire crsdv,
    input wire [1:0] rxd,
    output logic axiov, 
    output logic [1:0] axiod
); 

    typedef enum {WAITING, CHECKING, TRANSMITTING} states;
    states state;
    logic [6:0] counter;

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= WAITING;
        end

        if (state == WAITING) begin
            counter <= 0;
            axiov <= 0;
            axiod <= 0;
            if (crsdv && (rxd == 2'b01)) begin
                state <= CHECKING;
            end
        end else if (state == CHECKING) begin
          if (counter < 30) begin
                if (rxd == 2'b01 && crsdv) begin
                    counter <= counter + 1;
                end else begin
                    // false carrier event
                    if (~crsdv) begin
                        state <= WAITING;
                    end
                end
          end else if (counter == 30) begin
                if (rxd == 2'b11 && crsdv) begin
                state <= TRANSMITTING; 
                counter <= 0;
                end else begin
                    // false carrier event
                    if (~crsdv) begin
                        state <= WAITING; 
                    end
                end
            end 
        end else if (state == TRANSMITTING) begin
            if (crsdv) begin
                axiod <= rxd;
                axiov <= 1;
            end else begin // complete transmission
                state <= WAITING;
                axiov <= 0;
            end
        end
    end
endmodule


`default_nettype wire
