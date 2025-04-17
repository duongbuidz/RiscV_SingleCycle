`timescale 1ns / 1ps

module EX_tb;

    // Inputs
    reg [31:0] dataA;
    reg [31:0] dataB;
    reg [31:0] imm_ext;
    reg [31:0] PC;
    reg [31:0] instruction;
    reg [1:0] ALUOp;
    reg ALUSrc;
    reg Branch;
    
    // Outputs
    wire [31:0] alu_result;
    wire [31:0] mem_write_data;
    wire branch_taken;
    wire [31:0] pc_target;
    
    // Instantiate the Unit Under Test (UUT)
    EX uut (
        .dataA(dataA),
        .dataB(dataB),
        .imm_ext(imm_ext),
        .PC(PC),
        .instruction(instruction),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .alu_result(alu_result),
        .mem_write_data(mem_write_data),
        .branch_taken(branch_taken),
        .pc_target(pc_target)
    );
    
    initial begin
        // Initialize Inputs
        dataA = 0;
        dataB = 0;
        imm_ext = 0;
        PC = 32'h00400000; // Example PC value
        instruction = 0;
        ALUOp = 0;
        ALUSrc = 0;
        Branch = 0;
        
        // Wait 10 ns for global reset
        #10;
        
        ////////////////////////////////////////////////////////////////////
        // Test Case 1: ADD instruction (R-type)
        // add x1, x2, x3
        // opcode: 0110011, funct3: 000, funct7: 0000000
        ////////////////////////////////////////////////////////////////////
        $display("\nTest Case 1: ADD instruction (R-type)");
        instruction = 32'h003100b3; // add x1, x2, x3
        dataA = 32'h00000004;      // x2 = 4
        dataB = 32'h00000005;      // x3 = 5
        ALUOp = 2'b10;             // R-type operation
        ALUSrc = 0;                // Use register value
        Branch = 0;
        #10;
        $display("ADD 4 + 5 = %h (Expected 00000009)", alu_result);
        $display("mem_write_data = %h (Should be x3 value: 00000005)", mem_write_data);
        $display("branch_taken = %b (Should be 0)", branch_taken);
        
        ////////////////////////////////////////////////////////////////////
        // Test Case 2: ADDI instruction (I-type)
        // addi x1, x2, 10
        // opcode: 0010011, funct3: 000
        ////////////////////////////////////////////////////////////////////
        $display("\nTest Case 2: ADDI instruction (I-type)");
        instruction = 32'h00a10093; // addi x1, x2, 10
        dataA = 32'h00000004;      // x2 = 4
        imm_ext = 32'h0000000a;    // Immediate 10
        ALUOp = 2'b10;             // I-type operation
        ALUSrc = 1;                // Use immediate value
        Branch = 0;
        #10;
        $display("ADDI 4 + 10 = %h (Expected 0000000e)", alu_result);
        $display("mem_write_data = %h (Should be x2 value: 00000004)", mem_write_data);
        
        ////////////////////////////////////////////////////////////////////
        // Test Case 3: BEQ instruction (taken)
        // beq x1, x2, label
        // opcode: 1100011, funct3: 000
        ////////////////////////////////////////////////////////////////////
        $display("\nTest Case 3: BEQ instruction (taken)");
instruction = 32'h00208263; // beq x1, x2, 100
dataA = 32'h0000000a;      // x1 = 10
dataB = 32'h0000000a;      // x2 = 10
imm_ext = 32'h00000064;    // Offset 100
ALUOp = 2'b01;             // Branch operation
ALUSrc = 0;
Branch = 1;

// Debug signals
$display("Opcode = %b (Expected 1100011)", instruction[6:0]);
$display("Funct3 = %b (Expected 000)", instruction[14:12]);
$display("rs1 = %h, rs2 = %h", dataA, dataB);
$display("ALUOp = %b (Expected 01)", ALUOp);

#10;
$display("BEQ 10 == 10: branch_taken = %b (Expected 1)", branch_taken);
$display("pc_target = %h (Expected %h)", pc_target, PC + 32'h00000064);
        
        ////////////////////////////////////////////////////////////////////
        // Test Case 4: LW instruction (I-type)
        // lw x1, 8(x2)
        // opcode: 0000011, funct3: 010
        ////////////////////////////////////////////////////////////////////
        $display("\nTest Case 4: LW instruction (I-type)");
        instruction = 32'h00812083; // lw x1, 8(x2)
        dataA = 32'h10000004;      // x2 = 0x10000004
        imm_ext = 32'h00000008;    // Offset 8
        ALUOp = 2'b00;             // Memory operation
        ALUSrc = 1;                // Use immediate value
        Branch = 0;
        #10;
        $display("LW base 0x10000004 + offset 8 = %h (Expected 1000000c)", alu_result);
        
        ////////////////////////////////////////////////////////////////////
        // Test Case 5: JAL instruction
        // jal x1, 2048
        // opcode: 1101111
        ////////////////////////////////////////////////////////////////////
        $display("\nTest Case 5: JAL instruction");
        instruction = 32'h800000ef; // jal x1, 2048
        imm_ext = 32'h00000800;    // Offset 2048
        ALUOp = 2'b00;             // Not relevant for JAL
        ALUSrc = 1;                // Not used
        Branch = 0;
        #10;
        $display("JAL target = %h (Expected %h)", pc_target, PC + 32'h00000800);
        
        // End simulation
        #10;
        $display("\nAll test cases completed!");
        $finish;
    end
    
endmodule
