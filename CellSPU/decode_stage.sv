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
    end

endmodule