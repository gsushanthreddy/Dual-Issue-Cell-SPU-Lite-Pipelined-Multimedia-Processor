import descriptions::*;

module decode_stage(
    input clock,
    input reset,
    input [0:31] first_inst,
    input [0:31] second_inst
);
    logic [0:3] first_inst_4;
    logic [0:6] first_inst_7;
    logic [0:7] first_inst_8;
    logic [0:8] first_inst_9;
    logic [0:10] first_inst_11;

    logic [0:3] second_inst_4;
    logic [0:6] second_inst_7;
    logic [0:7] second_inst_8;
    logic [0:8] second_inst_9;
    logic [0:10] second_inst_11;

    assign first_inst_4 = first_inst[0:3];
    assign first_inst_7 = first_inst[0:6];
    assign first_inst_8 = first_inst[0:7];
    assign first_inst_9 = first_inst[0:8];
    assign first_inst_11 = first_inst[0:10];

    assign second_inst_4 = second_inst[0:3];
    assign second_inst_7 = second_inst[0:6];
    assign second_inst_8 = second_inst[0:7];
    assign second_inst_9 = second_inst[0:8];
    assign second_inst_11 = second_inst[0:10];

    logic ep_inst1_flag;
    logic op_inst1_flag;
    logic ep_inst2_flag;
    logic op_inst2_flag;

    opcode ep_opcode_1;
    opcode ep_opcode_2;
    opcode op_opcode_1;
    opcode op_opcode_2;

    logic [0:6] ep_rt_1_address;
    logic [0:6] ep_ra_1_address;
    logic [0:6] ep_rc_1_address;
    logic [0:6] ep_rb_1_address;
    logic [0:6] ep_rt_2_address;
    logic [0:6] ep_ra_2_address;
    logic [0:6] ep_rb_2_address;
    logic [0:6] ep_rc_2_address;

    logic [0:6] op_rt_1_address;
    logic [0:6] op_ra_1_address;
    logic [0:6] op_rb_1_address;
    logic [0:6] op_rt_2_address;
    logic [0:6] op_ra_2_address;
    logic [0:6] op_rb_2_address;

    logic [0:17] ep_I18_1;
    logic [0:15] ep_I16_1;
    logic [0:9] ep_I10_1;
    logic [0:6] ep_I7_1;
    logic [0:17] ep_I18_2;
    logic [0:15] ep_I16_2;
    logic [0:9] ep_I10_2;
    logic [0:6] ep_I7_2;

    logic [0:17] op_I18_1;
    logic [0:15] op_I16_1;
    logic [0:9] op_I10_1;
    logic [0:6] op_I7_1;
    logic [0:17] op_I18_2;
    logic [0:15] op_I16_2;
    logic [0:9] op_I10_2;
    logic [0:6] op_I7_2;
    

    always_comb begin
        if(first_inst_4 == 4'b1110 || first_inst_4 == 4'b1101 || first_inst_4 == 4'b1111 || first_inst_4 == 4'b1100) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_rt_1_address = first_inst[4:10];
            ep_rb_1_address = first_inst[11:17];
            ep_ra_1_address = first_inst[18:24];
            ep_rc_1_address = first_inst[25:31];
            case(first_inst_4)
                4'b1110:
                    begin
                        ep_opcode_1 = FLOATING_MULTIPLY_AND_ADD;
                    end
                4'b1101:
                    begin
                        ep_opcode_1 = FLOATING_NEGATIVE_MULTIPLY_AND_SUBTRACT;
                    end
                4'b1111:
                    begin
                        ep_opcode_1 = FLOATING_MULTIPLY_AND_SUBTRACT;
                    end
                4'b1100:
                    begin
                        ep_opcode_1 = MULTIPLY_AND_ADD;
                    end
            endcase
        end

        if(second_inst_4 == 4'b1110 || second_inst_4 == 4'b1101 || second_inst_4 == 4'b1111 || second_inst_4 == 4'b1100) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_rt_2_address = second_inst[4:10];
            ep_rb_2_address = second_inst[11:17];
            ep_ra_2_address = second_inst[18:24];
            ep_rc_2_address = second_inst[25:31];
            case(second_inst_4)
                4'b1110:
                    begin
                        ep_opcode_2 = FLOATING_MULTIPLY_AND_ADD;
                    end
                4'b1101:
                    begin
                        ep_opcode_2 = FLOATING_NEGATIVE_MULTIPLY_AND_SUBTRACT;
                    end
                4'b1111:
                    begin
                        ep_opcode_2 = FLOATING_MULTIPLY_AND_SUBTRACT;
                    end
                4'b1100:
                    begin
                        ep_opcode_2 = MULTIPLY_AND_ADD;
                    end
            endcase
        end

        if(first_inst_7 == 7'b0100001 ) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_I18_1 = first_inst[7:24]
            ep_rt_1_address = first_inst[25:31];

            ep_opcode_1 = IMMEDIATE_LOAD_ADDRESS;
    
        end

        if(second_inst_7 == 7'b0100001 ) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_I18_2 = second_inst[7:24]
            ep_rt_2_address = second_inst[25:31];

            ep_opcode_2 = IMMEDIATE_LOAD_ADDRESS;
    
        end

        if(first_inst_8 == 8'b00011101 || first_inst_8 == 8'b00011100 || first_inst_8 == 8'b00001101 || first_inst_8 == 8'b00001100 || first_inst_8 == 8'b00010101 || first_inst_8 == 8'b00010100 || first_inst_8 == 8'b00000101 || first_inst_8 == 8'b00000100 || first_inst_8 == 8'b01000101 || first_inst_8 == 8'b01000100 || first_inst_8 == 8'b01111101 || first_inst_8 = 8'b01111100 || first_inst_8 == 8'b01001101 || first_inst_8 == 8'b01001100 || first_inst_8 == 8'b01011101 || first_inst_8 == 8'b01011100 || first_inst_8 == 8'b01110100 || first_inst_8 == 8'b01110101) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_I10_1 = first_inst[8:17];
            ep_ra_1_address = first_inst[18:24];
            ep_rt_1_address = first_inst[25:31];
            
            case(first_inst_8)
                8'b00011101:
                    begin
                        ep_opcode_1 = ADD_HALFWORD_IMMEDIATE;
                    end
                8'b00011100:
                    begin
                        ep_opcode_1 = ADD_WORD_IMMEDIATE;
                    end
                8'b00001101:
                    begin
                        ep_opcode_1 = SUBTRACT_FROM_HALFWORD_IMMEDIATE;
                    end
                8'b00001100:
                    begin
                        ep_opcode_1 = SUBTRACT_FROM_WORD_IMMEDIATE;
                    end
                8'b00010101:
                    begin
                        ep_opcode_1 = AND_HALFWORD_IMMEDIATE;
                    end
                8'b00010100:
                    begin
                        ep_opcode_1 = AND_WORD_IMMEDIATE;
                    end
                8'b00000101:
                    begin
                        ep_opcode_1 = OR_HALFWORD_IMMEDIATE;
                    end
                8'b00000100:
                    begin
                        ep_opcode_1 = OR_WORD_IMMEDIATE;
                    end
                8'b01000101:
                    begin
                        ep_opcode_1 = EXCLUSIVE_OR_HALFWORD_IMMEDIATE;
                    end
                8'b01000100:
                    begin
                        ep_opcode_1 = EXCLUSIVE_OR_WORD_IMMEDIATE;
                    end
                8'b01111101:
                    begin
                        ep_opcode_1 = COMPARE_EQUAL_HALFWORD_IMMEDIATE;
                    end
                8'b01111100:
                    begin
                        ep_opcode_1 = COMPARE_EQUAL_WORD_IMMEDIATE;
                    end
                8'b01001101:
                    begin
                        ep_opcode_1 = COMPARE_GREATER_THAN_HALFWORD_IMMEDIATE;
                    end
                8'b01001100:
                    begin
                        ep_opcode_1 = COMPARE_GREATER_THAN_WORD_IMMEDIATE;
                    end
                8'b01011101:
                    begin
                        ep_opcode_1 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD_IMMEDIATE;
                    end
                8'b01011100:
                    begin
                        ep_opcode_1 = COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE;
                    end
                8'b01110100:
                    begin
                        ep_opcode_1 = MULTIPLY_IMMEDIATE;
                    end
                8'b01110101:
                    begin
                        ep_opcode_1 = MULTIPLY_UNSIGNED_IMMEDIATE;
                    end
            endcase
        end

        if(second_inst_8 == 8'b00011101 || second_inst_8 == 8'b00011100 || second_inst_8 == 8'b00001101 || second_inst_8 == 8'b00001100 || second_inst_8 == 8'b00010101 || second_inst_8 == 8'b00010100 || second_inst_8 == 8'b00000101 || second_inst_8 == 8'b00000100 || second_inst_8 == 8'b01000101 || second_inst_8 == 8'b01000100 || second_inst_8 == 8'b01111101 || second_inst_8 = 8'b01111100 || second_inst_8 == 8'b01001101 || second_inst_8 == 8'b01001100 || second_inst_8 == 8'b01011101 || second_inst_8 == 8'b01011100 || second_inst_8 == 8'b01110100 || second_inst_8 == 8'b01110101) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_I10_2 = second_inst[8:17];
            ep_ra_2_address = second_inst[18:24];
            ep_rt_2_address = second_inst[25:31];
            
            case(second_inst_8)
                8'b00011101:
                    begin
                        ep_opcode_2 = ADD_HALFWORD_IMMEDIATE;
                    end
                8'b00011100:
                    begin
                        ep_opcode_2 = ADD_WORD_IMMEDIATE;
                    end
                8'b00001101:
                    begin
                        ep_opcode_2 = SUBTRACT_FROM_HALFWORD_IMMEDIATE;
                    end
                8'b00001100:
                    begin
                        ep_opcode_2 = SUBTRACT_FROM_WORD_IMMEDIATE;
                    end
                8'b00010101:
                    begin
                        ep_opcode_2 = AND_HALFWORD_IMMEDIATE;
                    end
                8'b00010100:
                    begin
                        ep_opcode_2 = AND_WORD_IMMEDIATE;
                    end
                8'b00000101:
                    begin
                        ep_opcode_2 = OR_HALFWORD_IMMEDIATE;
                    end
                8'b00000100:
                    begin
                        ep_opcode_2 = OR_WORD_IMMEDIATE;
                    end
                8'b01000101:
                    begin
                        ep_opcode_2 = EXCLUSIVE_OR_HALFWORD_IMMEDIATE;
                    end
                8'b01000100:
                    begin
                        ep_opcode_2 = EXCLUSIVE_OR_WORD_IMMEDIATE;
                    end
                8'b01111101:
                    begin
                        ep_opcode_2 = COMPARE_EQUAL_HALFWORD_IMMEDIATE;
                    end
                8'b01111100:
                    begin
                        ep_opcode_2 = COMPARE_EQUAL_WORD_IMMEDIATE;
                    end
                8'b01001101:
                    begin
                        ep_opcode_2 = COMPARE_GREATER_THAN_HALFWORD_IMMEDIATE;
                    end
                8'b01001100:
                    begin
                        ep_opcode_2 = COMPARE_GREATER_THAN_WORD_IMMEDIATE;
                    end
                8'b01011101:
                    begin
                        ep_opcode_2 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD_IMMEDIATE;
                    end
                8'b01011100:
                    begin
                        ep_opcode_2 = COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE;
                    end
                8'b01110100:
                    begin
                        ep_opcode_2 = MULTIPLY_IMMEDIATE;
                    end
                8'b01110101:
                    begin
                        ep_opcode_2 = MULTIPLY_UNSIGNED_IMMEDIATE;
                    end
            endcase
        end

        if(first_inst_9 == 9'b010000011 || first_inst_9 == 9'b010000010 || first_inst_9 == 9'b010000001) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_I16_1 = first_inst[9:24];
            ep_rt_1_address = first_inst[25:31];
            case(first_inst_9)
                9'b010000011:
                    begin
                        ep_opcode_1 = IMMEDIATE_LOAD_HALFWORD;
                    end
                9'b010000010:
                    begin
                        ep_opcode_1 = IMMEDIATE_LOAD_HALFWORD_UPPER;
                    end
                9'b010000001:
                    begin
                        ep_opcode_1 = IMMEDIATE_LOAD_WORD;
                    end
            endcase
        end

        if(second_inst_9 == 9'b010000011 || second_inst_9 == 9'b010000010 || second_inst_9 == 9'b010000001) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_I16_2 = second_inst[9:24];
            ep_rt_2_address = second_inst[25:31];
            case(first_inst_9)
                9'b010000011:
                    begin
                        ep_opcode_2 = IMMEDIATE_LOAD_HALFWORD;
                    end
                9'b010000010:
                    begin
                        ep_opcode_2 = IMMEDIATE_LOAD_HALFWORD_UPPER;
                    end
                9'b010000001:
                    begin
                        ep_opcode_2 = IMMEDIATE_LOAD_WORD;
                    end
            endcase
        end

        if(first_inst_11 == 11'b00011000000 || first_inst_11 == 11'b00011001000 || first_inst_11 == 11'b00001000000 || first_inst_11 == 11'b00001001000 || first_inst_11 == 11'b01101000000 || first_inst_11 == 11'b01101000001 || first_inst_11 == 11'b00011000010 || first_inst_11 == 11'b00001000010 || first_inst_11 == 11'b00011000001 || first_inst_11 == 11'b01011000001 || first_inst_11 == 11'b00001000001 || first_inst_11 = 11'b01011001001 || first_inst_11 == 11'b01001000001 || first_inst_11 == 11'b00011001001 || first_inst_11 == 11'b00001001001 || first_inst_11 == 11'b01111001000 || first_inst_11 == 11'b01111000000 || first_inst_11 == 11'b01001001000 || first_inst_11 == 11'b01001000000 || first_inst_11 == 11'b01011001000 || first_inst_11 == 11'b01011000000 || first_inst_11 == 11'b00001011111 || first_inst_11 == 11'b00001011011 || first_inst_11 == 11'b00001011100 || first_inst_11 == 11'b00001011000 || first_inst_11 == 11'b01011000110 || first_inst_11 = 11'b01111000100 || first_inst_11 == 11'b01111001100 || first_inst_11 == 11'b01111000101 || first_inst_11 == 11'b00001010011 || first_inst_11 == 11'b00011010011 || first_inst_11 == 11'b01001010011) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_rb_1_address = first_inst[11:17];
            ep_ra_1_address = first_inst[18:24];
            ep_rt_1_address = first_inst[25:31];
            
            case(first_inst_11)
                11'b00011000000:
                    begin
                        ep_opcode_1 = ADD_WORD;
                    end
                11'b00011001000:
                    begin
                        ep_opcode_1 = ADD_HALFWORD;
                    end
                11'b00001000000:
                    begin
                        ep_opcode_1 = SUBTRACT_FROM_WORD;
                    end
                11'b00001001000:
                    begin
                        ep_opcode_1 = SUBTRACT_FROM_HALFWORD;
                    end
                11'b01101000000:
                    begin
                        ep_opcode_1 = ADD_EXTENDED;
                    end
                11'b01101000001:
                    begin
                        ep_opcode_1 = SUBTRACT_FROM_EXTENDED;
                    end
                11'b00011000010:
                    begin
                        ep_opcode_1 = CARRY_GENERATE;
                    end
                11'b00001000010:
                    begin
                        ep_opcode_1 = BORROW_GENERATE;
                    end
                11'b00011000001:
                    begin
                        ep_opcode_1 = AND;
                    end
                11'b01011000001:
                    begin
                        ep_opcode_1 = AND_WITH_COMPLEMENT;
                    end
                11'b00001000001:
                    begin
                        ep_opcode_1 = OR;
                    end
                11'b01011001001:
                    begin
                        ep_opcode_1 = OR_COMPLEMENT;
                    end
                11'b01001000001:
                    begin
                        ep_opcode_1 = EXCLUSIVE_OR;
                    end
                11'b00011001001:
                    begin
                        ep_opcode_1 = NAND;
                    end
                11'b00001001001:
                    begin
                        ep_opcode_1 = NOR;
                    end
                11'b01111001000:
                    begin
                        ep_opcode_1 = COMPARE_EQUAL_HALFWORD;
                    end
                11'b01111000000:
                    begin
                        ep_opcode_1 = COMPARE_EQUAL_WORD;
                    end
                11'b01001001000:
                    begin
                        ep_opcode_1 = COMPARE_GREATER_THAN_HALFWORD;
                    end
                11'b01001000000:
                    begin
                        ep_opcode_1 = COMPARE_GREATER_THAN_WORD;
                    end
                11'b01011001000:
                    begin
                        ep_opcode_1 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD;
                    end
                11'b01011000000:
                    begin
                        ep_opcode_1 = COMPARE_LOGICAL_GREATER_THAN_WORD;
                    end
                11'b00001011111:
                    begin
                        ep_opcode_1 = SHIFT_LEFT_HALFWORD;
                    end
                11'b00001011011:
                    begin
                        ep_opcode_1 = SHIFT_LEFT_WORD;
                    end
                11'b00001011100:
                    begin
                        ep_opcode_1 = ROTATE_HALFWORD;
                    end
                11'b00001011000:
                    begin
                        ep_opcode_1 = ROTATE_WORD;
                    end
                11'b01011000110:
                    begin
                        ep_opcode_1 = FLOATING_MULTIPLY;
                    end
                11'b01111000100:
                    begin
                        ep_opcode_1 = MULTIPLY;
                    end
                111'b01111001100:
                    begin
                        ep_opcode_1 = MULTIPLY_UNSIGNED;
                    end
                11'b01111000101:
                    begin
                        ep_opcode_1 = MULTIPLY_HIGH;
                    end
                11'b00001010011:
                    begin
                        ep_opcode_1 = ABSOLUTE_DIFFERENCES_OF_BYTES;
                    end
                11'b00011010011:
                    begin
                        ep_opcode_1 = AVERAGE_BYTES;
                    end
                11'b01001010011:
                    begin
                        ep_opcode_1 = SUM_BYTES_INTO_HALFWORDS;
                    end
            endcase
        end

        if(second_inst_11 == 11'b00011000000 || second_inst_11 == 11'b00011001000 || second_inst_11 == 11'b00001000000 || second_inst_11 == 11'b00001001000 || second_inst_11 == 11'b01101000000 || second_inst_11 == 11'b01101000001 || second_inst_11 == 11'b00011000010 || second_inst_11 == 11'b00001000010 || second_inst_11 == 11'b00011000001 || second_inst_11 == 11'b01011000001 || second_inst_11 == 11'b00001000001 || second_inst_11 = 11'b01011001001 || second_inst_11 == 11'b01001000001 || second_inst_11 == 11'b00011001001 || second_inst_11 == 11'b00001001001 || second_inst_11 == 11'b01111001000 || second_inst_11 == 11'b01111000000 || second_inst_11 == 11'b01001001000 || second_inst_11 == 11'b01001000000 || second_inst_11 == 11'b01011001000 || second_inst_11 == 11'b01011000000 || second_inst_11 == 11'b00001011111 || second_inst_11 == 11'b00001011011 || second_inst_11 == 11'b00001011100 || second_inst_11 == 11'b00001011000 || second_inst_11 == 11'b01011000110 || second_inst_11 = 11'b01111000100 || second_inst_11 == 11'b01111001100 || second_inst_11 == 11'b01111000101 || second_inst_11 == 11'b00001010011 || second_inst_11 == 11'b00011010011 || second_inst_11 == 11'b01001010011) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_rb_2_address = second_inst[11:17];
            ep_ra_2_address = second_inst[18:24];
            ep_rt_2_address = second_inst[25:31];
            
            case(second_inst_11)
                11'b00011000000:
                    begin
                        ep_opcode_2 = ADD_WORD;
                    end
                11'b00011001000:
                    begin
                        ep_opcode_2 = ADD_HALFWORD;
                    end
                11'b00001000000:
                    begin
                        ep_opcode_2 = SUBTRACT_FROM_WORD;
                    end
                11'b00001001000:
                    begin
                        ep_opcode_2 = SUBTRACT_FROM_HALFWORD;
                    end
                11'b01101000000:
                    begin
                        ep_opcode_2 = ADD_EXTENDED;
                    end
                11'b01101000001:
                    begin
                        ep_opcode_2 = SUBTRACT_FROM_EXTENDED;
                    end
                11'b00011000010:
                    begin
                        ep_opcode_2 = CARRY_GENERATE;
                    end
                11'b00001000010:
                    begin
                        ep_opcode_2 = BORROW_GENERATE;
                    end
                11'b00011000001:
                    begin
                        ep_opcode_2 = AND;
                    end
                11'b01011000001:
                    begin
                        ep_opcode_2 = AND_WITH_COMPLEMENT;
                    end
                11'b00001000001:
                    begin
                        ep_opcode_2 = OR;
                    end
                11'b01011001001:
                    begin
                        ep_opcode_2 = OR_COMPLEMENT;
                    end
                11'b01001000001:
                    begin
                        ep_opcode_2 = EXCLUSIVE_OR;
                    end
                11'b00011001001:
                    begin
                        ep_opcode_2 = NAND;
                    end
                11'b00001001001:
                    begin
                        ep_opcode_2 = NOR;
                    end
                11'b01111001000:
                    begin
                        ep_opcode_2 = COMPARE_EQUAL_HALFWORD;
                    end
                11'b01111000000:
                    begin
                        ep_opcode_2 = COMPARE_EQUAL_WORD;
                    end
                11'b01001001000:
                    begin
                        ep_opcode_2 = COMPARE_GREATER_THAN_HALFWORD;
                    end
                11'b01001000000:
                    begin
                        ep_opcode_2 = COMPARE_GREATER_THAN_WORD;
                    end
                11'b01011001000:
                    begin
                        ep_opcode_2 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD;
                    end
                11'b01011000000:
                    begin
                        ep_opcode_2 = COMPARE_LOGICAL_GREATER_THAN_WORD;
                    end
                11'b00001011111:
                    begin
                        ep_opcode_2 = SHIFT_LEFT_HALFWORD;
                    end
                11'b00001011011:
                    begin
                        ep_opcode_2 = SHIFT_LEFT_WORD;
                    end
                11'b00001011100:
                    begin
                        ep_opcode_2 = ROTATE_HALFWORD;
                    end
                11'b00001011000:
                    begin
                        ep_opcode_2 = ROTATE_WORD;
                    end
                11'b01011000110:
                    begin
                        ep_opcode_2 = FLOATING_MULTIPLY;
                    end
                11'b01111000100:
                    begin
                        ep_opcode_2 = MULTIPLY;
                    end
                111'b01111001100:
                    begin
                        ep_opcode_2 = MULTIPLY_UNSIGNED;
                    end
                11'b01111000101:
                    begin
                        ep_opcode_2 = MULTIPLY_HIGH;
                    end
                11'b00001010011:
                    begin
                        ep_opcode_2 = ABSOLUTE_DIFFERENCES_OF_BYTES;
                    end
                11'b00011010011:
                    begin
                        ep_opcode_2 = AVERAGE_BYTES;
                    end
                11'b01001010011:
                    begin
                        ep_opcode_2 = SUM_BYTES_INTO_HALFWORDS;
                    end
            endcase
        end

        if(first_inst_11 == 11'b01010100101 || first_inst_11 == 11'b00110110101 || first_inst_11 == 11'b00110110100 || first_inst_11 == 11'b01010110100) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_ra_1_address = first_inst[18:24];
            ep_rt_1_address = first_inst[25:31];
            case(first_inst_11)
                11'b01010100101:
                    begin
                        ep_opcode_1 = COUNT_LEADING_ZEROS;
                    end
                11'b00110110101:
                    begin
                        ep_opcode_1 = FORM_SELECT_MASK_FOR_HALFWORDS;
                    end
                11'b00110110100:
                    begin
                        ep_opcode_1 = FORM_SELECT_MASK_FOR_WORDS;
                    end
                11'b01010110100:
                    begin
                        ep_opcode_1 = COUNT_ONES_IN_BYTES;
                    end
            endcase
        end

        if(second_inst_11 == 11'b01010100101 || second_inst_11 == 11'b00110110101 || second_inst_11 == 11'b00110110100 || second_inst_11 == 11'b01010110100) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_ra_2_address = second_inst[18:24];
            ep_rt_2_address = second_inst[25:31];
            case(second_inst_11)
                11'b01010100101:
                    begin
                        ep_opcode_2 = COUNT_LEADING_ZEROS;
                    end
                11'b00110110101:
                    begin
                        ep_opcode_2 = FORM_SELECT_MASK_FOR_HALFWORDS;
                    end
                11'b00110110100:
                    begin
                        ep_opcode_2 = FORM_SELECT_MASK_FOR_WORDS;
                    end
                11'b01010110100:
                    begin
                        ep_opcode_2 = COUNT_ONES_IN_BYTES;
                    end
            endcase
        end

        if(first_inst_11 == 11'b00001111111 || first_inst_11 == 11'b00001111011 || first_inst_11 == 11'b00001111100 || first_inst_11 == 11'b00001111000) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_I7_1 = first_inst[11:17];
            ep_ra_1_address = first_inst[18:24];
            ep_rt_1_address = first_inst[25:31];
            case(first_inst_11)
                11'b00001111111:
                    begin
                        ep_opcode_1 = SHIFT_LEFT_HALFWORD_IMMEDIATE;
                    end
                11'b00001111011:
                    begin
                        ep_opcode_1 = SHIFT_LEFT_WORD_IMMEDIATE;
                    end
                11'b00001111100:
                    begin
                        ep_opcode_1 = ROTATE_HALFWORD_IMMEDIATE;
                    end
                11'b00001111000:
                    begin
                        ep_opcode_1 = ROTATE_WORD_IMMEDIATE;
                    end
            endcase
        end

        if(second_inst_11 == 11'b00001111111 || second_inst_11 == 11'b00001111011 || second_inst_11 == 11'b00001111100 || second_inst_11 == 11'b00001111000) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_I7_2 = second_inst[11:17];
            ep_ra_2_address = second_inst[18:24];
            ep_rt_2_address = second_inst[25:31];
            case(second_inst_11)
                11'b00001111111:
                    begin
                        ep_opcode_2 = SHIFT_LEFT_HALFWORD_IMMEDIATE;
                    end
                11'b00001111011:
                    begin
                        ep_opcode_2 = SHIFT_LEFT_WORD_IMMEDIATE;
                    end
                11'b00001111100:
                    begin
                        ep_opcode_2 = ROTATE_HALFWORD_IMMEDIATE;
                    end
                11'b00001111000:
                    begin
                        ep_opcode_2 = ROTATE_WORD_IMMEDIATE;
                    end
            endcase
        end

        // odd pipe

        if(first_inst_8 == 8'b00110100 || first_inst_8 == 8'b00100100) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I10_1 = first_inst[8:17];
            op_ra_1_address = first_inst[18:24];
            op_rt_1_address = first_inst[25:31];
            case(first_inst_8)
                8'b00110100:
                    begin
                        op_opcode_1 = LOAD_QUADFORM_DFORM;
                    end
                8'b00100100:
                    begin
                        op_opcode_1 = STORE_QUADFORM_DFORM;
                    end
            endcase
        end

        if(second_inst_8 == 8'b00110100 || second_inst_8 == 8'b00100100) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I10_2 = second_inst[8:17];
            op_ra_2_address = second_inst[18:24];
            op_rt_2_address = second_inst[25:31];
            case(second_inst_8)
                8'b00110100:
                    begin
                        op_opcode_2 = LOAD_QUADFORM_DFORM;
                    end
                8'b00100100:
                    begin
                        op_opcode_2 = STORE_QUADFORM_DFORM;
                    end
            endcase
        end


        if(first_inst_9 == 9'b001100001 || first_inst_9 == 9'b001000001 || first_inst_9 == 9'b001100110 || first_inst_9 == 9'b001100010 || first_inst_9 == 9'b001000010 || first_inst_9 == 9'b001000000 || first_inst_9 == 9'b001000110 || first_inst_9 == 9'b001000100) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I16_1 = first_inst[9:24];
            op_rt_1_address = first_inst[25:31];
            case(first_inst_9)
                9'b001100001:
                    begin
                        op_opcode_1 = LOAD_QUADWORD_AFORM;
                    end
                9'b001000001:
                    begin
                        op_opcode_1 = STORE_QUADFORM_AFORM;
                    end
                9'b001100110:
                    begin
                        op_opcode_1 = BRANCH_RELATIVE_AND_SET_LINK;
                    end
                9'b001100010:
                    begin
                        op_opcode_1 = BRANCH_ABSOLUTE_AND_SET_LINK;
                    end
                9'b001000010:
                    begin
                        op_opcode_1 = BRANCH_IF_NOT_ZERO_WORD;
                    end
                9'b001000000:
                    begin
                        op_opcode_1 = BRANCH_IF_ZERO_WORD;
                    end
                9'b001000110:
                    begin
                        op_opcode_1 = BRANCH_IF_NOT_ZERO_HALFWORD;
                    end
                9'b001000100:
                    begin
                        op_opcode_1 = BRANCH_IF_ZERO_HALFWORD;
                    end
            endcase
        end

        if(second_inst_9 == 9'b001100001 || second_inst_9 == 9'b001000001 || second_inst_9 == 9'b001100110 || second_inst_9 == 9'b001100010 || second_inst_9 == 9'b001000010 || second_inst_9 == 9'b001000000 || second_inst_9 == 9'b001000110 || second_inst_9 == 9'b001000100) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I16_2 = second_inst[9:24];
            op_rt_2_address = second_inst[25:31];
            case(second_inst_9)
                9'b001100001:
                    begin
                        op_opcode_2 = LOAD_QUADWORD_AFORM;
                    end
                9'b001000001:
                    begin
                        op_opcode_2 = STORE_QUADFORM_AFORM;
                    end
                9'b001100110:
                    begin
                        op_opcode_2 = BRANCH_RELATIVE_AND_SET_LINK;
                    end
                9'b001100010:
                    begin
                        op_opcode_2 = BRANCH_ABSOLUTE_AND_SET_LINK;
                    end
                9'b001000010:
                    begin
                        op_opcode_2 = BRANCH_IF_NOT_ZERO_WORD;
                    end
                9'b001000000:
                    begin
                        op_opcode_2 = BRANCH_IF_ZERO_WORD;
                    end
                9'b001000110:
                    begin
                        op_opcode_2 = BRANCH_IF_NOT_ZERO_HALFWORD;
                    end
                9'b001000100:
                    begin
                        op_opcode_2 = BRANCH_IF_ZERO_HALFWORD;
                    end
            endcase
        end


        if(first_inst_9 == 9'b001100100 || first_inst_9 == 9'b001100000) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I16_1 = first_inst[9:24];
            case(first_inst_9)
                9'b001100100:
                    begin
                        op_opcode_1 = BRANCH_RELATIVE;
                    end
                9'b001100000:
                    begin
                        op_opcode_1 = BRANCH_ABSOLUTE;
                    end
            endcase
        end

        if(second_inst_9 == 9'b001100100 || second_inst_9 == 9'b001100000) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I16_2 = second_inst[9:24];
            case(second_inst_9)
                9'b001100100:
                    begin
                        op_opcode_2 = BRANCH_RELATIVE;
                    end
                9'b001100000:
                    begin
                        op_opcode_2 = BRANCH_ABSOLUTE;
                    end
            endcase
        end


        if(first_inst_11 == 11'b00111011011 || first_inst_11 == 11'b00111011111 || first_inst_11 == 11'b00111001111 || first_inst_11 == 11'b00111011100 || first_inst_11 == 11'b00111001100 || first_inst_11 == 11'b00111011000) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I16_1 = first_inst[9:24];
            op_rt_1_address = first_inst[25:31];
            case(first_inst_11)
                11'b00111011011:
                    begin
                        op_opcode_1 = SHIFT_LEFT_QUADWORD_BY_BITS;
                    end
                11'b00111011111:
                    begin
                        op_opcode_1 = SHIFT_LEFT_QUADWORD_BY_BYTES;
                    end
                11'b00111001111:
                    begin
                        op_opcode_1 = SHIFT_LEFT_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
                    end
                11'b00111011100:
                    begin
                        op_opcode_1 = ROTATE_QUADWORD_BY_BYTES;
                    end
                11'b00111001100:
                    begin
                        op_opcode_1 = ROTATE_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
                    end
                11'b00111011000:
                    begin
                        op_opcode_1 = ROTATE_QUADWORD_BY_BITS;
                    end
            endcase
        end

        if(second_inst_11 == 11'b00111011011 || second_inst_11 == 11'b00111011111 || second_inst_11 == 11'b00111001111 || second_inst_11 == 11'b00111011100 || second_inst_11 == 11'b00111001100 || second_inst_11 == 11'b00111011000) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I16_2 = second_inst[9:24];
            op_rt_2_address = second_inst[25:31];
            case(second_inst_11)
                11'b00111011011:
                    begin
                        op_opcode_2 = SHIFT_LEFT_QUADWORD_BY_BITS;
                    end
                11'b00111011111:
                    begin
                        op_opcode_2 = SHIFT_LEFT_QUADWORD_BY_BYTES;
                    end
                11'b00111001111:
                    begin
                        op_opcode_2 = SHIFT_LEFT_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
                    end
                11'b00111011100:
                    begin
                        op_opcode_2 = ROTATE_QUADWORD_BY_BYTES;
                    end
                11'b00111001100:
                    begin
                        op_opcode_2 = ROTATE_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
                    end
                11'b00111011000:
                    begin
                        op_opcode_2 = ROTATE_QUADWORD_BY_BITS;
                    end
            endcase
        end

        if(first_inst_11 == 11'b00111111011 || first_inst_11 == 11'b00111111111 || first_inst_11 == 11'b00111111100 || first_inst_11 == 11'b00111111000) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I7_1 = first_inst[11:17];
            op_ra_1_address = first_inst[18:24];
            op_rt_1_address = first_inst[25:31];
            case(first_inst_11)
                11'b00111111011:
                    begin
                        op_opcode_1 = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE;
                    end
                11'b00111111111:
                    begin
                        op_opcode_1 = SHIFT_LEFT_QUADWORD_BY_BYTE_IMMEDIATE;
                    end
                11'b00111111100:
                    begin
                        op_opcode_1 = ROTATE_QUADWORD_BY_BYTES_IMMEDIATE;
                    end
                11'b00111111000:
                    begin
                        op_opcode_1 = ROTATE_QUADWORD_BY_BITS_IMMEDIATE;
                    end
            endcase
        end

        if(second_inst_11 == 11'b00111111011 || second_inst_11 == 11'b00111111111 || second_inst_11 == 11'b00111111100 || second_inst_11 == 11'b00111111000) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I7_2 = second_inst[11:17];
            op_ra_2_address = second_inst[18:24];
            op_rt_2_address = second_inst[25:31];
            case(second_inst_11)
                11'b00111111011:
                    begin
                        op_opcode_2 = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE;
                    end
                11'b00111111111:
                    begin
                        op_opcode_2 = SHIFT_LEFT_QUADWORD_BY_BYTE_IMMEDIATE;
                    end
                11'b00111111100:
                    begin
                        op_opcode_2 = ROTATE_QUADWORD_BY_BYTES_IMMEDIATE;
                    end
                11'b00111111000:
                    begin
                        op_opcode_2 = ROTATE_QUADWORD_BY_BITS_IMMEDIATE;
                    end
            endcase
        end

        if(first_inst_11 == 11'b00110110010 || first_inst_11 == 11'b00110110001 || first_inst_11 == 11'b00110110000) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_ra_1_address = first_inst[18:24];
            op_rt_1_address = first_inst[25:31];
            case(first_inst_11)
                11'b00110110010:
                    begin
                        op_opcode_1 = GATHER_BITS_FROM_BYTES;
                    end
                11'b00110110001:
                    begin
                        op_opcode_1 = GATHER_BITS_FROM_HALFWORDS;
                    end
                11'b00110110000:
                    begin
                        op_opcode_1 = GATHER_BITS_FROM_WORDS;
                    end
            endcase
        end

        if(second_inst_11 == 11'b00110110010 || second_inst_11 == 11'b00110110001 || second_inst_11 == 11'b00110110000) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_ra_2_address = second_inst[18:24];
            op_rt_2_address = second_inst[25:31];
            case(second_inst_11)
                11'b00110110010:
                    begin
                        op_opcode_2 = GATHER_BITS_FROM_BYTES;
                    end
                11'b00110110001:
                    begin
                        op_opcode_2 = GATHER_BITS_FROM_HALFWORDS;
                    end
                11'b00110110000:
                    begin
                        op_opcode_2 = GATHER_BITS_FROM_WORDS;
                    end
            endcase
        end

    end

endmodule