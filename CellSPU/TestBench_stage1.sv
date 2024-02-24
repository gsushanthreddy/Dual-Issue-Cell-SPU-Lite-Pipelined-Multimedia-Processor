import descriptions::*;

// this file for testing the First stage of the odd pipe

module testbench_st1();

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

    logic [0:14] ls_address_output;
    logic [0:127] ls_data_input;
    logic [0:127] ls_data_output;

    oddpipe dut(
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
        .LS_address_output(ls_address_output),
        .LS_data_input(ls_address_output),
        .LS_data_output(ls_data_output),

    );

    initial clock = 0;
    always #5 clock = ~clock;

    initial begin

        @(posedge clock)

        op_op_code = SHIFT_LEFT_QUADWORD_BY_BITS;
        rb = 128'd10;
        ra = 128'd20;

         @(posedge clock)

        op_op_code = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE;
        I7 = 7'd5;
        ra = 128'd15;

    end




endmodule