module tb_top;
    reg clk, reset;
    risc_v_single_cycle UUT (
        .clk(clk), 
        .reset(reset)
    );
    initial begin
        clk = 0;
    end

    always #50 clk = ~clk; 

    initial begin
        reset = 1'b1;
        #50;
        reset = 1'b0; 
        #5200; 
        $finish; 
    end

endmodule
