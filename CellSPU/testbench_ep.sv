import descriptions::*;

// this file for testing the First stage of the even pipe

module testbench_ep();

    logic clock;
    logic reset;
    opcode ep_op_code;

    logic [0:6] I7;
    logic [0:9] I10;
    logic [0:15] I16;
    logic [0:17] I18;

    logic [0:127] ra, rb, rc, rt_value;
    logic [0:6] rt_address;

    logic wrt_en_ep;

    logic [0:142] FW_ep_st_1;
    logic [0:142] FW_ep_st_2;
    logic [0:142] FW_ep_st_3;
    logic [0:142] FW_ep_st_4;
    logic [0:142] FW_ep_st_5;
    logic [0:142] FW_ep_st_6;
    logic [0:142] FW_ep_st_7;
    logic [0:142] ep_output;

    evenpipe dut(
        .clock(clock),
        .reset(reset),
        .ep_input_op_code(ep_op_code),
        .ra_input(ra),
        .rb_input(rb),
        .rc_input(rc),
        .rt_address_input(rt_address),
        .I7_input(I7),
        .I10_input(I10),
        .I16_input(I16),
        .I18_input(I18),
        .fw_ep_st_1(FW_ep_st_1),
        .fw_ep_st_2(FW_ep_st_2),
        .fw_ep_st_3(FW_ep_st_3),
        .fw_ep_st_4(FW_ep_st_4),
        .fw_ep_st_5(FW_ep_st_5),
        .fw_ep_st_6(FW_ep_st_6),
        .fw_ep_st_7(FW_ep_st_7),
        .out_ep(ep_output)
    );

    initial clock = 0;
    always #5 clock = ~clock;

    initial begin

        @(posedge clock)

        ep_op_code = ADD_WORD;
        rb = 128'd10;
        ra = 128'd20;

        @(posedge clock)

        ep_op_code = ADD_HALFWORD;
        ra = 128'd15;
        rb = 128'd30;

        @(posedge clock)

        ep_op_code = ADD_HALFWORD_IMMEDIATE;
        ra = 128'd15;
        I10 = 10'd35;

        @(posedge clock)

        ep_op_code = ADD_WORD_IMMEDIATE;
        ra = 128'd15;
        I10 = 10'd40;

        @(posedge clock)

        ep_op_code = SUBTRACT_FROM_WORD;
        ra = 128'd20;
        rb = 128'd55;

        @(posedge clock)

        ep_op_code = SUBTRACT_FROM_HALFWORD;
        ra = 128'd21;
        rb = 128'd56;

        @(posedge clock)

        ep_op_code = SUBTRACT_FROM_HALFWORD_IMMEDIATE;
        ra = 128'd21;
        I10 = 10'd36;

        @(posedge clock)

        ep_op_code = SUBTRACT_FROM_WORD_IMMEDIATE;
        ra = 128'd25;
        I10 = 10'd100;

        // @(posedge clock)

        // ep_op_code = ADD_EXTENDED;
        // ra = 128'd25;
        // rb = 128'd45;

        // @(posedge clock)

        // ep_op_code =  SUBTRACT_FROM_EXTENDED;
        // ra = 128'd25;
        // rb = 128'd45;

        @(posedge clock)

        ep_op_code =  CARRY_GENERATE;
        ra = 128'd25;
        rb = 128'd45;

        @(posedge clock)

        ep_op_code =  BORROW_GENERATE;
        ra = 128'd25;
        rb = 128'd45;

        @(posedge clock)

        ep_op_code =  AND;
        ra = 128'd2;
        rb = 128'd8;

        @(posedge clock)

        ep_op_code =  AND_WITH_COMPLEMENT;
        ra = 128'd2;
        rb = 128'd4;

        @(posedge clock)

        ep_op_code =  AND_HALFWORD_IMMEDIATE;
        ra = 128'd2;
        I10 = 10'd16;

        @(posedge clock)

        ep_op_code =  AND_WORD_IMMEDIATE;
        ra = 128'd2;
        I10 = 10'd32;

        @(posedge clock)

        ep_op_code =  OR;
        ra = 128'd2;
        rb = 128'd4;

        @(posedge clock)

        ep_op_code =  OR_COMPLEMENT;
        ra = 128'd2;
        rb = 128'd32;

        @(posedge clock)

        ep_op_code =  OR_HALFWORD_IMMEDIATE;
        ra = 128'd4;
        I10 = 10'd32;

        @(posedge clock)

        ep_op_code =  OR_WORD_IMMEDIATE;
        ra = 128'd4;
        I10 = 10'd64;

        @(posedge clock)

        ep_op_code =  EXCLUSIVE_OR;
        ra = 128'd4;
        rb = 128'd4;

        @(posedge clock)

        ep_op_code =  EXCLUSIVE_OR_HALFWORD_IMMEDIATE;
        ra = 128'd4;
        I10 = 10'd8;

        @(posedge clock)

        ep_op_code =  EXCLUSIVE_OR_WORD_IMMEDIATE;
        ra = 128'd8;
        I10 = 10'd16;

        @(posedge clock)

        ep_op_code =  NAND;
        ra = 128'd4;
        rb = 128'd16;

        @(posedge clock)

        ep_op_code =  NOR;
        ra = 128'd123;
        rb = 128'd234;

        @(posedge clock)

        ep_op_code =  COUNT_LEADING_ZEROS;
        ra = 128'd1025;
        
        @(posedge clock)

        ep_op_code =  FORM_SELECT_MASK_FOR_HALFWORDS;
        ra = 128'd578;

        @(posedge clock)

        ep_op_code =  FORM_SELECT_MASK_FOR_WORDS;
        ra = 128'd234;

        @(posedge clock)

        ep_op_code =  COMPARE_EQUAL_HALFWORD;
        ra = 128'd234;
        rb = 128'd234;

        @(posedge clock)

        ep_op_code =  COMPARE_EQUAL_HALFWORD_IMMEDIATE;
        ra = 128'd234;
        I10 = 10'd3128;

        @(posedge clock)

        ep_op_code =  COMPARE_EQUAL_HALFWORD_IMMEDIATE;
        ra = 128'd234;
        I10 = 10'd3128;

        @(posedge clock)

        ep_op_code =  COMPARE_EQUAL_WORD;
        ra = 128'd234;
        rb = 128'd235;

        @(posedge clock)

        ep_op_code =  COMPARE_EQUAL_WORD_IMMEDIATE;
        ra = 128'd234;
        I10 = 10'd84;

        @(posedge clock)

        ep_op_code =  COMPARE_GREATER_THAN_HALFWORD;
        ra = 128'd234;
        rb = 128'd739;

        @(posedge clock)

        ep_op_code =  COMPARE_GREATER_THAN_HALFWORD_IMMEDIATE;
        ra = 128'd234;
        I10 = 10'd127;

        @(posedge clock)

        ep_op_code =  COMPARE_GREATER_THAN_WORD;
        ra = 128'd234;
        rb = 128'd2347;

        @(posedge clock)

        ep_op_code =  COMPARE_GREATER_THAN_WORD_IMMEDIATE;
        ra = 128'd234;
        I10 = 10'd327;

        @(posedge clock)

        ep_op_code =  COMPARE_LOGICAL_GREATER_THAN_HALFWORD;
        ra = 128'd234;
        rb = 128'd23;

        @(posedge clock)

        ep_op_code =  COMPARE_LOGICAL_GREATER_THAN_HALFWORD_IMMEDIATE;
        ra = 128'd234;
        I10 = 10'd123;

        @(posedge clock)

        ep_op_code =  COMPARE_LOGICAL_GREATER_THAN_WORD;
        ra = 128'd234;
        rb = 128'd789;

        @(posedge clock)

        ep_op_code =  COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE;
        ra = 128'd234;
        I10 = 10'd1233;

        @(posedge clock)

        ep_op_code =  IMMEDIATE_LOAD_HALFWORD;
        I16 = 16'd3234;

        @(posedge clock)

        ep_op_code =  IMMEDIATE_LOAD_HALFWORD_UPPER;
        I16 = 16'd324;

        @(posedge clock)

        ep_op_code =  IMMEDIATE_LOAD_WORD;
        I16 = 16'd374;

        @(posedge clock)

        ep_op_code =  IMMEDIATE_LOAD_ADDRESS;
        I18 = 18'd2348;

        @(posedge clock)

        ep_op_code =  SHIFT_LEFT_HALFWORD;
        ra = 128'd24;
        rb = 128'd123;

        @(posedge clock)

        ep_op_code =  SHIFT_LEFT_HALFWORD_IMMEDIATE;
        ra = 128'd234;
        I7 = 7'd327;

        @(posedge clock)

        ep_op_code =  SHIFT_LEFT_WORD;
        ra = 128'd213;
        rb = 128'd2;

        @(posedge clock)

        ep_op_code =  SHIFT_LEFT_WORD_IMMEDIATE;
        ra = 128'd345;
        I7 = 7'd2;

        @(posedge clock)

        ep_op_code =  ROTATE_HALFWORD;
        ra = 128'd213;
        rb = 128'd4;

        @(posedge clock)

        ep_op_code =  ROTATE_HALFWORD_IMMEDIATE;
        ra = 128'd64;
        I7 = 7'd4;

        @(posedge clock)

        ep_op_code =  ROTATE_WORD;
        ra = 128'd64;
        rb = 128'd8;

        @(posedge clock)

        ep_op_code =  ROTATE_WORD_IMMEDIATE;
        ra = 128'd64;
        I7 = 7'd8;

        @(posedge clock)

        ep_op_code =  FLOATING_MULTIPLY;
        ra = 128'd123;
        rb = 128'd987;

        @(posedge clock)

        ep_op_code =  FLOATING_MULTIPLY_AND_ADD;
        ra = 128'd456;
        rb = 128'd654;
        rc = 128'd21;

        @(posedge clock)

        ep_op_code =  FLOATING_NEGATIVE_MULTIPLY_AND_SUBTRACT;
        ra = 128'd456;
        rb = 128'd654;
        rc = 128'd123771;
        
        @(posedge clock)

        ep_op_code =  FLOATING_MULTIPLY_AND_SUBTRACT;
        ra = 128'd129;
        rb = 128'd481;
        rc = 128'd34820;

        @(posedge clock)

        ep_op_code = MULTIPLY;
        rb = 128'd128;
        ra = 128'd64;

        @(posedge clock)

        ep_op_code = MULTIPLY_UNSIGNED;
        rb = 128'd216;
        ra = 128'd512;

        @(posedge clock)

        ep_op_code = MULTIPLY_IMMEDIATE;
        ra = 128'd216;
        I10 = 10'd2;

        @(posedge clock)

        ep_op_code = MULTIPLY_UNSIGNED_IMMEDIATE;
        ra = 128'd216;
        I10 = 10'd4;

        @(posedge clock)

        ep_op_code = MULTIPLY_AND_ADD;
        ra = 128'd216;
        rb = 128'd8;
        rc = 128'd2138;

        @(posedge clock)

        ep_op_code = MULTIPLY_HIGH;
        ra = 128'd216;
        rb = 128'd8;

        @(posedge clock)

        ep_op_code = ABSOLUTE_DIFFERENCES_OF_BYTES;
        ra = 128'd216;
        rb = 128'd1024;

        @(posedge clock)

        ep_op_code = AVERAGE_BYTES;
        ra = 128'd216;
        rb = 128'd216;

        @(posedge clock)

        ep_op_code = SUM_BYTES_INTO_HALFWORDS;
        ra = 128'd216;
        rb = 128'd4;

        @(posedge clock)

        ep_op_code = COUNT_ONES_IN_BYTES;
        ra = 128'd216;
    end




endmodule
