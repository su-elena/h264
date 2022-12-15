`default_nettype none
`timescale 1ns / 1ps

module cavlc_encoder(
    input wire clk,
    input wire rst,
    input wire axiiv,

    input wire [3:0]num_coeff,
    input wire [1:0]t1_s,
    //N_upper
    input wire nu_valid,
    input wire [1:0]nu,
    //N_left
    input wire nl_valid,
    input wire [1:0]nl,
    //Chroma_DC
    input wire is_chroma_DC,
    // input wire ready,//DELETE THIS AFTER
    // input wire byte_available, //DELETE THIS AFTER
    // input wire [7:0]dout,  //DELETE THIS AFTER
    // input wire axiid, //TBD TBD TBD TBD!!!!!!
    output logic axiov,
    output logic [20:0] axiod //TBD TBD TBD TBD!!!!!!
);
    /* ADD DESCRIPTION HERE */
    /*Used to encode residual, scan ordered blocks of transform coefficients*/

    //NUM VLC Look up tables.
    
    //NUM-VLC0
    //NumCoef\T1s  == 0
    logic num_vlc0_0_0        =  1'b1;
    logic [5:0]num_vlc0_0_1   = 6'b000011;
    logic [7:0]num_vlc0_0_2   = 8'b00000111;
    logic [8:0]num_vlc0_0_3   = 9'b000001001;
    logic [8:0]num_vlc0_0_4   = 9'b000001000;
    logic [9:0]num_vlc0_0_5   = 10'b0000000111;
    logic [10:0]num_vlc0_0_6  = 11'b00000000111;
    logic [11:0]num_vlc0_0_7  = 12'b000000001001;
    logic [11:0]num_vlc0_0_8  = 12'b000000001000;
    logic [12:0]num_vlc0_0_9  = 13'b0000000000111;
    logic [12:0]num_vlc0_0_10 = 13'b0000000000110;
    logic [13:0]num_vlc0_0_11 = 14'b00000000000011;
    logic [13:0]num_vlc0_0_12 = 14'b00000000000010;
    logic [13:0]num_vlc0_0_13 = 14'b00000000000101;
    logic [14:0]num_vlc0_0_14 = 15'b000000000000011;
    logic [16:0]num_vlc0_0_15 = 17'b00000000000000001;
    logic [16:0]num_vlc0_0_16 = 17'b00000000000000000;



    //NumCoef\T1s  == 1
    logic num_vlc0_1_0        =  1'b1; //UNDEFINED
    logic [1:0]num_vlc0_1_1   = 2'b01;
    logic [6:0]num_vlc0_1_2   = 7'b0001001;
    logic [7:0]num_vlc0_1_3   = 8'b00000110;
    logic [8:0]num_vlc0_1_4   = 9'b000001011;
    logic [8:0]num_vlc0_1_5   = 9'b000001010;
    logic [9:0]num_vlc0_1_6   = 10'b0000000110;
    logic [10:0]num_vlc0_1_7  = 11'b00000000110;
    logic [10:0]num_vlc0_1_8  = 11'b00000001001;
    logic [11:0]num_vlc0_1_9  = 12'b000000001011;
    logic [12:0]num_vlc0_1_10 = 13'b0000000001101;
    logic [12:0]num_vlc0_1_11 = 13'b0000000001100;
    logic [13:0]num_vlc0_1_12 = 14'b00000000000100;
    logic [13:0]num_vlc0_1_13 = 14'b00000000000111;
    logic [14:0]num_vlc0_1_14 = 15'b000000000000010;
    logic [16:0]num_vlc0_1_15 = 17'b00000000000000011;
    logic [17:0]num_vlc0_1_16 = 18'b000000000000001001;

    //NumCoef\T1s  == 2
    logic num_vlc0_2_0        =  1'b1; //UNASSIGNED
    logic num_vlc0_2_1        = 1'b1;   //UNASSIGNED
    logic [2:0]num_vlc0_2_2   = 3'b001;
    logic [6:0]num_vlc0_2_3   = 7'b0001000;
    logic [8:0]num_vlc0_2_4   = 9'b000000101;
    logic [8:0]num_vlc0_2_5   = 9'b000000100;
    logic [9:0]num_vlc0_2_6   = 10'b0000001101;
    logic [9:0]num_vlc0_2_7   = 10'b0000001100;
    logic [11:0]num_vlc0_2_8  = 12'b000000001010;
    logic [11:0]num_vlc0_2_9  = 12'b000000000101;
    logic [12:0]num_vlc0_2_10 = 13'b0000000001111;
    logic [12:0]num_vlc0_2_11 = 13'b0000000001110;
    logic [13:0]num_vlc0_2_12 = 14'b00000000000110;
    logic [14:0]num_vlc0_2_13 = 15'b000000000010001;
    logic [14:0]num_vlc0_2_14 = 15'b000000000010000;
    logic [16:0]num_vlc0_2_15 = 17'b00000000000000010;
    logic [18:0]num_vlc0_2_16 = 19'b0000000000000010001;

    //NumCoef\T1s  == 3
    logic num_vlc0_3_0        = 1'b1;   //UNASSIGNED   
    logic num_vlc0_3_1        = 1'b1;   //UNASSIGNED
    logic num_vlc0_3_2        = 1'b1;   //UNASSIGNED
    logic [4:0]num_vlc0_3_3   = 5'b00011;
    logic [5:0]num_vlc0_3_4   = 6'b000010;
    logic [6:0]num_vlc0_3_5   = 7'b0001011;
    logic [7:0]num_vlc0_3_6  = 8'b00010101;
    logic [7:0]num_vlc0_3_7  = 8'b00010100;
    logic [8:0]num_vlc0_3_8  = 9'b000000111;
    logic [9:0]num_vlc0_3_9  = 10'b0000000101;
    logic [10:0]num_vlc0_3_10 = 11'b00000001000;
    logic [11:0]num_vlc0_3_11 = 12'b000000000100;
    logic [12:0]num_vlc0_3_12 = 13'b0000000000101;
    logic [13:0]num_vlc0_3_13 = 14'b00000000001001;
    logic [15:0]num_vlc0_3_14 = 16'b0000000000000011;
    logic [16:0]num_vlc0_3_15 = 17'b00000000000000101;
    logic [18:0]num_vlc0_3_16 = 19'b0000000000000010000;




