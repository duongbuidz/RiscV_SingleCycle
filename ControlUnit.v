module ControlUnit (op,RegWrite,ALUSrc,MemWrite,MemRead,ResultSrc,Branch,ALUOp);
    input [6:0]op;
    output RegWrite,ALUSrc,MemWrite,MemRead,ResultSrc,Branch;
    output [1:0]ALUOp;

    assign RegWrite = (op == 7'b0000011 | op == 7'b0110011) ? 1'b1 : // load va r-type cho phep write
                                                              1'b0 ; 
    assign ALUSrc = (op == 7'b0000011 | op == 7'b0100011 | op == 7'b0010011) ? 1'b1 :// load or store or i type
                                                            1'b0 ; 
    assign MemWrite = (op == 7'b0100011) ? 1'b1 :
                                           1'b0 ; // store memwrite 
    assign MemRead = (op == 7'b0000011) ? 1'b1 :
                                           1'b0 ; // load memread
    assign ResultSrc = (op == 7'b0000011) ? 1'b1 : // load 
                                            1'b0 ;
    assign Branch = (op == 7'b1100011) ? 1'b1 : // branch
                                         1'b0 ;  
	assign ALUOp = (op == 7'b0110011 | op == 7'b0010011) ? 2'b10 : // r type
                   (op == 7'b1100011) ? 2'b01 : // branch
                                        2'b00 ;

endmodule 