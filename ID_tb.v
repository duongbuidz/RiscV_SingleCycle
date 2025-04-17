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
    wire [31:0] imm_ext;
    wire [4:0] rd;
    
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
        .imm_ext(imm_ext),
        .rd(rd)
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
        
        // Test Case 1: R-type instruction (ADD)
        $display("\nTest Case 1: ADD instruction (R-type)");
        instruction = 32'h00c58633; // add x12, x11, x12
        #10;
        display_outputs();
        
        // Test Case 2: I-type instruction (ADDI)
        $display("\nTest Case 2: ADDI instruction (I-type)");
        instruction = 32'h00c58593; // addi x11, x11, 12
        #10;
        display_outputs();
        
        // Test Case 3: Load instruction (LW)
        $display("\nTest Case 3: LW instruction (I-type)");
        instruction = 32'h0045a603; // lw x12, 4(x11)
        #10;
        display_outputs();
        
        // Test Case 4: Store instruction (SW)
        $display("\nTest Case 4: SW instruction (S-type)");
        instruction = 32'h00c5a223; // sw x12, 4(x11)
        #10;
        display_outputs();
        
        // Test Case 5: Branch instruction (BEQ)
        $display("\nTest Case 5: BEQ instruction (B-type)");
        instruction = 32'h00c58663; // beq x11, x12, 12
        #10;
        display_outputs();
        
        // Test Case 6: Test register write
        $display("\nTest Case 6: Register Write Test");
        instruction = 32'h00c58593; // addi x11, x11, 12 (rd = x11)
        WB_out = 32'h1234ABCD;     // Data to be written
        #10;
        display_outputs();
        
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
            $display("Control Signals:");
            $display("  RegWrite: %b, ALUSrc: %b, MemWrite: %b", RegWrite, ALUSrc, MemWrite);
            $display("  MemRead: %b, ResultSrc: %b, Branch: %b, ALUOp: %b", MemRead, ResultSrc, Branch, ALUOp);
            $display("Register Values:");
            $display("  dataA (rs1): %h, dataB (rs2): %h", dataA, dataB);
            $display("Immediate: %h", imm_ext);
            $display("Destination Register (rd): %d", rd);
            $display("----------------------------------------");
        end
    endtask
    
endmodule
