import descriptions::*;

// this module is the top layer for the part 2 of the project which include 11 stages(fetch,decode,RF and forward, pipes, write back to local store and reg file)

module toplevel_cellSPU(

    input clock,
    input reset,

    // ouputs from fetch stage
    output logic [0:31] first_inst,
    output logic [0:31] second_inst,
    output logic stall,
    output logic [0:31] pc_input,
    output logic [0:31] pc_output,

    // outputs from decode stage
    output opcode opcode_even,
    output opcode opcode_odd,

    output logic dependency_stall_1,
    output logic dependency_stall_2,
    output logic previous_stall,


    // outputs of every propagation state of even pipe
    output logic [0:142] fw_ep_st_1,
    output logic [0:142] fw_ep_st_2,
    output logic [0:142] fw_ep_st_3,
    output logic [0:142] fw_ep_st_4,
    output logic [0:142] fw_ep_st_5,
    output logic [0:142] fw_ep_st_6,
    output logic [0:142] fw_ep_st_7,

    // outputs of every propagation state of odd pipe
    output logic [0:142] fw_op_st_1,
    output logic [0:142] fw_op_st_2,
    output logic [0:142] fw_op_st_3,
    output logic [0:142] fw_op_st_4,
    output logic [0:142] fw_op_st_5,
    output logic [0:142] fw_op_st_6,
    output logic [0:142] fw_op_st_7,

    // Branch related ports
    output logic branch_taken,
    output logic flush,

    // Register file
    output logic [0:127] reg_file [128],

    // Local store
    output logic [0:7] ls [0:32767]
);

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


fetch_stage fetch (

    .clock(clock),
    .reset(reset),
    .stall(stall),
    .branch_taken(branch_taken),
    .pc_input(pc_input),
    .pc_output(pc_output),
    .first_inst(first_inst),
    .second_inst(second_inst)

);

decode_stage decode (

    .clock(clock),
    .reset(reset),
    .flush(flush),
    .first_inst_input(first_inst),
    .second_inst_input(second_inst),
    .rt_ep_address(rt_even_address),
    .rt_op_address(rt_odd_address),
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
    .opcode_instruction_even(opcode_even),
    .ra_even_address(ra_even_address),
    .rb_even_address(rb_even_address),
    .rc_even_address(rc_even_address),
    .rt_even_address(rt_even_address),
    .I7_even(I7_even),
    .I10_even(I10_even),
    .I16_even(I16_even),
    .I18_even(I18_even),
    .opcode_instruction_odd(opcode_odd),
    .ra_odd_address(ra_odd_address),
    .rb_odd_address(rb_odd_address),
    .rt_odd_address(rt_odd_address),
    .I7_odd(I7_odd),
    .I10_odd(I10_odd),
    .I16_odd(I16_odd),
    .I18_odd(I18_odd),
    .stall(stall),
    .dependency_stall_1(dependency_stall_1),
    .dependency_stall_2(dependency_stall_2),
    .previous_stall(previous_stall)

);

toplevel_part1 register_pipes_localstore(

    .clock(clock),
    .reset(reset),
    .ra_ep_address(ra_even_address),
    .rb_ep_address(rb_even_address),
    .rc_ep_address(rc_even_address),
    .rt_ep_address(rt_even_address),
    .I7_ep(I7_even),
    .I10_ep(I10_even),
    .I16_ep(I16_even),
    .I18_ep(I18_even),
    .ep_opcode(opcode_even),
    .ra_op_address(ra_odd_address),
    .rb_op_address(rb_odd_address),
    .rt_op_address(rt_odd_address),
    .I7_op(I7_odd),
    .I10_op(I10_odd),
    .I16_op(I16_odd),
    .I18_op(I18_odd),
    .op_opcode(opcode_odd),
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
    .PC_input(pc_output),
    .PC_output(pc_input),
    .reg_file(reg_file),
    .ls(ls),
    .flush(flush)

);

endmodule