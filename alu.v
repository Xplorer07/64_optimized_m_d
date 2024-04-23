module alu(alu_out, multiply_top_in, divide_top_in, multiplicand_or_divider_in, sel); //sel = 1 means multiply, 0 means divide
    input [64:0] multiply_top_in;
    input [64:0] divide_top_in;
    input [64:0] multiplicand_or_divider_in;
    input sel;

    output [64:0] alu_out;

    wire [64:0] sum;
    wire [64:0] diff;

    assign sum = multiplicand_or_divider_in + multiply_top_in;   //for multiplication purpose
    assign diff = divide_top_in - multiplicand_or_divider_in;        // for division purpose
    
    assign alu_out = sel?sum:diff;
endmodule

