import descriptions::*;

// this file for testing the First stage of the odd pipe
`timescale  1ns/1ns

module testbench_op();

    logic clock;
    logic reset;
    opcode op_op_code;

    logic [0:6] I7;
    logic [0:9] I10;
    logic [0:15] I16;
    logic [0:17] I18;

    logic [0:127] ra, rb, rt_value;
    logic [0:6] rt_address;

    logic [0:31] pc_input;
    logic [0:31] pc_output;

    logic wrt_en_op;

    logic ls_wrt_en;

    logic Branch_Taken;

    logic [0:14] ls_address;
    logic [0:127] ls_data_input;
    logic [0:127] ls_data_output;

    logic [0:142] FW_op_st_1;
    logic [0:142] FW_op_st_2;
    logic [0:142] FW_op_st_3;
    logic [0:142] FW_op_st_4;
    logic [0:142] FW_op_st_5;
    logic [0:142] FW_op_st_6;
    logic [0:142] FW_op_st_7;

    oddpipe dut2(
        .clock(clock),
        .reset(reset),
        .op_input_op_code(op_op_code),
        .ra_input(ra),
        .rb_input(rb),
        .rt_address_input(rt_address),
        .I7_input(I7),
        .I10_input(I10),
        .I16_input(I16),
        .I18_input(I18),
        .LS_address(ls_address),
        .LS_data_input(ls_data_input),
        .LS_data_output(ls_data_output),
        .LS_wrt_en(ls_wrt_en),
        .fw_op_st_1(FW_op_st_1),
        .fw_op_st_2(FW_op_st_2),
        .fw_op_st_3(FW_op_st_3),
        .fw_op_st_4(FW_op_st_4),
        .fw_op_st_5(FW_op_st_5),
        .fw_op_st_6(FW_op_st_6),
        .fw_op_st_7(FW_op_st_7),
        .branch_taken(Branch_Taken),
        .PC_input(pc_input),
        .PC_output(pc_output)
    );

    initial clock = 0;
    always #5 clock = ~clock;

    initial begin

        // permute

        @(posedge clock)

        op_op_code = SHIFT_LEFT_QUADWORD_BY_BITS;
        rb = 128'd10;
        ra = 128'd20;

        @(posedge clock)

        op_op_code = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE;
        I7 = 7'd5;
        ra = 128'd15;

        @(posedge clock)

        op_op_code = SHIFT_LEFT_QUADWORD_BY_BYTES;
        rb = 128'd110;
        ra = 128'd25;

        @(posedge clock)

        op_op_code = SHIFT_LEFT_QUADWORD_BY_BYTE_IMMEDIATE;
        I7 = 7'd15;
        ra = 128'd33;

        @(posedge clock)
        
        op_op_code = SHIFT_LEFT_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
        rb = 128'd45;
        ra = 128'd18;

        @(posedge clock)
        
        op_op_code = ROTATE_QUADWORD_BY_BYTES;
        rb = 128'd34;
        ra = 128'd77;
 
        @(posedge clock)
        
        op_op_code = ROTATE_QUADWORD_BY_BYTES_IMMEDIATE;
        I7 = 7'd7;
        ra = 128'd37;
   
        @(posedge clock)
        
        op_op_code = ROTATE_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
        rb = 128'd46;
        ra = 128'd71;

        @(posedge clock)
        
        op_op_code = ROTATE_QUADWORD_BY_BITS;
        rb = 128'd61;
        ra = 128'd75;

        @(posedge clock)
        
        op_op_code = ROTATE_QUADWORD_BY_BITS_IMMEDIATE;
        I7 = 7'd5;
        ra = 128'd65;

        @(posedge clock)
        
        op_op_code = GATHER_BITS_FROM_BYTES;
        ra = 128'd15;
        
        @(posedge clock)
        
        op_op_code = GATHER_BITS_FROM_HALFWORDS;
        ra = 128'd95;

        @(posedge clock)
        
        op_op_code = GATHER_BITS_FROM_WORDS;
        ra = 128'd45;

        // Load and store
        @(posedge clock)
        
        op_op_code = LOAD_QUADFORM_DFORM;
        ra = 128'd5;
        I10 = 10'd5;

        @(posedge clock)
        
        op_op_code = LOAD_QUADWORD_AFORM;
        I16 = 16'd9;
        
        @(posedge clock)
        
        op_op_code = STORE_QUADFORM_DFORM;
        ra = 128'd6;
        I10 = 10'd9;
        rb = 128'd5;
        
        @(posedge clock)
        
        op_op_code = STORE_QUADFORM_AFORM;
        I16 = 16'd18;
        rb = 128'd3;

        //Branch

        @(posedge clock)
        
        op_op_code = BRANCH_RELATIVE;
        pc_input = 32'd162;
        I16 = 16'd3;

        @(posedge clock)
        
        op_op_code = BRANCH_ABSOLUTE;
        I16 = 16'd18;
        
        @(posedge clock)
        
        op_op_code = BRANCH_RELATIVE_AND_SET_LINK;
        pc_input = 32'd62;
        I16 = 16'd23;

        @(posedge clock)
        
        op_op_code = BRANCH_ABSOLUTE_AND_SET_LINK;
        pc_input = 32'd12;
        I16 = 16'd28;

        @(posedge clock)
        
        op_op_code = BRANCH_IF_NOT_ZERO_WORD;
        pc_input = 32'd32;
        I16 = 16'd8;

        @(posedge clock)
        
        op_op_code = BRANCH_IF_ZERO_WORD;
        pc_input = 32'd21;
        I16 = 16'd38;

        @(posedge clock)
        
        op_op_code = BRANCH_IF_NOT_ZERO_HALFWORD;
        pc_input = 32'd22;
        I16 = 16'd2;


        @(posedge clock)
        
        op_op_code = BRANCH_IF_ZERO_HALFWORD;
        pc_input = 32'd72;
        I16 = 16'd31;

        #10;

        $finish;

    end

endmodule