// !!!!! Num_VLC1 !!!!!
    //NumCoef\T1s  == 0
    logic [1:0]num_vlc1_0_0   = 2'b11;
    logic [5:0]num_vlc1_0_1   = 6'b000011;
    logic [5:0]num_vlc1_0_2   = 6'b000010;
    logic [5:0]num_vlc1_0_3   = 6'b001001;
    logic [6:0]num_vlc1_0_4   = 7'b1000001;
    logic [7:0]num_vlc1_0_5   = 8'b00000111;
    logic [7:0]num_vlc1_0_6   = 8'b00000110;
    logic [8:0]num_vlc1_0_7   = 9'b000001001;
    logic [8:0]num_vlc1_0_8   = 9'b000001000;
    logic [9:0]num_vlc1_0_9   = 10'b0000000111;
    logic [9:0]num_vlc1_0_10  = 10'b0000000110;
    logic [10:0]num_vlc1_0_11 = 11'b00000000101;
    logic [10:0]num_vlc1_0_12 = 11'b00000000100;
    logic [11:0]num_vlc1_0_13 = 12'b000000000011;
    logic [12:0]num_vlc1_0_14 = 13'b0000000000011;
    logic [13:0]num_vlc1_0_15 = 14'b00000000000001;
    logic [14:0]num_vlc1_0_16 = 15'b000000000000101;



    //NumCoef\T1s  == 1
    logic num_vlc1_1_0        = 1'b1;//UNASSIGNED;
    logic [2:0]num_vlc1_1_1   = 3'b011;
    logic [4:0]num_vlc1_1_2   = 5'b00011;
    logic [5:0]num_vlc1_1_3   = 6'b001000;
    logic [5:0]num_vlc1_1_4   = 6'b001011;
    logic [6:0]num_vlc1_1_5   = 7'b1000000;
    logic [6:0]num_vlc1_1_6  = 7'b1000011;
    logic [7:0]num_vlc1_1_7  = 8'b10011101;
    logic [8:0]num_vlc1_1_8  = 9'b000001011;
    logic [8:0]num_vlc1_1_9  = 9'b000001010;
    logic [9:0]num_vlc1_1_10 = 10'b0000001101;
    logic [10:0]num_vlc1_1_11 = 11'b00000000111;
    logic [10:0]num_vlc1_1_12 = 11'b00000000110;
    logic [11:0]num_vlc1_1_13 = 12'b000000000010;
    logic [11:0]num_vlc1_1_14 = 12'b000000000101;
    logic [13:0]num_vlc1_1_15 = 14'b00000000000000;
    logic [14:0]num_vlc1_1_16 = 15'b000000000000100;



        //NumCoef\T1s  == 2
    logic num_vlc1_2_0        = 1'b1;//UNASSIGNED;
    logic num_vlc1_2_1        = 1'b1;//UNASSIGNED;
    logic [2:0]num_vlc1_2_2   = 3'b010;
    logic [5:0]num_vlc1_2_3   = 6'b001010;
    logic [5:0]num_vlc1_2_4   = 6'b100101;
    logic [6:0]num_vlc1_2_5   = 7'b1000010;
    logic [6:0]num_vlc1_2_6   = 7'b1001101;
    logic [7:0]num_vlc1_2_7   = 8'b10011100;
    logic [8:0]num_vlc1_2_8   = 9'b000000101;
    logic [8:0]num_vlc1_2_9   = 9'b000000100;
    logic [9:0]num_vlc1_2_10  = 10'b0000001100;
    logic [10:0]num_vlc1_2_11 = 11'b00000001001;
    logic [10:0]num_vlc1_2_12 = 11'b00000001000;
    logic [11:0]num_vlc1_2_13 = 12'b000000000100;
    logic [12:0]num_vlc1_2_14 = 13'b0000000000010;
    logic [14:0]num_vlc1_2_15 = 15'b000000000000111;
    logic [15:0]num_vlc1_2_16 = 16'b0000000000001101;



        //NumCoef\T1s  == 3
    logic num_vlc1_3_0        = 1'b1 ; //UNASSIGNED
    logic num_vlc1_3_1        = 1'b1 ; //UNASSIGNED
    logic num_vlc1_3_2        = 1'b1 ; //UNASSIGNED
    logic [2:0]num_vlc1_3_3   = 3'b101;
    logic [3:0]num_vlc1_3_4   = 4'b0011;
    logic [4:0]num_vlc1_3_5   = 5'b00010;
    logic [4:0]num_vlc1_3_6   = 5'b10001;
    logic [5:0]num_vlc1_3_7   = 6'b100100;
    logic [6:0]num_vlc1_3_8   = 7'b1001100;
    logic [7:0]num_vlc1_3_9   = 8'b10011111;
    logic [7:0]num_vlc1_3_10  = 8'b10011110;
    logic [8:0]num_vlc1_3_11  = 9'b000000111;
    logic [9:0]num_vlc1_3_12  = 10'b0000000101;
    logic [11:0]num_vlc1_3_13 = 12'b000000000111;
    logic [12:0]num_vlc1_3_14 = 13'b0000000001101;
    logic [12:0]num_vlc1_3_15 = 13'b0000000001100;
    logic [15:0]num_vlc1_3_16 = 16'b0000000000001100;


    // !!!!! Num_VLC2 !!!!!  
    //NumCoef\T1s  == 0
    logic [3:0]num_vlc2_0_0   = 4'b0011;
    logic [6:0]num_vlc2_0_1   = 7'b0000011;
    logic [6:0]num_vlc2_0_2   = 7'b0000010;
    logic [5:0]num_vlc2_0_3   = 6'b000011;
    logic [5:0]num_vlc2_0_4   = 6'b000010;
    logic [5:0]num_vlc2_0_5   = 6'b101101;
    logic [5:0]num_vlc2_0_6   = 6'b101100;
    logic [5:0]num_vlc2_0_7   = 6'b101111;
    logic [6:0]num_vlc2_0_8   = 7'b0110101;
    logic [6:0]num_vlc2_0_9   = 7'b0110100;
    logic [6:0]num_vlc2_0_10  = 7'b0110111;
    logic [7:0]num_vlc2_0_11  = 8'b01111001;
    logic [7:0]num_vlc2_0_12  = 8'b01111000;
    logic [8:0]num_vlc2_0_13  = 9'b000000011;
    logic [9:0]num_vlc2_0_14  = 10'b0000000011;
    logic [9:0]num_vlc2_0_15  = 10'b0000000010;
    logic [12:0]num_vlc2_0_16 = 13'b0000000000001;




    //NumCoef\T1s  == 1
    logic num_vlc2_1_0        = 1'b1; //UNASSIGNED
    logic [3:0]num_vlc2_1_1   = 4'b0010;
    logic [5:0]num_vlc2_1_2   = 6'b101110;
    logic [5:0]num_vlc2_1_3   = 6'b101001;
    logic [5:0]num_vlc2_1_4   = 6'b101000;
    logic [5:0]num_vlc2_1_5   = 6'b101011;
    logic [5:0]num_vlc2_1_6   = 6'b101010;
    logic [5:0]num_vlc2_1_7   = 6'b010101;
    logic [5:0]num_vlc2_1_8   = 6'b010100;
    logic [5:0]num_vlc2_1_9   = 6'b010111;
    logic [6:0]num_vlc2_1_10  = 7'b0110110;
    logic [6:0]num_vlc2_1_11  = 7'b0110001;
    logic [7:0]num_vlc2_1_12  = 8'b01111011;
    logic [8:0]num_vlc2_1_13  = 9'b000000010;
    logic [8:0]num_vlc2_1_14  = 9'b000000101;
    logic [10:0]num_vlc2_1_15 = 11'b00000000011;
    logic [11:0]num_vlc2_1_16 = 12'b000000000001;




    //NumCoef\T1s  == 2
    logic num_vlc2_2_0        = 1'b1; //UNASSIGNED
    logic num_vlc2_2_1        = 1'b1; //UNASSIGNED
    logic [3:0]num_vlc2_2_2   = 4'b1101;
    logic [5:0]num_vlc2_2_3   = 6'b010110;
    logic [5:0]num_vlc2_2_4   = 6'b010001;
    logic [5:0]num_vlc2_2_5   = 6'b010000;
    logic [5:0]num_vlc2_2_6   = 6'b010011;
    logic [5:0]num_vlc2_2_7   = 6'b010010;
    logic [5:0]num_vlc2_2_8   = 6'b011101;
    logic [5:0]num_vlc2_2_9   = 6'b011100;
    logic [6:0]num_vlc2_2_10  = 7'b0110000;
    logic [7:0]num_vlc2_2_11  = 8'b01111010;
    logic [7:0]num_vlc2_2_12  = 8'b01100101;
    logic [8:0]num_vlc2_2_13  = 9'b000000100;
    logic [9:0]num_vlc2_2_14  = 10'b0000001101;
    logic [10:0]num_vlc2_2_15 = 11'b00000000010;
    logic [13:0]num_vlc2_2_16 = 14'b00000000000001;





    //NumCoef\T1s  == 3
    logic num_vlc2_3_0        = 1'b1 ; //UNASSIGNED
    logic num_vlc2_3_1        = 1'b1; //UNASSIGNED
    logic num_vlc2_3_2        = 1'b1; //UNASSIGNED
    logic [3:0]num_vlc2_3_3   = 4'b1100;
    logic [3:0]num_vlc2_3_4   = 4'b1111;
    logic [3:0]num_vlc2_3_5   = 4'b1110;
    logic [3:0]num_vlc2_3_6   = 4'b1001;
    logic [3:0]num_vlc2_3_7   = 4'b1000;
    logic [4:0]num_vlc2_3_8   = 5'b00011;
    logic [4:0]num_vlc2_3_9   = 5'b00010;
    logic [5:0]num_vlc2_3_10  = 6'b011111;
    logic [6:0]num_vlc2_3_11  = 7'b0110011;
    logic [7:0]num_vlc2_3_12  = 8'b01100100;
    logic [8:0]num_vlc2_3_13  = 9'b000000111;
    logic [9:0]num_vlc2_3_14  = 10'b0000001100;
    logic [10:0]num_vlc2_3_15 = 11'b00000000001;
    logic [13:0]num_vlc2_3_16 = 14'b00000000000000;




