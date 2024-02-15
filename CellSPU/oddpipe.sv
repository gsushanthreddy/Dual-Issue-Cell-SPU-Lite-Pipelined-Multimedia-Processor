import descriptions::*;

// op_input_op_code = odd pipe op code given as input (declaring port)
// op_op_code = odd pipe op code
// rep_left_bit_I10_xx = repeat left bit of I10 so that I10 converts to XX bits


module oddpipe(
    input clock,
    input reset,
    input opcode op_input_op_code,
    input [0:127] ra_input,
    input [0:127] rb_input,
    input [0:127] rc_input,
    input [0:6] rt_address_input,
    input [0:6] I7_input,
    input [0:9] I10_input,
    input [0:15] I16_input,
    input [0:17] I18_input
);
    opcode op_op_code;
    logic [0:127] ra, rb, rc, rt_value;
    logic [0:6] I7;
    logic [0:9] I10;
    logic [0:15] I16;
    logic [0:17] I18;
    logic [0:2] s1;
    logic [0:6] s2;
    logic [0:4] s3;
    logic [0:3] s4;
    logic [0:7] s5;
    logic [0:15] s6;
    logic [0:3] unit_latency;
    logic [0:2] unit_id; 
    logic [0:127] t_128;

    assign logic [0:15] rep_left_bit_I10_16 = {{6{I10[0]}}, I10};
    assign logic [0:31] rep_left_bit_I10_32 = {{22{I10[0]}}, I10};
    
    always_comb begin 
        case(op_op_code)
        
            SHIFT_LEFT_QUADWORD_BY_BITS:
                $display("Shift left quadword by bits instruction starts...");
                begin
                    s1 = rb[29:31];
                    for(int b=0;b<128;b++) 
                        begin
                            if (b+s1 < 128) begin
                                t_128[b] = ra[b+s1];
                            end 
                            else begin
                                t_128[b] = 0;
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end

            SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE:
                $display("Shift left quadword by bits immediate instruction starts...");
                begin
                    s2 = I7 & 7'h07;
                    for(int b=0;b<128;b++) 
                        begin
                            if (b+s2 < 128) begin
                                t_128[b] = ra[b+s2];
                            end 
                            else begin
                                t_128[b] = 0;
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end

            SHIFT_LEFT_QUADWORD_BY_BYTES:
                $display("Shift left quadword by bytes instruction starts...");
                begin
                    s3 = rb[27:31];
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s3 < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s3)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = 8'd0;
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end
            
            SHIFT_LEFT_QUADWORD_BY_BYTE_IMMEDIATE:
                $display("Shift left quadword by byte immediate instruction starts...");
                begin
                    s2 = I7 & 7'h1F;
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s2 < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s2)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = 8'd0;
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end

            SHIFT_LEFT_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT:
                $display("Shift left quadword by bytes from bit shift count instruction starts...");
                begin
                    s3 = rb[24:28];
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s3 < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s3)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = 8'd0;
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end
            
            ROTATE_QUADWORD_BY_BYTES:
                $display("Rotate Quadword by bytes instruction starts...");
                begin
                    s4 = rb[28:31];
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s4 < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s4)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s4-16)*BYTE) +: BYTE];
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end

            ROTATE_QUADWORD_BY_BYTES_IMMEDIATE:
                $display("Rotate Quadword by bytes immediate instruction starts...");
                begin
                    s4 = I7[3:6];
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s4 < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s4)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s4-16)*BYTE) +: BYTE];
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end

            ROTATE_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT:
                $display("Rotate Quadword by bytes from bit shift count instruction starts...");
                begin
                    s3 = rb[24:28];
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s3 < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s3)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s3-16)*BYTE) +: BYTE];
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end
            
            ROTATE_QUADWORD_BY_BITS:
                $display("Rotate Quadword by bits instruction starts...");
                begin
                    s1 = rb[29:31];
                    for(int b=0;b<128;b++) 
                        begin
                            if (b+s1 < 128) begin
                                t_128[b] = ra[b+s1];
                            end 
                            else begin
                                t_128[b] = ra[b+s1-128];
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end

            ROTATE_QUADWORD_BY_BITS_IMMEDIATE:
                $display("Rotate Quadword by bits immediate instruction starts...");
                begin
                    s1 = I7[4:6];
                    for(int b=0;b<128;b++) 
                        begin
                            if (b+s1 < 128) begin
                                t_128[b] = ra[b+s1];
                            end 
                            else begin
                                t_128[b] = ra[b+s1-128];
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end

            GATHER_BITS_FROM_BYTES:
                $display("Gather bits from bytes instruction starts...");
                begin
                    s6 = 16'd0;
                    for(int j=0;b<16;j++) 
                        begin
                            s6[j] = ra[(j*BYTE + (BYTE-1))];
                        end
                    rt_value[(0*BYTE) : (3*BYTE)] = {16'd0, s6};
                    rt_value[(4*BYTE) : (7*BYTE)] = 32'd0;
                    rt_value[(8*BYTE) : (11*BYTE)] = 32'd0;
                    rt_value[(12*BYTE) : (15*BYTE)] = 32'd0;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end

            GATHER_BITS_FROM_HALFWORDS:
                $display("Gather bits from halfwords instruction starts...");
                begin
                    s5 = 8'd0;
                    for(int j=0;b<8;j++) 
                        begin
                            s5[j] = ra[(j*HALFWORD + (HALFWORD-1))];
                        end
                    rt_value[(0*BYTE) : (3*BYTE)] = {24'd0, s5};
                    rt_value[(4*BYTE) : (7*BYTE)] = 32'd0;
                    rt_value[(8*BYTE) : (11*BYTE)] = 32'd0;
                    rt_value[(12*BYTE) : (15*BYTE)] = 32'd0;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end
                
            GATHER_BITS_FROM_WORDS:
                $display("Gather bits from words instruction starts...");
                begin
                    s4 = 4'd0;
                    for(int j=0;b<4;j++) 
                        begin
                            s4[j] = ra[(j*WORD + (WORD-1))];
                        end
                    rt_value[(0*BYTE) : (3*BYTE)] = {28'd0, s4};
                    rt_value[(4*BYTE) : (7*BYTE)] = 32'd0;
                    rt_value[(8*BYTE) : (11*BYTE)] = 32'd0;
                    rt_value[(12*BYTE) : (15*BYTE)] = 32'd0;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;
                end


            


            
            
        endcase
    end
            
endmodule           

            