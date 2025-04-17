module ALUControl (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input [6:0] op,
    output reg [3:0] ALUControl
);			
	wire RtypeSub;
	assign RtypeSub = funct7[5] & op[5]; // bit thu 5 cua func7 va opcode de phan biet giua add va sub
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0000; // addition (for load/store/auipc)
            2'b01: ALUControl = 4'b0001; // subtraction (for branches)
            default: begin // R-type or I-type ALU operations
                case (funct3)
                    3'b000: begin
                        if (RtypeSub)
                            ALUControl = 4'b0001; // sub
                        else
                            ALUControl = 4'b0000; // add, addi
                    end
                    3'b001: ALUControl = 4'b0100; // sll, slli
                    3'b010: ALUControl = 4'b0101; // slt, slti
                    3'b011: ALUControl = 4'b1000; // sltu, sltiu
                    3'b100: ALUControl = 4'b0110; // xor, xori
                    3'b101: begin
                        if (~funct7[5])
                            ALUControl = 4'b0111; // srl, srli
                        else
                            ALUControl = 4'b1111; // sra, srai
                    end
                    3'b110: ALUControl = 4'b0011; // or, ori
                    3'b111: ALUControl = 4'b0010; // and, andi
                    default: ALUControl = 4'bxxxx; // undefined
                endcase
            end
        endcase
    end
endmodule