//   !!!!!!NUM-VLC_CHROMA_DC

    //Num_coeffs\T1s  == 0
    logic [3:0]num_vlc_dc_0_1   = 4'b0001;
    logic [4:0]num_vlc_dc_0_2   = 5'b00001;
    logic [4:0]num_vlc_dc_0_3   = 5'b00110;
    logic [6:0]num_vlc_dc_0_4   = 7'b0000001;

    //Num_coeffs\T1s  == 1
    logic num_vlc_dc_1_1        = 1'b1;
    logic [4:0]num_vlc_dc_1_2   = 5'b00111;
    logic [5:0]num_vlc_dc_1_3   = 6'b000001;
    logic [7:0]num_vlc_dc_1_4   = 8'b00000000;

    //Num_coeffs\T1s  == 2
    logic num_vlc_dc_2_1        = 1'b1; //UNASSIGNED
    logic [1:0]num_vlc_dc_2_2   = 2'b01;
    logic [5:0]num_vlc_dc_2_3   = 6'b001010;
    logic [7:0]num_vlc_dc_2_4   = 8'b00000001;

    //Num_coeffs\T1s  == 3
    logic num_vlc_dc_3_1        = 1'b1; //UNASSIGNED
    logic num_vlc_dc_3_2        = 1'b1; //UNASSIGNED
    logic [4:0]num_vlc_dc_3_3   = 5'b00100;
    logic [5:0]num_vlc_dc_3_4   = 6'b001011;



    /// !!!!!!! FLC Tables !!!!!!!!

    //T1s = 0
    logic [5:0]num_flc0_0   = 6'b000011;
    logic [5:0]num_flc0_1  = 6'b000000;
    logic [5:0]num_flc0_2   = 6'b000100;
    logic [5:0]num_flc0_3   = 6'b001000;
    logic [5:0]num_flc0_4   = 6'b001100;
    logic [5:0]num_flc0_5   = 6'b010000;
    logic [5:0]num_flc0_6   = 6'b010100;
    logic [5:0]num_flc0_7   = 6'b011000;
    logic [5:0]num_flc0_8   = 6'b011100;
    logic [5:0]num_flc0_9   = 6'b100000;
    logic [5:0]num_flc0_10  = 6'b100100;
    logic [5:0]num_flc0_11  = 6'b101000;
    logic [5:0]num_flc0_12  = 6'b101100;
    logic [5:0]num_flc0_13  = 6'b110000;
    logic [5:0]num_flc0_14  = 6'b110100;
    logic [5:0]num_flc0_15  = 6'b111000;
    logic [5:0]num_flc0_16  = 6'b111100;

    //T1s = 1
    logic [5:0]num_flc1_0   = 6'b000000; //UNASSIGNED
    logic [5:0]num_flc1_1  = 6'b000001;
    logic [5:0]num_flc1_2   = 6'b000101;
    logic [5:0]num_flc1_3   = 6'b001001;
    logic [5:0]num_flc1_4   = 6'b001101;
    logic [5:0]num_flc1_5   = 6'b010001;
    logic [5:0]num_flc1_6   = 6'b010101;
    logic [5:0]num_flc1_7   = 6'b011001;
    logic [5:0]num_flc1_8   = 6'b011101;
    logic [5:0]num_flc1_9   = 6'b100001;
    logic [5:0]num_flc1_10  = 6'b100101;
    logic [5:0]num_flc1_11  = 6'b101001;
    logic [5:0]num_flc1_12  = 6'b101101;
    logic [5:0]num_flc1_13  = 6'b110001;
    logic [5:0]num_flc1_14  = 6'b110101;
    logic [5:0]num_flc1_15  = 6'b111001;
    logic [5:0]num_flc1_16  = 6'b111101;

    //T1s = 2
    logic [5:0]num_flc2_0   = 6'b000000; //UNASSIGNED
    logic [5:0]num_flc2_1  = 6'b000000; //UNASSIGNED
    logic [5:0]num_flc2_2   = 6'b000110;
    logic [5:0]num_flc2_3   = 6'b001010;
    logic [5:0]num_flc2_4   = 6'b001110;
    logic [5:0]num_flc2_5   = 6'b010010;
    logic [5:0]num_flc2_6   = 6'b010110;
    logic [5:0]num_flc2_7   = 6'b011010;
    logic [5:0]num_flc2_8   = 6'b011110;
    logic [5:0]num_flc2_9   = 6'b100010;
    logic [5:0]num_flc2_10  = 6'b100110;
    logic [5:0]num_flc2_11  = 6'b101010;
    logic [5:0]num_flc2_12  = 6'b101110;
    logic [5:0]num_flc2_13  = 6'b110010;
    logic [5:0]num_flc2_14  = 6'b110110;
    logic [5:0]num_flc2_15  = 6'b111010;
    logic [5:0]num_flc2_16  = 6'b111110;


    //T1s = 3
    logic [5:0]num_flc3_0   = 6'b000000; //UNASSIGNED
    logic [5:0]num_flc3_1  = 6'b000000; //UNASSIGNED
    logic [5:0]num_flc3_2   = 6'b000000; //UNASSIGNED
    logic [5:0]num_flc3_3   = 6'b001011;
    logic [5:0]num_flc3_4   = 6'b001111;
    logic [5:0]num_flc3_5   = 6'b010011;
    logic [5:0]num_flc3_6   = 6'b010111;
    logic [5:0]num_flc3_7   = 6'b011011;
    logic [5:0]num_flc3_8   = 6'b011111;
    logic [5:0]num_flc3_9   = 6'b100011;
    logic [5:0]num_flc3_10  = 6'b100111;
    logic [5:0]num_flc3_11  = 6'b101011;
    logic [5:0]num_flc3_12  = 6'b101111;
    logic [5:0]num_flc3_13  = 6'b110011;
    logic [5:0]num_flc3_14  = 6'b110111;
    logic [5:0]num_flc3_15  = 6'b111011;
    logic [5:0]num_flc3_16  = 6'b111111;
