import descriptions::*;
`timescale  1ns/1ns
module toplevel_part1_tb();
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
    logic [0:6] rt_rf_ep_address;
    logic [0:6] rt_rf_op_address;
    
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
        .ls(ls),
        .rf_rt_ep_address(rf_rt_ep_address),
        .rf_rt_op_address(rf_rt_op_address)
    );

    initial clock = 1;
    always #5 clock = ~clock;

    initial begin 
        @(posedge clock)
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
        //a rt,ra,rb
        ep_op_code = ADD_WORD; // checking even to even forwarding
        ra_ep_address = 7'd1; // should be forwarded from immediate load word (1)
        rb_ep_address = 7'd2; // should be forwarded from immediate load word (2)
        rt_ep_address = 7'd4;
        //shlqbii rt,ra,value
        op_op_code = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE; //checking even to odd forwarding 
        ra_op_address = 7'd1; // should be forwarded from immediate load (1)
        I7_op = 7'd5;
        rt_op_address = 7'd5;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //andhi rt,ra,value
        ep_op_code = AND_HALFWORD_IMMEDIATE; // checking for the latest value forwarding
        ra_ep_address = 7'd4; // should be fetched from ADD word not from immediate load word (4)
        I10_ep = 10'd5; 
        rt_ep_address = 7'd6;
        //rotqby rt,ra,rb
        op_op_code = ROTATE_QUADWORD_BY_BYTES; // checking for latest value forwarding from even pipe and also from odd pipe
        ra_op_address = 7'd4; //should be fetched from ADD word not from immediate load word (4)
        rb_op_address = 7'd5; // should be fetced from shift left quadwords by bits immediate not from immediate load word (5)
        rt_op_address = 7'd7;

        @(posedge clock)
        //nor rt,ra,rb
        ep_op_code = NOR; // ra, rb are fetched from the register file
        ra_ep_address = 7'd1;
        rb_ep_address = 7'd2;
        rt_ep_address = 7'd8;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //clz rt,ra
        ep_op_code = COUNT_LEADING_ZEROS; // ra is fetched from reg file
        ra_ep_address = 7'd3;
        rt_ep_address = 7'd9;
        //gbb rt,ra
        op_op_code = GATHER_BITS_FROM_BYTES; // ra is fetched from reg file
        ra_op_address = 7'd3; 
        rt_op_address = 7'd10;

        @(posedge clock)
        //shlhi rt,ra,value
        ep_op_code = SHIFT_LEFT_HALFWORD_IMMEDIATE; // ra is fetched from reg file
        ra_ep_address = 7'd1;
        I7_ep = 7'd1;
        rt_ep_address = 7'd9;
        //rotqbyi rt,ra,value
        op_op_code = ROTATE_QUADWORD_BY_BYTES_IMMEDIATE; // ra is fetched from reg file
        ra_op_address = 7'd2; 
        I7_op = 7'd4;
        rt_op_address = 7'd10;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //mpy rt,ra,rb
        ep_op_code = MULTIPLY; // checking odd to even and even to even forwarding
        ra_ep_address = 7'd7; // should be forwarded from rotate quadword by bytes
        rb_ep_address = 7'd8; // should be forwarded from Nor
        rt_ep_address = 7'd13;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

         @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //mpya rt,ra,rb,rc
        ep_op_code = MULTIPLY_AND_ADD; // checking latest value from even to even and odd to even
        ra_ep_address = 7'd8; // should be forwarded from nor
        rb_ep_address = 7'd9; // should be forwarded from shift left halfword immediate not from count leading zeroes
        rc_ep_address = 7'd10; // should be forwarded from rotate quadword by bytes immediate not from gather bits from bytes
        rt_ep_address = 7'd14;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //avgb rt,ra,rb
        ep_op_code = AVERAGE_BYTES; // ra, rb are fetched from reg file
        ra_ep_address = 7'd5; 
        rb_ep_address = 7'd7;
        rt_ep_address = 7'd15;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

        @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

         @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;
         @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

         @(posedge clock)
        //nop
        ep_op_code = NO_OPERATION_EXECUTE;
        //lnop
        op_op_code = NO_OPERATION_LOAD;

    #20;
    $finish;
    end
endmodule