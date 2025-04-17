`timescale 1ns / 1ps

module MUX(
    input [31:0] input0,
    input [31:0] input1,
    input select,
    output reg [31:0] out
);
always @(*) begin
    out = select ? input1 : input0;
end
endmodule

module WB(
    input [31:0] alu_out,
    input [31:0] read_data,
    input ResultSrc,
    output [31:0] WB_out
);

MUX muxWB(
    .input0(alu_out),
    .input1(read_data),
    .select(ResultSrc),
    .out(WB_out)
);

endmodule

module WB_tb;

    // Inputs
    reg [31:0] alu_out;
    reg [31:0] read_data;
    reg ResultSrc;
    
    // Outputs
    wire [31:0] WB_out;
    
    // Instantiate the Unit Under Test (UUT)
    WB uut (
        .alu_out(alu_out),
        .read_data(read_data),
        .ResultSrc(ResultSrc),
        .WB_out(WB_out)
    );
    
    initial begin
        // Initialize Inputs
        alu_out = 0;
        read_data = 0;
        ResultSrc = 0;
        
        // Wait 100 ns for global reset to finish
        #100;
        
        // Test case 1: Select ALU output (ResultSrc = 0)
        alu_out = 32'h12345678;
        read_data = 32'hABCDEF01;
        ResultSrc = 0;
        #10;
        $display("Test 1 - ALU out: %h, Read data: %h, ResultSrc: %b => WB_out: %h", 
                 alu_out, read_data, ResultSrc, WB_out);
        
        // Test case 2: Select Memory data (ResultSrc = 1)
        alu_out = 32'h12345678;
        read_data = 32'hABCDEF01;
        ResultSrc = 1;
        #10;
        $display("Test 2 - ALU out: %h, Read data: %h, ResultSrc: %b => WB_out: %h", 
                 alu_out, read_data, ResultSrc, WB_out);
        
        // Test case 3: Change values
        alu_out = 32'h11112222;
        read_data = 32'h33334444;
        ResultSrc = 0;
        #10;
        $display("Test 3 - ALU out: %h, Read data: %h, ResultSrc: %b => WB_out: %h", 
                 alu_out, read_data, ResultSrc, WB_out);
        
        ResultSrc = 1;
        #10;
        $display("Test 4 - ALU out: %h, Read data: %h, ResultSrc: %b => WB_out: %h", 
                 alu_out, read_data, ResultSrc, WB_out);
        
        // Finish simulation
        $display("WB testbench finished");
        $finish;
    end
endmodule