//     logic num_vlc0_0        = ;
//     logic [5:0]num_vlc0_1   = ;
//     logic [7:0]num_vlc0_2   = ;
//     logic [8:0]num_vlc0_3   = ;
//     logic [8:0]num_vlc0_4   = ;
//     logic [9:0]num_vlc0_5   = ;
//     logic [10:0]num_vlc0_6  = ;
//     logic [11:0]num_vlc0_7  = ;
//     logic [11:0]num_vlc0_8  = ;
//     logic [12:0]num_vlc0_9  = ;
//     logic [12:0]num_vlc0_10 = ;
//     logic [13:0]num_vlc0_11 = ;
//     logic [13:0]num_vlc0_12 = ;
//     logic [13:0]num_vlc0_13 = ;
//     logic [14:0]num_vlc0_14 = ;
//     logic [16:0]num_vlc0_15 = ;
//     logic [16:0]num_vlc0_16 = ;


//     logic num_vlc0_0        = ;
//     logic [5:0]num_vlc0_1   = ;
//     logic [7:0]num_vlc0_2   = ;
//     logic [8:0]num_vlc0_3   = ;
//     logic [8:0]num_vlc0_4   = ;
//     logic [9:0]num_vlc0_5   = ;
//     logic [10:0]num_vlc0_6  = ;
//     logic [11:0]num_vlc0_7  = ;
//     logic [11:0]num_vlc0_8  = ;
//     logic [12:0]num_vlc0_9  = ;
//     logic [12:0]num_vlc0_10 = ;
//     logic [13:0]num_vlc0_11 = ;
//     logic [13:0]num_vlc0_12 = ;
//     logic [13:0]num_vlc0_13 = ;
//     logic [14:0]num_vlc0_14 = ;
//     logic [16:0]num_vlc0_15 = ;
//     logic [16:0]num_vlc0_16 = ;


