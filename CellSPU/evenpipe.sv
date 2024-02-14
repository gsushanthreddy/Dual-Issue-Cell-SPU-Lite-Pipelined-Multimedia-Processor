import descriptions::*;

// ep_input_op_code = even pipe op code given as input (declaring port)
// ep_op_code = even pipe op code
// rep_left_bit_I10_xx = repeat left bit of I10 so that I10 converts to XX bits
// t_XX = temporary wire which can traverse XX bits 

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
    logic [0:127] ra, rb, rc, rt_value;
    logic [0:9] I10;
    logic [0:15] I16;
    logic [0:17] I18;
    logic [0:3] unit_latency;
    logic [0:2] unit_id; 

    logic t_1;
    logic [0:3] t_4;
    logic [0:7] t_8;
    logic [0:31] t_32;

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
                $display("Add Extended instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ra[i*WORD : (i+1)*WORD-1] + rb[i*WORD : (i+1)*WORD-1] + rt_value[31 + i*WORD]; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            SUBTRACT_FROM_EXTENDED:
                $display("Subtract from extended instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = rb[i*WORD : (i+1)*WORD-1] + ~(ra[i*WORD : (i+1)*WORD-1]) + rt_value[31 + i*WORD]; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end

            CARRY_GENERATE:
                $display("Carry Generate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            t_32 = ra[i*WORD : (i+1)*WORD-1] + rb[i*WORD : (i+1)*WORD-1]
                            rt_value[i*WORD : (i+1)*WORD-1] = {31'b0, t_32[0]}; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end

            BORROW_GENERATE:
                $display("Borrow Generate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if($unsigned(ra[i*WORD : (i+1)*WORD-1]) >= $unsigned(rb[i*WORD : (i+1)*WORD-1])) 
                                begin 
                                    rt_value[i*WORD : (i+1)*WORD-1] = 31'b1;
                                end
                            else 
                                begin
                                    rt_value[i*WORD : (i+1)*WORD-1] = 31'b0;
                                end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            AND:
                $display("And instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ra[i*WORD : (i+1)*WORD-1] & rb[i*WORD : (i+1)*WORD-1];
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            AND_WITH_COMPLEMENT:
                $display("And with complement instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ra[i*WORD : (i+1)*WORD-1] & ~(rb[i*WORD : (i+1)*WORD-1]);
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            AND_HALFWORD_IMMEDIATE:
                $display("And Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD : (i+1)*HALFWORD-1] = ra[i*HALFWORD : (i+1)*HALFWORD-1] & rep_left_bit_I10_16;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            AND_HALFWORD_IMMEDIATE:
                $display("And halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD : (i+1)*HALFWORD-1] = ra[i*HALFWORD : (i+1)*HALFWORD-1] & rep_left_bit_I10_32;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            OR:
                $display("Or instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ra[i*WORD : (i+1)*WORD-1] | rb[i*WORD : (i+1)*WORD-1];
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end

            OR_COMPLEMENT:
                $display("Or with complement instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ra[i*WORD : (i+1)*WORD-1] | ~(rb[i*WORD : (i+1)*WORD-1]);
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end

            OR_HALFWORD_IMMEDIATE:
                $display("Or Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD : (i+1)*HALFWORD-1] = ra[i*HALFWORD : (i+1)*HALFWORD-1] | rep_left_bit_I10_16;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end

            OR_WORD_IMMEDIATE:
                $display("Or word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ra[i*WORD : (i+1)*WORD-1] | rep_left_bit_I10_32;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            EXCLUSIVE_OR:
                $display("Exclusive Or instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ra[i*WORD : (i+1)*WORD-1] ^ rb[i*WORD : (i+1)*WORD-1];
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            EXCLUSIVE_OR_HALFWORD_IMMEDIATE:
                $display("Exclusive Or Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD : (i+1)*HALFWORD-1] = ra[i*HALFWORD : (i+1)*HALFWORD-1] ^ rep_left_bit_I10_16;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            EXCLUSIVE_OR_WORD_IMMEDIATE:
                $display("Exclusive Or word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ra[i*WORD : (i+1)*WORD-1] ^ rep_left_bit_I10_32;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            NAND:
                $display("NAND instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ~(ra[i*WORD : (i+1)*WORD-1] & rb[i*WORD : (i+1)*WORD-1]);
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            NOR:
                $display("NOR instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD : (i+1)*WORD-1] = ~(ra[i*WORD : (i+1)*WORD-1] | rb[i*WORD : (i+1)*WORD-1]);
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COUNT_LEADING_ZEROS:
                $display("Count Leading Zeros instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            t_1 = 'b0;
                            t_32 = ra[i*WORD : (i+1)*WORD-1];
                            for(int j=0;j<WORD;j++)
                            begin
                                if(t_32[j] == 1 && t_1 == 'b0)
                                begin
                                    t_1 = 'b1;
                                    rt_value[i*WORD : (i+1)*WORD-1] = j;
                                end
                            end
                            if(t_1 == 'b0)
                            begin
                                rt_value[i*WORD : (i+1)*WORD-1] = 32;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            FORM_SELECT_MASK_FOR_HALFWORDS:
                $display("Form Select Mask for Halfwords instruction starts...");
                begin
                    t_8 = ra[24:31]
                    for(int i=0;i<8;i++) 
                        begin
                            if(t_8[i] == 0)
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'h0000;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'hffff;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            FORM_SELECT_MASK_FOR_WORDS:
                $display("Form Select Mask for Words instruction starts...");
                begin
                    t_4 = ra[28:31]
                    for(int i=0;i<4;i++) 
                        begin
                            if(t_4[i] == 0)
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'h00000000;
                            end
                            else
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'hffffffff;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COMPARE_EQUAL_HALFWORD:
                $display("Compare Equal Halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if(ra[i*HALFWORD : (i+1)*HALFWORD -1] == rb[i*HALFWORD : (i+1)*HALFWORD -1])
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'hffff;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COMPARE_EQUAL_HALFWORD_IMMEDIATE:
                $display("Compare Equal Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if(ra[i*HALFWORD : (i+1)*HALFWORD -1] == rep_left_bit_I10_16)
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'hFFFF;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COMPARE_EQUAL_WORD:
                $display("Compare Equal word instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if(ra[i*WORD : (i+1)*WORD -1] == rb[i*WORD : (i+1)*WORD -1])
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COMPARE_EQUAL_WORD_IMMEDIATE:
                $display("Compare Equal word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if(ra[i*WORD : (i+1)*WORD -1] == rep_left_bit_I10_32)
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end

            COMPARE_GREATER_THAN_HALFWORD:
                $display("Compare greater than Halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if($signed(ra[i*HALFWORD : (i+1)*HALFWORD -1]) > $signed(rb[i*HALFWORD : (i+1)*HALFWORD -1]))
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'hFFFF;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COMPARE_GREATER_THAN_HALFWORD_IMMEDIATE:
                $display("Compare greater than Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if($signed(ra[i*HALFWORD : (i+1)*HALFWORD -1]) > rep_left_bit_I10_16)
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'hFFFF;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COMPARE_GREATER_THAN_WORD:
                $display("Compare greater than word instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if($signed(ra[i*WORD : (i+1)*WORD -1]) > $signed(rb[i*WORD : (i+1)*WORD -1]))
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COMPARE_GREATER_THAN_WORD_IMMEDIATE:
                $display("Compare greater than word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if($signed(ra[i*WORD : (i+1)*WORD -1]) > rep_left_bit_I10_32)
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COMPARE_LOGICAL_GREATER_THAN_HALFWORD:
                $display("Compare logical greater than halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if(ra[i*HALFWORD : (i+1)*HALFWORD -1] > rb[i*HALFWORD : (i+1)*HALFWORD -1])
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'hFFFF;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COMPARE_LOGICAL_GREATER_THAN_HALFWORD_IMMEDIATE:
                $display("Compare Logical greater than Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if(ra[i*HALFWORD : (i+1)*HALFWORD -1] > rep_left_bit_I10_16)
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'hFFFF;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COMPARE_LOGICAL_GREATER_THAN_WORD:
                $display("Compare Logical greater than word instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if(ra[i*WORD : (i+1)*WORD -1] > rb[i*WORD : (i+1)*WORD -1])
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE:
                $display("Compare Logical greater than word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if(ra[i*WORD : (i+1)*WORD -1] > rep_left_bit_I10_32)
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD : (i+1)*WORD -1] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            IMMEDIATE_LOAD_HALFWORD: 
                $display("Immediate Load halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++)
                    begin
                        rt_value[i*HALFWORD : (i+1)*HALFWORD -1] = I16;
                    end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            IMMEDIATE_LOAD_HALFWORD_UPPER:
                $display("Immediate Load Halfword Upper Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        rt_value[i*WORD : (i+1)*WORD -1] = {I16,16'b0};
                    end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end

            IMMEDIATE_LOAD_HALFWORD: 
                $display("Immediate Load word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        rt_value[i*WORD : (i+1)*WORD -1] = rep_left_bit_I10_32;
                    end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
            
            IMMEDIATE_LOAD_ADDRESS:
                $display("Immediate Load Address Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        rt_value[i*WORD : (i+1)*WORD -1] = {14'b0,I18};
                    end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                end
        endcase
    end
endmodule
