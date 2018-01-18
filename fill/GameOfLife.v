module GameOfLife (
	input [9:0] SW, 
	input [3:0] KEY, 
	input CLOCK_50, 
	output VGA_CLK, VGA_HS, VGA_VS,
	output VGA_BLANK_N, VGA_SYNC_N, 
	output [7:0] VGA_R, VGA_G, VGA_B
	);

	// call everything from here...
	
	
	wire go;
	wire [2:0] colour;
	reg [7:0] x;
	reg [6:0] y;
	wire writeEn;
	wire clock;
	
	parameter n = 16;
	parameter m = 16;
	reg [n*m: 0] array;
	
	initial begin
		x <= 8'b00000001;
		y <= 7'b0000001;
		array[n-1   :   0] <= 16'b0000001000100000;
		array[2*n-1 :   n] <= 16'b0000001000100000;
		array[3*n-1 : 2*n] <= 16'b0000001000100000;
		array[4*n-1 : 3*n] <= 16'b0001001000100000;
		array[5*n-1 : 4*n] <= 16'b0000001000100000;
		array[6*n-1 : 5*n] <= 16'b0000101000100000;
		array[7*n-1 : 6*n] <= 16'b0000001000100000;
		array[8*n-1 : 7*n] <= 16'b0010001000100000;
		array[9*n-1 : 8*n] <= 16'b0000001000100000;
		array[10*n-1: 9*n] <= 16'b0000001000100000;
		array[11*n-1:10*n] <= 16'b0000001000100100;
		array[12*n-1:11*n] <= 16'b0000001000100000;
		array[13*n-1:12*n] <= 16'b0000001000100000;
		array[14*n-1:13*n] <= 16'b0010001000100000;
		array[15*n-1:14*n] <= 16'b0000001000100000;
		array[16*n-1:15*n] <= 16'b0000001000100000;
	end

	
	/***** GAME FSM *****/
	currentGameStateFSM FSM(.w(SW[0]), .resetn(SW[1]), .CLOCK_50(CLOCK_50), .go(go));
	clock2Hz setClock(.CLOCK_50(CLOCK_50), .clock(clock));
	
	print map(.clock(CLOCK_50), .x(x), .y(y), .x1(x), .y1(y));
	
		
				   
	fill screenOut(
			.CLOCK_50(CLOCK_50),  // On Board 50 MHz
			.KEY(KEY),		  // On Board Keys
			.x_wir(x),
			.y_wir(y),
			.start(go),
			.VGA_CLK(VGA_CLK),   			  //  VGA Clock
			.VGA_HS(VGA_HS),  				  //  VGA H_SYNC
			.VGA_VS(VGA_VS),				  //  VGA V_SYNC
			.VGA_BLANK_N(VGA_BLANK_N),			  //  VGA BLANK
			.VGA_SYNC_N(VGA_SYNC_N),			  //  VGA SYNC
			.VGA_R(VGA_R),   	  //  VGA Red[9:0]
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),

			// Your inputs + outputs here //
			//.go(go), 					  // PLAY state is ON -> allowed to fill screen
			//.colour(colour),
			//.x(x),   	// fix these
			//.y(y)			// fix these
		);			

endmodule





module currentGameStateFSM (input w, resetn, CLOCK_50, output go); // w = SW[0], resetn = ~KEY[0]

	// y -> current state, Y -> next state
	reg y, Y;
	parameter   IDLE = 1'b0,  // IDLE   ->  in-game screen where user can decide which squares to make live
			      PLAY = 1'b1;  // PLAY   ->  game is played (squares evolve)  

	// state control
	always @(*)
		case(y)
			IDLE:  if(w)  Y = PLAY;
				    else   Y = IDLE;	

			PLAY:  if(w)  Y = PLAY;
				    else   Y = IDLE;

			default: 	  Y = IDLE;
		endcase


	// state FF's
	always @(posedge CLOCK_50)
		if (!resetn) 
			y = IDLE;
		else 
			y = Y;


	// combinational logic for output ( = 1 when PLAY)
	assign go = y;

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


module print map(input clock, input reg x, y, output reg x1, y1);
	always @(posedge clock) 
		begin
			if (x == 16) 
			begin
					x1 <= 1;
					if (y == 16) y1 <= 1;
					else y1 <= y + 1;
			end
			else x1 <= x + 1;
		end
endmodule


module fill(
			input CLOCK_50,			// On Board 50 MHz
			input [3:0] KEY,		// On Board Keys
			input [7:0] x_wir,
			input [6:0] y_wir,
			input start, 
			// Ports below are for the VGA output //  Don't change.
			output 	 	   VGA_CLK,   			  //  VGA Clock
			output 	      VGA_HS,  				  //  VGA H_SYNC
			output 		   VGA_VS,				  //  VGA V_SYNC
			output         VGA_BLANK_N,			  //  VGA BLANK
			output 	      VGA_SYNC_N,			  //  VGA SYNC
			output	[9:0] VGA_R,   				  //  VGA Red[9:0]
			output	[9:0] VGA_G,	 			  //  VGA Green[9:0]
			output	[9:0] VGA_B   				  //  VGA Blue[9:0]


			// Your inputs + outputs here //
			//input go 					  // PLAY state is ON -> allowed to fill screen 
			//input x,
			//input y
		   );


	// Create (colour, x, y and writeEn) wires that are inputs to the controller + resetn
	wire       resetn;
	assign     resetn = KEY[0];
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire      writeEn;



	//
	//
	//always @(*)
	//	if (go)  writeEn <= 1'b1;
	//	else 	 writeEn <= 1'b0;
		
	//assign x = 8'd1;
	//assign y = 7'd0;
	//assign colour = 3'd101;
	assign colour = 3'b100;
	assign x = x_wir;
	assign y = y_wir;
	assign writeEn = start;
	//
	//



	// Create an Instance of a VGA controller - can be only one!
	// Define number of colours + the initial background image file (.MIF) for controller.
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
					.VGA_CLK(VGA_CLK));
	defparam VGA.RESOLUTION 		  	 = "160x120";
	defparam VGA.MONOCHROME 			 = "FALSE";
	defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
	defparam VGA.BACKGROUND_IMAGE 	 	 = "black.mif"; // load in another initial image here (i.e. loading screen)
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design requires.
	
	
	
endmodule





module nextStateSolver(/**/);



endmodule