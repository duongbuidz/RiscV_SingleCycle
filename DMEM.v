module DMEM(
    input clk,               
    input rst,               
    input MemRead,           
    input MemWrite,          
    input [31:0] address,    
    input [31:0] write_data, 
    output[31:0] read_data 
);
  reg [31:0] dmem [255:0];

  integer k;
  
  assign read_data = (MemRead) ? dmem[address] : 32'b00;
  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for (k = 0; k < 255; k = k + 1) begin
        dmem[k] = 32'b00;
      end
    end else if (MemWrite) begin
      dmem[address] = write_data;
    end
  end

endmodule 