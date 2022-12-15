`default_nettype none
`timescale 1ns / 1ps

module exp_golomb_enc_look_up(
    input wire clk,
    input wire rst,
    input wire axiiv,
    // input wire ready,//DELETE THIS AFTER
    // input wire byte_available, //DELETE THIS AFTER
    // input wire [7:0]dout,  //DELETE THIS AFTER
    input wire [8:0] axiid, //For now only until decimal 512 as input
    output logic axiov,
    output logic [15:0] axiod
);
    /* ADD DESCRIPTION HERE */
    logic [15:0] final_out;
    assign axiod = final_out;

    // Variables for BRAM
    // logic [8:0] bram_pos;
    // logic [7:0] bram_input;
    // logic bram_1_write;
    // logic [7:0] bram_1_out;




    // SD Variables //
    logic ready; //UNCOMMENT WHEN DONE TESTING!
    logic [31:0] addr;
    logic [7:0] dout; // UNCOMMENT WHEN DONE TESTING!
    logic rd;
    logic byte_available;// UNCOMMENT WHEN DONE TESTING!

    //For WRITING
    logic wr;
    logic [7:0] din;
    logic ready_for_next_byte;
    always_ff @(posedge clk ) begin 
        if (rst) begin 
            rd <= 1;
            wr <= 0;
        end
    end
    // Note: I AM ASSUMING THAT EXP GOLOMB USES 25MHZ 

    sd_controller sd(.reset(rst), .clk(clk), .cs(sd_dat[3]), .mosi(sd_cmd), 
                     .miso(sd_dat[0]), .sclk(sd_sck), .ready(ready), .address(addr),
                     .rd(rd), .dout(dout), .byte_available(byte_available),
                     .wr(wr), .din(din), .ready_for_next_byte(ready_for_next_byte)); 

    // Based on CodeNum (from inout axiid) calculate which sector of the SD you need to get
    

    logic not_running;
    logic is_sd_reading_done; //Related to "ready" signal!!!
    
    logic encoded_num_acquired;
    assign is_sd_reading_done = ready;





    always_ff @(posedge clk) begin
        if (rst)begin
            addr <= 32'b0;
            not_running <=1;
        end else begin
            if (not_running && axiiv) begin
                // Sector 1 (512) if code_nume is less than 257, else Sector 2(1024)
                addr <= axiid < 257 ? 512 : 1024; // Using two bytes per num
                not_running <= 0;
            end else begin
                //If we are done reading SD and we are IDLE again
                if (~not_running && is_sd_reading_done) begin
                    not_running <= 1;
                end else begin
                    not_running <= not_running;
                end
            end
        end
    end



    logic [8:0] byte_available_count;
    logic [31:0] current_addrs;

    // Getting current address to read from
    // always_comb begin
    //     current_addrs = addrs + byte_available_count*8;
    // end


    logic [7:0] previous_byte;
    logic second_byte;
    always_ff @(posedge clk) begin
        if (rst) begin
            byte_available_count <= 0;
            previous_byte <=8'b0;
            second_byte <=1;
            encoded_num_acquired <= 0;
            // axiov <= 0;
        end else begin
            if (~encoded_num_acquired) begin
                if (byte_available) begin
                    if (byte_available_count == axiid + 1) begin // Becuase it takes two bytes to represent one number // maybe axiid + 1
                        encoded_num_acquired <= 1;
                        final_out <= {previous_byte, dout};
                        axiov <= 1;
                    end else begin
                            previous_byte <= dout;
                            axiov <= 0;
                    end
                end
                //We use two bytes to represent an encoded codenum so our coutner adds 1 every two bytes
                if (byte_available) begin
                    if (~second_byte) begin
                        second_byte <= 1;
                    end else begin
                        byte_available_count = byte_available_count + 1;
                        second_byte <= 0;
                    end        
                end
            end else begin
                axiov <= 0;
                //SD finished reading
                if (is_sd_reading_done == 1) begin
                    encoded_num_acquired <= 0;
                end
                byte_available_count <= 0;
                previous_byte <=8'b0;
                second_byte <=1;
            end
        end
    end

    // //IMPLEMENTATION 2 START
    // logic not_found= 1'b1;
    // always_comb begin 

    //         if (state == 1) begin
    //             for  (int counti = 8; counti >0; counti = counti -1) begin
    //                 if(input_plus_one[counti] == 1'b1 && not_found)begin
    //                     input_bit_count = counti +1;// for 1000 we get 3, maybe +1?
    //                     start_zeros = counti;
    //                     //CHECK: If this number represents the actual length of input number 
    //                     //(lenght meaning how many bits its using to represent it) 
    //                     not_found = 1'b0;
    //                     // temp_out = input_plus_one;
    //                     // temp_out[input_bit_count+start_zeros] = 1'b1;
    //                 end
    //             end
    //         end else begin
    //             not_found= 1'b1;
    //         end

    //         first_one_found = 1'b0;

    // end








    // logic [3:0] state;
    // logic [8:0] input_plus_one;
    // logic [3:0] first_one_found;
    // logic [3:0] input_bit_count = 0;
    // logic [3:0] start_zeros;
    // logic [15:0] temp_out;
    // int count = 8;
    // always_ff @(posedge clk ) begin
    //     if(rst) begin
    //         state <= 0;
    //         input_plus_one <=0;
    //         first_one_found<=0;
    //     end else begin
    //         case(state)
    //             0: begin
    //                 if(axiiv) begin
    //                     state <= 1;
    //                     input_plus_one <= axiid + 1;
    //                     first_one_found<=0;
    //                     count <= 8;
    //                 end
    //                 axiov <= 0;
    //             end
    //             // 1: begin
    //             //     // for  (int count = 8; count >0; count = count -1) begin
    //             //         if(input_plus_one[count] == 1'b1 && ~first_one_found && count >=0)begin
    //             //             input_bit_count <= count +1;// for 1000 we get 3, maybe +1?
    //             //             start_zeros <= count;
    //             //             //CHECK: If this number represents the actual length of input number 
    //             //             //(lenght meaning how many bits its using to represent it) 
    //             //             first_one_found <= 1'b1;
    //             //             // temp_out = input_plus_one;
    //             //             // input_plus_one[input_bit_count+start_zeros] <= 1'b1;
    //             //             state <= 2;
    //             //         end
    //             //         if (count == 0) begin
    //             //             state <=0;
    //             //         end else begin
    //             //             count <= count - 1;
    //             //         end
    //             //         axiov <=0;
    //             // end
    //             1: begin
    //                 input_plus_one[input_bit_count+start_zeros] <= 1'b1;
    //                 state <= 2;
    //             end

    //             2: begin
    //                 final_out <= input_plus_one;
    //                 axiov <=1;
    //                 state <=0;
    //             end
                
    //         endcase
    //     end
    //     end



  // Uncomment if using BRAM      
    // xilinx_true_dual_port_read_first_1_clock_ram #(.RAM_WIDTH(8), .RAM_DEPTH(512), .RAM_PERFORMANCE("HIGH_PERFORMANCE"), .INIT_FILE("")) bram1 (
    //     .addra(hcount_in),  //Goes from 0 to 511 ?
    //     .addrb(), 
    //     .dina(pixel_data_in),
    //     .dinb(16'b0),  
    //     .clka(clk),
    //     .wea(bram_1_write),           
    //     .web(1'b0),
    //     .ena(1'b1),
    //     .enb(1'b1),  
    //     .rsta(rst),
    //     .rstb(rst),  
    //     .regcea(1'b1),
    //     .regceb(1'b1), 
    //     .douta(bram_1_out),
    //     .doutb());






    // xilinx_true_dual_port_read_first_1_clock_ram #(.RAM_WIDTH(16), .RAM_DEPTH(320), .RAM_PERFORMANCE("HIGH_PERFORMANCE"), .INIT_FILE("")) bram2 (
    //     .addra(hcount_in),
    //     .addrb(), 
    //     .dina(pixel_data_in),
    //     .dinb(16'b0),  
    //     .clka(clk_in),
    //     .wea(bram_2_write),          
    //     .web(1'b0),
    //     .ena(1'b1),
    //     .enb(1'b1),  
    //     .rsta(rst_in),
    //     .rstb(rst_in),  
    //     .regcea(1'b1),
    //     .regceb(1'b1), 
    //     .douta(bram_2_out),
    //     .doutb());
    
endmodule


`default_nettype wire
