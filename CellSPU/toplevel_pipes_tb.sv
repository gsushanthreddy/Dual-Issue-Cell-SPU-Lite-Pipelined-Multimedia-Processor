import descriptions::*;
`timescale  1ns/1ns
module toplevel_pipes_tb();
    logic           clock;
    logic           reset, branch_taken;
    opcode          ep_op_code, op_op_code;
    logic [0 : 6]   ra_ep_address, ra_op_address, rb_ep_address, rb_op_address, rc_ep_address, rt_ep_address, rt_op_address;
    logic [0 : 6]   I7_ep, I7_op;
    logic [0 : 9]   I10_ep, I10_op;
    logic [0 : 15]  I16_ep, I16_op;
    logic [0 : 17]  I18_ep, I18_op;
    logic [0 : 142] fw_ep_st_1, fw_op_st_1, fw_ep_st_2, fw_op_st_2, fw_ep_st_3, fw_op_st_3, fw_ep_st_4, fw_op_st_4, fw_ep_st_5, fw_op_st_5, fw_ep_st_6, fw_op_st_6, fw_ep_st_7, fw_op_st_7;
    logic [0 : 31]  PC_input, PC_output;
    logic [0:127]   reg_file[128];
    logic [0:7]     ls [0:32767];

    toplevel_part1 dut(
        .clock(clock),
        .reset(reset),
        .ra_ep_address(ra_ep_address),
        .rb_ep_address(rb_ep_address), 
        .rc_ep_address(rc_ep_address),
        .rt_ep_address(rt_ep_address),
        .I7_ep(I7_ep),
        .I10_ep(I10_ep),
        .I16_ep(I16_ep),
        .I18_ep(I18_ep),
        .ep_opcode(ep_op_code),
        .ra_op_address(ra_op_address), 
        .rb_op_address(rb_op_address), 
        .rt_op_address(rt_op_address),
        .I7_op(I7_op),
        .I10_op(I10_op),
        .I16_op(I16_op),
        .I18_op(I18_op),
        .op_opcode(op_op_code),
        .fw_ep_st_1(fw_ep_st_1),
        .fw_ep_st_2(fw_ep_st_2),
        .fw_ep_st_3(fw_ep_st_3),
        .fw_ep_st_4(fw_ep_st_4),
        .fw_ep_st_5(fw_ep_st_5),
        .fw_ep_st_6(fw_ep_st_6),
        .fw_ep_st_7(fw_ep_st_7),
        .fw_op_st_1(fw_op_st_1),
        .fw_op_st_2(fw_op_st_2),
        .fw_op_st_3(fw_op_st_3),
        .fw_op_st_4(fw_op_st_4),
        .fw_op_st_5(fw_op_st_5),
        .fw_op_st_6(fw_op_st_6),
        .fw_op_st_7(fw_op_st_7),
        .branch_taken(branch_taken),
        .PC_input(PC_input),
        .PC_output(PC_output),
        .reg_file(reg_file),
        .ls(ls)
    );

    initial clock = 1;
    always #5 clock = ~clock;
    initial reset = 0;


    initial begin 
        @(posedge clock)
        //il rt,symbol
        reset=1;
        ep_op_code = NO_OPERATION_EXECUTE; // loading 1 into register 1
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        reset=0;
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 1 into register 1
        I16_ep = 16'd2;
        rt_ep_address = 7'd1;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 4 into register 2
        I16_ep = 16'd4;
        rt_ep_address = 7'd2;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 6 into register 3
        I16_ep = 16'd6;
        rt_ep_address = 7'd3;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 1 into register 4
        I16_ep = 16'd1;
        rt_ep_address = 7'd4;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 8 into register 5
        I16_ep = 16'd8;
        rt_ep_address = 7'd5;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 10 into register 6
        I16_ep = 16'd10;
        rt_ep_address = 7'd6;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 1 into register 7
        I16_ep = 16'd1;
        rt_ep_address = 7'd7;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 5 into register 8
        I16_ep = 16'd5;
        rt_ep_address = 7'd8;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 12 into register 9
        I16_ep = 16'd12;
        rt_ep_address = 7'd9;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 16 into register 10
        I16_ep = 16'd16;
        rt_ep_address = 7'd10;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 15 into register 11
        I16_ep = 16'd15;
        rt_ep_address = 7'd11;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 8 into register 12
        I16_ep = 16'd8;
        rt_ep_address = 7'd12;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 7 into register 13
        I16_ep = 16'd7;
        rt_ep_address = 7'd13;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 9 into register 14
        I16_ep = 16'd9;
        rt_ep_address = 7'd14;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 18 into register 15
        I16_ep = 16'd18;
        rt_ep_address = 7'd15;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 22 into register 16
        I16_ep = 16'd22;
        rt_ep_address = 7'd16;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 24 into register 17
        I16_ep = 16'd24;
        rt_ep_address = 7'd17;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 26 into register 18
        I16_ep = 16'd26;
        rt_ep_address = 7'd18;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 28 into register 19
        I16_ep = 16'd28;
        rt_ep_address = 7'd19;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //il rt,symbol
        ep_op_code = IMMEDIATE_LOAD_WORD; // loading 30 into register 20
        I16_ep = 16'd30;
        rt_ep_address = 7'd20;
        //lnop
        op_op_code = NO_OPERATION_LOAD;
        
        @(posedge clock)
        ep_op_code = ADD_WORD;
        ra_ep_address = 7'd1;
        rb_ep_address = 7'd2;
        rt_ep_address = 7'd21;

        op_op_code = SHIFT_LEFT_QUADWORD_BY_BITS;
        ra_op_address = 7'd3;
        rb_op_address = 7'd4;
        rt_op_address = 7'd22;
        
        @(posedge clock)
        ep_op_code = ADD_HALFWORD;
        ra_ep_address = 7'd5;
        rb_ep_address = 7'd6;
        rt_ep_address = 7'd23;

        op_op_code = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE;
        ra_op_address = 7'd7;
        I7_op = 7'd5;
        rt_op_address = 7'd24;

        @(posedge clock)
        ep_op_code = ADD_HALFWORD_IMMEDIATE;
        ra_ep_address = 7'd8;
        I10_ep = 10'd4;
        rt_ep_address = 7'd25;

        op_op_code = SHIFT_LEFT_QUADWORD_BY_BYTES;
        ra_op_address = 7'd9;
        rb_op_address = 7'd10;
        rt_op_address = 7'd26;

        @(posedge clock)
        ep_op_code = ADD_WORD_IMMEDIATE;
        ra_ep_address = 7'd11;
        I10_ep = 10'd40;
        rt_ep_address = 7'd27;

        op_op_code = SHIFT_LEFT_QUADWORD_BY_BYTE_IMMEDIATE;
        ra_op_address = 7'd12;
        I7_op = 7'd15;
        rt_op_address = 7'd28;

        @(posedge clock)
        ep_op_code = SUBTRACT_FROM_WORD;
        ra_ep_address = 7'd13;
        rb_ep_address = 7'd14;
        rt_ep_address = 7'd29;

        op_op_code = SHIFT_LEFT_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
        ra_op_address = 7'd15;
        rb_op_address = 7'd16;
        rt_op_address = 7'd30;

        @(posedge clock)
        ep_op_code = SUBTRACT_FROM_HALFWORD;
        ra_ep_address = 7'd17;
        rb_ep_address = 7'd18;
        rt_ep_address = 7'd31;

        op_op_code = ROTATE_QUADWORD_BY_BYTES;
        ra_op_address = 7'd19;
        rb_op_address = 7'd20;
        rt_op_address = 7'd32;

        @(posedge clock)
        ep_op_code = SUBTRACT_FROM_HALFWORD_IMMEDIATE;
        ra_ep_address = 7'd1;
        I10_ep = 10'd2;
        rt_ep_address = 7'd33;

        op_op_code = ROTATE_QUADWORD_BY_BYTES_IMMEDIATE;
        ra_op_address = 7'd2;
        I7_op = 7'd4;
        rt_op_address = 7'd34;

        @(posedge clock)
        ep_op_code = SUBTRACT_FROM_WORD_IMMEDIATE;
        ra_ep_address = 7'd3;
        I10_ep = 10'd100;
        rt_ep_address = 7'd35;

        op_op_code = ROTATE_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
        ra_op_address = 7'd4;
        rb_op_address = 7'd5;
        rt_op_address = 7'd36;

        @(posedge clock)
        ep_op_code = ADD_EXTENDED;
        ra_ep_address = 7'd6;
        rb_ep_address = 7'd7;
        rt_ep_address = 7'd8;

        op_op_code = ROTATE_QUADWORD_BY_BITS;
        ra_op_address = 7'd9;
        rb_op_address = 7'd10;
        rt_op_address = 7'd37;
        
        @(posedge clock)
        ep_op_code = SUBTRACT_FROM_EXTENDED;
        ra_ep_address = 7'd11;
        rb_ep_address = 7'd12;
        rt_ep_address = 7'd3;

        op_op_code = ROTATE_QUADWORD_BY_BITS_IMMEDIATE;
        ra_op_address = 7'd13;
        I7_op = 7'd4;
        rt_op_address = 7'd38;

        @(posedge clock)
        ep_op_code = CARRY_GENERATE;
        ra_ep_address = 7'd14;
        rb_ep_address = 7'd15;
        rt_ep_address = 7'd39;

        op_op_code = GATHER_BITS_FROM_BYTES;
        ra_op_address = 7'd16;
        rt_op_address = 7'd40;

        @(posedge clock)
        ep_op_code = BORROW_GENERATE;
        ra_ep_address = 7'd17;
        rb_ep_address = 7'd18;
        rt_ep_address = 7'd41;

        op_op_code = GATHER_BITS_FROM_HALFWORDS;
        ra_op_address = 7'd19;
        rt_op_address = 7'd42;

        @(posedge clock)
        ep_op_code = AND;
        ra_ep_address = 7'd20;
        rb_ep_address = 7'd1;
        rt_ep_address = 7'd43;

        op_op_code = GATHER_BITS_FROM_WORDS;
        ra_op_address = 7'd2;
        rt_op_address = 7'd44;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = AND_WORD_IMMEDIATE;
        ra_ep_address = 7'd7;
        rt_ep_address = 7'd49;

        op_op_code = STORE_QUADFORM_DFORM;
        ra_op_address = 7'd8;
        I10_op = 10'd9;
        rb_op_address = 7'd2;

        @(posedge clock)
        ep_op_code = OR;
        ra_ep_address = 7'd9;
        rb_ep_address = 7'd10;
        rt_ep_address = 7'd51;

        op_op_code = STORE_QUADFORM_AFORM;
        I16_op = 16'd18;
        rb_op_address = 7'd3;

        @(posedge clock)
        ep_op_code = AND_WITH_COMPLEMENT;
        ra_ep_address = 7'd3;
        rb_ep_address = 7'd4;
        rt_ep_address = 7'd45;

        op_op_code = LOAD_QUADFORM_DFORM;
        ra_op_address = 7'd5;
        I10_op = 10'd5;
        rt_op_address = 7'd46;

        @(posedge clock)
        ep_op_code = AND_HALFWORD_IMMEDIATE;
        ra_ep_address = 7'd6;
        I10_ep = 10'd16;
        rt_ep_address = 7'd47;

        op_op_code = LOAD_QUADWORD_AFORM;
        I16_op = 16'd9;
        rt_op_address = 7'd48;
        
        @(posedge clock)
        ep_op_code = OR_COMPLEMENT;
        ra_ep_address = 7'd11;
        rb_ep_address = 7'd12;
        rt_ep_address = 7'd53;

        op_op_code = BRANCH_RELATIVE;
        PC_input = 32'd162;
        I16_op = 16'd3;
        rt_op_address = 7'd54;

        @(posedge clock)
        ep_op_code = OR_HALFWORD_IMMEDIATE;
        ra_ep_address = 7'd13;
        rt_ep_address = 7'd55;

        op_op_code = BRANCH_ABSOLUTE;
        I16_op = 16'd23;
        rt_op_address = 7'd56;

        @(posedge clock)
        ep_op_code = OR_WORD_IMMEDIATE;
        ra_ep_address = 7'd14;
        I10_ep = 10'd64;
        rt_ep_address = 7'd57;

        op_op_code = BRANCH_RELATIVE_AND_SET_LINK;
        PC_input = 32'd62;
        I16_op = 16'd23;
        rt_op_address = 7'd58;

        @(posedge clock)
        ep_op_code = EXCLUSIVE_OR;
        ra_ep_address = 7'd17;
        rb_ep_address = 7'd18;
        rt_ep_address = 7'd59;

        op_op_code = BRANCH_ABSOLUTE_AND_SET_LINK;
        PC_input = 32'd12;
        I16_op = 16'd28;
        rt_op_address = 7'd60;

        @(posedge clock)
        ep_op_code = EXCLUSIVE_OR_HALFWORD_IMMEDIATE;
        ra_ep_address = 7'd19;
        I10_ep = 10'd8;
        rt_ep_address = 7'd61;

        op_op_code = BRANCH_IF_NOT_ZERO_WORD;
        PC_input = 32'd32;
        I16_op = 16'd8;
        rt_op_address = 7'd62;

        @(posedge clock)
        ep_op_code = EXCLUSIVE_OR_WORD_IMMEDIATE;
        ra_ep_address = 7'd20;
        I10_ep = 10'd8;
        rt_ep_address = 7'd63;

        op_op_code = BRANCH_IF_ZERO_WORD;
        PC_input = 32'd21;
        I16_op = 16'd38;
        rt_op_address = 7'd64;

        @(posedge clock)
        ep_op_code = NAND;
        ra_ep_address = 7'd1;
        rb_ep_address = 7'd2;
        rt_ep_address = 7'd65;

        op_op_code = BRANCH_IF_NOT_ZERO_HALFWORD;
        PC_input = 32'd22;
        I16_op = 16'd2;
        rt_op_address = 7'd66;

        @(posedge clock)
        ep_op_code = NOR;
        ra_ep_address = 7'd3;
        rb_ep_address = 7'd4;
        rt_ep_address = 7'd67;

        op_op_code = BRANCH_IF_ZERO_HALFWORD;
        PC_input = 32'd72;
        I16_op = 16'd31;
        rt_op_address = 7'd8;
        
        @(posedge clock)
        ep_op_code = COUNT_LEADING_ZEROS;
        ra_ep_address = 7'd5;
        rt_ep_address = 7'd69;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = FORM_SELECT_MASK_FOR_HALFWORDS;
        ra_ep_address = 7'd6;
        rt_ep_address = 7'd70;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = FORM_SELECT_MASK_FOR_WORDS;
        ra_ep_address = 7'd7;
        rt_ep_address = 7'd71;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COMPARE_EQUAL_HALFWORD;
        ra_ep_address = 7'd8;
        rb_ep_address = 7'd9;
        rt_ep_address = 7'd72;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COMPARE_EQUAL_HALFWORD_IMMEDIATE;
        ra_ep_address = 7'd10;
        I10_ep = 10'd32;
        rt_ep_address = 7'd73;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COMPARE_EQUAL_WORD;
        ra_ep_address = 7'd11;
        rb_ep_address = 7'd12;
        rt_ep_address = 7'd74;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COMPARE_EQUAL_WORD_IMMEDIATE;
        ra_ep_address = 7'd13;
        I10_ep = 10'd64;
        rt_ep_address = 7'd75;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COMPARE_GREATER_THAN_HALFWORD;
        ra_ep_address = 7'd14;
        rb_ep_address = 7'd15;
        rt_ep_address = 7'd76;

        op_op_code = NO_OPERATION_LOAD;
        
        @(posedge clock)
        ep_op_code = COMPARE_GREATER_THAN_HALFWORD_IMMEDIATE;
        ra_ep_address = 7'd16;
        I10_ep = 10'd8;
        rt_ep_address = 7'd77;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COMPARE_GREATER_THAN_WORD;
        ra_ep_address = 7'd17;
        rb_ep_address = 7'd18;
        rt_ep_address = 7'd78;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COMPARE_GREATER_THAN_WORD_IMMEDIATE;
        ra_ep_address = 7'd19;
        I10_ep = 10'd128;
        rt_ep_address = 7'd79;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COMPARE_LOGICAL_GREATER_THAN_HALFWORD;
        ra_ep_address = 7'd20;
        rb_ep_address = 7'd1;
        rt_ep_address = 7'd80;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COMPARE_LOGICAL_GREATER_THAN_HALFWORD_IMMEDIATE;
        ra_ep_address = 7'd2;
        I10_ep = 10'd4;
        rt_ep_address = 7'd81;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COMPARE_LOGICAL_GREATER_THAN_WORD;
        ra_ep_address = 7'd3;
        rb_ep_address = 7'd4;
        rt_ep_address = 7'd82;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE;
        ra_ep_address = 7'd5;
        I10_ep = 10'd1234;
        rt_ep_address = 7'd83;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_HALFWORD;
        I16_ep = 16'd1025;
        rt_ep_address = 7'd84;

        op_op_code = NO_OPERATION_LOAD;
        
        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_HALFWORD_UPPER;
        I16_ep = 16'd2049;
        rt_ep_address = 7'd85;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_ADDRESS;
        I18_ep = 18'd23456;
        rt_ep_address = 7'd86;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = SHIFT_LEFT_HALFWORD;
        ra_ep_address = 7'd6;
        rb_ep_address = 7'd7;
        rt_ep_address = 7'd87;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = SHIFT_LEFT_HALFWORD_IMMEDIATE;
        ra_ep_address = 7'd8;
        I7_ep = 7'd16;
        rt_ep_address = 7'd88;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = SHIFT_LEFT_WORD;
        ra_ep_address = 7'd9;
        rb_ep_address = 7'd10;
        rt_ep_address = 7'd89;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = SHIFT_LEFT_WORD_IMMEDIATE;
        ra_ep_address = 7'd11;
        I7_ep = 7'd2;
        rt_ep_address = 7'd90;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = ROTATE_HALFWORD;
        ra_ep_address = 7'd12;
        rb_ep_address = 7'd13;
        rt_ep_address = 7'd91;

        op_op_code = NO_OPERATION_LOAD;
        
        @(posedge clock)
        ep_op_code = ROTATE_HALFWORD_IMMEDIATE;
        ra_ep_address = 7'd14;
        I7_ep = 7'd8;
        rt_ep_address = 7'd92;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = ROTATE_WORD;
        ra_ep_address = 7'd15;
        rb_ep_address = 7'd16;
        rt_ep_address = 7'd93;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = ROTATE_WORD_IMMEDIATE;
        ra_ep_address = 7'd17;
        I7_ep = 7'd8;
        rt_ep_address = 7'd94;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = FLOATING_MULTIPLY;
        ra_ep_address = 7'd18;
        rb_ep_address = 7'd19;
        rt_ep_address = 7'd95;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = FLOATING_MULTIPLY_AND_ADD;
        ra_ep_address = 7'd20;
        rb_ep_address = 7'd1;
        rc_ep_address = 7'd2;
        rt_ep_address = 7'd96;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = FLOATING_NEGATIVE_MULTIPLY_AND_SUBTRACT;
        ra_ep_address = 7'd3;
        rb_ep_address = 7'd4;
        rc_ep_address = 7'd5;
        rt_ep_address = 7'd97;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = FLOATING_MULTIPLY_AND_SUBTRACT;
        ra_ep_address = 7'd6;
        rb_ep_address = 7'd7;
        rc_ep_address = 7'd8;
        rt_ep_address = 7'd98;

        op_op_code = NO_OPERATION_LOAD;
        
        @(posedge clock)
        ep_op_code = MULTIPLY;
        ra_ep_address = 7'd9;
        rb_ep_address = 7'd10;
        rt_ep_address = 7'd99;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = MULTIPLY_UNSIGNED;
        ra_ep_address = 7'd11;
        rb_ep_address = 7'd12;
        rt_ep_address = 7'd100;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = MULTIPLY_UNSIGNED_IMMEDIATE;
        ra_ep_address = 7'd13;
        I10_ep = 10'd2;
        rt_ep_address = 7'd101;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = MULTIPLY_AND_ADD;
        ra_ep_address = 7'd14;
        rb_ep_address = 7'd15;
        rc_ep_address = 7'd16;
        rt_ep_address = 7'd102;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = MULTIPLY_HIGH;
        ra_ep_address = 7'd17;
        rb_ep_address = 7'd18;
        rt_ep_address = 7'd103;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = ABSOLUTE_DIFFERENCES_OF_BYTES;
        ra_ep_address = 7'd19;
        rb_ep_address = 7'd20;
        rt_ep_address = 7'd104;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = AVERAGE_BYTES;
        ra_ep_address = 7'd1;
        rb_ep_address = 7'd2;
        rt_ep_address = 7'd105;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = SUM_BYTES_INTO_HALFWORDS;
        ra_ep_address = 7'd3;
        rb_ep_address = 7'd4;
        rt_ep_address = 7'd106;

        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        ep_op_code = COUNT_ONES_IN_BYTES;
        ra_ep_address = 7'd1;
        rt_ep_address = 7'd107;

        op_op_code = NO_OPERATION_LOAD;
    #500;
    $finish;
    end
endmodule