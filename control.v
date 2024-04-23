module control(clk, reset, start, m_d, data_in, alu_sel, ready, wr, initial_wr, sh_right, sh_left); //md = 1 means multiply, md = 0 means divide
    input clk, reset, start, m_d;
    input [1:0] data_in;

    output ready, wr, initial_wr, sh_right, sh_left, alu_sel;

    wire ready_check;
    wire wr_check;
    wire initial_wr_check;
    wire sh_right_check;
    wire sh_left_check;
    wire mul_wr;
    wire div_wr;

    reg [1:0] state;
    reg [9:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'd0;                    // state is idle when reset is high
            counter <= 10'd0;                // counter is set to 10 bit 0's 
        end
        else begin
            case (state) //Idle state
                2'b00: begin 
                    if (start == 1) state <= 2'b01;        // start signal is checked 
                end

                2'b01: begin //Load state
                    counter <= 0;                    //counter is set to 0 in load state
                    state <= 2'b10;                 
                end

                2'b10: begin //Op state
                    if (counter == 63) state <= 2'b00; 
                    counter <= counter + 1;              // counter is incremented by one until 64th repitition
                end
            endcase
        end
    end
    
    assign alu_sel = m_d;

    assign mul_wr = data_in[0] && m_d;
    assign div_wr = !(data_in[1] || m_d); 
    assign wr_check = (state == 2'b10) && (mul_wr || div_wr); 
    assign wr = wr_check ? 1 : 0; 
    
    assign initial_wr_check = (state == 2'b01); 
    assign initial_wr = initial_wr_check ? 1 : 0; 
    
    assign sh_right_check = (state == 2'b10) && m_d; 
    assign sh_right = sh_right_check ? 1 : 0; 

    assign sh_left_check = (state == 2'b10) && (!m_d);
    assign sh_left = sh_left_check ? 1 : 0;
    
    assign ready_check = (state == 2'b00); 
    assign ready = ready_check ? 1 : 0; 
endmodule

