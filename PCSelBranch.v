module NextPCSel(
    input [31:0] PC_plus4,
    input [31:0] PC_branch,       //  PC + immediate
    input PCSel,                  
    output [31:0] next_PC
);
    assign next_PC = (PCSel == 1'b0) ? PC_plus4 : PC_branch;
endmodule
