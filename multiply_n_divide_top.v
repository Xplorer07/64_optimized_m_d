module multiply_n_divide_top(clk, reset, a_in, b_in, m_d, start, result, ready);
    input [63:0] a_in, b_in;
    input clk, reset, start, m_d;

    output ready;
    output [128:0] result;

    wire [63:0] mul_div_reg_out;

    wire [64:0] alu_out;
    wire [128:0] res_reg_out;
    wire control_wr;
    wire control_initial_wr;
    wire control_sh_right;
    wire control_alu_sel;
    // 3 modules are interconnected through explicit port mapping
    multiplicand_n_divider_register mndr1(
        .clk(clk),
        .reset(reset),
        .data_in(b_in),
        .data_out(mul_div_reg_out)
    );

    alu alu1(
        .multiply_top_in(res_reg_out[128:64]),
        .divide_top_in(res_reg_out[127:63]),
        .multiplicand_or_divider_in({1'b0,mul_div_reg_out}),
        .sel(control_alu_sel),
        .alu_out(alu_out)
    );

    result_register resr1(
        .clk(clk),
        .reset(reset),
        .data_in(alu_out),
        .wr(control_wr),
        .initial_data_in(a_in),
        .initial_wr(control_initial_wr),
        .sh_right(control_sh_right),
        .sh_left(control_sh_left),
        .result(res_reg_out)
    );

    control cu1(
        .clk(clk),
        .reset(reset),
        .start(start),
        .m_d(m_d),
        .data_in({alu_out[64], res_reg_out[0]}),
        .alu_sel(control_alu_sel),
        .ready(ready),
        .wr(control_wr),
        .initial_wr(control_initial_wr),
        .sh_right(control_sh_right),
        .sh_left(control_sh_left)
    );

    assign result = res_reg_out;
endmodule

