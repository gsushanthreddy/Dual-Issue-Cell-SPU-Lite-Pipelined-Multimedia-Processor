import descriptions::*;

// this file for testing the First stage of the odd pipe

module testbench_op();

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

    logic ls_wrt_en;

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

    logic [0:142] op_output;

    oddpipe dut2(
        .clock(clock),
        .reset(reset),
        .op_input_op_code(op_op_code),
        .I7_input(I7),
        .I10_input(I10),
        .I16_input(I16),
        .I18_input(I18),
        .ra_input(ra),
        .rb_input(rb),
        .rc_input(rc),
        .rt_address_input(rt_address),
        .PC_input(pc_input),
        .PC_output(pc_output),
        .LS_address_output(ls_address),
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
        .out_op(op_output)
    );

    initial clock = 0;
    always #5 clock = ~clock;

    initial begin

        // permute

        @(posedge clock)

        #1;
        op_op_code = SHIFT_LEFT_QUADWORD_BY_BITS;
        rb = 128'd10;
        ra = 128'd20;

        @(posedge clock)

        #1;
        op_op_code = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE;
        I7 = 7'd5;
        ra = 128'd15;

        @(posedge clock)

        #1;
        op_op_code = SHIFT_LEFT_QUADWORD_BY_BYTES;
        rb = 128'd110;
        ra = 128'd25;

        @(posedge clock)

        #1;
        op_op_code = SHIFT_LEFT_QUADWORD_BY_BYTE_IMMEDIATE;
        I7 = 7'd15;
        ra = 128'd33;

        @(posedge clock)
        
        #1;
        op_op_code = SHIFT_LEFT_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
        rb = 128'd45;
        ra = 128'd18;

        @(posedge clock)
        
        #1;
        op_op_code = ROTATE_QUADWORD_BY_BYTES;
        rb = 128'd34;
        ra = 128'd77;
 
        @(posedge clock)
        
        #1;
        op_op_code = ROTATE_QUADWORD_BY_BYTES_IMMEDIATE;
        I7 = 7'd7;
        ra = 128'd37;
   
        @(posedge clock)
        
        #1;
        op_op_code = ROTATE_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
        rb = 128'd46;
        ra = 128'd71;

        @(posedge clock)
        
        #1;
        op_op_code = ROTATE_QUADWORD_BY_BITS;
        rb = 128'd61;
        ra = 128'd75;

        @(posedge clock)
        
        #1;
        op_op_code = ROTATE_QUADWORD_BY_BITS_IMMEDIATE;
        I7 = 7'd5;
        ra = 128'd65;

        @(posedge clock)
        
        #1;
        op_op_code = GATHER_BITS_FROM_BYTES;
        ra = 128'd15;
        
        @(posedge clock)
        
        #1;
        op_op_code = GATHER_BITS_FROM_HALFWORDS;
        ra = 128'd95;

        @(posedge clock)
        
        #1;
        op_op_code = GATHER_BITS_FROM_WORDS;
        ra = 128'd45;

        #10;

        $finish;

    end

endmodule