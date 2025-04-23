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
        instruction = 32'h00c58633; // add x12, x11, x12
        #10; display_outputs();
        
        #10;
        rst = 1;
        #10;
        rst = 0;
        
        
        // --- Test Case 2: I-type instruction (ADDI) ---
        $display("\nTest Case 2: ADDI instruction (I-type)");
        instruction = 32'h00c58593; // addi x11, x11, 12
        #10; display_outputs();

        // --- Test Case 3: Load instruction (LW) ---
        $display("\nTest Case 3: LW instruction (I-type)");
        instruction = 32'h0045a603; // lw x12, 4(x11)
        #10; display_outputs();
        
        #10;
        rst = 1;
        #10;
        rst = 0;
        
        // --- Test Case 4: Store instruction (SW) ---
        $display("\nTest Case 4: SW instruction (S-type)");
        instruction = 32'h00c5a223; // sw x12, 4(x11) rs1 = 11 rs2 = 12 rd = imm
        #10; display_outputs();

        // --- Test Case 5: Branch instruction (BEQ) ---
        $display("\nTest Case 5: BEQ instruction (B-type)");
        instruction = 32'h00c58663; // beq x11, x12, 12
        #10; display_outputs();

        // --- Test Case 6: Register Write Test ---
        $display("\nTest Case 6: Register Write Test");
        instruction = 32'h00c58593; // addi x11, x11, 12 (rd = x11)
        WB_out = 32'h1234ABCD;
        #10; display_outputs();

        // --- Test Case 7: Ghi vào x0 (ph?i b? b? qua) ---
        $display("\nTest Case 7: Attempt to write to x0 (should be ignored)");
        instruction = 32'b000000000001_00000_000_00000_0010011; // addi x0, x0, 1
        WB_out = 32'hFFFFFFFF;
        #10; display_outputs();

        // --- Ki?m tra l?i x0 b?ng cách dùng nó làm rs1 ho?c rs2 ---
        $display("\nTest Case 8: Read from x0 (rs1 = 0)");
        instruction = 32'b000000000001_00000_000_00001_0010011; // addi x1, x0, 1
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
