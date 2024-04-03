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

    logic [0:6] ep_rt_1_address;
    logic [0:6] ep_ra_1_address;
    logic [0:6] ep_rc_1_address;
    logic [0:6] ep_rb_1_address;
    logic [0:6] ep_rt_2_address;
    logic [0:6] ep_ra_2_address;
    logic [0:6] ep_rb_2_address;
    logic [0:6] ep_rc_2_address;

    logic [0:17] ep_I18_1;
    logic [0:15] ep_I16_1;
    logic [0:9] ep_I10_1;
    logic [0:6] ep_I7_1;
    logic [0:17] ep_I18_2;
    logic [0:15] ep_I16_2;
    logic [0:9] ep_I10_2;
    logic [0:6] ep_I7_2;
    

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
    end

endmodule