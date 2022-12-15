`default_nettype none
`timescale 1ns / 1ps

module exp_golomb_encoder(
    input wire clk,
    input wire rst,
    input wire axiiv,
    input wire [8:0] axiid, //For now only until decimal 512 as input
    output logic axiov,
    output logic [15:0] axiod
);
    /* ADD DESCRIPTION HERE */
    logic [15:0] final_out;
    assign axiod = final_out;


    //IMPLEMENTATION 1 START
    //Checking how many bits does the input number occupies
    // logic [3:0] input_bit_count = 0;
    // logic [3:0] first_one_found = 1'b0;
    // logic [8:0] input_plus_one;
    // logic [3:0] start_zeros;
    // logic [15:0] temp_out;

    // always_comb begin 

    //         input_plus_one = axiid + 1;
    //         for  (int count = 8; count >0; count = count -1) begin
    //             if(input_plus_one[count] == 1'b1 && ~first_one_found)begin
    //                 input_bit_count = count +1;// for 1000 we get 3, maybe +1?
    //                 start_zeros = count;
    //                 //CHECK: If this number represents the actual length of input number 
    //                 //(lenght meaning how many bits its using to represent it) 
    //                 first_one_found = 1'b1;
    //                 temp_out = input_plus_one;
    //                 temp_out[input_bit_count+start_zeros] = 1'b1;
    //             end
    //         end

    //         first_one_found = 1'b0;

    // end

    // always_ff @(posedge clk) begin
    //     if (rst) begin
    //         final_out <= 0;
    //         axiov <= 0;
    //     end else begin
    //         final_out <= temp_out;
    //         axiov <= axiiv;
    //     end
    // end

    //IMPLEMENTATION 1 END

    //IMPLEMENTATION 2 START
    logic not_found= 1'b1;
    always_comb begin 

            if (state == 1) begin
                for  (int counti = 8; counti >0; counti = counti -1) begin
                    if(input_plus_one[counti] == 1'b1 && not_found)begin
                        input_bit_count = counti +1;// for 1000 we get 3, maybe +1?
                        start_zeros = counti;
                        //CHECK: If this number represents the actual length of input number 
                        //(lenght meaning how many bits its using to represent it) 
                        not_found = 1'b0;
                        // temp_out = input_plus_one;
                        // temp_out[input_bit_count+start_zeros] = 1'b1;
                    end
                end
            end else begin
                not_found= 1'b1;
            end

            first_one_found = 1'b0;

    end








    logic [3:0] state;
    logic [8:0] input_plus_one;
    logic [3:0] first_one_found;
    logic [3:0] input_bit_count = 0;
    logic [3:0] start_zeros;
    logic [15:0] temp_out;
    int count = 8;
    always_ff @(posedge clk ) begin
        if(rst) begin
            state <= 0;
            input_plus_one <=0;
            first_one_found<=0;
        end else begin
            case(state)
                0: begin
                    if(axiiv) begin
                        state <= 1;
                        input_plus_one <= axiid + 1;
                        first_one_found<=0;
                        count <= 8;
                    end
                    axiov <= 0;
                end
                // 1: begin
                //     // for  (int count = 8; count >0; count = count -1) begin
                //         if(input_plus_one[count] == 1'b1 && ~first_one_found && count >=0)begin
                //             input_bit_count <= count +1;// for 1000 we get 3, maybe +1?
                //             start_zeros <= count;
                //             //CHECK: If this number represents the actual length of input number 
                //             //(lenght meaning how many bits its using to represent it) 
                //             first_one_found <= 1'b1;
                //             // temp_out = input_plus_one;
                //             // input_plus_one[input_bit_count+start_zeros] <= 1'b1;
                //             state <= 2;
                //         end
                //         if (count == 0) begin
                //             state <=0;
                //         end else begin
                //             count <= count - 1;
                //         end
                //         axiov <=0;
                // end
                1: begin
                    input_plus_one[input_bit_count+start_zeros] <= 1'b1;
                    state <= 2;
                end

                2: begin
                    final_out <= input_plus_one;
                    axiov <=1;
                    state <=0;
                end
                
            endcase
        end
        end
        
    
    
endmodule


`default_nettype wire
