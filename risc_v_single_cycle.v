module risc_v_single_cycle (
	input clk, rst
    // output [31:0] pc_out
);	

//	always @(*) begin
//        case (opcode)
//            7'b0110011: instruction = {funct7, rs2, rs1, funct3, rd, opcode}; // R-type
//            7'b0010011: instruction = {imm[11:0], rs1, funct3, rd, opcode}; // I-type
//            7'b0000011, 7'b0100011: instruction = {imm[11:0], rs1, funct3, rd, opcode}; // Load/Store
//            7'b1100011: instruction = {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], opcode}; // Branch
//            7'b1101111: instruction = {imm[20], imm[10:1], imm[11], imm[19:12], rd, opcode}; // JAL
//            default: instruction = 0;
//        endcase
//    end
    
    wire [31:0] instruction;
    wire [6:0] op;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] addA, addB, addD;
    wire [31:0] imm_ext;
    wire [31:0] PC_plus4, PC_branch, next_PC, PC_Out;
    wire [31:0] dataA, dataB, B;
    wire [3:0] ALUControl;
    wire [31:0] alu_out;
    wire [31:0] dmem_out;
    wire [31:0] WB_out;
    wire ALUSrc, MemWrite, MemRead, RegWrite, Branch, PCSel, ResultSrc;
    wire [1:0] ALUOp, ImmSrc;
    wire [31:0] read_data;
    
    PC PC(.clk(clk),
		  .rst(rst),
		  .next_PC(next_PC),
		  .PC_Out(PC_Out));
    PCAdder PCAdder(.PC_in(PC_Out),
				    .PC_plus4(PC_plus4));
	BranchAdder BranchAdder(.PC_in(PC_Out),
				            .imm_ext(imm_ext),
				            .PC_branch(PC_branch));
    NextPCSel NextPCSel(.PC_plus4(PC_plus4), 
						.PC_branch(PC_branch), 
						.PCSel(PCSel),
					    .next_PC(next_PC));
    IMEM IMEM(.clk(clk),
			  .rst(rst),
			  .PC_Out(PC_Out), 
			  .instruction(instruction));
    ControlUnit ControlUnit (
                            .op(instruction[6:0]),
                            .RegWrite(RegWrite),
                            .ImmSrc(ImmSrc),
                            .ALUSrc(ALUSrc),
                            .MemWrite(MemWrite),
                            .MemRead(MemRead),
                            .ResultSrc(ResultSrc),
                            .Branch(Branch),
                            .ALUOp(ALUOp));
    RegisterFile reg_unit(.clk(clk),
                            .rst(rst),
                            .addA(instruction[19:15]),
                            .addB(instruction[24:20]),
                            .addD(instruction[11:7]),
                            .WB_out(WB_out),
                            .RegWrite(RegWrite),
                            .dataA(dataA),
                            .dataB(dataB));
    ImmGen ImmGen(.instruction(instruction),
					.imm_ext(imm_ext));
    ALUControl ALU_Control(.ALUOp(ALUOp),
						  .funct3(instruction[14:12]),
						  .funct7(instruction[31:25]),
						  .op(instruction[6:0]),
						  .ALUControl(ALUControl));
    ALU ALU(.A(dataA), 
			.B(B), 
			.ALUControl(ALUControl), 
			.alu_out(alu_out));
    BranchComp BranchComp(.op(instruction[6:0]),
							    .funct3(instruction[14:12]),
								.rs1_data(dataA), 
								.rs2_data(dataB),
							    .PCSel(PCSel));
    DMEM DMEM(.clk(clk),               
			  .rst(rst),               
			  .MemRead(MemRead),           
			  .MemWrite(MemWrite),          
			  .address(alu_out),    
			  .write_data(dataB), 
			  .read_data(read_data));
    MUX muxALU(.input0(dataB),
			   .input1(imm_ext),
			   .select(ALUSrc), 
			   .out(B));
    MUX muxWB(.input0(alu_out),
			  .input1(read_data),
			  .select(ResultSrc),
			  .out(WB_out));
endmodule 