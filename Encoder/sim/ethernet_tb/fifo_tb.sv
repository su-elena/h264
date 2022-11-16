`timescale 1ns / 1ps
`default_nettype none

module fifo_tb();

    logic clk, rst, valid_in, axiov;
    logic [7:0] byte_in;
    logic [1:0] axiod;
    
    fifo_data_buffer uut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .byte_in(byte_in),
        .axiov(axiov),
        .axiod(axiod)
        );

    always begin
        #10;  
        clk = !clk;
    end

    initial begin

        $dumpfile("fifo.vcd");
        $dumpvars(0, fifo_tb);

        clk = 0;
        #20;
        rst = 1'b1;
        #20;
        rst = 1'b0;
        valid_in = 1'b0;
        #20;
        for (int i = 0; i < 84; i = i + 1) begin
            byte_in = 8'b11010010;
            valid_in = 1'b1;
            $display("%b           %b        %b       %d", axiov, axiod, valid_in, byte_in); 
            #20;
        end
        #20;
        valid_in = 1'b0;
        #60;
        #11200;
        $display("Finishing sim"); 
        $finish;
    end
endmodule

`default_nettype wire