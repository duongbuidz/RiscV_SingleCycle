`timescale 1ns / 1ps

module MEM_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] alu_out;
    reg [31:0] dataB;
    reg [31:0] instruction;
    reg MemRead;
    reg MemWrite;
    
    // Outputs
    wire [31:0] read_data;
    wire [31:0] mem_result;
    
    // Instantiate the Unit Under Test (UUT)
    MEM uut(
        .clk(clk),
        .rst(rst),
        .alu_out(alu_out),
        .dataB(dataB),
        .instruction(instruction),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .read_data(read_data),
        .mem_result(mem_result)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end
    
    initial begin
        // Initialize Inputs
        rst = 1;
        alu_out = 0;
        dataB = 0;
        instruction = 0;
        MemRead = 0;
        MemWrite = 0;
        
        // Wait for global reset
        #20;
        rst = 0;
        
        ////////////////////////////////////////////////////////////
        // Test Case 1: Store Word (SW)
        // sw x1, 0(x2)
        ////////////////////////////////////////////////////////////
        $display("\nTest Case 1: Store Word (SW)");
        instruction = 32'h00112023; // sw x1, 0(x2)
        alu_out = 32'h00000004;    // Address 4
        dataB = 32'hAABBCCDD;      // Data to store
        MemWrite = 1;
        #10;
        $display("Stored value %h at address %h", dataB, alu_out);
        MemWrite = 0;
        
        ////////////////////////////////////////////////////////////
        // Test Case 2: Load Word (LW)
        // lw x3, 0(x2)
        ////////////////////////////////////////////////////////////
        $display("\nTest Case 2: Load Word (LW)");
        instruction = 32'h00012183; // lw x3, 0(x2)
        alu_out = 32'h00000004;    // Address 4
        MemRead = 1;
        #10;
        $display("Loaded value %h from address %h", read_data, alu_out);
        $display("mem_result = %h (Expected AABBCCDD)", mem_result);
        MemRead = 0;
        
        ////////////////////////////////////////////////////////////
        // Test Case 3: Non-memory operation
        // add x4, x5, x6
        ////////////////////////////////////////////////////////////
        $display("\nTest Case 3: Non-memory operation");
        instruction = 32'h006282b3; // add x5, x5, x6
        alu_out = 32'h00001234;    // Some ALU result
        MemRead = 0;
        MemWrite = 0;
        #10;
        $display("mem_result = %h (Expected 00001234)", mem_result);
        
        // End simulation
        #20;
        $display("\nAll test cases completed!");
        $finish;
    end
    
endmodule
