`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company:		
//				
// Engineer: 	
//
// Create Date:
// Design Name:
// Module Name:
// Project Name:	
// Target Devices: 
// Tool versions:
// Description:	
//
// Dependencies:
//
// Revision:
//
//
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
module alu 
(
    //--------------------------
    // Input Ports
    //--------------------------
    input		[31:0]	operand0, 
	input		[31:0]	operand1, 
	input		[4:0]	shamt,
	input		[3:0]	control,
    //--------------------------
    // Output Ports
    //--------------------------
    output	reg	[31:0]	result,
	output				zero,
	output	reg			overflow
);
    //--------------------------
    // Bidirectional Ports
    //--------------------------
    // < Enter Bidirectional Ports in Alphabetical Order >
    // None
      
    ///////////////////////////////////////////////////////////////////
    // Begin Design
    ///////////////////////////////////////////////////////////////////
    //-------------------------------------------------
    // Signal Declarations: local params
    //-------------------------------------------------
    localparam C_AND 				= 4'b0000;
	localparam C_OR 				= 4'b0001;
	localparam C_XOR 				= 4'b0010;
	localparam C_NOR 				= 4'b0011;
	localparam C_ADD 				= 4'b0100;
	localparam C_SIGNED_ADD 		= 4'b0101;
	localparam C_SUBTRACT 			= 4'b0110;
	localparam C_SIGNED_SUBTRACT 	= 4'b0111;
	localparam C_SLT 				= 4'b1000;
	localparam C_SHIFT_LEFT 		= 4'b1001;
	localparam C_SHIFT_RIGHT 		= 4'b1010;
	localparam C_SHIFT_RIGHT_ARITH 	= 4'b1011;
    //-------------------------------------------------
    // Signal Declarations: reg
    //-------------------------------------------------  
 
    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------      
	assign zero = (result == 32'd0);
	
	always @*
	begin
		overflow = 1'b0;
		case (control)
			C_AND 				: result = operand0  &  operand1;
			C_OR 				: result = operand0  |  operand1;
			C_XOR 				: result = operand0  ^  operand1;
			C_NOR 				: result = ~(operand0  |  operand1);
			C_ADD 				: result = operand0  +  operand1;
			C_SUBTRACT 			: result = operand0  -  operand1;
			C_SIGNED_ADD 		: {overflow,result} = $signed(operand0) + $signed(operand1);
			C_SIGNED_SUBTRACT 	: {overflow,result} = $signed(operand0) - $signed(operand1);
			C_SLT 				: result = ($signed(operand0) < $signed(operand1));
			C_SHIFT_LEFT 		: result = operand1 << shamt;
			C_SHIFT_RIGHT 		: result = operand1 >> shamt;
			C_SHIFT_RIGHT_ARITH	: result = operand1 >>> shamt;
		endcase
	end
	
endmodule

