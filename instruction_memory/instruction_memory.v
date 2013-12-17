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

module instruction_memory

(
	address,
	instruction
);

    //--------------------------
	// Parameters
	//--------------------------	
	
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
	input		[31:0]	address;
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output 	[31:0] 	instruction;
		
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
   
    //-------------------------------------------------
    // Signal Declarations: reg
    //-------------------------------------------------    
    reg	[31:0] instruction_memory	[255:0];
	
	integer i;
	
    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------
		
	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
	// None

	//---------------------------------------------------------------
	// Combinational Logic
	//---------------------------------------------------------------
	initial
	begin
		for (i=0; i<256; i=i+1)
			instruction_memory[i] = 32'hFFFFFFFF;
			
		$readmemh("program.mips",instruction_memory);
	end
	
	assign instruction = instruction_memory[address[9:2]];
	
	always @(instruction)
	begin
		if (instruction == 32'hFFFFFFFF)
			$stop();
	end
	
	
	//DEBUG
	//always@(address)
	//begin
		//$display("ISNTR=%h", instruction);
	//end
	
 endmodule  



