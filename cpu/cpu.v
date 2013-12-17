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
    wire [31:0] operand1_wire;
    wire [31:0] reg_file_wdata_wire;
    wire [31:0] rdata1_wire;
    wire [31:0] sign_out_wire;
    wire waddr_sel;
    wire reg_file_rmux_sel;
    wire reg_file_dmux_sel;
    wire alu_mux_sel;
    wire [4:0] shamt_wire;
    wire [3:0] control_wire;
    wire zero_wire;
    wire [3:0] data_mem_wren_wire;
    wire reg_file_wren_wire;
    wire [31:0] alu_result_wire;
    wire [31:0] data_mem_rdata_wire;
    wire [31:0] rdata0_wire;
    wire overflow_wire;

	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
    program_conter cpu_program_counter
    (
      .clk            (clk),
      .rst            (rst),
      .pc_control     (pc_control_wire),
      .jump_address   (pc_control_wire),
      .branch_offset  (branch_offset_wire),
      .reg_address    (reg_address_wire),
      .pc             (pc_to_address_wire)
    );

    instruction_memory cpu_instruction_memory
    (
      .address        (pc_to_address_wire),
      .instruction    (instr_mem_instruction)
    );

    register_file cpu_register_file
    (
      .clk            (clk),
      .raddr0         (instr_mem_instruction[25:21]),
      .raddr1         (instr_mem_instruction[20:16]),
      .waddr          (waddr_sel),
      .wdata          (reg_file_wdata_wire),
      .wren           (reg_file_wren_wire),
      .rdata0         (rdata0_wire),
      .rdata1         (rdata1_wire)
    );

    alu cpu_alu
    (
      .operand0 (rdata0_wire),
      .operand1 (operand1_wire),
      .shamt (shamt_wire),
      .control (control_wire),
      .result (alu_result_wire),
      .zero (zero_wire),
      .overflow (overflow_wire)
    );

    data_memory cpu_data_memory
    (
      .clk  (clk),
      .addr (alu_result_wire),
      .rdata (data_mem_rdata_wire),
      .wdata (rdata1_wire),
      .wren (data_mem_wren_wire)
    );

    control_unt cpu_control_unit
    (
      .rst  (rst),
      .instruction  (instr_mem_instruction),
      .data_mem_wren  (data_mem_wren_wire),
      .reg_file_wren  (reg_file_wren_wire),
      .reg_file_dmux_select(reg_file_dmux_sel),
      .reg_file_rmux_select (reg_file_rmux_sel),
      .alu_mux_select (alu_mux_sel),
      .alu_control (control_wire),
      .alu_zero (zero_wire),
      .alu_shamt (shamt_wire),
      .pc_control (pc_control_wire)
    );

    mux_2_to1 cpu_mux_2to1_reg_file
    (
      .in0 (instr_mem_instruction[20:16]),
      .in1 (instr_mem_instruction[15:11]),
      .out (waddr_sel),
      .sel (reg_file_rmux_sel)
    );

    mux_2_to1 cpu_mux_2to1_alu
    (
      .in0 (rdata1_wire),
      .in1 (sign_out_wire),
      .out (operand1_wire),
      .sel (alu_mux_sel)
    );

    mux_2_to1 cpu_mux_2to1_data_mem
    (
      .in0 (data_mem_rdata_wire),
      .in1 (alu_result_wire),
      .out (reg_file_wdata_wire),
      .sel (reg_file_dmux_sel)
    );

    sign_extension cpu_sign_extension
    (
      .in (instr_mem_instruction[15:0]),
      .out (sign_out_wire)
    );

	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------
endmodule
