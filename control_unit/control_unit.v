`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company:
//
// Engineer: Michael Gidaro
//
// Create Date:	4/26/13
// Design Name: CPU
// Module Name: control unit
// Project Name:
// Target Devices:
// Tool versions:
// Description:		Handles all control signal for the cpu
//
// Dependencies:
//
// Revision:
//
//
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module control_unit
(
	rst,
	instruction,
	data_mem_wren,
	reg_file_wren,
	reg_file_dmux_select,
	reg_file_rmux_select,
	alu_mux_select,
	alu_control,
	alu_zero,
	alu_shamt,
	pc_control
);

    //--------------------------
	// Parameters
	//--------------------------

    //--------------------------
	// Input Ports
	//--------------------------
	// < Enter Input Ports  >
	input					rst;
    input 		  [31:0]		instruction;
	input 				alu_zero;

    //--------------------------
    // Output Ports
    //--------------------------
    // < Enter Output Ports  >
    output reg	[3:0]		data_mem_wren;
	output reg				reg_file_wren;
	output reg  			reg_file_dmux_select; // Refers to the mux that feeds the wdata bus of the register file
	output reg				reg_file_rmux_select; // Refers to the mux that feeds the waddr bus of the register file
	output reg				alu_mux_select;       // Refers to the mux that feeds the operand1 bus of the alu
	output reg	[3:0]		alu_control;
	output 	    [4:0]		alu_shamt;
	output reg	[3:0]		pc_control;


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

    // Instruction Types
    localparam R_TYPE                         = 6'b000000;
    localparam J_TYPE                         = 6'b00001x;

    // Arithmetic
    localparam C_ADD                          = 6'b100000;
    localparam C_ADD_UNSIGNED                 = 6'b100001;
    localparam C_SUBTRACT                     = 6'b100010;
    localparam C_SUBTRACT_UNSIGNED            = 6'b100011;
    localparam C_ADD_IMMEDIATE                = 6'b001000;
    localparam C_ADD_IMMEDIATE_UNSIGNED       = 6'b001001;

    // Logical
    localparam C_AND                          = 6'b100100;
    localparam C_AND_IMMEDIATE                = 6'b001100;
    localparam C_OR                           = 6'b100101;
    localparam C_OR_IMMEDIATE                 = 6'b001101;
    localparam C_XOR                          = 6'b100110;
    localparam C_NOR                          = 6'b100111;
    localparam C_SET_ON_LESS_THAN             = 6'b101010;
    localparam C_SET_ON_LESS_THAN_IMMEDIATE   = 6'b001010;

    // Data Transfer
    localparam C_LOAD_WORD                    = 6'b100011;
    localparam C_LOAD_UPPER_IMMEDIATE         = 6'b001111;
    localparam C_STORE_WORD                   = 6'b101011;
    localparam C_STORE_HALF_WORD              = 6'b101001;
    localparam C_STORE_BYTE                   = 6'b101000;

    // Shift
    localparam C_SHIFT_LEFT_LOGICAL           = 6'b000000;
    localparam C_SHIFT_RIGHT_LOGICAL          = 6'b000010;
    localparam C_SHIFT_RIGHT_ARITHMETIC       = 6'b000011;

    // Conditional Branch
    localparam C_BRANCH_ON_EQUAL              = 6'b000100;
    localparam C_BRANCH_ON_NOT_EQUAL          = 6'b000101;

    // Unconditional Jumps
    localparam C_JUMP                         = 6'b000010;
    localparam C_JUMP_REGISTER                = 6'b001000;

    //-------------------------------------------------
    // Signal Declarations: reg
    //-------------------------------------------------

    //-------------------------------------------------
    // Signal Declarations: wire
    //-------------------------------------------------
    wire [5:0] opcode, funct;
    wire [4:0] alu_shamt;

    assign opcode     = instruction[31:26]; // 6 bits
    assign alu_shamt  = instruction[10:6];  // 5 bits
    assign funct      = instruction[5:0];   // 6 bits

    always@*
    begin
        if ( rst != 1'b1 )
        begin
            // Data Memory Write Enable
            case (opcode)
                C_STORE_BYTE                              : data_mem_wren = 4'b0001;
                C_STORE_HALF_WORD                         : data_mem_wren = 4'b0011;
                C_STORE_WORD                              : data_mem_wren = 4'b1111;
                default                                   : data_mem_wren = 4'b0000;
            endcase

            // Reg File Write Enable
            case (opcode)
                (
                    R_TYPE                        ||
                    C_LOAD_WORD                   ||
                    C_LOAD_UPPER_IMMEDIATE
                )                                         : reg_file_wren = 1'b1;
                default                                   : reg_file_wren = 1'b0;
            endcase
        end
        else
        begin
            data_mem_wren = 1'b0;
            reg_file_wren = 1'b0;
        end

        // Data Memory Multiplexer
        case (opcode)
            (
                C_LOAD_WORD                   ||
                C_LOAD_UPPER_IMMEDIATE
            )                                         : reg_file_dmux_select = 1'b1;
            default                                   : reg_file_dmux_select = 1'b0;
        endcase

        // Register Write Source Multiplexer
        case (opcode)
            R_TYPE                                    : reg_file_rmux_select = 1'b1;
            default                                   : reg_file_dmux_select = 1'b0;
        endcase

        // ALU Source Multiplexer
        case (opcode)
            (
                R_TYPE                        ||
                C_BRANCH_ON_EQUAL             ||
                C_BRANCH_ON_NOT_EQUAL
            )                                         : alu_mux_select = 1'b0;
            default                                   : alu_mux_select = 1'b0;
        endcase

        // ALU Control
        case(opcode)
        R_TYPE                                        :
            case (funct)
                // AND
                (
                    C_AND                         ||
                    C_AND_IMMEDIATE
                )                                         : alu_control = 4'b0000;
                // OR
                (
                    C_OR                          ||
                    C_OR_IMMEDIATE
                )                                         : alu_control = 4'b0001;
                C_XOR                                     : alu_control = 4'b0010;
                C_NOR                                     : alu_control = 4'b0011;
                // ADD
                (
                    C_ADD_UNSIGNED                ||
                    C_ADD_IMMEDIATE_UNSIGNED
                )                                         : alu_control = 4'b0100;
                // ADD SIGNED
                (
                    C_ADD                         ||
                    C_ADD_IMMEDIATE
                )                                         : alu_control = 4'b0101;
                // SUBTRACT


                C_SUBTRACT_UNSIGNED                   : alu_control = 4'b0110;
                // SUBTRACT SIGNED

                C_SUBTRACT                            : alu_control = 4'b0101;
                // SET ON LESS THAN
                (
                    C_SET_ON_LESS_THAN            ||
                    C_SET_ON_LESS_THAN_IMMEDIATE
                )                                         : alu_control = 4'b1000;
                C_SHIFT_LEFT_LOGICAL                      : alu_control = 4'b1001;
                C_SHIFT_RIGHT_LOGICAL                     : alu_control = 4'b1010;
                C_SHIFT_RIGHT_ARITHMETIC                  : alu_control = 4'b1010;
                default                                   : alu_control = 4'b1111;
            endcase
        // BRANCH
        (
            C_BRANCH_ON_EQUAL                 ||
            C_BRANCH_ON_NOT_EQUAL
        )                                             : alu_control = 4'b0110; // SUBTRACT
        default                                       : alu_control = 4'b0100; // ADD
        endcase

        // Program Counter Control
        case (opcode)
            C_JUMP                                    : pc_control = 4'b0001;
            C_JUMP_REGISTER                           : pc_control = 4'b0010;
            C_BRANCH_ON_EQUAL                         : if ( alu_zero == 1'b0 )
                                                            pc_control = 4'b0011;
                                                        else
                                                            pc_control = pc_control + 4;
            C_BRANCH_ON_NOT_EQUAL                     : if ( alu_zero == 1'b0 )
                                                            pc_control = 4'b0011;
                                                        else
                                                            pc_control = pc_control + 4;
            default                                   : pc_control = pc_control + 4;
        endcase
    end


	//---------------------------------------------------------------
	// Instantiations
	//---------------------------------------------------------------
	// None

	//---------------------------------------------------------------
	// Combinatorial Logic
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	// Sequential Logic
	//---------------------------------------------------------------

endmodule



