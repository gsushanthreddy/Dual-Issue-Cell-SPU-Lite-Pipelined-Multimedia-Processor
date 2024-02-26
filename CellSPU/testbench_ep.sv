import descriptions::*;

// this file for testing the First stage of the odd pipe

module testbench_ep();

    logic clock;
    logic reset;
    opcode op_op_code;

    logic [0:6] I7;
    logic [0:9] I10;
    logic [0:15] I16;
    logic [0:17] I18;

    logic [0:127] ra, rb, rc, rt_value;
    logic [0:6] rt_address;

    logic [0:31] pc_input;
    logic [0:31] pc_output;

    logic wrt_en_op;

    logic [0:14] ls_address;
    logic [0:127] ls_data_input;
    logic [0:127] ls_data_output;

    evenpipe dut(
        .clock(clock),
        .reset(reset),
        .ep_input_op_code(ep_input_op_code),
        .ra_input(ra_input),
        .rb_input(rb_input),
        .rc_input(rc_input),
        .rt_address_input(rt_address_input),
        .I7_input(I7_input),
        .I10_input(I10_input),
        .I16_input(I16_input),
        .I18_input(I18_input)
    );

    initial clock = 0;
    always #5 clock = ~clock;

    initial begin

        @(posedge clock)

        ep_input_op_code = ADD_WORD;
        rb_input = 128'd10;
        ra_input = 128'd20;

        @(posedge clock)

        ep_input_op_code = ADD_HALFWORD;
        ra_input = 128'd15;
        rb_input = 128'd30;

        @(posedge clock)

        ep_input_op_code = ADD_HALFWORD_IMMEDIATE;
        ra_input = 128'd15;
        I10_input = 10'd35;

        @(posedge clock)

        ep_input_op_code = ADD_WORD_IMMEDIATE;
        ra_input = 128'd15;
        I10_input = 10'd40;

        @(posedge clock)

        ep_input_op_code = SUBTRACT_FROM_WORD;
        ra_input = 128'd20;
        rb_input = 128'd55;

        @(posedge clock)

        ep_input_op_code = SUBTRACT_FROM_HALFWORD;
        ra_input = 128'd21;
        rb_input = 128'd56;

        @(posedge clock)

        ep_input_op_code = SUBTRACT_FROM_HALFWORD_IMMEDIATE;
        ra_input = 128'd21;
        I10_input = 10'd36;

        @(posedge clock)

        ep_input_op_code = SUBTRACT_FROM_WORD_IMMEDIATE;
        ra_input = 128'd25;
        I10_input = 10'd100;

        // @(posedge clock)

        // ep_input_op_code = ADD_EXTENDED;
        // ra_input = 128'd25;
        // rb_input = 128'd45;

        // @(posedge clock)

        // ep_input_op_code =  SUBTRACT_FROM_EXTENDED;
        // ra_input = 128'd25;
        // rb_input = 128'd45;

        @(posedge clock)

        ep_input_op_code =  CARRY_GENERATE;
        ra_input = 128'd25;
        rb_input = 128'd45;

        @(posedge clock)

        ep_input_op_code =  BORROW_GENERATE;
        ra_input = 128'd25;
        rb_input = 128'd45;

        @(posedge clock)

        ep_input_op_code =  AND;
        ra_input = 128'd2;
        rb_input = 128'd8;

        @(posedge clock)

        ep_input_op_code =  AND_WITH_COMPLEMENT;
        ra_input = 128'd2;
        rb_input = 128'd4;

    end




endmodule