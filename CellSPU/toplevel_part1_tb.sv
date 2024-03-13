import descriptions::*;
`timescale  1ns/1ns
module toplevel_part1_tb();
    logic                                   clock;
    logic                                   reset, branch_taken;
    opcode                                  ep_op_code, op_op_code;
    logic [0 : 6]                           ra_ep_address, ra_op_address, rb_ep_address, rb_op_address, rc_ep_address, rt_ep_address, rt_op_address;
    logic [0 : 6]                           I7_ep, I7_op;
    logic [0 : 9]                           I10_ep, I10_op;
    logic [0 : 15]                          I16_ep, I16_op;
    logic [0 : 17]                          I18_ep, I18_op;
    logic [0 : 142]                         fw_ep_st_1, fw_op_st_1, fw_ep_st_2, fw_op_st_2, fw_ep_st_3, fw_op_st_3, fw_ep_st_4, fw_op_st_4, fw_ep_st_5, fw_op_st_5, fw_ep_st_6, fw_op_st_6, fw_ep_st_7, fw_op_st_7;
    logic [0 : 31]                          PC_input, PC_output;
    logic [0:127]                           reg_file[128];

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
        .ra_op_address(ra_ep_address), 
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
        .reg_file(reg_file)
    );

    initial clock = 1;
    always #5 clock = ~clock;

    initial begin 
        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_WORD;
        I10_ep = 10'd2;
        rt_ep_address = 7'd1;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_WORD;
        I10_ep = 10'd4;
        rt_ep_address = 7'd2;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_WORD;
        I10_ep = 10'd8;
        rt_ep_address = 7'd3;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_WORD;
        I10_ep = 10'd16;
        rt_ep_address = 7'd4;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_WORD;
        I10_ep = 10'd32;
        rt_ep_address = 7'd5;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_WORD;
        I10_ep = 10'd10;
        rt_ep_address = 7'd6;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_WORD;
        I10_ep = 10'd24;
        rt_ep_address = 7'd7;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_WORD;
        I10_ep = 10'd64;
        rt_ep_address = 7'd8;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;
        
        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_WORD;
        I10_ep = 10'd130;
        rt_ep_address = 7'd9;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = IMMEDIATE_LOAD_WORD;
        I10_ep = 10'd256;
        rt_ep_address = 7'd10;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;

        @(posedge clock)
        ep_op_code = NO_OPERATION_EXECUTE;
        op_op_code = NO_OPERATION_EXECUTE;
    // int even_q[$], odd_q[$];

    // initial begin
    //     reset = 1;
    //     PC = 0;
    //     @(posedge clk);
    //     reset = 0;
    //     unit_id = 1;
    //     opcode_even = ADD_WORD_IMMEDIATE;
    //     addr_ra_rd_even = 0;
    //     addr_rt_wt_even = 7'd1;
    //     imm10_even = -10'd5;
    //     // @(posedge clk);
    //     // opcode_even = ADD_WORD_IMMEDIATE;
    //     // addr_ra_rd_even = 1;
    //     // addr_rt_wt_even = 7'd2;
    //     // imm10_even = 10'd3;
    //     @(posedge clk);
    //     repeat(9) begin
    //         opcode_even = NOP;
    //         unit_id = 0;
    //         addr_rt_wt_even = 0;
    //         @(posedge clk);
    //     end
    // end
    //     opcode_even = ADD_WORD_IMMEDIATE;
    //     addr_ra_rd_even = 1;
    //     addr_rt_wt_even = 7'd2;
    //     imm10_even = -10'd4;
    //     @(posedge clk);
    //     repeat(3) begin
    //         opcode_even = NOP;
    //         unit_id = 0;
    //         addr_rt_wt_even = 0;
    //         @(posedge clk);
    //     end
    //     opcode_even = SUBTRACT_FROM_WORD;
    //     addr_ra_rd_even = 2;
    //     addr_rb_rd_even = 1;
    //     addr_rt_wt_even = 7'd3;
    //     @(posedge clk);
    //     opcode_even = NOP;
    //     unit_id = 0;
    //     addr_rt_wt_even = 0;
    //     repeat(9) begin
    //         @(posedge clk);
    //     end
    //     opcode_even = NOP;
    //     unit_id = 0;
    //     addr_rt_wt_even = 0;

    //     opcode_odd = STORE_QUADWORD_D;
    //     imm10_odd = 10;
    //     addr_ra_rd_odd = 2;
    //     addr_rc_rd_odd = 3;
    //     @(posedge clk);
    //     opcode_odd = STORE_QUADWORD_X;
    //     addr_ra_rd_odd = 2;
    //     addr_rb_rd_odd = 3;
    //     addr_rc_rd_odd = 1; 
    //     @(posedge clk);
    //     opcode_odd = STORE_QUADWORD_A;
    //     imm16_odd = 10;
    //     addr_rc_rd_odd = 2;
    //     @(posedge clk);
    //     // repeat(5) begin
    //     //     @(posedge clk);
    //     // end
    //     opcode_odd = LOAD_QUADWORD_D;
    //     imm10_odd = 10;
    //     addr_ra_rd_odd = 2;
    //     addr_rt_wt_odd = 5;
    //     @(posedge clk);
    //     opcode_odd = LNOP; addr_rt_wt_odd = 0;
    //     repeat(3) begin
    //         @(posedge clk);
    //     end

    //     //Even to even fw
    //     opcode_even = ADD_WORD; unit_id = 1; addr_ra_rd_even = 3; addr_rb_rd_even = 2; addr_rt_wt_even = 2; opcode_odd = LNOP; addr_ra_rd_odd = 2; addr_rt_wt_odd = 12; imm7_odd = 2;
    //     @(posedge clk);        
    //     repeat(3) begin
    //         opcode_even = NOP;
    //         unit_id = 0;
    //         addr_rt_wt_even = 0;
    //         addr_ra_rd_even = 0; addr_rb_rd_even = 0;
    //         @(posedge clk);
    //     end
    //     opcode_even = COMPARE_EQUAL_WORD; unit_id = 1; addr_ra_rd_even = 1; addr_rb_rd_even = 2; addr_rt_wt_even = 0; opcode_odd = LNOP; addr_ra_rd_odd = 2; addr_rt_wt_odd = 12; imm7_odd = 2;
    //     @(posedge clk);
    //     repeat(9) begin
    //         opcode_even = NOP;
    //         unit_id = 0;
    //         addr_rt_wt_even = 0;
    //         @(posedge clk);
    //     end

    //     //Even to odd fw
    //     opcode_even = ADD_WORD; unit_id = 1; addr_ra_rd_even = 3; addr_rb_rd_even = 2; addr_rt_wt_even = 2; opcode_odd = LNOP; addr_ra_rd_odd = 2; addr_rt_wt_odd = 12; imm7_odd = 2;
    //     @(posedge clk);        
    //     repeat(3) begin
    //         opcode_even = NOP;
    //         unit_id = 0;
    //         addr_rt_wt_even = 0;
    //         addr_ra_rd_even = 0; addr_rb_rd_even = 0;
    //         @(posedge clk);
    //     end
    //     opcode_odd = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE; unit_id = 1;  addr_ra_rd_even = 0; addr_rb_rd_even = 0; addr_rt_wt_even = 0; opcode_even = NOP; addr_ra_rd_odd = 2; addr_rt_wt_odd = 3; imm7_odd = 2;
    //     @(posedge clk);
    //     repeat(9) begin
    //         opcode_odd = LNOP;
    //         unit_id = 0;
    //         addr_rt_wt_even = 0;
    //         @(posedge clk);
    //     end
        
        

    //     //Odd to Even fw test
    //     opcode_even = NOP; unit_id = 0; addr_rt_wt_even = 0; opcode_odd = ROTATE_QUADWORD_BY_BYTES_IMMEDIATE; addr_ra_rd_odd = 2; addr_rt_wt_odd = 12; imm7_odd = 2;
    //     @(posedge clk);
    //     opcode_odd = LNOP; unit_id = 0; addr_rt_wt_odd = 0;
    //     repeat(3) begin
    //         @(posedge clk);
    //     end
    //     opcode_even = SHIFT_LEFT_WORD; addr_ra_rd_even = 12; addr_rb_rd_even = 1; addr_rt_wt_even = 10;
    //     @(posedge clk);
    //     repeat(9) begin
    //         opcode_even = NOP;
    //         unit_id = 0;
    //         addr_rt_wt_even = 0;
    //         @(posedge clk);
    //     end
        

    //     //odd to odd fw
    //     opcode_even = NOP; unit_id = 0; addr_rt_wt_even = 0;
    //     opcode_odd = LOAD_QUADWORD_X; addr_ra_rd_odd = 2; addr_rb_rd_odd = 3; addr_rt_wt_odd = 11;
    //     @(posedge clk);
    //     repeat(6) begin
    //         opcode_odd = LNOP;
    //         unit_id = 0;
    //         addr_rt_wt_odd = 0;
    //         @(posedge clk);
    //     end
    //     opcode_odd = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE; addr_ra_rd_odd = 11; addr_rt_wt_odd = 0; unit_id = 5; imm7_odd = 4;
    //     @(posedge clk);
    //     repeat(9) begin
    //         opcode_odd = LNOP;
    //         unit_id = 0;
    //         addr_rt_wt_odd = 0;
    //         @(posedge clk);
    //     end


    //     // //odd to even fw
    //     // opcode_even = NOP; unit_id = 0; addr_rt_wt_even = 0;
    //     // opcode_odd = SHIFT_LEFT_QUADWORD_BY_BITS; addr_ra_rd_odd = 11; addr_rt_wt_odd = 12; unit_id = 5; imm7_odd = 4;
    //     // @(posedge clk);
    //     // repeat(4) begin
    //     //     opcode_odd = LNOP;
    //     //     unit_id = 0;
    //     //     addr_rt_wt_odd = 0;
    //     //     @(posedge clk);
    //     // end
    //     // opcode_even = FLOATING_ADD; addr_ra_rd_even = 12; addr_rb_rd_even = 5; addr_rt_wt_even = 13;
    //     // @(posedge clk);
    //     // repeat(9) begin
    //     //     opcode_even = NOP; unit_id = 0; addr_ra_rd_even = 0; addr_rb_rd_even = 5;addr_rt_wt_even = 0;
    //     //     opcode_odd = LNOP;
    //     //     unit_id = 0;
    //     //     addr_rt_wt_odd = 0;
    //     //     @(posedge clk);
    //     // end

    //     //Flush Test
    //     opcode_odd = BRANCH_RELATIVE_AND_SET_LINK; addr_rc_rd_odd = 0; br_first_instr = 1;
    //     opcode_even = MULTIPLY_AND_ADD; addr_ra_rd_even = 1; addr_rb_rd_even = 2; addr_rc_rd_even = 5; addr_rt_wt_even = 6;
    //     @(posedge clk)
    //     repeat(9) begin
    //         opcode_even = NOP; unit_id = 0; addr_ra_rd_even = 0; addr_rb_rd_even = 5;addr_rt_wt_even = 0;
    //         opcode_odd = LNOP;
    //         unit_id = 0;
    //         addr_rt_wt_odd = 0;
    //         @(posedge clk);
    //     end

    //     //load random values to registerfile
    //     for(int i = 0; i < 128; i++) begin
    //         unit_id = 1;
    //         opcode_even = ADD_WORD_IMMEDIATE;
    //         addr_ra_rd_even = 127;
    //         addr_rt_wt_even = i;
    //         imm10_even = $random;
    //         @(posedge clk);
    //     end
        
    //     repeat(16) begin
    //         opcode_even = NOP; unit_id = 0; addr_ra_rd_even = 0; addr_rb_rd_even = 5;addr_rt_wt_even = 0;
    //         opcode_odd = LNOP;
    //         unit_id = 0;
    //         addr_rt_wt_odd = 0;
    //         @(posedge clk);
    //     end
    #20;
    $finish;
    end
endmodule