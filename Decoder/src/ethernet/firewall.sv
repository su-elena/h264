`timescale 1ns / 1ps
`default_nettype none

module firewall(
    input wire clk,
    input wire rst, 
    input wire axiiv, 
    input wire [1:0] axiid,
    output logic axiov,
    output logic [1:0] axiod
); 

    typedef enum {IDLE, BUFFERING, TRANSMITTING} states;
    states state;
    logic flag;
    logic prev_axiiv;
    logic [6:0] counter, transmission_counter;
    logic [47:0] buffer;
  assign axiov = ((state==TRANSMITTING)&&(axiiv)&&(transmission_counter > 30));

    always_comb begin
        if (axiov) begin
            axiod = axiid;
        end 
    end

    //FSM
    always_ff @(posedge clk) begin
        prev_axiiv <= axiiv;
        if (rst) begin
            state <= IDLE;
        end 
      
        if (state == TRANSMITTING) begin
            if (~axiiv) begin
                state <= IDLE;
            end 
        end else if (state == BUFFERING) begin
            if (axiiv) begin
              if (counter < 24) begin
                buffer <= {buffer[45:0], axiid};
              end 
            end

            if (axiiv && counter == 23 && ((buffer == 48'h69695A065491) || (buffer == 48'hFFFFFFFFFFFF))) begin
                state <= TRANSMITTING;
            end else if (counter == 23 && ~((buffer == 48'h69695A065491) || (buffer == 48'hFFFFFFFFFFFF))) begin
                state <= IDLE;
            end
        end else if (state == IDLE) begin
            counter <= 0;
            transmission_counter <= 0;
            buffer <= 48'b0;
            if (~prev_axiiv && axiiv) begin
                state <= BUFFERING;
                buffer <= {buffer[45:0], axiid};
            end
        end
        
        //drive the counters
        if (state == BUFFERING) begin
          if (counter < 25) begin
                if (axiiv) begin
                    counter <= counter + 1;
                end
            end
        end else if (state == TRANSMITTING) begin
          if (transmission_counter < 33) begin
                if (axiiv) begin
                    transmission_counter <= transmission_counter + 1;
                end
            end 
        end
    end
endmodule

`default_nettype wire