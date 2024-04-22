import descriptions::*;
`timescale  1ns/1ns
module testbench_dr();
    logic           clock;
    logic           reset, branch_taken,flush;
    logic [0:31]    first_inst_input,second_inst_input;
    logic [0 : 142] fw_ep_st_1, fw_op_st_1, fw_ep_st_2, fw_op_st_2, fw_ep_st_3, fw_op_st_3, fw_ep_st_4, fw_op_st_4, fw_ep_st_5, fw_op_st_5, fw_ep_st_6, fw_op_st_6, fw_ep_st_7, fw_op_st_7;
    logic [0:127]   reg_file[128];
    logic [0:7]     ls [0:32767];

    toplevel_from_decode dut_from_decode(
        .clock(clock),
        .reset(reset),
        .first_inst_input(first_inst_input),
        .second_inst_input(second_inst_input),
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
        .flush(flush),
        .reg_file(reg_file),
        .ls(ls)
    );

    initial clock = 1;
    always #5 clock = ~clock;

    initial begin 
        @(posedge clock)

        first_inst_input = 32'b010000001_0000000000001010_0000001;   // il r1, 10
        second_inst_input = 32'b00000000001_xxxxxxx_xxxxxxx_xxxxxxx; // lnop

        @(posedge clock)

        first_inst_input = 32'b010000001_0000000000010100_0000010;   // il r2, 20
        second_inst_input = 32'b00000000001_xxxxxxx_xxxxxxx_xxxxxxx; // lnop

        @(posedge clock)

        first_inst_input = 32'b010000001_0000000000011110_0000011;   // il r3, 30
        second_inst_input = 32'b00000000001_xxxxxxx_xxxxxxx_xxxxxxx; // lnop

        @(posedge clock)

        first_inst_input = 32'b010000001_0000000000101000_0000100;   // il r4, 20
        second_inst_input = 32'b010000001_0000000000110010_0000010;  // il r5, 50

        @(posedge clock)

        first_inst_input = 32'b010000001_0000000000111100_0000101;   // il r6, 60
        second_inst_input = 32'b00000000001_xxxxxxx_xxxxxxx_xxxxxxx; // lnop

        @(posedge clock)

        first_inst_input = 32'b010000001_1111111111110100_0000111;   // il r7, -10 // check
        second_inst_input = 32'b00000000001_xxxxxxx_xxxxxxx_xxxxxxx; // lnop

        @(posedge clock)

        first_inst_input = 32'b00011000000_0000011_0000100_0001000; // a r8, r4, r3
        second_inst_input = 32'b00111011011_0000011_0001000_0001001; // shlqbi r9,r8,r3

        @(posedge clock)

        first_inst_input = 32'b010000001_0000000001000110_0001010;   // il r10, 70
        second_inst_input = 32'b00000000001_xxxxxxx_xxxxxxx_xxxxxxx; // lnop

        @(posedge clock)

        first_inst_input = 32'b010000001_0000000001010000_0001011;   // il r11, 80
        second_inst_input = 32'b00000000001_xxxxxxx_xxxxxxx_xxxxxxx; // lnop

        @(posedge clock)

        first_inst_input = 32'b010000001_0000000001011010_0001100;   // il r12, 90
        second_inst_input = 32'b00110100_0000001010_0000001_0001100; // lqd r12, 10(r1)
    
    end
endmodule