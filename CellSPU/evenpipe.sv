// ep_input_op_code = even pipe op code given as input (declaring port)
// ep_op_code = even pipe op code
// rep_left_bit_I10_xx = repeat left bit of I10 so that I10 converts to XX bits
// t_XX = temporary wire which can traverse XX bits 
// t_XX_y = #y duplicate of temporary wire which can traverse XX bits 
// r_XX = temporary register of XX bits
// wrt_en_ep = write enable
// fw_ep_st_X = forward even pipe stage X = Total 143 bits = 3 bits uid + 128 bits rt_value + 1 bit write enable + 7 bits rt address value + 4 bits instruction latency
// out_ep = output of ep of length 143 bits
import descriptions::*;

module evenpipe(
    input clock,
    input reset,
    input opcode ep_input_op_code,
    input [0:127] ra_input,
    input [0:127] rb_input,
    input [0:127] rc_input,
    input [0:6] rt_address_input,
    input [0:6] I7_input,
    input [0:9] I10_input,
    input [0:15] I16_input,
    input [0:17] I18_input,
    output logic [0:142] out_ep
);
    // input opcode ep_input_op_code;
    opcode ep_op_code;
    logic [0:127] ra, rb, rc, rt_value;
    logic [0:6] rt_address;
    logic wrt_en_ep;
    logic [0:15] r_16;
    logic [0:31] r_32;
    logic [0:6] I7;
    logic [0:9] I10;
    logic [0:15] I16;
    logic [0:17] I18;
    logic [0:3] unit_latency;
    logic [0:2] unit_id; 

    real t_1_real; // for bits to short real conversion value of ra
    real t_2_real; // for bits to short real conversion value of rb
    real t_3_real; // for bits to short real conversion value of rc
    real t_4_real; // for bits to short real value of result

    int s;

    logic t_1;
    logic [0:3] t_4;
    logic [0:7] t_8;
    logic [0:7] t_8_1;
    logic [0:15] t_16;
    logic [0:31] t_32;

    logic [0:142] fw_ep_st_1;
    logic [0:142] fw_ep_st_2;
    logic [0:142] fw_ep_st_3;
    logic [0:142] fw_ep_st_4;
    logic [0:142] fw_ep_st_5;
    logic [0:142] fw_ep_st_6;
    logic [0:142] fw_ep_st_7;

    logic [0:16] rep_left_bit_I7_16;
    logic [0:32] rep_left_bit_I7_32;
    logic [0:15] rep_left_bit_I10_16;
    logic [0:31] rep_left_bit_I10_32;

    assign rep_left_bit_I7_16 = {{9{I7[0]}}, I7};
    assign rep_left_bit_I7_32 = {{25{I7[0]}}, I7};
    assign rep_left_bit_I10_16 = {{6{I10[0]}}, I10};
    assign rep_left_bit_I10_32 = {{22{I10[0]}}, I10};
    
    always_ff @(posedge clock) begin
        ra <= ra_input;
        rb <= rb_input;
        rc <= rc_input;
        rt_address <= rt_address_input;
        ep_op_code <= ep_input_op_code;
        I7 <= I7_input;
        I10 <= I10_input;
        I16 <= I16_input;
        I18 <= I18_input;
    end

    always_ff @(posedge clock) begin
        if(reset==1) begin 
            fw_ep_st_2 <= 143'd0;
            fw_ep_st_3 <= 143'd0;
            fw_ep_st_4 <= 143'd0;
            fw_ep_st_5 <= 143'd0;
            fw_ep_st_6 <= 143'd0;
            fw_ep_st_7 <= 143'd0;
            out_ep     <= 143'd0;
        end
        else begin 
            fw_ep_st_2 <= fw_ep_st_1;
            fw_ep_st_3 <= fw_ep_st_2;
            fw_ep_st_4 <= fw_ep_st_3;
            fw_ep_st_5 <= fw_ep_st_4;
            fw_ep_st_6 <= fw_ep_st_5;
            fw_ep_st_7 <= fw_ep_st_6;
            out_ep     <= fw_ep_st_7;
        end
    end

    always_comb begin 
        case(ep_op_code)
            ADD_WORD:
                //$display("Add Word instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ra[i*WORD +: WORD] + rb[i*WORD +: WORD]; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            ADD_HALFWORD:
                //$display("Add Halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD +: HALFWORD] = ra[i*HALFWORD +: HALFWORD] + rb[i*HALFWORD +: HALFWORD]; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            ADD_HALFWORD_IMMEDIATE:
                //$display("Add Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD +: HALFWORD] = ra[i*HALFWORD +: HALFWORD] + rep_left_bit_I10_16; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            ADD_WORD_IMMEDIATE:
                //$display("Add Word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ra[i*WORD +: WORD] + rep_left_bit_I10_32; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            SUBTRACT_FROM_WORD:
                //$display("Subtract from Word instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = rb[i*WORD +: WORD] + ~(ra[i*WORD +: WORD]) + 1; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            SUBTRACT_FROM_HALFWORD:
                //$display("Subtract from Halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD +: HALFWORD] = rb[i*HALFWORD +: HALFWORD] + ~(ra[i*HALFWORD +: HALFWORD]) + 1; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            SUBTRACT_FROM_HALFWORD_IMMEDIATE:
                //$display("Subtract from Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD +: HALFWORD] = rep_left_bit_I10_16 + ~(ra[i*HALFWORD +: HALFWORD]) + 1; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            SUBTRACT_FROM_WORD_IMMEDIATE:
                //$display("Subtract from word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = rep_left_bit_I10_32 + ~(ra[i*WORD +: WORD]) + 1; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            ADD_EXTENDED:
                //$display("Add Extended instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ra[i*WORD +: WORD] + rb[i*WORD +: WORD] + rt_value[31 + i*WORD]; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            SUBTRACT_FROM_EXTENDED:
                //$display("Subtract from extended instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = rb[i*WORD +: WORD] + ~(ra[i*WORD +: WORD]) + rt_value[31 + i*WORD]; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            CARRY_GENERATE:
                //$display("Carry Generate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            t_32 = ra[i*WORD +: WORD] + rb[i*WORD +: WORD];
                            rt_value[i*WORD +: WORD] = {31'b0, t_32[0]}; 
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            BORROW_GENERATE:
                //$display("Borrow Generate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if($unsigned(ra[i*WORD +: WORD]) >= $unsigned(rb[i*WORD +: WORD])) 
                                begin 
					                rt_value[i*WORD +: WORD] = 32'b1;
                                end
                            else 
                                begin
					                rt_value[i*WORD +: WORD] = 32'b0;
                                end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            AND:
                //$display("And instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ra[i*WORD +: WORD] & rb[i*WORD +: WORD];
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            AND_WITH_COMPLEMENT:
                //$display("And with complement instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ra[i*WORD +: WORD] & ~(rb[i*WORD +: WORD]);
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            AND_HALFWORD_IMMEDIATE:
                //$display("And Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD +: HALFWORD] = ra[i*HALFWORD +: HALFWORD] & rep_left_bit_I10_16;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            AND_WORD_IMMEDIATE:
                //$display("And halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ra[i*WORD +: WORD] & rep_left_bit_I10_32;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            OR:
                //$display("Or instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ra[i*WORD +: WORD] | rb[i*WORD +: WORD];
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            OR_COMPLEMENT:
                //$display("Or with complement instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ra[i*WORD +: WORD] | ~(rb[i*WORD +: WORD]);
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            OR_HALFWORD_IMMEDIATE:
                //$display("Or Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD +: HALFWORD] = ra[i*HALFWORD +: HALFWORD] | rep_left_bit_I10_16;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            OR_WORD_IMMEDIATE:
                //$display("Or word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ra[i*WORD +: WORD] | rep_left_bit_I10_32;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            EXCLUSIVE_OR:
                //$display("Exclusive Or instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ra[i*WORD +: WORD] ^ rb[i*WORD +: WORD];
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            EXCLUSIVE_OR_HALFWORD_IMMEDIATE:
                //$display("Exclusive Or Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            rt_value[i*HALFWORD +: HALFWORD] = ra[i*HALFWORD +: HALFWORD] ^ rep_left_bit_I10_16;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            EXCLUSIVE_OR_WORD_IMMEDIATE:
                //$display("Exclusive Or word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ra[i*WORD +: WORD] ^ rep_left_bit_I10_32;
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            NAND:
                //$display("NAND instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ~(ra[i*WORD +: WORD] & rb[i*WORD +: WORD]);
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            NOR:
                //$display("NOR instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            rt_value[i*WORD +: WORD] = ~(ra[i*WORD +: WORD] | rb[i*WORD +: WORD]);
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COUNT_LEADING_ZEROS:
                //$display("Count Leading Zeros instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            t_1 = 'b0;
                            t_32 = ra[i*WORD +: WORD];
                            for(int j=0;j<WORD;j++)
                            begin
                                if(t_32[j] == 1 && t_1 == 'b0)
                                begin
                                    t_1 = 'b1;
                                    rt_value[i*WORD +: WORD] = j;
                                end
                            end
                            if(t_1 == 'b0)
                            begin
                                rt_value[i*WORD +: WORD] = 32;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            FORM_SELECT_MASK_FOR_HALFWORDS:
                //$display("Form Select Mask for Halfwords instruction starts...");
                begin
                    t_8 = ra[24:31];
                    for(int i=0;i<8;i++) 
                        begin
                            if(t_8[i] == 0)
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'h0000;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'hffff;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            FORM_SELECT_MASK_FOR_WORDS:
                //$display("Form Select Mask for Words instruction starts...");
                begin
                    t_4 = ra[28:31];
                    for(int i=0;i<4;i++) 
                        begin
                            if(t_4[i] == 0)
                            begin 
                                rt_value[i*WORD +: WORD] = 32'h00000000;
                            end
                            else
                            begin 
                                rt_value[i*WORD +: WORD] = 32'hffffffff;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COMPARE_EQUAL_HALFWORD:
                //$display("Compare Equal Halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if(ra[i*HALFWORD +: HALFWORD] == rb[i*HALFWORD +: HALFWORD])
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'hffff;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COMPARE_EQUAL_HALFWORD_IMMEDIATE:
                //$display("Compare Equal Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if(ra[i*HALFWORD +: HALFWORD] == rep_left_bit_I10_16)
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'hFFFF;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COMPARE_EQUAL_WORD:
                //$display("Compare Equal word instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if(ra[i*WORD +: WORD] == rb[i*WORD +: WORD])
                            begin 
                                rt_value[i*WORD +: WORD] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD +: WORD] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COMPARE_EQUAL_WORD_IMMEDIATE:
                //$display("Compare Equal word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if(ra[i*WORD +: WORD] == rep_left_bit_I10_32)
                            begin 
                                rt_value[i*WORD +: WORD] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD +: WORD] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            COMPARE_GREATER_THAN_HALFWORD:
                //$display("Compare greater than Halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if($signed(ra[i*HALFWORD +: HALFWORD]) > $signed(rb[i*HALFWORD +: HALFWORD]))
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'hFFFF;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COMPARE_GREATER_THAN_HALFWORD_IMMEDIATE:
                //$display("Compare greater than Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if($signed(ra[i*HALFWORD +: HALFWORD]) > rep_left_bit_I10_16)
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'hFFFF;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COMPARE_GREATER_THAN_WORD:
                //$display("Compare greater than word instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if($signed(ra[i*WORD +: WORD]) > $signed(rb[i*WORD +: WORD]))
                            begin 
                                rt_value[i*WORD +: WORD] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD +: WORD] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COMPARE_GREATER_THAN_WORD_IMMEDIATE:
                //$display("Compare greater than word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if($signed(ra[i*WORD +: WORD]) > rep_left_bit_I10_32)
                            begin 
                                rt_value[i*WORD +: WORD] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD +: WORD] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COMPARE_LOGICAL_GREATER_THAN_HALFWORD:
                //$display("Compare logical greater than halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if(ra[i*HALFWORD +: HALFWORD] > rb[i*HALFWORD +: HALFWORD])
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'hFFFF;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COMPARE_LOGICAL_GREATER_THAN_HALFWORD_IMMEDIATE:
                //$display("Compare Logical greater than Halfword Immediate instruction starts...");
                begin
                    for(int i=0;i<8;i++) 
                        begin
                            if(ra[i*HALFWORD +: HALFWORD] > rep_left_bit_I10_16)
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'hFFFF;
                            end
                            else
                            begin 
                                rt_value[i*HALFWORD +: HALFWORD] = 16'h0000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COMPARE_LOGICAL_GREATER_THAN_WORD:
                //$display("Compare Logical greater than word instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if(ra[i*WORD +: WORD] > rb[i*WORD +: WORD])
                            begin 
                                rt_value[i*WORD +: WORD] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD +: WORD] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE:
                //$display("Compare Logical greater than word Immediate instruction starts...");
                begin
                    for(int i=0;i<4;i++) 
                        begin
                            if(ra[i*WORD +: WORD] > rep_left_bit_I10_32)
                            begin 
                                rt_value[i*WORD +: WORD] = 32'hFFFFFFFF;
                            end
                            else
                            begin 
                                rt_value[i*WORD +: WORD] = 32'h00000000;
                            end
                        end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            IMMEDIATE_LOAD_HALFWORD: 
                //$display("Immediate Load halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++)
                    begin
                        rt_value[i*HALFWORD +: HALFWORD] = I16;
                    end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            IMMEDIATE_LOAD_HALFWORD_UPPER:
                //$display("Immediate Load Halfword Upper instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        rt_value[i*WORD +: WORD] = {I16,16'b0};
                    end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            IMMEDIATE_LOAD_WORD: 
                //$display("Immediate Load word instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        rt_value[i*WORD +: WORD] = rep_left_bit_I10_32;
                    end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            IMMEDIATE_LOAD_ADDRESS:
                //$display("Immediate Load Address instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        rt_value[i*WORD +: WORD] = {14'b0,I18};
                    end
                    unit_latency = 4'd3;
                    unit_id = 3'd1;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            SHIFT_LEFT_HALFWORD: 
                //$display("Shift Left Half Word instruction starts...");
                begin
                    for(int i=0;i<8;i++)
                    begin
                        s = rb[i*HALFWORD +: HALFWORD] & 16'h001f;
                        t_16 = ra[i*HALFWORD +: HALFWORD];
                        for(int b=0;b<16;b++)
                        begin
                            if(b+s<16)
                            begin
                                r_16[b] = t_16[b+s];
                            end
                            else
                            begin
                                r_16[b] = 0;
                            end
                        end
                        rt_value[i*HALFWORD +: HALFWORD] = r_16;
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd2;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            SHIFT_LEFT_HALFWORD_IMMEDIATE: 
                //$display("Shift Left Halfword Immediate instruction starts...");
                begin
                    s = rep_left_bit_I7_16 & 16'h001f;
                    for(int i=0;i<8;i++)
                    begin
                    t_16 = ra[i*HALFWORD +: HALFWORD];
                        for(int b=0;b<16;b++)
                        begin
                            if(b+s<16)
                            begin
                                r_16[b] = t_16[b+s];
                            end
                            else
                            begin
                                r_16[b] = 0;
                            end
                        end
                        rt_value[i*HALFWORD +: HALFWORD] = r_16;
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd2;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            SHIFT_LEFT_WORD: 
                //$display("Shift Left Word instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        s = rb[i*WORD +: WORD] & 32'h0000003f;
                        t_32 = ra[i*WORD +: WORD];
                        for(int b=0;b<32;b++)
                        begin
                            if(b+s<32)
                            begin
                                r_32[b] = t_32[b+s];
                            end
                            else
                            begin
                                r_32[b] = 0;
                            end
                        end
                        rt_value[i*WORD +: WORD] = r_32;
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd2;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            SHIFT_LEFT_WORD_IMMEDIATE: 
                //$display("Shift Left Word Immediate instruction starts...");
                begin
                    s = rep_left_bit_I7_32 & 32'h0000003f;
                    for(int i=0;i<4;i++)
                    begin
                    t_32 = ra[i*WORD +: WORD];
                        for(int b=0;b<32;b++)
                        begin
                            if(b+s<32)
                            begin
                                r_32[b] = t_32[b+s];
                            end
                            else
                            begin
                                r_32[b] = 0;
                            end
                        end
                        rt_value[i*WORD +: WORD] = r_32;
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd2;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            ROTATE_HALFWORD: 
                //$display("Rotate Halfword instruction starts...");
                begin
                    for(int i=0;i<8;i++)
                    begin
                    s = rb[i*HALFWORD +: HALFWORD] & 16'h000f;
                    t_16 = ra[i*HALFWORD +: HALFWORD];
                        for(int b=0;b<16;b++)
                        begin
                            if(b+s<16)
                            begin
                                r_16[b] = t_16[b+s];
                            end
                            else
                            begin
                                r_16[b] = t_16[b+s-16];
                            end
                        end
                        rt_value[i*HALFWORD +: HALFWORD] = r_16;
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd2;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            ROTATE_HALFWORD_IMMEDIATE: 
                //$display("Rotate Halfword Immediate instruction starts...");
                begin
                    s = rep_left_bit_I7_16 & 16'h000f;
                    for(int i=0;i<8;i++)
                    begin
                    t_16 = ra[i*HALFWORD +: HALFWORD];
                        for(int b=0;b<16;b++)
                        begin
                            if(b+s<16)
                            begin
                                r_16[b] = t_16[b+s];
                            end
                            else
                            begin
                                r_16[b] = t_16[b+s-16];
                            end
                        end
                        rt_value[i*HALFWORD +: HALFWORD] = r_16;
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd2;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
                
            ROTATE_WORD: 
                //$display("Rotate word instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                    s = rb[i*WORD +: WORD] & 32'h0000001f;
                    t_32 = ra[i*WORD +: WORD];
                        for(int b=0;b<32;b++)
                        begin
                            if(b+s<32)
                            begin
                                r_32[b] = t_32[b+s];
                            end
                            else
                            begin
                                r_32[b] = t_32[b+s-32];
                            end
                        end
                        rt_value[i*WORD +: WORD] = r_32;
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd2;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            ROTATE_WORD_IMMEDIATE: 
                //$display("Rotate word Immediate instruction starts...");
                begin
                    s = rep_left_bit_I7_32 & 32'h0000001f;
                    for(int i=0;i<4;i++)
                    begin
                    t_32 = ra[i*WORD +: WORD];
                        for(int b=0;b<32;b++)
                        begin
                            if(b+s<32)
                            begin
                                r_32[b] = t_32[b+s];
                            end
                            else
                            begin
                                r_32[b] = t_32[b+s-32];
                            end
                        end
                        rt_value[i*WORD +: WORD] = r_32;
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd2;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            FLOATING_MULTIPLY: 
                //$display("Floating Multiply instruction starts...");
                begin
                    for(int i=0; i < 4; i++) 
                    begin
					    t_1_real = $bitstoshortreal(ra[i*WORD +: WORD]); 
					    t_2_real = $bitstoshortreal(rb[i*WORD +: WORD]);
					    t_4_real = t_1_real * t_2_real;

                        if (t_4_real < -SMAX)
                        begin
                            rt_value[i*WORD +: WORD] = -$shortrealtobits(SMAX);
                        end
                        else if (t_4_real) 
                        begin
                            rt_value[i*WORD +: WORD] = $shortrealtobits(SMAX);   
                        end
                        else if (t_4_real > -SMIN && t_4_real < SMIN)
                        begin
                            rt_value[i*WORD +: WORD] = 0;
                        end
                        else 
                        begin
                            rt_value[i*WORD +: WORD] = shortrealtobits(t_4_real);
                        end

                    end
                    unit_latency = 4'd7;
                    unit_id = 3'd3;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            FLOATING_MULTIPLY_AND_ADD: 
                //$display("Floating Multiply and Add instruction starts...");
                begin
                    for(int i=0; i < 4; i++) 
                    begin
					    t_1_real = $bitstoshortreal(ra[i*WORD +: WORD]); 
					    t_2_real = $bitstoshortreal(rb[i*WORD +: WORD]);
                        t_3_real = $bitstoshortreal(rc[i*WORD +: WORD]);
					    t_4_real = (t_1_real * t_2_real) + t_3_real;

                        if (t_4_real < -SMAX)
                        begin
                            rt_value[i*WORD +: WORD] = -$shortrealtobits(SMAX);
                        end
                        else if (t_4_real) 
                        begin
                            rt_value[i*WORD +: WORD] = $shortrealtobits(SMAX);   
                        end
                        else if (t_4_real > -SMIN && t_4_real < SMIN)
                        begin
                            rt_value[i*WORD +: WORD] = 0;
                        end
                        else 
                        begin
                            rt_value[i*WORD +: WORD] = shortrealtobits(t_4_real);
                        end

                    end
                    unit_latency = 4'd7;
                    unit_id = 3'd3;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            FLOATING_NEGATIVE_MULTIPLY_AND_SUBTRACT: 
                //$display("Floating Negative Multiply and Subtract instruction starts...");
                begin
                    for(int i=0; i < 4; i++) 
                    begin
					    t_1_real = $bitstoshortreal(ra[i*WORD +: WORD]); 
					    t_2_real = $bitstoshortreal(rb[i*WORD +: WORD]);
                        t_3_real = $bitstoshortreal(rc[i*WORD +: WORD]);
					    t_4_real = t_3_real - (t_1_real * t_2_real);

                        if (t_4_real < -SMAX)
                        begin
                            rt_value[i*WORD +: WORD] = -$shortrealtobits(SMAX);
                        end
                        else if (t_4_real) 
                        begin
                            rt_value[i*WORD +: WORD] = $shortrealtobits(SMAX);   
                        end
                        else if (t_4_real > -SMIN && t_4_real < SMIN)
                        begin
                            rt_value[i*WORD +: WORD] = 0;
                        end
                        else 
                        begin
                            rt_value[i*WORD +: WORD] = shortrealtobits(t_4_real);
                        end

                    end
                    unit_latency = 4'd7;
                    unit_id = 3'd3;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            FLOATING_MULTIPLY_AND_SUBTRACT: 
                //$display("Floating Multiply and Subtract instruction starts...");
                begin
                    for(int i=0; i < 4; i++) 
                    begin
					    t_1_real = $bitstoshortreal(ra[i*WORD +: WORD]); 
					    t_2_real = $bitstoshortreal(rb[i*WORD +: WORD]);
                        t_3_real = $bitstoshortreal(rc[i*WORD +: WORD]);
					    t_4_real = (t_1_real * t_2_real) - t_3_real;

                        if (t_4_real < -SMAX)
                        begin
                            rt_value[i*WORD +: WORD] = -$shortrealtobits(SMAX);
                        end
                        else if (t_4_real) 
                        begin
                            rt_value[i*WORD +: WORD] = $shortrealtobits(SMAX);   
                        end
                        else if (t_4_real > -SMIN && t_4_real < SMIN)
                        begin
                            rt_value[i*WORD +: WORD] = 0;
                        end
                        else 
                        begin
                            rt_value[i*WORD +: WORD] = shortrealtobits(t_4_real);
                        end

                    end
                    unit_latency = 4'd7;
                    unit_id = 3'd3;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            MULTIPLY: 
                //$display("Multiply instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        rt_value[i*(WORD) +: WORD] = $signed(ra[i*WORD+2*BYTE +: 2*BYTE]) * $signed(rb[i*WORD+2*BYTE +: 2*BYTE]);   
                    end
                    unit_latency = 4'd8;
                    unit_id = 3'd3;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            MULTIPLY_UNSIGNED: 
                //$display("Multiply Unsigned instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        rt_value[i*(WORD) +: WORD] = $unsigned(ra[i*WORD+2*BYTE +: 2*BYTE]) * $unsigned(rb[i*WORD+2*BYTE +: 2*BYTE]);   
                    end
                    unit_latency = 4'd8;
                    unit_id = 3'd3;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            MULTIPLY_IMMEDIATE: 
                //$display("Multiply Immediate instruction starts...");
                begin
                    t_16 = rep_left_bit_I10_16;
                    for(int i=0;i<4;i++)
                    begin
                        rt_value[i*(WORD) +: WORD] = $signed(ra[i*WORD+2*BYTE +: 2*BYTE]) * $signed(t_16);   
                    end
                    unit_latency = 4'd8;
                    unit_id = 3'd3;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            MULTIPLY_UNSIGNED_IMMEDIATE: 
                //$display("Multiply Unsigned Immediate instruction starts...");
                begin
                    t_16 = rep_left_bit_I10_16;
                    for(int i=0;i<4;i++)
                    begin
                        rt_value[i*(WORD) +: WORD] = $unsigned(ra[i*WORD+2*BYTE +: 2*BYTE]) * $unsigned(t_16);   
                    end
                    unit_latency = 4'd8;
                    unit_id = 3'd3;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end

            MULTIPLY_AND_ADD: 
                //$display("Multiply and Add instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        t_16 = $signed(ra[i*WORD+2*BYTE +: 2*BYTE]) * $signed(rb[i*WORD+2*BYTE +: 2*BYTE]);
                        rt_value[i*(WORD) +: WORD] = t_16 + $signed(rc[i*WORD +: WORD]);   
                    end
                    unit_latency = 4'd8;
                    unit_id = 3'd3;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            MULTIPLY_HIGH: 
                //$display("Multiply High instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        t_16 = $signed(ra[i*WORD +: HALFWORD]) * $signed(rb[i*WORD+2*BYTE +: HALFWORD]);
                        rt_value[i*(WORD) +: WORD] = {t_16,16'b0};   
                    end
                    unit_latency = 4'd8;
                    unit_id = 3'd3;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            ABSOLUTE_DIFFERENCES_OF_BYTES: 
                //$display("Absolute Differences Of Bytes instruction starts...");
                begin
                    for(int i=0;i<16;i++)
                    begin
                        if($unsigned(rb[i*BYTE +: BYTE]) > $unsigned(ra[i*BYTE +: BYTE])) 
                        begin
                            rt_value[i*BYTE +: BYTE] = rb[i*BYTE +: BYTE] - ra[i*BYTE +:BYTE];
                        end
                        else
                        begin
                            rt_value[i*BYTE +: BYTE] = ra[i*BYTE +: BYTE] - rb[i*BYTE +: BYTE];
                        end
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd4;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            AVERAGE_BYTES: 
                //$display("Average Bytes instruction starts...");
                begin
                    for(int i=0;i<16;i++)
                    begin
                        rt_value[i*BYTE +: BYTE] = {8'b0,ra[i*BYTE +: BYTE]} + {8'b0,rb[i*BYTE +: BYTE]} + 1;
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd4;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            SUM_BYTES_INTO_HALFWORDS: 
                //$display("Sum Bytes into Halfwords instruction starts...");
                begin
                    for(int i=0;i<4;i++)
                    begin
                        rt_value[i*WORD +: HALFWORD] = rb[i*WORD +: BYTE] + rb[i*WORD+BYTE +: BYTE] + rb[i*WORD+2*BYTE +: BYTE]+ rb[i*WORD+3*BYTE +: BYTE];
                        rt_value[i*WORD+HALFWORD +: HALFWORD] = ra[i*WORD +: BYTE] + ra[i*WORD+BYTE +: BYTE] + ra[i*WORD+2*BYTE +: BYTE]+ ra[i*WORD+3*BYTE +: BYTE];
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd4;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
            
            COUNT_ONES_IN_BYTES: 
                //$display("Count ones in bytes instruction starts...");
                begin
                    for(int i=0;i<16;i++)
                    begin
                        t_8 = 0;
                        t_8_1 = ra[i*BYTE +: BYTE];
                        for(int m=0;m<8;m++)
                        begin
                            if(t_8_1[m] == 1) 
                            begin
                                t_8 = t_8 + 1;
                            end
                        end
                    end
                    unit_latency = 4'd4;
                    unit_id = 3'd4;
                    wrt_en_ep = 1;
                    //fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
                end
        endcase
        // fw_ep_st_1[0:2] = unit_id;
        // fw_ep_st_1[3:130] = rt_value;
        // fw_ep_st_1[131] = wrt_en_ep;
        // fw_ep_st_1[132:138] = rt_address;
        // fw_ep_st_1[139:142] = unit_latency; 
        fw_ep_st_1 = {unit_id, rt_value, wrt_en_ep, rt_address, unit_latency};
    end
endmodule
