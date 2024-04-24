import descriptions::*;
`timescale  1ns/1ns
module testbench_cell_SPU();
    logic           clock;
    logic           reset, branch_taken,flush;
    logic [0 : 142] fw_ep_st_1, fw_op_st_1, fw_ep_st_2, fw_op_st_2, fw_ep_st_3, fw_op_st_3, fw_ep_st_4, fw_op_st_4, fw_ep_st_5, fw_op_st_5, fw_ep_st_6, fw_op_st_6, fw_ep_st_7, fw_op_st_7;
    logic [0:127]   reg_file[128];
    logic [0:7]     ls [0:32767];
    logic [0:31]    first_inst,second_inst;
    logic           stall,dependency_stall_1,dependency_stall_2,previous_stall;
    logic [0:31]    pc_input,pc_output;
    opcode          opcode_even,opcode_odd;
    logic [0:6] ra_even_address;
    logic [0:6] rb_even_address;
    logic [0:6] rc_even_address;
    logic [0:6] rt_even_address;
    logic [0:6] I7_even;
    logic [0:9] I10_even;
    logic [0:15] I16_even;
    logic [0:17] I18_even;    
    logic [0:6] ra_odd_address;
    logic [0:6] rb_odd_address;
    logic [0:6] rt_odd_address;
    logic [0:6] I7_odd;
    logic [0:9] I10_odd;
    logic [0:15] I16_odd;
    logic [0:17] I18_odd;
    logic [0:6] rt_rf_ep_address;
    logic [0:6] rt_rf_op_address;

    toplevel_cellSPU dut_cell_SPU(
        .clock(clock),
        .reset(reset),
        .first_inst(first_inst),
        .second_inst(second_inst),
        .stall(stall),
        .pc_input(pc_input),
        .pc_output(pc_output),
        .opcode_even(opcode_even),
        .opcode_odd(opcode_odd),
        .dependency_stall_1(dependency_stall_1),
        .dependency_stall_2(dependency_stall_2),
        .previous_stall(previous_stall),
        .ra_even_address(ra_even_address),
        .rb_even_address(rb_even_address),
        .rc_even_address(rc_even_address),
        .rt_even_address(rt_even_address),
        .ra_odd_address(ra_odd_address),
        .rb_odd_address(rb_odd_address),
        .rt_odd_address(rt_odd_address),
        .I7_even(I7_even),
        .I10_even(I10_even),
        .I16_even(I16_even),
        .I18_even(I18_even),
        .I7_odd(I7_odd),
        .I10_odd(I10_odd),
        .I16_odd(I16_odd),
        .I18_odd(I18_odd),
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
        .ls(ls),
        .rt_rf_ep_address(rt_rf_ep_address),
        .rt_rf_op_address(rt_rf_op_address)
    );

    initial clock = 1;
    always #5 clock = ~clock;

    initial begin 
        reset = 1;
        #4 reset = ~reset;
        repeat(100) @(posedge clock);
        $finish;
    end
endmodule