//     logic num_vlc0_0        = ;
//     logic [5:0]num_vlc0_1   = ;
//     logic [7:0]num_vlc0_2   = ;
//     logic [8:0]num_vlc0_3   = ;
//     logic [8:0]num_vlc0_4   = ;
//     logic [9:0]num_vlc0_5   = ;
//     logic [10:0]num_vlc0_6  = ;
//     logic [11:0]num_vlc0_7  = ;
//     logic [11:0]num_vlc0_8  = ;
//     logic [12:0]num_vlc0_9  = ;
//     logic [12:0]num_vlc0_10 = ;
//     logic [13:0]num_vlc0_11 = ;
//     logic [13:0]num_vlc0_12 = ;
//     logic [13:0]num_vlc0_13 = ;
//     logic [14:0]num_vlc0_14 = ;
//     logic [16:0]num_vlc0_15 = ;
//     logic [16:0]num_vlc0_16 = ;





    logic [3:0] N_vlc;
    logic [3:0] num_vlc_table_select;


    // MODULE INPUTS
    // input wire [3:0]num_coeff,
    // input wire [1:0]t1_s,
    // //N_upper
    // input wire nu_valid,
    // input wire [1:0]nu,
    // //N_left
    // input wire nl_valid,
    // input wire [1:0]nl,
    // //Chroma_DC
    // input wire is_chroma_DC,

always_comb begin 
        if (nu_valid && nl_valid) begin
            N_vlc = (nu+nl)/2;
        end else if (nu_valid) begin
            N_vlc = nu;
        end else if (nl_valid) begin
            N_vlc = nl;
        // end else if (is_chroma_DC) begin
        end else begin
            N_vlc = 0;
        end
