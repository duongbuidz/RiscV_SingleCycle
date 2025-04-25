module ControlUnit (op,RegWrite,ALUSrc,MemWrite,MemRead,ResultSrc,Branch,ALUOp,imm_sel);
    input [6:0]op;
    output RegWrite,ALUSrc,MemWrite,MemRead,ResultSrc,Branch;
    output [1:0]ALUOp;
    output reg [2:0]imm_sel;

    assign RegWrite = (op == 7'b0000011 | op == 7'b0110011 | op == 7'b0010011 | op == 7'b0110111) ? 1'b1 : // tru store va branch k cho phep write
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
	always@(*) begin	
	case(op)
			7'b0010011, // I-type 
            7'b0000011, // LOAD 
            7'b1100111: // JALR
                imm_sel = 3'b001;

            7'b0100011: // S-type 
                imm_sel = 3'b010;

            7'b1100011: // B-type 
                imm_sel = 3'b011;

            7'b0110111, // U-type 
            7'b0010111: 
                imm_sel = 3'b100;

            7'b1101111: // J-type
                imm_sel = 3'b101;

            default:
                imm_sel = 3'b000;
        endcase
        end
endmodule 
