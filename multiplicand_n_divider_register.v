module multiplicand_n_divider_register(clk, reset, data_in, data_out);
    input [63:0] data_in;
    input clk, reset;
    output [63:0] data_out;
    reg [63:0] mul_div_reg;

    always @(posedge clk) begin
        if (reset)                        //assings 65 bit 0's when reset is on
            mul_div_reg <= 64'd0;
        else 
            mul_div_reg <= data_in;         //assigns the multiplicand or divisor to the register
    end
    assign data_out = mul_div_reg;
endmodule

