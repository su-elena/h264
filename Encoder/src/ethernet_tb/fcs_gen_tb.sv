`timescale 1ns / 1ps
`default_nettype none

module fcs_gen_tb();
    logic clk, rst, axiiv, axiov;
    logic [31:0] cksum;
    logic[1:0] axiid, axiod;
    logic [167:0] msg; 
    assign msg = 168'h4261_7272_7921_2042_7265_616b_6661_7374_2074_696d65;

    fcs_gen uut (
        .clk(clk), 
        .rst(rst), 
        .axiiv(axiiv),
        .axiid(axiid),
        .cksum(cksum),
        .axiov(axiov));

    always begin
        #10;  
        clk = !clk;
    end

    initial begin

        $dumpfile("fcs_gen.vcd");
        $dumpvars(0, fcs_gen_tb);

        clk = 1;
        #20;
        rst = 1'b1;
        axiiv = 1'b1;
        #20;
        rst = 1'b0;
        axiiv = 1'b0;
        #20;
        for (int i = 0; i < 84; i = i + 1) begin
            axiid = {msg[167-2*i-1], msg[167-2*i]};
            axiiv = 1'b1;
            $display("%b           %b        %b       %d", axiiv, axiid, axiov, cksum); 
            #20;
        end
        #20;
        axiiv = 1'b0;
        #60;
        axiiv = 1'b1;
        $display("%b           %b        %b       %d", axiiv, axiid, axiov, cksum); 
        #200;

        $display("Finishing sim"); 
        $finish;
    end



    
endmodule

`default_nettype wire