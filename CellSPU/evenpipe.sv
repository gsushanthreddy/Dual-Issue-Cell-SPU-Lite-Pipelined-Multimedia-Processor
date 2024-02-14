import descriptions::*;

// ep_input_op_code = even pipe op code given as input (declaring port)
// ep_op_code = even pipe op code
// rep_left_bit_I10_xx = repeat left bit of I10 so that I10 converts to XX bits


module evenpipe(
    input clock,
    input reset,
    input opcode ep_input_op_code,
    input [0:127] ra_input,
    input [0:127] rb_input,
    input [0:127] rc_input,
    input [0:6] rt_address_input,
    input [0:9] I10_input,
    input [0:15] I16_input,
    input [0:17] I18_input
);
    opcode ep_op_code;
    logic[0:127] ra, rb, rc, rt_value;
    logic [0:9] I10;
    logic [0:15] I16;
    logic [0:17] I18;
    logic[0:3] unit_latency;
    logic[0:2] unit_id; 

    assign logic [0:15] rep_left_bit_I10_16 = {{6{I10[0]}}, I10};
    assign logic [0:31] rep_left_bit_I10_32 = {{22{I10[0]}}, I10};
    
    always_comb begin 
        case(ep_op_code)
            
            ADD_WORD:
                $display("Add Word instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ra[i*WORD : (i+1)*WORD-1] + rb[i*WORD : (i+1)*WORD-1]; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            ADD_HALFWORD:
                $display("Add Halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD : (i+1)*HALFWORD-1] = ra[i*HALFWORD : (i+1)*HALFWORD-1] + rb[i*HALFWORD : (i+1)*HALFWORD-1]; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            ADD_HALFWORD_IMMEDIATE:
                $display("Add Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD : (i+1)*HALFWORD-1] = ra[i*HALFWORD : (i+1)*HALFWORD-1] + rep_left_bit_I10_16; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            ADD_WORD_IMMEDIATE:
                $display("Add Word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ra[i*WORD : (i+1)*WORD-1] + rep_left_bit_I10_32; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            SUBTRACT_FROM_WORD:
                $display("Subtract from Word instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = rb[i*WORD : (i+1)*WORD-1] + ~(ra[i*WORD : (i+1)*WORD-1]) + 1; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            SUBTRACT_FROM_HALFWORD:
                $display("Subtract from Halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD : (i+1)*HALFWORD-1] = rb[i*HALFWORD : (i+1)*HALFWORD-1] + ~(ra[i*HALFWORD : (i+1)*HALFWORD-1]) + 1; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            SUBTRACT_FROM_HALFWORD_IMMEDIATE:
                $display("Subtract from Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD : (i+1)*HALFWORD-1] = rep_left_bit_I10_16 + ~(ra[i*HALFWORD : (i+1)*HALFWORD-1]) + 1; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            SUBTRACT_FROM_WORD_IMMEDIATE:
                $display("Subtract from word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = rep_left_bit_I10_32 + ~(ra[i*WORD : (i+1)*WORD-1]) + 1; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            ADD_EXTENDED:
                $display("Add Extended Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ra[i*WORD : (i+1)*WORD-1] + rb[i*WORD : (i+1)*WORD-1] + rt_value[31 + i*WORD]; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
        endcase
    end
endmodule
