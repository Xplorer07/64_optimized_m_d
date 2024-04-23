module result_register(clk, reset, data_in, wr, initial_data_in, initial_wr, sh_right, sh_left, result);
    input [64:0] data_in;
    input [63:0] initial_data_in;
    input clk, reset, wr, initial_wr, sh_right, sh_left;

    output [128:0] result;

    reg [128:0] result_reg;

    always @(posedge clk) begin
        if (reset) 
            result_reg <= 129'd0;   // outputs the 129 bits 0's when reset is high
        else begin
            if (initial_wr == 1) 
                result_reg <= {65'd0, initial_data_in};             // when initial_wr is on , the output is concatenation of 65'd0 and initial_data-in
            else begin
                if (wr && sh_right) 
                    result_reg <= {1'd0, data_in, result_reg[63:1]};    // when wr and sh_right signals are on ,output is concatenation of 1'd0, data_in and 64 bits updated result_reg

                else if (wr && sh_left)
                    result_reg <= {data_in, result_reg[62:0], 1'b1};    //when wr and sh_left signals are on ,output is concatenation of  data_in and 64 bits updated result_reg and 1'd1

                else if (sh_right) 
                    result_reg <= {1'd0, result_reg[128:1]};  // when only sh_right is on , the output is concatenation of 1'd0 and 128 bits result register 

                else if (sh_left)
                    result_reg <= {result_reg[127:0], 1'b0};  // when only sh_left is on , the output is concatenation of  128 bits result register and 1'd0 
            end
        end
    end

    assign result = result_reg;
endmodule
