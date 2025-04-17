module ImmGen (
    input [31:0] instruction,
    output reg [31:0] imm_ext
);

    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            7'b0010011, // I-type (ADDI, ANDI, ORI, etc.)
            7'b0000011, // I-type (LOAD)
            7'b1100111: // I-type (JALR)
                imm_ext = {{20{instruction[31]}}, instruction[31:20]}; // sign-extend 12-bit

            7'b0100011: // S-type (STORE)
                imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            7'b1100011: // B-type (BEQ, BNE, etc.)
                imm_ext = {{19{instruction[31]}}, instruction[31], instruction[7],
                            instruction[30:25], instruction[11:8], 1'b0};

            7'b0110111, // U-type (LUI)
            7'b0010111: // U-type (AUIPC)
                imm_ext = {instruction[31:12], 12'b0};

            7'b1101111: // J-type (JAL)
                imm_ext = {{11{instruction[31]}}, instruction[31],
                            instruction[19:12], instruction[20],
                            instruction[30:21], 1'b0};

            default:
                imm_ext = 32'b0;
        endcase
    end

endmodule
