`timescale 1ps/1ps          // time unit is set to 1 ps with 1ps unit precision

module multiply_n_divide_top_tb;
    reg [63:0] a_in, b_in;
    reg clk, reset, start, m_d;

    wire ready;
    wire [128:0] result;
    wire quotient;
    wire remainder;

    integer i;

    multiply_n_divide_top mlndu1(clk, reset, a_in, b_in, m_d, start, result, ready);
    
    assign quotient = result[63:0];
    assign remainder = result[128:63];

    always #1 clk = ~clk;

    initial begin
        reset = 1; clk = 1; a_in = 64'd0; b_in = 64'd0; start = 0; m_d = 1'b0;
        #2;
        reset = 0;
        a_in = 3;
        b_in = 7;

        start = 1;
        m_d = 0;
        #4;
        for (i = 0; i < 100; i = i + 1) begin
            while (ready == 0) begin
                #2;
            end
            
            if (m_d) begin
                $display("%d. \t time = %d \t a_in = %d \t b_in = %d \t result = %d", i+1, $time, a_in, b_in, result);
                if (a_in * b_in != result) begin
                    $display("Wrong!!!");
                end
                else $display("Right!!!");
            end
            else begin
                $display("%d. \t time = %d \t a_in = %d \t b_in = %d \t quotient = %d \t remainder = %d", i+1, $time, a_in, b_in, quotient, remainder);
                if (a_in / b_in != quotient) $display("Wrong!!!");
                else $display("Right!!!");
            end
            start = 1;
            a_in = a_in * 7;           // ramdom value generation
            b_in = b_in * 3;
            #2;
        end 
        #10 $finish;
    end
endmodule