end



    always_ff @(posedge clk ) begin
        if (rst) begin
            // N_vlc <=0;
            num_vlc_table_select <=0;

        end else if (axiiv) begin
            //Calculating VLC   table select


            if (is_chroma_DC) begin
                num_vlc_table_select <=4; //Using Chroma_DC table
            end else if (N_vlc < 2 && N_vlc >= 0) begin
                num_vlc_table_select <= 0;
            end else if (N_vlc >=2 && N_vlc <4) begin
                num_vlc_table_select <= 1;
            end else if (N_vlc >=4 && N_vlc <8) begin
                num_vlc_table_select <= 2;
            end else if (N_vlc >= 8) begin
                num_vlc_table_select <= 3;
            end


            //Encoding table Selector:
            //0 - Num-VLC0
            //1 - Num-VLC1
            //2 - Num-VLC2
            //3 - FLC
            //4 - Chroma_DC table
            
            case (num_vlc_table_select)

            0: begin

                case (t1_s)

                0: begin case (num_coeff)
                    0:  axiod <= num_vlc0_0_0;
                    1:  axiod <= num_vlc0_0_1;
                    2:  axiod <= num_vlc0_0_2;
                    3:  axiod <= num_vlc0_0_3;
                    4:  axiod <= num_vlc0_0_4;
                    5:  axiod <= num_vlc0_0_5;
                    6:  axiod <= num_vlc0_0_6;
                    7:  axiod <= num_vlc0_0_7;
                    8:  axiod <= num_vlc0_0_8;
                    9:  axiod <= num_vlc0_0_9;
                    10: axiod <= num_vlc0_0_10;
                    11: axiod <= num_vlc0_0_11;
                    12: axiod <= num_vlc0_0_12;
                    13: axiod <= num_vlc0_0_13;
                    14: axiod <= num_vlc0_0_14;
                    15: axiod <= num_vlc0_0_15;
                    16: axiod <= num_vlc0_0_16;
                endcase
                end 
                1: begin case (num_coeff)
                    0:  axiod <= num_vlc0_1_0;
                    1:  axiod <= num_vlc0_1_1;
                    2:  axiod <= num_vlc0_1_2;
                    3:  axiod <= num_vlc0_1_3;
                    4:  axiod <= num_vlc0_1_4;
                    5:  axiod <= num_vlc0_1_5;
                    6:  axiod <= num_vlc0_1_6;
                    7:  axiod <= num_vlc0_1_7;
                    8:  axiod <= num_vlc0_1_8;
                    9:  axiod <= num_vlc0_1_9;
                    10: axiod <= num_vlc0_1_10;
                    11: axiod <= num_vlc0_1_11;
                    12: axiod <= num_vlc0_1_12;
                    13: axiod <= num_vlc0_1_13;
                    14: axiod <= num_vlc0_1_14;
                    15: axiod <= num_vlc0_1_15;
                    16: axiod <= num_vlc0_1_16;
                endcase
                end

                2: begin case (num_coeff)
                    0:  axiod <= num_vlc0_2_0;
                    1:  axiod <= num_vlc0_2_1;
                    2:  axiod <= num_vlc0_2_2;
                    3:  axiod <= num_vlc0_2_3;
                    4:  axiod <= num_vlc0_2_4;
                    5:  axiod <= num_vlc0_2_5;
                    6:  axiod <= num_vlc0_2_6;
                    7:  axiod <= num_vlc0_2_7;
                    8:  axiod <= num_vlc0_2_8;
                    9:  axiod <= num_vlc0_2_9;
                    10: axiod <= num_vlc0_2_10;
                    11: axiod <= num_vlc0_2_11;
                    12: axiod <= num_vlc0_2_12;
                    13: axiod <= num_vlc0_2_13;
                    14: axiod <= num_vlc0_2_14;
                    15: axiod <= num_vlc0_2_15;
                    16: axiod <= num_vlc0_2_16;
                endcase
                end

                3: begin
                    case (num_coeff)
                    0:  axiod <= num_vlc0_3_0;
                    1:  axiod <= num_vlc0_3_1;
                    2:  axiod <= num_vlc0_3_2;
                    3:  axiod <= num_vlc0_3_3;
                    4:  axiod <= num_vlc0_3_4;
                    5:  axiod <= num_vlc0_3_5;
                    6:  axiod <= num_vlc0_3_6;
                    7:  axiod <= num_vlc0_3_7;
                    8:  axiod <= num_vlc0_3_8;
                    9:  axiod <= num_vlc0_3_9;
                    10: axiod <= num_vlc0_3_10;
                    11: axiod <= num_vlc0_3_11;
                    12: axiod <= num_vlc0_3_12;
                    13: axiod <= num_vlc0_3_13;
                    14: axiod <= num_vlc0_3_14;
                    15: axiod <= num_vlc0_3_15;
                    16: axiod <= num_vlc0_3_16;
                endcase
                end
                endcase
            end

            1: begin

                case (t1_s)

                0: begin case (num_coeff)
                    0:  axiod <= num_vlc1_0_0;
                    1:  axiod <= num_vlc1_0_1;
                    2:  axiod <= num_vlc1_0_2;
                    3:  axiod <= num_vlc1_0_3;
                    4:  axiod <= num_vlc1_0_4;
                    5:  axiod <= num_vlc1_0_5;
                    6:  axiod <= num_vlc1_0_6;
                    7:  axiod <= num_vlc1_0_7;
                    8:  axiod <= num_vlc1_0_8;
                    9:  axiod <= num_vlc1_0_9;
                    10: axiod <= num_vlc1_0_10;
                    11: axiod <= num_vlc1_0_11;
                    12: axiod <= num_vlc1_0_12;
                    13: axiod <= num_vlc1_0_13;
                    14: axiod <= num_vlc1_0_14;
                    15: axiod <= num_vlc1_0_15;
                    16: axiod <= num_vlc1_0_16;
                endcase
                end 
                1: begin case (num_coeff)
                    0:  axiod <= num_vlc1_1_0;
                    1:  axiod <= num_vlc1_1_1;
                    2:  axiod <= num_vlc1_1_2;
                    3:  axiod <= num_vlc1_1_3;
                    4:  axiod <= num_vlc1_1_4;
                    5:  axiod <= num_vlc1_1_5;
                    6:  axiod <= num_vlc1_1_6;
                    7:  axiod <= num_vlc1_1_7;
                    8:  axiod <= num_vlc1_1_8;
                    9:  axiod <= num_vlc1_1_9;
                    10: axiod <= num_vlc1_1_10;
                    11: axiod <= num_vlc1_1_11;
                    12: axiod <= num_vlc1_1_12;
                    13: axiod <= num_vlc1_1_13;
                    14: axiod <= num_vlc1_1_14;
                    15: axiod <= num_vlc1_1_15;
                    16: axiod <= num_vlc1_1_16;
                endcase
                end

                2: begin case (num_coeff)
                    0:  axiod <= num_vlc1_2_0;
                    1:  axiod <= num_vlc1_2_1;
                    2:  axiod <= num_vlc1_2_2;
                    3:  axiod <= num_vlc1_2_3;
                    4:  axiod <= num_vlc1_2_4;
                    5:  axiod <= num_vlc1_2_5;
                    6:  axiod <= num_vlc1_2_6;
                    7:  axiod <= num_vlc1_2_7;
                    8:  axiod <= num_vlc1_2_8;
                    9:  axiod <= num_vlc1_2_9;
                    10: axiod <= num_vlc1_2_10;
                    11: axiod <= num_vlc1_2_11;
                    12: axiod <= num_vlc1_2_12;
                    13: axiod <= num_vlc1_2_13;
                    14: axiod <= num_vlc1_2_14;
                    15: axiod <= num_vlc1_2_15;
                    16: axiod <= num_vlc1_2_16;
                endcase
                end

                3: begin
                    case (num_coeff)
                    0:  axiod <= num_vlc1_3_0;
                    1:  axiod <= num_vlc1_3_1;
                    2:  axiod <= num_vlc1_3_2;
                    3:  axiod <= num_vlc1_3_3;
                    4:  axiod <= num_vlc1_3_4;
                    5:  axiod <= num_vlc1_3_5;
                    6:  axiod <= num_vlc1_3_6;
                    7:  axiod <= num_vlc1_3_7;
                    8:  axiod <= num_vlc1_3_8;
                    9:  axiod <= num_vlc1_3_9;
                    10: axiod <= num_vlc1_3_10;
                    11: axiod <= num_vlc1_3_11;
                    12: axiod <= num_vlc1_3_12;
                    13: axiod <= num_vlc1_3_13;
                    14: axiod <= num_vlc1_3_14;
                    15: axiod <= num_vlc1_3_15;
                    16: axiod <= num_vlc1_3_16;
                endcase
                end
                endcase
            end


            2: begin

                case (t1_s)

                0: begin case (num_coeff)
                    0:  axiod <= num_vlc2_0_0;
                    1:  axiod <= num_vlc2_0_1;
                    2:  axiod <= num_vlc2_0_2;
                    3:  axiod <= num_vlc2_0_3;
                    4:  axiod <= num_vlc2_0_4;
                    5:  axiod <= num_vlc2_0_5;
                    6:  axiod <= num_vlc2_0_6;
                    7:  axiod <= num_vlc2_0_7;
                    8:  axiod <= num_vlc2_0_8;
                    9:  axiod <= num_vlc2_0_9;
                    10: axiod <= num_vlc2_0_10;
                    11: axiod <= num_vlc2_0_11;
                    12: axiod <= num_vlc2_0_12;
                    13: axiod <= num_vlc2_0_13;
                    14: axiod <= num_vlc2_0_14;
                    15: axiod <= num_vlc2_0_15;
                    16: axiod <= num_vlc2_0_16;
                endcase
                end 
                1: begin case (num_coeff)
                    0:  axiod <= num_vlc2_1_0;
                    1:  axiod <= num_vlc2_1_1;
                    2:  axiod <= num_vlc2_1_2;
                    3:  axiod <= num_vlc2_1_3;
                    4:  axiod <= num_vlc2_1_4;
                    5:  axiod <= num_vlc2_1_5;
                    6:  axiod <= num_vlc2_1_6;
                    7:  axiod <= num_vlc2_1_7;
                    8:  axiod <= num_vlc2_1_8;
                    9:  axiod <= num_vlc2_1_9;
                    10: axiod <= num_vlc2_1_10;
                    11: axiod <= num_vlc2_1_11;
                    12: axiod <= num_vlc2_1_12;
                    13: axiod <= num_vlc2_1_13;
                    14: axiod <= num_vlc2_1_14;
                    15: axiod <= num_vlc2_1_15;
                    16: axiod <= num_vlc2_1_16;
                endcase
                end

                2: begin case (num_coeff)
                    0:  axiod <= num_vlc2_2_0;
                    1:  axiod <= num_vlc2_2_1;
                    2:  axiod <= num_vlc2_2_2;
                    3:  axiod <= num_vlc2_2_3;
                    4:  axiod <= num_vlc2_2_4;
                    5:  axiod <= num_vlc2_2_5;
                    6:  axiod <= num_vlc2_2_6;
                    7:  axiod <= num_vlc2_2_7;
                    8:  axiod <= num_vlc2_2_8;
                    9:  axiod <= num_vlc2_2_9;
                    10: axiod <= num_vlc2_2_10;
                    11: axiod <= num_vlc2_2_11;
                    12: axiod <= num_vlc2_2_12;
                    13: axiod <= num_vlc2_2_13;
                    14: axiod <= num_vlc2_2_14;
                    15: axiod <= num_vlc2_2_15;
                    16: axiod <= num_vlc2_2_16;
                endcase
                end

                3: begin
                    case (num_coeff)
                    0:  axiod <= num_vlc2_3_0;
                    1:  axiod <= num_vlc2_3_1;
                    2:  axiod <= num_vlc2_3_2;
                    3:  axiod <= num_vlc2_3_3;
                    4:  axiod <= num_vlc2_3_4;
                    5:  axiod <= num_vlc2_3_5;
                    6:  axiod <= num_vlc2_3_6;
                    7:  axiod <= num_vlc2_3_7;
                    8:  axiod <= num_vlc2_3_8;
                    9:  axiod <= num_vlc2_3_9;
                    10: axiod <= num_vlc2_3_10;
                    11: axiod <= num_vlc2_3_11;
                    12: axiod <= num_vlc2_3_12;
                    13: axiod <= num_vlc2_3_13;
                    14: axiod <= num_vlc2_3_14;
                    15: axiod <= num_vlc2_3_15;
                    16: axiod <= num_vlc2_3_16;
                endcase
                end
                endcase
            end


            3: begin

                case (t1_s)

                0: begin case (num_coeff)
                    0:  axiod <= num_flc0_0;
                    1:  axiod <= num_flc0_1;
                    2:  axiod <= num_flc0_2;
                    3:  axiod <= num_flc0_3;
                    4:  axiod <= num_flc0_4;
                    5:  axiod <= num_flc0_5;
                    6:  axiod <= num_flc0_6;
                    7:  axiod <= num_flc0_7;
                    8:  axiod <= num_flc0_8;
                    9:  axiod <= num_flc0_9;
                    10: axiod <= num_flc0_10;
                    11: axiod <= num_flc0_11;
                    12: axiod <= num_flc0_12;
                    13: axiod <= num_flc0_13;
                    14: axiod <= num_flc0_14;
                    15: axiod <= num_flc0_15;
                    16: axiod <= num_flc0_16;
                endcase
                end 
                1: begin case (num_coeff)
                    0:  axiod <= num_flc1_0;
                    1:  axiod <= num_flc1_1;
                    2:  axiod <= num_flc1_2;
                    3:  axiod <= num_flc1_3;
                    4:  axiod <= num_flc1_4;
                    5:  axiod <= num_flc1_5;
                    6:  axiod <= num_flc1_6;
                    7:  axiod <= num_flc1_7;
                    8:  axiod <= num_flc1_8;
                    9:  axiod <= num_flc1_9;
                    10: axiod <= num_flc1_10;
                    11: axiod <= num_flc1_11;
                    12: axiod <= num_flc1_12;
                    13: axiod <= num_flc1_13;
                    14: axiod <= num_flc1_14;
                    15: axiod <= num_flc1_15;
                    16: axiod <= num_flc1_16;
                endcase
                end

                2: begin case (num_coeff)
                    0:  axiod <= num_flc2_0;
                    1:  axiod <= num_flc2_1;
                    2:  axiod <= num_flc2_2;
                    3:  axiod <= num_flc2_3;
                    4:  axiod <= num_flc2_4;
                    5:  axiod <= num_flc2_5;
                    6:  axiod <= num_flc2_6;
                    7:  axiod <= num_flc2_7;
                    8:  axiod <= num_flc2_8;
                    9:  axiod <= num_flc2_9;
                    10: axiod <= num_flc2_10;
                    11: axiod <= num_flc2_11;
                    12: axiod <= num_flc2_12;
                    13: axiod <= num_flc2_13;
                    14: axiod <= num_flc2_14;
                    15: axiod <= num_flc2_15;
                    16: axiod <= num_flc2_16;
                endcase
                end

                3: begin
                    case (num_coeff)
                    0:  axiod <= num_flc3_0;
                    1:  axiod <= num_flc3_1;
                    2:  axiod <= num_flc3_2;
                    3:  axiod <= num_flc3_3;
                    4:  axiod <= num_flc3_4;
                    5:  axiod <= num_flc3_5;
                    6:  axiod <= num_flc3_6;
                    7:  axiod <= num_flc3_7;
                    8:  axiod <= num_flc3_8;
                    9:  axiod <= num_flc3_9;
                    10: axiod <= num_flc3_10;
                    11: axiod <= num_flc3_11;
                    12: axiod <= num_flc3_12;
                    13: axiod <= num_flc3_13;
                    14: axiod <= num_flc3_14;
                    15: axiod <= num_flc3_15;
                    16: axiod <= num_flc3_16;
                endcase
                end
                endcase




            end

            4: begin

                case (t1_s)
                0: begin case (num_coeff)
                    1:  axiod <= num_vlc_dc_0_1; 
                    2:  axiod <= num_vlc_dc_0_2;
                    3:  axiod <= num_vlc_dc_0_3;
                    4:  axiod <= num_vlc_dc_0_4;

                endcase
                end 
                1: begin case (num_coeff)
                    1:  axiod <= num_vlc_dc_1_1;
                    2:  axiod <= num_vlc_dc_1_2;
                    3:  axiod <= num_vlc_dc_1_3;
                    4:  axiod <= num_vlc_dc_1_4;

                endcase
                end

                2: begin case (num_coeff)
                    1:  axiod <= num_vlc_dc_2_1;
                    2:  axiod <= num_vlc_dc_2_2;
                    3:  axiod <= num_vlc_dc_2_3;
                    4:  axiod <= num_vlc_dc_2_4;

                endcase
                end 

                3: begin
                    case (num_coeff)
                    1:  axiod <= num_vlc_dc_3_1;
                    2:  axiod <= num_vlc_dc_3_2;
                    3:  axiod <= num_vlc_dc_3_3;
                    4:  axiod <= num_vlc_dc_3_4;
                endcase
                end
                endcase

            end
            endcase

            axiov <=1;
        end else begin
            axiov <= 0;
        end
    end


endmodule


`default_nettype wire
