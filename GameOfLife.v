/***********************************************************************************/
/******************** Call everything from GameOfLife module... ********************/	
/***********************************************************************************/

module GameOfLife ( /*INPUTS & OUTPUTS*/
					input [9:0] SW, 
					input [3:0] KEY, 
					input CLOCK_50, 
					output VGA_CLK, VGA_HS, VGA_VS,
					output VGA_BLANK_N, VGA_SYNC_N, 
					output [7:0] VGA_R, VGA_G, VGA_B,
					output [9:0] LEDR, 
					output [6:0] HEX0, HEX1, HEX2, HEX3
				  );
				  

	//---------VAR DECLARATIONS---------//	
	wire       go;					// *go* determines the state of current game		 
	wire [4:0] preset;
	reg  [7:0] x;					// *x* coordinate of pixel
	reg  [6:0] y;					// *y* coordinate of pixel
	
	wire 		clock2Hz;			// 2Hz clock
	wire 		clock4Hz;			// 4Hz Clock
	
	parameter n = 32;				// *n* parameter specifies width of array
	parameter m = 32;				// *m* parameter specifies height of array
	
	reg  [n*m-1: 0] array;				// master array
	wire [n*m-1: 0] array_preset1;
	wire [n*m-1: 0] array_preset2;
	wire [n*m-1: 0] array_preset3;
	wire [n*m-1: 0] array_preset4;
	wire [n*m-1: 0] array_preset5;
	wire [n*m-1: 0] array_preset6;
	wire [n*m-1: 0] presetArray7;
	wire [n*m-1: 0] array_preset8;
	wire [n*m-1: 0] array_preset9;
	wire [n*m-1: 0] array_preset10;
	wire [n*m-1: 0] array_wir;    	// wire net to master array
	wire [n*m-1: 0] array_out;  		// output wire from nextStateSolver
	wire [n*m-1: 0] array_out_user;	// output wire from userSetLocation
	
	
	
	integer i, sum;
	wire [10:0] hex_sum;
	wire [3:0] hex0_, hex1_, hex2_, hex3_;
	
	/******************* INITIAL SETTING *******************/
	/*
	assign presetArray[n-1   :   0] = 4'b1011;
	assign presetArray[2*n-1 :   n] = 4'b1001;
	assign presetArray[3*n-1 : 2*n] = 4'b0100;
	assign presetArray[4*n-1 : 3*n] = 4'b0001;
	*/
	
	
	
	/*
	assign presetArray1[n-1   :   0] = 8'b10000000;
	assign presetArray1[2*n-1 :   n] = 8'b11110010;
	assign presetArray1[3*n-1 : 2*n] = 8'b00000010;
	assign presetArray1[4*n-1 : 3*n] = 8'b00000011;
	assign presetArray1[5*n-1 : 4*n] = 8'b00100010;
	assign presetArray1[6*n-1 : 5*n] = 8'b00001010;
	assign presetArray1[7*n-1 : 6*n] = 8'b01111010;
	assign presetArray1[8*n-1 : 7*n] = 8'b00110010;
	
	assign presetArray2[n-1   :   0] = 8'b11000000;
	assign presetArray2[2*n-1 :   n] = 8'b00000010;
	assign presetArray2[3*n-1 : 2*n] = 8'b00000010;
	assign presetArray2[4*n-1 : 3*n] = 8'b01110011;
	assign presetArray2[5*n-1 : 4*n] = 8'b00100010;
	assign presetArray2[6*n-1 : 5*n] = 8'b00001010;
	assign presetArray2[7*n-1 : 6*n] = 8'b01111010;
	assign presetArray2[8*n-1 : 7*n] = 8'b00110010;
	
	assign presetArray3[n-1   :   0] = 8'b11100000;
	assign presetArray3[2*n-1 :   n] = 8'b11110010;
	assign presetArray3[3*n-1 : 2*n] = 8'b00000010;
	assign presetArray3[4*n-1 : 3*n] = 8'b01110011;
	assign presetArray3[5*n-1 : 4*n] = 8'b00100010;
	assign presetArray3[6*n-1 : 5*n] = 8'b00001010;
	assign presetArray3[7*n-1 : 6*n] = 8'b01111010;
	assign presetArray3[8*n-1 : 7*n] = 8'b00110010;
	
	assign presetArray4[n-1   :   0] = 8'b11110000;
	assign presetArray4[2*n-1 :   n] = 8'b11110010;
	assign presetArray4[3*n-1 : 2*n] = 8'b00000010;
	assign presetArray4[4*n-1 : 3*n] = 8'b01110011;
	assign presetArray4[5*n-1 : 4*n] = 8'b00100010;
	assign presetArray4[6*n-1 : 5*n] = 8'b00001010;
	assign presetArray4[7*n-1 : 6*n] = 8'b01111010;
	assign presetArray4[8*n-1 : 7*n] = 8'b00110010;
	
	assign presetArray5[n-1   :   0] = 8'b11111000;
	assign presetArray5[2*n-1 :   n] = 8'b11110010;
	assign presetArray5[3*n-1 : 2*n] = 8'b00000010;
	assign presetArray5[4*n-1 : 3*n] = 8'b01110011;
	assign presetArray5[5*n-1 : 4*n] = 8'b00100010;
	assign presetArray5[6*n-1 : 5*n] = 8'b00001010;
	assign presetArray5[7*n-1 : 6*n] = 8'b01111010;
	assign presetArray5[8*n-1 : 7*n] = 8'b00110010;
	
	assign presetArray6[n-1   :   0] = 8'b11111100;
	assign presetArray6[2*n-1 :   n] = 8'b11110010;
	assign presetArray6[3*n-1 : 2*n] = 8'b00000010;
	assign presetArray6[4*n-1 : 3*n] = 8'b01110011;
	assign presetArray6[5*n-1 : 4*n] = 8'b00100010;
	assign presetArray6[6*n-1 : 5*n] = 8'b00001010;
	assign presetArray6[7*n-1 : 6*n] = 8'b01111010;
	assign presetArray6[8*n-1 : 7*n] = 8'b00110010;
	
	assign presetArray7[n-1   :   0] = 8'b11111110;
	assign presetArray7[2*n-1 :   n] = 8'b11110010;
	assign presetArray7[3*n-1 : 2*n] = 8'b00000010;
	assign presetArray7[4*n-1 : 3*n] = 8'b01110011;
	assign presetArray7[5*n-1 : 4*n] = 8'b00100010;
	assign presetArray7[6*n-1 : 5*n] = 8'b00001010;
	assign presetArray7[7*n-1 : 6*n] = 8'b01001010;
	assign presetArray7[8*n-1 : 7*n] = 8'b00110010;
	*/
	
	/*
	assign presetArray[n-1   :   0] <= 16'b1111111000111110;
	assign presetArray[2*n-1 :   n] <= 16'b1111001000100000;
	assign presetArray[3*n-1 : 2*n] <= 16'b0000001000100000;
	assign presetArray[4*n-1 : 3*n] <= 16'b0001001000100000;
	assign presetArray[5*n-1 : 4*n] <= 16'b0000001000100000;
	assign presetArray[6*n-1 : 5*n] <= 16'b0000101000100000;
	assign presetArray[7*n-1 : 6*n] <= 16'b0111101000100000;
	assign presetArray[8*n-1 : 7*n] <= 16'b0011001000100000;
	assign presetArray[9*n-1 : 8*n] <= 16'b0000001000100000;
	assign presetArray[10*n-1: 9*n] <= 16'b1111001000100000;
	assign presetArray[11*n-1:10*n] <= 16'b0000001000100100;
	assign presetArray[12*n-1:11*n] <= 16'b0000001000100000;
	assign presetArray[13*n-1:12*n] <= 16'b0000001000100000;
	assign presetArray[14*n-1:13*n] <= 16'b0011001000100000;
	assign presetArray[15*n-1:14*n] <= 16'b0011001000100000;
	assign presetArray[16*n-1:15*n] <= 16'b0000001000100000;
	*/
	/*
	assign presetArray[n-1   :   0] <= 32'b11111110001111101111111000111110;
	assign presetArray[2*n-1 :   n] <= 32'b11110010001000001111001000100000;
	assign presetArray[3*n-1 : 2*n] <= 32'b00000010001000000000001000100000;
	assign presetArray[4*n-1 : 3*n] <= 32'b00010010101000000001001010100000;
	assign presetArray[5*n-1 : 4*n] <= 32'b01000110001111000100011000111100;
	assign presetArray[6*n-1 : 5*n] <= 32'b00001010001100000000101000110000;
	assign presetArray[7*n-1 : 6*n] <= 32'b01111011101110000111101000111000;
	assign presetArray[8*n-1 : 7*n] <= 32'b00110010001010000011001000101000;
	assign presetArray[9*n-1 : 8*n] <= 32'b00100010001100000010001000110000;
	assign presetArray[10*n-1: 9*n] <= 32'b11110010001000001111001000100000;
	assign presetArray[11*n-1:10*n] <= 32'b00010111001001000001011100100100;
	assign presetArray[12*n-1:11*n] <= 32'b00011010001000000001101000100000;
	assign presetArray[13*n-1:12*n] <= 32'b00000011001000000000001100100000;
	assign presetArray[14*n-1:13*n] <= 32'b00110011001000000011001100100000;
	assign presetArray[15*n-1:14*n] <= 32'b00110010001000000011001000100000;
	assign presetArray[16*n-1:15*n] <= 32'b00000010001000000000001000100000;
	assign presetArray[17*n-1:16*n] <= 32'b11111110001111101111111000111110;
	assign presetArray[18*n-1:17*n] <= 32'b11110010001000001111001000100000;
	assign presetArray[19*n-1:18*n] <= 32'b00000010001000000000001000100000;
	assign presetArray[20*n-1:19*n] <= 32'b00010010101000110001001010100000;
	assign presetArray[21*n-1:20*n] <= 32'b01000110001111000100011000111100;
	assign presetArray[22*n-1:21*n] <= 32'b00001010001100000000101000110000;
	assign presetArray[23*n-1:22*n] <= 32'b01111010001110000111101000111000;
	assign presetArray[24*n-1:23*n] <= 32'b00110010001010000011001000101000;
	assign presetArray[25*n-1:24*n] <= 32'b00100010001100000010001000110000;
	assign presetArray[26*n-1:25*n] <= 32'b11110010001000001111001000100000;
	assign presetArray[27*n-1:26*n] <= 32'b00010111001001000001011100100100;
	assign presetArray[28*n-1:27*n] <= 32'b00011010001000000001101000100000;
	assign presetArray[29*n-1:28*n] <= 32'b00000011001000111000001100100000;
	assign presetArray[30*n-1:29*n] <= 32'b00110011001000000011001100100000;
	assign presetArray[31*n-1:30*n] <= 32'b00110010001000000011001000100000;
	assign presetArray[32*n-1:31*n] <= 32'b00000010001000000000001000100000;
	*/
	
	assign presetArray7[n-1   :   0] = 32'b11111110001111101111111000111110;
	assign presetArray7[2*n-1 :   n] = 32'b11110010001000001111001000100000;
	assign presetArray7[3*n-1 : 2*n] = 32'b00000010001000000000001000100000;
	assign presetArray7[4*n-1 : 3*n] = 32'b00010010101000000001001010100000;
	assign presetArray7[5*n-1 : 4*n] = 32'b01000110001111000100011000111100;
	assign presetArray7[6*n-1 : 5*n] = 32'b00001010001100000000101000110000;
	assign presetArray7[7*n-1 : 6*n] = 32'b01111011101110000111101000111000;
	assign presetArray7[8*n-1 : 7*n] = 32'b00110010001010000011001000101000;
	assign presetArray7[9*n-1 : 8*n] = 32'b00100010001100000010001000110000;
	assign presetArray7[10*n-1: 9*n] = 32'b11110010001000001111001000100000;
	assign presetArray7[11*n-1:10*n] = 32'b00010111001001000001011100100100;
	assign presetArray7[12*n-1:11*n] = 32'b00011010001000000001101000100000;
	assign presetArray7[13*n-1:12*n] = 32'b00000011001000000000001100100000;
	assign presetArray7[14*n-1:13*n] = 32'b00110011001000000011001100100000;
	assign presetArray7[15*n-1:14*n] = 32'b00110010001000000011001000100000;
	assign presetArray7[16*n-1:15*n] = 32'b00000010001000000000001000100000;
	assign presetArray7[17*n-1:16*n] = 32'b11111110001111101111111000111110;
	assign presetArray7[18*n-1:17*n] = 32'b11110010001000001111001000100000;
	assign presetArray7[19*n-1:18*n] = 32'b00000010001000000000001000100000;
	assign presetArray7[20*n-1:19*n] = 32'b00010010101000110001001010100000;
	assign presetArray7[21*n-1:20*n] = 32'b01000110001111000100011000111100;
	assign presetArray7[22*n-1:21*n] = 32'b00001010001100000000101000110000;
	assign presetArray7[23*n-1:22*n] = 32'b01111010001110000111101000111000;
	assign presetArray7[24*n-1:23*n] = 32'b00110010001010000011001000101000;
	assign presetArray7[25*n-1:24*n] = 32'b00100010001100000010001000110000;
	assign presetArray7[26*n-1:25*n] = 32'b11110010001000001111001000100000;
	assign presetArray7[27*n-1:26*n] = 32'b00010111001001000001011100100100;
	assign presetArray7[28*n-1:27*n] = 32'b00011010001000000001101000100000;
	assign presetArray7[29*n-1:28*n] = 32'b00000011001000111000001100100000;
	assign presetArray7[30*n-1:29*n] = 32'b00110011001000000011001100100000;
	assign presetArray7[31*n-1:30*n] = 32'b00110010001000000011001000100000;
	assign presetArray7[32*n-1:31*n] = 32'b00000010001000000000001000100000;
	/*
	assign presetArray2 = 0;
	assign presetArray3 = 0;
	assign presetArray4 = 0;
	assign presetArray5 = 0;
	assign presetArray6 = 0;
	assign presetArray7 = 0;
	*/
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	assign array_preset6[n-1   :   0] = 32'b00000000000000000000000000000000;
	assign array_preset6[2*n-1 :   n] = 32'b00000000000000000000000000000000;
	assign array_preset6[3*n-1 : 2*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[4*n-1 : 3*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[5*n-1 : 4*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[6*n-1 : 5*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[7*n-1 : 6*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[8*n-1 : 7*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[9*n-1 : 8*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[10*n-1: 9*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[11*n-1:10*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[12*n-1:11*n] = 32'b00000000000111000000000000000000;
	assign array_preset6[13*n-1:12*n] = 32'b00000000000101000000000000000000;
	assign array_preset6[14*n-1:13*n] = 32'b00000000000111000000000000000000;
	assign array_preset6[15*n-1:14*n] = 32'b00000000000000100000000000000000;
	assign array_preset6[16*n-1:15*n] = 32'b00000000000000011100000000000000;
	assign array_preset6[17*n-1:16*n] = 32'b00000000000000010100000000000000;
	assign array_preset6[18*n-1:17*n] = 32'b00000000000000011100000000000000;
	assign array_preset6[19*n-1:18*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[20*n-1:19*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[21*n-1:20*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[22*n-1:21*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[23*n-1:22*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[24*n-1:23*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[25*n-1:24*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[26*n-1:25*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[27*n-1:26*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[28*n-1:27*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[29*n-1:28*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[30*n-1:29*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[31*n-1:30*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[32*n-1:31*n] = 32'b00000000000000000000000000000000;

	
	
	assign array_preset1[n-1   :   0] = 32'b00000000000000000000000000000000;
	assign array_preset1[2*n-1 :   n] = 32'b00000000000000000000000000000000;
	assign array_preset1[3*n-1 : 2*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[4*n-1 : 3*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[5*n-1 : 4*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[6*n-1 : 5*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[7*n-1 : 6*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[8*n-1 : 7*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[9*n-1 : 8*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[10*n-1: 9*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[11*n-1:10*n] = 32'b00000000000110000000000000000000;
	assign array_preset1[12*n-1:11*n] = 32'b00000000001100000000000000000000;
	assign array_preset1[13*n-1:12*n] = 32'b00000000000010000000000000000000;
	assign array_preset1[14*n-1:13*n] = 32'b00000000000000110000000000000000;
	assign array_preset1[15*n-1:14*n] = 32'b00000000000001000000000000000000;
	assign array_preset1[16*n-1:15*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[17*n-1:16*n] = 32'b00000000000010010000000000000000;
	assign array_preset1[18*n-1:17*n] = 32'b00000000011010000000000000000000;
	assign array_preset1[19*n-1:18*n] = 32'b00000000110000100000000000000000;
	assign array_preset1[20*n-1:19*n] = 32'b00000000001010010000000000000000;
	assign array_preset1[21*n-1:20*n] = 32'b00000000000000010000000000000000;
	assign array_preset1[22*n-1:21*n] = 32'b00000000000010010000000000000000;
	assign array_preset1[23*n-1:22*n] = 32'b00000000000001010000000000000000;
	assign array_preset1[24*n-1:23*n] = 32'b00000000000001010000000000000000;
	assign array_preset1[25*n-1:24*n] = 32'b00000000000000110000000000000000;
	assign array_preset1[26*n-1:25*n] = 32'b00000000000000100000000000000000;
	assign array_preset1[27*n-1:26*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[28*n-1:27*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[29*n-1:28*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[30*n-1:29*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[31*n-1:30*n] = 32'b00000000000000000000000000000000;
	assign array_preset1[32*n-1:31*n] = 32'b00000000000000000000000000000000;

	
	
	assign array_preset2[n-1   :   0] = 32'b00000000000000000000000000000000;
	assign array_preset2[2*n-1 :   n] = 32'b00000000000000000000000000000000;
	assign array_preset2[3*n-1 : 2*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[4*n-1 : 3*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[5*n-1 : 4*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[6*n-1 : 5*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[7*n-1 : 6*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[8*n-1 : 7*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[9*n-1 : 8*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[10*n-1: 9*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[11*n-1:10*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[12*n-1:11*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[13*n-1:12*n] = 32'b00000011100000000000000000000000;
	assign array_preset2[14*n-1:13*n] = 32'b00000010000000001100000000000000;
	assign array_preset2[15*n-1:14*n] = 32'b00000001000000111010000000000000;
	assign array_preset2[16*n-1:15*n] = 32'b00000000011001100000000000000000;
	assign array_preset2[17*n-1:16*n] = 32'b00000000001000000000000000000000;
	assign array_preset2[18*n-1:17*n] = 32'b00000000000000100000000000000000;
	assign array_preset2[19*n-1:18*n] = 32'b00000000001100010000000000000000;
	assign array_preset2[20*n-1:19*n] = 32'b00000000010101100000000000000000;
	assign array_preset2[21*n-1:20*n] = 32'b00000000010100101100000000000000;
	assign array_preset2[22*n-1:21*n] = 32'b00000000100001100000000000000000;
	assign array_preset2[23*n-1:22*n] = 32'b00000000110000000000000000000000;
	assign array_preset2[24*n-1:23*n] = 32'b00000000110000000000000000000000;
	assign array_preset2[25*n-1:24*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[26*n-1:25*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[27*n-1:26*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[28*n-1:27*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[29*n-1:28*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[30*n-1:29*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[31*n-1:30*n] = 32'b00000000000000000000000000000000;
	assign array_preset2[32*n-1:31*n] = 32'b00000000000000000000000000000000;
		
	assign array_preset3[n-1   :   0] = 32'b00000000000000000000000000000000;
	assign array_preset3[2*n-1 :   n] = 32'b00000000000000000000000000000000;
	assign array_preset3[3*n-1 : 2*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[4*n-1 : 3*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[5*n-1 : 4*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[6*n-1 : 5*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[7*n-1 : 6*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[8*n-1 : 7*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[9*n-1 : 8*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[10*n-1: 9*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[11*n-1:10*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[12*n-1:11*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[13*n-1:12*n] = 32'b00000000000010000000000000000000;
	assign array_preset3[14*n-1:13*n] = 32'b00000000110010100000000000000000;
	assign array_preset3[15*n-1:14*n] = 32'b00000000101000000000000000000000;
	assign array_preset3[16*n-1:15*n] = 32'b00000000000000011000000000000000;
	assign array_preset3[17*n-1:16*n] = 32'b00000000010000000000000000000000;
	assign array_preset3[18*n-1:17*n] = 32'b00000000100000010000000000000000;
	assign array_preset3[19*n-1:18*n] = 32'b00000000110101000000000000000000;
	assign array_preset3[20*n-1:19*n] = 32'b00000000000001000000000000000000;
	assign array_preset3[21*n-1:20*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[22*n-1:21*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[23*n-1:22*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[24*n-1:23*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[25*n-1:24*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[26*n-1:25*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[27*n-1:26*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[28*n-1:27*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[29*n-1:28*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[30*n-1:29*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[31*n-1:30*n] = 32'b00000000000000000000000000000000;
	assign array_preset3[32*n-1:31*n] = 32'b00000000000000000000000000000000;
	
	
	assign array_preset4[n-1   :   0] = 32'b00000000000000000000000000000000;
	assign array_preset4[2*n-1 :   n] = 32'b00000000000000000000000000000000;
	assign array_preset4[3*n-1 : 2*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[4*n-1 : 3*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[5*n-1 : 4*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[6*n-1 : 5*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[7*n-1 : 6*n] = 32'b00000000011000000110000000000000;
	assign array_preset4[8*n-1 : 7*n] = 32'b00000000100100001001000000000000;
	assign array_preset4[9*n-1 : 8*n] = 32'b00000000101000000101000000000000;
	assign array_preset4[10*n-1: 9*n] = 32'b00000011001110011100110000000000;
	assign array_preset4[11*n-1:10*n] = 32'b00000100000010010000001000000000;
	assign array_preset4[12*n-1:11*n] = 32'b00000101100000000001101000000000;
	assign array_preset4[13*n-1:12*n] = 32'b00000010100000000001010000000000;
	assign array_preset4[14*n-1:13*n] = 32'b00000000110000000011000000000000;
	assign array_preset4[15*n-1:14*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[16*n-1:15*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[17*n-1:16*n] = 32'b00000000110000000011000000000000;
	assign array_preset4[18*n-1:17*n] = 32'b00000010100000000001010000000000;
	assign array_preset4[19*n-1:18*n] = 32'b00000101100000000001101000000000;
	assign array_preset4[20*n-1:19*n] = 32'b00000100000010010000001000000000;
	assign array_preset4[21*n-1:20*n] = 32'b00000011001110011100110000000000;
	assign array_preset4[22*n-1:21*n] = 32'b00000000101000000101000000000000;
	assign array_preset4[23*n-1:22*n] = 32'b00000000100100001001000000000000;
	assign array_preset4[24*n-1:23*n] = 32'b00000000011000000110000000000000;
	assign array_preset4[25*n-1:24*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[26*n-1:25*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[27*n-1:26*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[28*n-1:27*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[29*n-1:28*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[30*n-1:29*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[31*n-1:30*n] = 32'b00000000000000000000000000000000;
	assign array_preset4[32*n-1:31*n] = 32'b00000000000000000000000000000000;

	
	
	assign array_preset5[n-1   :   0] = 32'b00000000000000000000000000000000;
	assign array_preset5[2*n-1 :   n] = 32'b00000000000000000000000000000000;
	assign array_preset5[3*n-1 : 2*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[4*n-1 : 3*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[5*n-1 : 4*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[6*n-1 : 5*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[7*n-1 : 6*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[8*n-1 : 7*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[9*n-1 : 8*n] = 32'b00000000000001100000000000000000;
	assign array_preset5[10*n-1: 9*n] = 32'b00000000000001010000000000000000;
	assign array_preset5[11*n-1:10*n] = 32'b00000000100001011000000000000000;
	assign array_preset5[12*n-1:11*n] = 32'b00000001100000100000000000000000;
	assign array_preset5[13*n-1:12*n] = 32'b00000010010000000000000000000000;
	assign array_preset5[14*n-1:13*n] = 32'b00000011100000000000000000000000;
	assign array_preset5[15*n-1:14*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[16*n-1:15*n] = 32'b00000000000000001110000000000000;
	assign array_preset5[17*n-1:16*n] = 32'b00000000000000010010000000000000;
	assign array_preset5[18*n-1:17*n] = 32'b00000000001000001100000000000000;
	assign array_preset5[19*n-1:18*n] = 32'b00000000110100001000000000000000;
	assign array_preset5[20*n-1:19*n] = 32'b00000000010100000000000000000000;
	assign array_preset5[21*n-1:20*n] = 32'b00000000001100000000000000000000;
	assign array_preset5[22*n-1:21*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[23*n-1:22*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[24*n-1:23*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[25*n-1:24*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[26*n-1:25*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[27*n-1:26*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[28*n-1:27*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[29*n-1:28*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[30*n-1:29*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[31*n-1:30*n] = 32'b00000000000000000000000000000000;
	assign array_preset5[32*n-1:31*n] = 32'b00000000000000000000000000000000;
	
	
	assign array_preset8[n-1   :   0] = 32'b00000000000000000000000000000000;
	assign array_preset8[2*n-1 :   n] = 32'b00000000000000000000000000000000;
	assign array_preset8[3*n-1 : 2*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[4*n-1 : 3*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[5*n-1 : 4*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[6*n-1 : 5*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[7*n-1 : 6*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[8*n-1 : 7*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[9*n-1 : 8*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[10*n-1: 9*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[11*n-1:10*n] = 32'b00000000000000000011000000000000;
	assign array_preset8[12*n-1:11*n] = 32'b00000000000000000101000000000000;
	assign array_preset8[13*n-1:12*n] = 32'b00000000000000001000000000000000;
	assign array_preset8[14*n-1:13*n] = 32'b00000000000000010000000000000000;
	assign array_preset8[15*n-1:14*n] = 32'b00000000000000100000000000000000;
	assign array_preset8[16*n-1:15*n] = 32'b00000000000001000000000000000000;
	assign array_preset8[17*n-1:16*n] = 32'b00000000000010000000000000000000;
	assign array_preset8[18*n-1:17*n] = 32'b00000000000100000000000000000000;
	assign array_preset8[19*n-1:18*n] = 32'b00000000001000000000000000000000;
	assign array_preset8[20*n-1:19*n] = 32'b00000000010000000000000000000000;
	assign array_preset8[21*n-1:20*n] = 32'b00000000100000000000000000000000;
	assign array_preset8[22*n-1:21*n] = 32'b00000001000000000000000000000000;
	assign array_preset8[23*n-1:22*n] = 32'b00111110000000000000000000000000;
	assign array_preset8[24*n-1:23*n] = 32'b00111100000000000000000000000000;
	assign array_preset8[25*n-1:24*n] = 32'b00101100000000000000000000000000;
	assign array_preset8[26*n-1:25*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[27*n-1:26*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[28*n-1:27*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[29*n-1:28*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[30*n-1:29*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[31*n-1:30*n] = 32'b00000000000000000000000000000000;
	assign array_preset8[32*n-1:31*n] = 32'b00000000000000000000000000000000;

	
	
	assign array_preset9[n-1   :   0] = 32'b00000000000000000000000000000000;
	assign array_preset9[2*n-1 :   n] = 32'b00000000000000000000000000000000;
	assign array_preset9[3*n-1 : 2*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[4*n-1 : 3*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[5*n-1 : 4*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[6*n-1 : 5*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[7*n-1 : 6*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[8*n-1 : 7*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[9*n-1 : 8*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[10*n-1: 9*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[11*n-1:10*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[12*n-1:11*n] = 32'b00000000000100000000000000000000;
	assign array_preset9[13*n-1:12*n] = 32'b00000000001001000000000000000000;
	assign array_preset9[14*n-1:13*n] = 32'b00000001001001000000000000000000;
	assign array_preset9[15*n-1:14*n] = 32'b00000010101010110000000000000000;
	assign array_preset9[16*n-1:15*n] = 32'b00000001001001000000000000000000;
	assign array_preset9[17*n-1:16*n] = 32'b00000000001000001000000000000000;
	assign array_preset9[18*n-1:17*n] = 32'b00000000000111110000000000000000;
	assign array_preset9[19*n-1:18*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[20*n-1:19*n] = 32'b00000000000001000000000000000000;
	assign array_preset9[21*n-1:20*n] = 32'b00000000000010100000000000000000;
	assign array_preset9[22*n-1:21*n] = 32'b00000000000001000000000000000000;
	assign array_preset9[23*n-1:22*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[24*n-1:23*n] = 32'b00000000000000000000000000000000;
	assign array_preset6[25*n-1:24*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[26*n-1:25*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[27*n-1:26*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[28*n-1:27*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[29*n-1:28*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[30*n-1:29*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[31*n-1:30*n] = 32'b00000000000000000000000000000000;
	assign array_preset9[32*n-1:31*n] = 32'b00000000000000000000000000000000;

	assign array_preset10[n-1   :   0] = 32'b00000000000000000000000000000000;
	assign array_preset10[2*n-1 :   n] = 32'b00000000000000111111111111100000;
	assign array_preset10[3*n-1 : 2*n] = 32'b00000000011111110000000000000000;
	assign array_preset10[4*n-1 : 3*n] = 32'b00000111110000000000000110000000;
	assign array_preset10[5*n-1 : 4*n] = 32'b00000000000000000001111100000000;
	assign array_preset10[6*n-1 : 5*n] = 32'b00011111111100000110000000000000;
	assign array_preset10[7*n-1 : 6*n] = 32'b00000000011100000111100000000000;
	assign array_preset10[8*n-1 : 7*n] = 32'b00000000000000000110011000001100;
	assign array_preset10[9*n-1 : 8*n] = 32'b00000011111110000110000110011000;
	assign array_preset10[10*n-1: 9*n] = 32'b00111110000001111111000001100000;
	assign array_preset10[11*n-1:10*n] = 32'b00011111111100000000000011000000;
	assign array_preset10[12*n-1:11*n] = 32'b00011100000100000001111000000000;
	assign array_preset10[13*n-1:12*n] = 32'b00111000001001000011000001100000;
	assign array_preset10[14*n-1:13*n] = 32'b00000001001001000000000001111000;
	assign array_preset10[15*n-1:14*n] = 32'b00000010101010000000000000000000;
	assign array_preset10[16*n-1:15*n] = 32'b00000001001001000000000000000000;
	assign array_preset10[17*n-1:16*n] = 32'b00000000001000000000000000000100;
	assign array_preset10[18*n-1:17*n] = 32'b00000000000111110000000000000100;
	assign array_preset10[19*n-1:18*n] = 32'b00001100000000111100000000010100;
	assign array_preset10[20*n-1:19*n] = 32'b00110000000001001111100000010100;
	assign array_preset10[21*n-1:20*n] = 32'b00000000000010100000000000000000;
	assign array_preset10[22*n-1:21*n] = 32'b00000000000001100000000000000000;
	assign array_preset10[23*n-1:22*n] = 32'b00001100000000111000000000000000;
	assign array_preset10[24*n-1:23*n] = 32'b00000000000110000000000000000000;
	assign array_preset10[25*n-1:24*n] = 32'b00000000000110000001111111111110;
	assign array_preset10[26*n-1:25*n] = 32'b00000000011000000000000000000000;
	assign array_preset10[27*n-1:26*n] = 32'b00000110000000000011110000000000;
	assign array_preset10[28*n-1:27*n] = 32'b00000111000000000000000000000000;
	assign array_preset10[29*n-1:28*n] = 32'b00000000100000000000111000000000;
	assign array_preset10[30*n-1:29*n] = 32'b00000000110110000000011100000000;
	assign array_preset10[31*n-1:30*n] = 32'b00000000100011111110000000000000;
	assign array_preset10[32*n-1:31*n] = 32'b00000000000000000000000000000000;







	
	
	/*******************************************************/
	
	assign array_wir = array;
	assign LEDR[0] = go;
	
	/*******************************************************/

	wire resetn;
	assign resetn = ~KEY[0];
	
	
	// Feedback to master array from either (0) array_out_user or (1) array_out (depends on *go*)
	always@(posedge CLOCK_50 or posedge resetn)
	begin
			case(go)
				1'b0: begin
						if(!resetn) begin
							case(preset)
								4'b0000: array <= array_out_user;
								4'b0001: array <= array_preset1;
								4'b0010: array <= array_preset2;
								4'b0011: array <= array_preset3;
								4'b0100: array <= array_preset4;
								4'b0101: array <= array_preset5;
								4'b0110: array <= array_preset6;
								4'b0111: array <= presetArray7;
								4'b1000: array <= array_preset8;
								4'b1001: array <= array_preset9;
								4'b1010: array <= array_preset10;
								default: array <= array_out_user;
							endcase
						end
						else
							array <= 0;
						end
				1'b1: array <= array_out;
			endcase
	 end
	/****************************************************************************************************/
	
		/***** GAME FSM *****/
		currentGameStateFSM FSM(.w(~KEY[3]), .x(~KEY[2]), .go(go), .preset(preset)); // sets go
	
		/***** 2Hz CLOCK *****/
		clock2Hz setClock2(.CLOCK_50(CLOCK_50), .clock(clock2Hz));
		clock4Hz setClock4(.CLOCK_50(CLOCK_50), .clock(clock4Hz));
	
		/***** NEXT STATE SOLVER *****/
		nextStateSolver solvesquare(.array(array_wir), .clock(clock4Hz), .go(go), .array_out(array_out), .hex_sum(hex_sum));
		
	/****************************************************************************************************/
	
	// loops (@50MHz) through x, y to print screen
	reg text_out = 0;
	always @(posedge CLOCK_50)
		begin
			if (!text_out)
				if (x == 2*n+3) begin
					x <= 0;
					if (y == 2*m+3) begin
						text_out <= 1;
						x <= 10;
						y <= 80;
					end
					else  y <= y + 1;
				end else x <= x + 1;
				
			else if (text_out) begin
				if (x == 25) begin
					x <= 10;
					if (y == 99) begin
						text_out <= 0;
						x <= 0;
						y <= 0;
					end
					else  y <= y + 1;
				end else x <= x + 1;
			end
		end
			
/************************ SCREEN OUTPUT ********************************************/
		fill screenOut(
				.CLOCK_50(CLOCK_50),  			  // On Board 50 MHz
				.resetn(KEY[0]),		  				  // On Board Keys
				.x_wir(x),						  // pass in x (modified above)
				.y_wir(y),						  // pass in y (modified above)
				.array(array_wir),
				.x_in(SW[4:0]),
				.y_in(SW[9:5]),
				.preset(preset),
				
				.VGA_CLK(VGA_CLK),   		      //  VGA Clock
				.VGA_HS(VGA_HS),  			 	  //  VGA H_SYNC
				.VGA_VS(VGA_VS),				  //  VGA V_SYNC
				.VGA_BLANK_N(VGA_BLANK_N),		  //  VGA BLANK
				.VGA_SYNC_N(VGA_SYNC_N),		  //  VGA SYNC
				.VGA_R(VGA_R),   	  			  //  VGA Red[9:0]
				.VGA_G(VGA_G),					  //  VGA Green[9:0]
				.VGA_B(VGA_B)					  //  VGA Blue[9:0]
				);			
				
		

		/***** LET USER PICK LIVE PIXELS *****/
		userSetLocation userSelect(.clock(CLOCK_50), .SW(SW[9:0]), .KEY(KEY[1]), .go(go), .array_in(array_wir), .array_out_user(array_out_user), .x_hex(x_hex), .y_hex(y_hex));
	
		/***** DECIDE WHAT TO DISPLAY ON HEX *****/
		toDisplayOnHex display(.hex_sum(hex_sum), .hex0_(hex0_), .hex1_(hex1_), .hex2_(hex2_), .hex3_(hex3));
	
		/***** HEX DISPLAYS *****/
		hex_decoder h0(.hex_digit(hex0_), .segments(HEX0));
		hex_decoder h1(.hex_digit(hex1_), .segments(HEX1));
		hex_decoder h2(.hex_digit(hex2_), .segments(HEX2));
		hex_decoder h3(.hex_digit(hex3_), .segments(HEX3));
	
	/****************************************************************************************************/

endmodule

module fill(
			input CLOCK_50,			// On Board 50 MHz
			input resetn,			// On Board Keys
			input [7:0]  x_wir,     // x coordinate
			input [6:0]  y_wir,    	// y coordinate
			input [n*m-1:0] array,  // master array wire
			input [4:0] x_in,
			input [4:0] y_in,
			input [4:0] preset,

			// Ports below are for the VGA output, Don't change.
			output	 	 VGA_CLK,   		//  VGA Clock
			output       VGA_HS,  			//  VGA H_SYNC
			output 	    VGA_VS,				//  VGA V_SYNC
			output       VGA_BLANK_N,		//  VGA BLANK
			output 	    VGA_SYNC_N,		//  VGA SYNC
			output [9:0] VGA_R,   			//  VGA Red[9:0]
			output [9:0] VGA_G,	 			//  VGA Green[9:0]
			output [9:0] VGA_B   			//  VGA Blue[9:0]
		   );
			
	wire [0:11*5-1] text_pre;
	wire [0:11*5-1] text_usr;
	
	wire [0:5*5-1] text_x;
	wire [0:5*5-1] text_y;
	
	wire [0:3*5-1] text_0;
	wire [0:3*5-1] text_1;
	wire [0:3*5-1] text_2;
	wire [0:3*5-1] text_3;
	wire [0:3*5-1] text_4;
	wire [0:3*5-1] text_5;
	wire [0:3*5-1] text_6;
	wire [0:3*5-1] text_7;
	wire [0:3*5-1] text_8;
	wire [0:3*5-1] text_9;
	
	assign text_pre[0: 10] = 11'b11101110111;
	assign text_pre[11:21] = 11'b10101010100;
	assign text_pre[22:32] = 11'b11101110111;
	assign text_pre[33:43] = 11'b10001100100;
	assign text_pre[44:54] = 11'b10001010111;
	
	assign text_usr[0: 10] = 11'b10101110111;
	assign text_usr[11:21] = 11'b10101000101;
	assign text_usr[22:32] = 11'b10101110111;
	assign text_usr[33:43] = 11'b10100010110;
	assign text_usr[44:54] = 11'b11101110101;
	
	assign text_x[0:  4] = 5'b10100;
	assign text_x[5:  9] = 5'b10101;
	assign text_x[10:14] = 5'b01000;
	assign text_x[15:19] = 5'b10100;
	assign text_x[20:24] = 5'b10101;
	
	assign text_y[0:  4] = 5'b10100;
	assign text_y[5:  9] = 5'b10101;
	assign text_y[10:14] = 5'b11100;
	assign text_y[15:19] = 5'b00100;
	assign text_y[20:24] = 5'b11101;
	
	assign text_0[0:  2] = 3'b111;
	assign text_0[3:  5] = 3'b101;
	assign text_0[6:  8] = 3'b101;
	assign text_0[9: 11] = 3'b101;
	assign text_0[12:14] = 3'b111;
	
	assign text_1[0:  2] = 3'b001;
	assign text_1[3:  5] = 3'b001;
	assign text_1[6:  8] = 3'b001;
	assign text_1[9: 11] = 3'b001;
	assign text_1[12:14] = 3'b001;
	
	assign text_2[0:  2] = 3'b111;
	assign text_2[3:  5] = 3'b001;
	assign text_2[6:  8] = 3'b111;
	assign text_2[9: 11] = 3'b100;
	assign text_2[12:14] = 3'b111;
	
	assign text_3[0:  2] = 3'b111;
	assign text_3[3:  5] = 3'b001;
	assign text_3[6:  8] = 3'b111;
	assign text_3[9: 11] = 3'b001;
	assign text_3[12:14] = 3'b111;
	
	assign text_4[0:  2] = 3'b101;
	assign text_4[3:  5] = 3'b101;
	assign text_4[6:  8] = 3'b111;
	assign text_4[9: 11] = 3'b001;
	assign text_4[12:14] = 3'b001;
	
	assign text_5[0:  2] = 3'b111;
	assign text_5[3:  5] = 3'b100;
	assign text_5[6:  8] = 3'b111;
	assign text_5[9: 11] = 3'b001;
	assign text_5[12:14] = 3'b111;
	
	assign text_6[0:  2] = 3'b110;
	assign text_6[3:  5] = 3'b100;
	assign text_6[6:  8] = 3'b111;
	assign text_6[9: 11] = 3'b101;
	assign text_6[12:14] = 3'b111;
	
	assign text_7[0:  2] = 3'b111;
	assign text_7[3:  5] = 3'b001;
	assign text_7[6:  8] = 3'b001;
	assign text_7[9: 11] = 3'b001;
	assign text_7[12:14] = 3'b001;
	
	assign text_8[0:  2] = 3'b111;
	assign text_8[3:  5] = 3'b101;
	assign text_8[6:  8] = 3'b111;
	assign text_8[9: 11] = 3'b101;
	assign text_8[12:14] = 3'b111;
	
	assign text_9[0:  2] = 3'b111;
	assign text_9[3:  5] = 3'b101;
	assign text_9[6:  8] = 3'b111;
	assign text_9[9: 11] = 3'b001;
	assign text_9[12:14] = 3'b001;

	parameter n = 32;
	parameter m = 32;
	parameter offset_x = 3;
	parameter offset_y = 3;
	reg writeEn;
	reg [2:0] colour;
	reg [7:0] x;
	reg [6:0] y;
	
	always@(*) // Set color depending on if array[x,y] is 0,1
		begin
			if (y < 80) begin
				writeEn = 1;
				x = x_wir + offset_x; 
				y = y_wir + offset_y;
				if ((x_wir < 2) || (y_wir < 2) || (x_wir > (2*n + 1)) || (y_wir > (2*m+1)))
					colour = 0;
				else
					if (array[((x_wir-2)/2) + ((y_wir-2)/2)*n])
						colour <= 4 + ((array[((x_wir-2)/2) + ((y_wir-2)/2)*n] + ((x_wir-2)/2)%2 + ((y_wir-2)/2)%2)%2);
					else
						colour <= 3'b111;
			end
			else begin
				x = x_wir; 
				y = y_wir;
				
				if (((y-80) < 5) && ((x-10) < 11)) begin
					if (preset == 3'b000)
						colour = 7-6*text_usr[(x-10) + (y-80)*11];
					else
						colour = 7-6*text_pre[(x-10) + (y-80)*11];
				end
				
				else if (((y-80) < 5) && ((x-10) > 11) && ((x-10) < 15)) begin
						case(preset)
							4'b0000: colour = 7;
							4'b0001: colour = 7-6*text_0[(x-22) + (y-80)*3];
							4'b0010: colour = 7-6*text_1[(x-22) + (y-80)*3];
							4'b0011: colour = 7-6*text_2[(x-22) + (y-80)*3];
							4'b0100: colour = 7-6*text_3[(x-22) + (y-80)*3];
							4'b0101: colour = 7-6*text_4[(x-22) + (y-80)*3];
							4'b0110: colour = 7-6*text_5[(x-22) + (y-80)*3];
							4'b0111: colour = 7-6*text_6[(x-22) + (y-80)*3];
							4'b1000: colour = 7-6*text_7[(x-22) + (y-80)*3];
							4'b1001: colour = 7-6*text_8[(x-22) + (y-80)*3];
							4'b1010: colour = 7-6*text_9[(x-22) + (y-80)*3];
						endcase
				end
				
				else if (((y-80) > 6) && ((y-80) < 12) && ((x-10) < 5))
					colour = 7-6*text_x[(x-10) + (y-87)*5];
				
				else if (((y-80) > 6) && ((y-80) < 12) && ((x-10) > 5) && ((x-10) < 9)) begin
						if (x_in > 29)
							colour = 7-6*text_3[(x-16) + (y-87)*3];
						else if (x_in > 19)
							colour = 7-6*text_2[(x-16) + (y-87)*3];
						else if (x_in > 9)
							colour = 7-6*text_1[(x-16) + (y-87)*3];
						else
							colour = 7-6*text_0[(x-16) + (y-87)*3];
				end
				
				else if (((y-80) > 6) && ((y-80) < 12) && ((x-10) > 9) && ((x-10) < 13)) begin
						case (x_in%10)
							0: colour = 7-6*text_0[(x-20) + (y-87)*3];
							1: colour = 7-6*text_1[(x-20) + (y-87)*3];
							2: colour = 7-6*text_2[(x-20) + (y-87)*3];
							3: colour = 7-6*text_3[(x-20) + (y-87)*3];
							4: colour = 7-6*text_4[(x-20) + (y-87)*3];
							5: colour = 7-6*text_5[(x-20) + (y-87)*3];
							6: colour = 7-6*text_6[(x-20) + (y-87)*3];
							7: colour = 7-6*text_7[(x-20) + (y-87)*3];
							8: colour = 7-6*text_8[(x-20) + (y-87)*3];
							9: colour = 7-6*text_9[(x-20) + (y-87)*3];
						endcase
				end
				else if (((y-80) > 13) && ((y-80) < 19) && ((x-10) < 5))
					colour = 7-6*text_y[(x-10) + (y-94)*5];
				
				else if (((y-80) > 13) && ((y-80) < 19) && ((x-10) > 5) && ((x-10) < 9)) begin
						if (y_in > 29)
							colour = 7-6*text_3[(x-16) + (y-94)*3];
						else if (y_in > 19)
							colour = 7-6*text_2[(x-16) + (y-94)*3];
						else if (y_in > 9)
							colour = 7-6*text_1[(x-16) + (y-94)*3];
						else
							colour = 7-6*text_0[(x-16) + (y-94)*3];
				end
				
				else if (((y-80) > 13) && ((y-80) < 19) && ((x-10) > 9) && ((x-10) < 13)) begin
						case (y_in%10)
							0: colour = 7-6*text_0[(x-20) + (y-94)*3];
							1: colour = 7-6*text_1[(x-20) + (y-94)*3];
							2: colour = 7-6*text_2[(x-20) + (y-94)*3];
							3: colour = 7-6*text_3[(x-20) + (y-94)*3];
							4: colour = 7-6*text_4[(x-20) + (y-94)*3];
							5: colour = 7-6*text_5[(x-20) + (y-94)*3];
							6: colour = 7-6*text_6[(x-20) + (y-94)*3];
							7: colour = 7-6*text_7[(x-20) + (y-94)*3];
							8: colour = 7-6*text_8[(x-20) + (y-94)*3];
							9: colour = 7-6*text_9[(x-20) + (y-94)*3];
						endcase
				end
				else
					colour = 3'b111;
				
				if (colour == 0)
					colour  = 3'b111;
				else if (colour == 1)
					colour = 3'b000;
			end
			
		end
	
		
	// Create an Instance of a VGA controller - can be only one!
	// Define number of colours + initial background image file (.MIF) for controller.
	vga_adapter VGA(
					.resetn(resetn),
					.clock(CLOCK_50),
					.colour(colour),
					.x(x),
					.y(y),
					.plot(writeEn),

					/* Signals for DAC to drive monitor. */
					.VGA_R(VGA_R),
					.VGA_G(VGA_G),
					.VGA_B(VGA_B),
					.VGA_HS(VGA_HS),
					.VGA_VS(VGA_VS),
					.VGA_BLANK(VGA_BLANK_N),
					.VGA_SYNC(VGA_SYNC_N),
					.VGA_CLK(VGA_CLK)
					);

	defparam VGA.RESOLUTION 		  	 = "160x120";
	defparam VGA.MONOCHROME 			 = "FALSE";
	defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
	defparam VGA.BACKGROUND_IMAGE 	 	 = "DNA.mif";
	
endmodule

module userSetLocation (input clock, go, KEY,
								input 	   [9:0]  SW, 
								input      [n*m-1:0] array_in,
								output reg [n*m-1:0] array_out_user, 
								output reg [3:0]   x_hex, y_hex
							  );	
	parameter  m = 32;
	parameter  n = 32;
	reg [9:0] location; 		
	integer i, x_, y_, location_, clicks = 0;
	
	always@(posedge clock)
		if (!go)
			location <= SW[9:0];
	
	always @(location)
	begin
			location_ = location;
			x_        = location_[4:0];
			y_        = location_[9:5];
			x_hex     = x_[3:0];
			y_hex     = y_[3:0];
	end

	always@(negedge KEY) 
	begin
		if (!go) begin
			for(i = 0; i < n*m; i=i+1) begin
				
				if (i == (x_ + y_*n)) begin
					if (clicks == 1) begin
						array_out_user[i] <= 1'b0;
						clicks <= 0;
					end
					else begin
						array_out_user[i] <= 1'b1;
						clicks <= 1;
					end
				end
				else
					array_out_user[i] = array_in[i];
			end
		end
	end 

endmodule


module toDisplayOnHex(
					  input [10:0] hex_sum,
					  output [3:0] hex0_, hex1_, hex2_, hex3_
					  );
	assign hex0_ = hex_sum % 10;
	assign hex1_ = (hex_sum % 100)/10;
	assign hex2_ = (hex_sum /100)%10;
	assign hex3_ = hex_sum/100;

endmodule
//------------------------------------------------------------------------------------------------------------------------//


//----------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------CODE BELOW WORKS------------------------------------------------------//
//----------------------------------------------------------------------------------------------------------------------------//

module currentGameStateFSM (input w, x, output reg go, output reg [4:0] preset);

	initial go     = 0;
	initial preset = 4'b0000;
	
	always@(posedge w)
		go = ~go;
	
	always@(posedge x)
	begin
		if (!go) begin
			if (preset == 4'b1010)
				preset <=4'b0000;
			else 
				preset <= preset + 1;
		end
	end

endmodule

module nextStateSolver(input [n*m-1:0]array, input clock, go, output reg[n*m-1:0]array_out, output [10:0] hex_sum);
	parameter n = 32;
	parameter m = 32;
	integer i, sum, live;
	
	always @(posedge clock)		
	begin
		if (!go)
			array_out = array;	
		else begin
			live=0;
			for (i = 0;i < n*m; i = i + 1) begin
				sum = 0;
				
				if (i == 0) begin
					sum = array[1]+array[n]+array[n+1] + array[n-1]+array[2*n-1]+array[n*(m-1)]+array[n*(m-1)+1] + array[n*m-1];
					if (sum == 3) array_out[i] <= 1;
					else if ((sum == 2) && (array[i] == 1)) array_out[i] <= 1;
					else array_out[i] <= 0;
				end
				
				else if (i == (n-1)) begin
					sum = array[n-2]+array[2*n-2]+array[2*n-1] + array[0]+array[n]+array[n*m-1]+array[n*m-2] + array[n*(m-1)];
					if (sum == 3) array_out[i] <= 1;
					else if ((sum == 2) && (array[i] == 1)) array_out[i] <= 1;
					else array_out[i] <= 0;
				end
				
				else if (i == (n*(m-1))) begin
					sum = array[n*(m-2)]+array[n*(m-2)+1]+array[n*(m-1)+1] + array[0]+array[1]+array[n*m-1]+array[n*(m-1)-1] + array[n-1];
					if (sum == 3) array_out[i] <= 1;
					else if ((sum == 2) && (array[i] == 1)) array_out[i] <= 1;
					else array_out[i] <= 0;
				end
				
				else if (i == (n*m-1)) begin
					sum = array[n*(m-1)-1]+array[n*(m-1)-2]+array[n*m-2] + array[n-1]+array[n-2]+array[n*(m-1)]+array[n*(m-2)] + array[0];
					if (sum == 3) array_out[i] <= 1;
					else if ((sum == 2) && (array[i] == 1)) array_out[i] <= 1;
					else array_out[i] <= 0;
				end
				
				else if ((i > 0) && (i < (n-1))) begin
					sum = array[i+1]+array[i-1]+array[i+n]+array[i+n+1]+array[i+n-1] + array[n*(m-1)+i]+array[n*(m-1)+i-1]+array[n*(m-1)+i+1];
					if (sum == 3) array_out[i] <= 1;
					else if ((sum == 2) && (array[i] == 1)) array_out[i] <= 1;
					else array_out[i] <= 0;
				end
				
				else if ((i % n) == 0) begin
					sum = array[i+1]+array[i+n]+array[i-n]+array[i+n+1]+array[i-n+1] + array[i-1]+array[i+n-1]+array[i+2*n-1];
					if (sum == 3) array_out[i] <= 1;
					else if ((sum == 2) && (array[i] == 1)) array_out[i] <= 1;
					else array_out[i] <= 0;
				end
				
				else if (((i+1) % n) == 0) begin
					sum = array[i-1]+array[i+n]+array[i-n]+array[i+n-1]+array[i-n-1] + array[i+1]+array[i-n+1]+array[i-2*n+1];
					if (sum == 3) array_out[i] <= 1;
					else if ((sum == 2) && (array[i] == 1)) array_out[i] <= 1;
					else array_out[i] <= 0;
				end
				
				else if ((i > n*(m-1)) && (i < (m*n-1))) begin
					sum = array[i+1]+array[i-1]+array[i-n]+array[i-n+1]+array[i-n-1] + array[i-n*(m-1)]+array[i-n*(m-1)-1]+array[i-n*(m-1)+1];
					if (sum == 3) array_out[i] <= 1;
					else if ((sum == 2) && (array[i] == 1)) array_out[i] <= 1;
					else array_out[i] <= 0;
				end
				
				else if (i < (m*(n-1)-1))begin
					sum = array[i+1]+array[i-1]+array[i-n]+array[i+n]+array[i-n+1]+array[i-n-1]+array[i+n-1]+array[i+n+1];
					if (sum == 3) array_out[i] <= 1;
					else if (sum == 2 && array[i] == 1) array_out[i] <= 1;
					else array_out[i] <= 0;
				end
				if(array[i] == 1'b1) live=live+1;
			end
		end	
	end
	assign hex_sum = live;
endmodule

module clock2Hz(input CLOCK_50, output reg clock); // generates clock running at 2Hz
	 reg [31:0] count;
    always @(posedge CLOCK_50) 
    	begin
        	if (count == 25000000) begin
					count <= 0;
					clock <= 1;
        	end
        	else begin
					count <= count + 1;
					clock <= 0;
        	end				 
      end
endmodule

module clock4Hz(input CLOCK_50, output reg clock); // generates clock running at 2Hz
	 reg [31:0] count;
    always @(posedge CLOCK_50) 
    	begin
        	if (count == 12500000) begin
					count <= 0;
					clock <= 1;
        	end
        	else begin
					count <= count + 1;
					clock <= 0;
        	end				 
      end
endmodule

module hex_decoder(input [3:0] hex_digit, output reg [6:0] segments);   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule


///////////////////////////////////////////////////////////////////////////////////////////


