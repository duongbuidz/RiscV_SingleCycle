`timescale 1ns / 1ps

module ID_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] instruction;
    reg [31:0] WB_out;
    
    // Outputs
    wire RegWrite;
    wire ALUSrc;
    wire MemWrite;
    wire MemRead;
    wire ResultSrc;
    wire Branch;
    wire [1:0] ALUOp;
    wire [31:0] dataA;
    wire [31:0] dataB;
    wire [31:0] dataD;
    wire [31:0] imm_ext;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    
    // Instantiate the Unit Under Test (UUT)
    ID uut (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .WB_out(WB_out),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUOp(ALUOp),
        .dataA(dataA),
        .dataB(dataB),
        .dataD(dataD),
        .imm_ext(imm_ext),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end
    
    initial begin
        // Initialize Inputs
        rst = 1;
        instruction = 32'h00000000; // NOP
        WB_out = 32'h00000000;
        
        // Wait for global reset
        #20;
        rst = 0;

        // --- Test Case 1: R-type instruction (ADD) ---
        $display("\nTest Case 1: ADD instruction (R-type)");
        instruction = 32'b0000000_00111_00110_000_00101_0110011; // add x5, x6, x7
        #10; display_outputs();
        
        #10;
        rst = 1;
        #10;
        rst = 0;
        
        
        // --- Test Case 2: I-type instruction (ADDI) ---
        $display("\nTest Case 2: ADDI instruction (I-type)");
        instruction = 32'b111111111110_01001_000_01000_0010011; // addi x8, x9, -2
        #10; display_outputs();
        
        #10;
        rst = 1;
        #10;
        rst = 0;

        // --- Test Case 3: Load instruction (LW) ---
        $display("\nTest Case 3: LW instruction (I-type)");
        instruction = 32'b000000000100_01011_010_01010_0000011; // lw x10, 4(x11)
        #10; display_outputs();
        
        #10;
        rst = 1;
        #10;
        rst = 0;
        
        // --- Test Case 4: Store instruction (SW) ---
        $display("\nTest Case 4: SW instruction (S-type)");
        instruction = 32'b0000000_01100_01101_010_01000_0100011; // sw x12, 8(x13)
        #10; display_outputs();

        // --- Test Case 5: Branch instruction (BEQ) ---
        $display("\nTest Case 5: BEQ instruction (B-type)");
        instruction = 32'b000000_01110_01111_000_10000_1100011; // beq x14, x15, 16
        #10; display_outputs();

        // --- Test Case 6: Register Write Test ---
        $display("\nTest Case 6: Register Write Test");
        instruction = 32'b000000001100_01011_000_01011_0010011; // addi x11, x11, 12 (rd = x11)
        WB_out = 32'h1234ABCD;
        #10; display_outputs();

        // --- Test Case 7: Ghi v o x0 
        $display("\nTest Case 7: Attempt to write to x0 (should be ignored)");
        instruction = 32'b000000000001_00000_000_00000_0010011; // addi x0, x0, 1
        WB_out = 32'hFFFFFFFF;
        #10; display_outputs();

        
        $display("\nTest Case 8: Read from x0 (rs1 = 0)");
        instruction = 32'b000000000001_00000_000_00001_0010011; // addi x1, x0, 1
        #10; display_outputs();
        
        #10; rst = 1;
        #10; rst = 0;
        
        $display("\nTest Case 9: LUI");
        instruction = 32'b00010010001101000101_00001_0110111; // LUI x1, 0x12345
        #10; display_outputs();
        
        // End simulation
        #20;
        $display("\nAll test cases completed!");
        $finish;
    end

    // Task to display outputs
    task display_outputs;
        begin
            $display("Time: %0t", $time);
            $display("Instruction: %h", instruction);            
            $display("  RegWrite: %b", RegWrite);            
            $display("Register Values:");
            $display("  rs1: %h, dataA (rs1): %h", rs1, dataA);
            $display("  rs2: %h, dataB (rs2): %h", rs2, dataB);
            $display("  rd: %h, dataD (rd): %h", rd, dataD);
            $display("Immediate: %h", imm_ext);            
        end
    endtask

endmodule

