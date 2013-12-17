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

module data_memory

(
	clk,		//clock
	addr,
	rdata,
	wdata,
	wren
);

    //--------------------------
	// Parameters
	//--------------------------	
	
    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
	input				clk;
    input 		[31:0]	addr;
	input		[31:0]	wdata;
	input 		[3:0]	wren;
	
    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >	
    output 		[31:0] 	rdata;
		
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
    reg	[31:0] data_memory	[65535:0];
	
		
    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------
		
	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
	// None

	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------
	wire   [15:0] data_addr;
	assign data_addr = addr[17:2];
	assign rdata = data_memory[data_addr];
							
	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
    always @(posedge clk)
	begin
		if (wren[0]) //byte
			data_memory[data_addr] <= wdata[7:0];
		else if (wren[0] & wren[1]) //halfword
			data_memory[data_addr] <= wdata[15:0];
		else if (wren[0] & wren[1] & wren[2] & wren[3])
			data_memory[data_addr] <= wdata[31:0];
	end
	
 endmodule  



