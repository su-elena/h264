`default_nettype none
`timescale 1ns / 1ps

module header_gen (
    input wire clk, input wire rst,
    output logic axiov, output logic [79:0] axiod
);
    logic [31:0] source, dest;
    logic [15:0] ethertype;
    logic [79:0] buffer_in, buffer, buffer_out;
    logic axiiv, bitorder_axiov;
    logic [1:0] axiid, bitorder_axiod;
    logic [6:0] counter;
    assign ethertype = 16'h0800;
    assign source = 32'hFFFF_FFFF;
    assign dest = 32'h692C083075FD;
    assign buffer_in = {dest, source, ethertype};

    bitorder header (
        .clk(clk),
        .rst(rst), 
        .axiiv(axiiv), 
        .axiid(buffer[79:78]),
        .axiov(bitorder_axiov),
        .axiod(bitorder_axiod)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            buffer <= buffer_in;
        end else if (counter < 40) begin
            axiiv <= 1'b1;
            counter <= counter + 1;
            buffer 
        end else if (counter == 40) begin
            axiov <= 1'b1;
        end
    end
endmodule

`default nettype wire