`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company:
//
// Engineer: Michael Gidaro
//
// Create Date:	4/26/13
// Design Name: CPU
// Module Name: CPU
// Project Name:
// Target Devices:
// Tool versions:
// Description:	Connects all modules that make up the CPU
//
// Dependencies:
//
// Revision:
//
//
// Additional Comments:
// Instantiate all the necessary components in this file. Connect them as appropriate using wires.  Use the figure
// provided in the specification as a guide.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cpu
(
	clk,
	rst
);

	//--------------------------
	// Parameters
	//--------------------------

    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
    input 					clk;
	input 					rst;

	//--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >


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

    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------
    wire [3:0] pc_control_wire;
    wire [25:0] jump_address_wire;
    wire [15:0] branch_offset_wire;
    wire [31:0] reg_address_wire;
    wire [31:0] pc_to_address_wire;
    wire [31:0] instr_mem_instruction;


	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
    program_conter cpu_program_counter
    (
      .clk    (clk),
      .rst    (rst),
      .pc_control (pc_control_wire),
      .jump_address   (pc_control_wire),
      .branch_offset  (branch_offset_wire),
      .reg_address    (reg_address_wire),
      .pc             (pc_to_wire)
    );

    instruction_memory cpu_program_counter
    (
      .address  (pc_to_address_wire),
      .instruction  (instr_mem_instruction),
    );

    register_file cpu_register_file
    (
      .clk            (clk),
      .raddr0         (instr_mem_instruction[25:21]),
      .raddr1         (instr_mem_instruction[20:16]),
      .waddr          (),
      .wdata (),
      .wren (),
      .rdata0 (),
      .rdata1 ()
    );

    alu cpu_alu
    (
      .operand0 (),
      .operand1 (),
      .shamt (),
      .control (),
      .result (),
      .zero (),
      .overflow ()
    );

    data_memory cpu_data_memory
    (
      .clk  (clk),
      .addr (),
      .rdata (),
      .wdata (),
      .wren ()
    );

    control_unt cpu_control_unit
    (
      .rst  (rst),
      .instruction  (),
      .data_mem_wren  (),
      .reg_file_wren  (),
      .reg_file_dmux_select(),
      .reg_file_rmux_select (),
      .alu_mux_select (),
      .alu_control (),
      .alu_zero (),
      .alu_shamt (),
      .pc_control ()
    );

    mux_2_to1 cpu_mux_2to1_reg_file
    (
      .in0 (),
      .in1 (),
      .out (),
      .sel ()
    );

    mux_2_to1 cpu_mux_2to1_alu
    (
      .in0 (),
      .in1 (),
      .out (),
      .sel ()
    );

    mux_2_to1 cpu_mux_2to1_data_mem
    (
      .in0 (),
      .in1 (),
      .out (),
      .sel ()
    );

    sign_extension cpu_sign_extension
    (
      .in (),
      .out ()
    );

	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
endmodule
