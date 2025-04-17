`timescale 1ns / 1ps

module IF_tb;

    reg clk;
    reg rst;
    reg PCSel;
    reg [31:0] imm_ext;
    
    wire [31:0] instruction;
    wire [31:0] PC_Out;
    wire [31:0] PC_plus4;
    
    IF uut (
        .clk(clk), 
        .rst(rst), 
        .PCSel(PCSel), 
        .imm_ext(imm_ext), 
        .instruction(instruction), 
        .PC_Out(PC_Out), 
        .PC_plus4(PC_plus4)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end
    
    initial begin
        // Initialize Inputs
        rst = 1;
        PCSel = 0;
        imm_ext = 0;
        
        // Wait 100ns for global reset
        #100;
        rst = 0;
        
        // Test case 1: (PCSel=0)
        $display("Test case 1: Sequential execution");
        PCSel = 0;
        #10; 
        $display("PC=%h, PC+4=%h, Instr=%h", PC_Out, PC_plus4, instruction);
        
        // Test case 2: Branch taken (PCSel=1)
        $display("\nTest case 2: Branch taken");
        PCSel = 1;
        imm_ext = 32'h00000010; // +16
        #10;
        $display("PC=%h, PC_branch=%h, Instr=%h", PC_Out, PC_Out + imm_ext, instruction);
        
        // Test case 3: PCSel=0
        $display("\nTest case 3: Back to sequential");
        PCSel = 0;
        #10;
        $display("PC=%h, PC+4=%h, Instr=%h", PC_Out, PC_plus4, instruction);
        
        // Test case 4: branch offset âm
        $display("\nTest case 4: Negative branch offset");
        PCSel = 1;
        imm_ext = 32'hFFFFFFFC; // -4
        #10;
        $display("PC=%h, PC_branch=%h, Instr=%h", PC_Out, PC_Out + imm_ext, instruction);
        
        // End simulation
        #100;
        $display("\nSimulation finished");
        $finish;
    end
    
    // Monitor changes
    always @(posedge clk) begin
        $display("[%0t] PC=%h, Instr=%h, PCSel=%b", $time, PC_Out, instruction, PCSel);
    end
    
endmodule
