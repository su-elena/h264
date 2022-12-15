`default_nettype none
`timescale 1ns / 1ps

module exp_golomb_decoder(
    input wire clk,
    input wire rst,
    input wire axiiv,

    input wire [15:0] axiid, 
    output logic axiov, 
    output logic [8:0] axiod
);
    /* ADD DESCRIPTION HERE */
    logic delimitating_one_found = 1'b1;
    logic not_found= 1'b1;
    logic [15:0] temp_input = 15'b0;
    logic [15:0] temp_inout;
    logic [4:0] leading_zeros = 5'b0;
    always_comb begin 
            if (state == 1) begin
                temp_input = axiid;
                for  (int counti = 15; counti >=0; counti = counti -1) begin
                    if(axiid[counti] == 1'b1 && not_found)begin
                        // start_zeros = counti;
                        if (delimitating_one_found) begin
                            delimitating_one_found = 0;
                            temp_input[counti] = 0;
                        end else begin
                            not_found = 1'b0;
                            temp_input[counti] = 0;
                            if (leading_zeros == 0) begin
                                temp_inout = 0 ;
                            end else begin
                                // if (leading_zeros !=0) begin
                                    temp_inout = 2**leading_zeros + temp_input - 1;
                                // end else begin
                                //     temp_inout = 0;
                                // end
                                    

                            end
                        end
                    end else begin
                        if (~delimitating_one_found && not_found ) begin
                            leading_zeros = leading_zeros +1;
                        end
                        
                    end
                end
            end else begin
                not_found= 1'b1;
                delimitating_one_found = 1'b1;
                leading_zeros = 0;
            end

            // first_one_found = 1'b0;

    end



    logic [3:0] state;
    logic [3:0] start_zeros;

    always_ff @(posedge clk ) begin
        if(rst) begin
            state <= 0;
        end else begin
            case(state)
                0: begin
                    if(axiiv) begin
                        state <= 1;
                    end
                    axiov <= 0;
                end

                1: begin
                    // input_plus_one[input_bit_count+start_zeros] <= 1'b1;
                    
                    state <= 2;
                end

                2: begin
                    // if (temp_input == 15'b0) begin //In case its the 0 codenum
                        // axiod <= 0;
                    // end else begin
                        axiod <= temp_inout;
                        axiov <=1;
                        state <=0;
                    // end
                end
                // 3: begin
                //     axiov <= 0;
                //     state <= 0;
                // end
            endcase
        end
        end
        
    
    
endmodule




`default_nettype wire
