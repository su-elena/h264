`timescale 1ns / 1ps
`default_nettype none

module top_level(
    input wire clk,
    input wire btnc,
    output logic eth_rstn,
    input wire eth_crsdv,
    output wire eth_refclk, 
    input wire [1:0] eth_rxd,
    output wire [15:0] led,
    output logic ca, cb, cc, cd, ce, cf, cg,
    output logic [7:0] an
);

    logic axiov_out;
    logic ethclk;
    logic prev_axiov, prev_agg_axiov; 
    logic [1:0] axiod_out;
    logic [1:0] bitorder_axiod;
    logic bitorder_axiov;
    logic [1:0] firewall_axiod;
    logic [31:0] segment_input;
    logic firewall_axiov;
    logic [13:0] counter; 
    logic module_done, kill, prev_done;
    logic [31:0] aggregate_axiod;
    logic aggregate_axiov;
    assign led[13:0] = counter; 
    assign led[14] = module_done;
    assign led[15] = kill;

    divider clk_divider(
        .clk(clk), 
        .ethclk(eth_refclk)
    );

    ether ethernet(
        .clk(eth_refclk),
        .rst(btnc),
        .crsdv(eth_crsdv),
        .rxd(eth_rxd),
        .axiov(axiov_out),
        .axiod(axiod_out)
    );

    bitorder dibit_buffer (
        .clk(eth_refclk), 
        .rst(btnc),
        .axiiv(axiov_out),
        .axiid(axiod_out),
        .axiov(bitorder_axiov),
        .axiod(bitorder_axiod)
    );

    cksum fcs (
        .clk(eth_refclk),
        .rst(btnc),
        .axiiv(axiov_out),
        .axiid(axiod_out),
        .done(module_done),
        .kill(kill)
    );

    firewall firewall (
        .clk(eth_refclk),
        .rst(btnc),
        .axiiv(bitorder_axiov),
        .axiid(bitorder_axiod),
        .axiod(firewall_axiod),
        .axiov(firewall_axiov)
    );

    aggregate aggregator(
        .clk(eth_refclk),
        .rst(btnc),
        .axiiv(firewall_axiov),
        .axiid(firewall_axiod),
        .axiov(aggregate_axiov),
        .axiod(aggregate_axiod)
    );

    seven_segment_controller #(.COUNT_TO(100000)) segments (
        .clk_in(eth_refclk),
        .rst_in(btnc),
        .val_in(segment_input),
        .cat_out({cg, cf, ce, cd, cc, cb, ca}),
        .an_out(an)
    );

    always_ff @(posedge eth_refclk) begin
        prev_axiov <= axiov_out;
        prev_done <= module_done;
        if (aggregate_axiov) begin
            segment_input <= aggregate_axiod;
        end

        if (btnc) begin
            eth_rstn <= 0;
            counter <= 0;
        end else begin
            eth_rstn <= 1;
            if (~prev_done && module_done) begin
                counter <= counter + 1;
            end
        end
    end
endmodule

`default_nettype wire
