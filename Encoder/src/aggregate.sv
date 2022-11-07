`default_nettype none
`timescale 1ns / 1ps

module aggregate(
    input wire clk,
    input wire rst,
    input wire axiiv,
    input wire [1:0] axiid,
    output logic axiov,
    output logic [31:0] axiod
);
    logic [31:0] buffer;
    logic [6:0] counter; 
    logic [6:0] fcs_counter; 

    always_comb begin
        if (axiov) begin
            axiod = buffer;
        end
    end 

    always_ff @(posedge clk) begin
        if (rst) begin
            buffer <= 32'b0;
            counter <= 0;
            fcs_counter <= 0;
        end else begin
            if (axiiv) begin
              if (counter < 16) begin
                    buffer <= {buffer[29:0], axiid};
                    counter <= counter + 1;
              end else if (counter == 16) begin
                if (fcs_counter < 15) begin
                        fcs_counter <= fcs_counter + 1;
                end else if (fcs_counter == 15) begin
                        fcs_counter <= 0;
                        axiov <= 1'b1;
                    end
                end
            end else begin
                axiov <= 1'b0;
                counter <= 0;
                buffer <= 32'b0;
                fcs_counter <= 0;
            end
        end
    end
endmodule

`default_nettype wire
