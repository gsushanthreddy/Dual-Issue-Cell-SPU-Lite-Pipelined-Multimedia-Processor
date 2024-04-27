import descriptions::*;

// this module is the top layer for the part 2 of the project which include 11 stages(fetch,decode,RF and forward, pipes, write back to local store and reg file)

module toplevel_cellSPU(

    input clock,
    input reset,
    input flush,
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
    output logic [0:6] ra_even_address,
    output logic [0:6] rb_even_address,
    output logic [0:6] rc_even_address,
    output logic [0:6] rt_even_address,
    output logic [0:6] I7_even,
    output logic [0:9] I10_even,
    output logic [0:15] I16_even,
    output logic [0:17] I18_even,

    output logic [0:6] ra_odd_address,
    output logic [0:6] rb_odd_address,
    output logic [0:6] rt_odd_address,
    output logic [0:6] I7_odd,
    output logic [0:9] I10_odd,
    output logic [0:15] I16_odd,
    output logic [0:17] I18_odd,

    
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

    // Register file
    output logic [0:127] reg_file [128],

    // Local store
    output logic [0:7] ls [0:32767]
);

logic wrt_en_fw_ep;
logic wrt_en_fw_op;
logic wrt_en_decode_ep;
logic wrt_en_decode_op;

// register file outputs
logic [0:127] ra_ep_rf_value;
logic [0:127] rb_ep_rf_value;
logic [0:127] rc_ep_rf_value;
logic [0:127] ra_op_rf_value;
logic [0:127] rb_op_rf_value;

// Forwarding unit outputs
logic [0:127] ra_value_fw_ep;
logic [0:127] rb_value_fw_ep;
logic [0:127] rc_value_fw_ep;
logic [0:6] I7_fw_ep;
logic [0:9] I10_fw_ep;
logic [0:15] I16_fw_ep;
logic [0:17] I18_fw_ep;
logic [0:127] ra_value_fw_op;
logic [0:127] rb_value_fw_op;
logic [0:127] rc_value_fw_op;
logic [0:6] I7_fw_op;
logic [0:9] I10_fw_op;
logic [0:15] I16_fw_op;
logic [0:17] I18_fw_op;
logic [0:6] rt_fw_ep_address;
logic [0:6] rt_fw_op_address;
opcode opcode_ep_fw;
opcode opcode_op_fw;
logic wrt_fw_stage_ep;
logic wrt_fw_stage_op;

//  outputs of odd piope to local store

logic [0:14] LS_address;
logic [0:127] LS_data_input;
logic [0:127] LS_data_output;
logic LS_wrt_en;

// pc logics for odd pipe input

logic [0:31] pc_decode;
logic [0:31] pc_forward_unit;

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
    .rt_fw_stage_ep_address(rt_fw_ep_address),
    .rt_fw_stage_op_address(rt_fw_op_address),
    .wrt_fw_stage_ep_in(wrt_fw_stage_ep),
    .wrt_fw_stage_op_in(wrt_fw_stage_op),
    .wrt_en_fw_ep(wrt_en_decode_ep),
    .wrt_en_fw_op(wrt_en_decode_op),
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
    .pc_decode_in(pc_output),
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
    .previous_stall(previous_stall),
    .wrt_en_decode_ep(wrt_en_decode_ep),
    .wrt_en_decode_op(wrt_en_decode_op),
    .pc_decode_out(pc_decode)

);

registerFile Register_fetch (
    .clock(clock),
    .reset(reset),
    .ra_ep_address(ra_even_address),
    .rb_ep_address(rb_even_address),
    .rc_ep_address(rc_even_address),
    .wrt_back_arr_ep(fw_ep_st_7),
    .ra_op_address(ra_odd_address),
    .rb_op_address(rb_odd_address),
    .wrt_back_arr_op(fw_op_st_7),
    .ra_ep_value(ra_ep_rf_value),
    .rb_ep_value(rb_ep_rf_value),
    .rc_ep_value(rc_ep_rf_value),
    .ra_op_value(ra_op_rf_value),
    .rb_op_value(rb_op_rf_value),
    .reg_file(reg_file)
);

forwardunit forward_unit (
    .clock(clock),
    .reset(reset),
    .flush(flush),
    .ep_opcode(opcode_even),
    .ra_address_ep(ra_even_address),
    .rb_address_ep(rb_even_address),
    .rc_address_ep(rc_even_address),
    .ra_value_ep(ra_ep_rf_value),
    .rb_value_ep(rb_ep_rf_value),
    .rc_value_ep(rc_ep_rf_value),
    .rt_address_ep(rt_even_address),
    .I7_ep(I7_even),
    .I10_ep(I10_even),
    .I16_ep(I16_even),
    .I18_ep(I18_even),
    .fw_ep_st_1(fw_ep_st_1),
    .fw_ep_st_2(fw_ep_st_2),
    .fw_ep_st_3(fw_ep_st_3),
    .fw_ep_st_4(fw_ep_st_4),
    .fw_ep_st_5(fw_ep_st_5),
    .fw_ep_st_6(fw_ep_st_6),
    .fw_ep_st_7(fw_ep_st_7),
    .wrt_en_ep(wrt_en_decode_ep),
    .op_opcode(opcode_odd),
    .ra_address_op(ra_odd_address),
    .rb_address_op(rb_odd_address),
    .ra_value_op(ra_op_rf_value),
    .rb_value_op(rb_op_rf_value),
    .rt_address_op(rt_odd_address),
    .I7_op(I7_odd),
    .I10_op(I10_odd),
    .I16_op(I16_odd),
    .I18_op(I18_odd),
    .fw_op_st_1(fw_op_st_1),
    .fw_op_st_2(fw_op_st_2),
    .fw_op_st_3(fw_op_st_3),
    .fw_op_st_4(fw_op_st_4),
    .fw_op_st_5(fw_op_st_5),
    .fw_op_st_6(fw_op_st_6),
    .fw_op_st_7(fw_op_st_7),
    .wrt_en_op(wrt_en_decode_op),
    .pc_forward_unit_in(pc_decode),
    .opcode_ep_fw(opcode_ep_fw),
    .opcode_op_fw(opcode_op_fw),
    .ra_value_fw_ep(ra_value_fw_ep),
    .rb_value_fw_ep(rb_value_fw_ep),
    .rc_value_fw_ep(rc_value_fw_ep),
    .I7_fw_ep(I7_fw_ep),
    .I10_fw_ep(I10_fw_ep),
    .I16_fw_ep(I16_fw_ep),
    .I18_fw_ep(I18_fw_ep),
    .ra_value_fw_op(ra_value_fw_op),
    .rb_value_fw_op(rb_value_fw_op),
    .I7_fw_op(I7_fw_op),
    .I10_fw_op(I10_fw_op),
    .I16_fw_op(I16_fw_op),
    .I18_fw_op(I18_fw_op),
    .rt_fw_ep_address(rt_fw_ep_address),
    .rt_fw_op_address(rt_fw_op_address),
    .wrt_fw_stage_ep(wrt_fw_stage_ep),
    .wrt_fw_stage_op(wrt_fw_stage_op),
    .pc_forward_unit_out(pc_forward_unit)
);

evenpipe Even_pipe(
    .clock(clock),
    .reset(reset),
    .flush(flush),
    .ep_input_op_code(opcode_ep_fw),
    .ra_input(ra_value_fw_ep),
    .rb_input(rb_value_fw_ep),
    .rc_input(rc_value_fw_ep),
    .rt_address_input(rt_fw_ep_address),
    .I7_input(I7_fw_ep),
    .I10_input(I10_fw_ep),
    .I16_input(I16_fw_ep),
    .I18_input(I18_fw_ep),
    .fw_ep_st_1(fw_ep_st_1),
    .fw_ep_st_2(fw_ep_st_2),
    .fw_ep_st_3(fw_ep_st_3),
    .fw_ep_st_4(fw_ep_st_4),
    .fw_ep_st_5(fw_ep_st_5),
    .fw_ep_st_6(fw_ep_st_6),
    .fw_ep_st_7(fw_ep_st_7)
);

oddpipe Odd_pipe (
    .clock(clock),
    .reset(reset),
    .op_input_op_code(opcode_op_fw),
    .ra_input(ra_value_fw_op),
    .rb_input(rb_value_fw_op),
    .rt_address_input(rt_fw_op_address),
    .I7_input(I7_fw_op),
    .I10_input(I10_fw_op),
    .I16_input(I16_fw_op),
    .I18_input(I18_fw_op),

    .LS_address(LS_address),
    .LS_data_input(LS_data_input),
    .LS_data_output(LS_data_output),
    .LS_wrt_en(LS_wrt_en),
    .fw_op_st_1(fw_op_st_1),
    .fw_op_st_2(fw_op_st_2),
    .fw_op_st_3(fw_op_st_3),
    .fw_op_st_4(fw_op_st_4),
    .fw_op_st_5(fw_op_st_5),
    .fw_op_st_6(fw_op_st_6),
    .fw_op_st_7(fw_op_st_7),
    .branch_taken(branch_taken),
    .PC_input(pc_forward_unit),
    .PC_output(pc_input),
    .flush(flush)
);

LocalStore LS (

    .clock(clock),
    .reset(reset),
    .localstore_wrt_en(LS_wrt_en),
    .LS_address(LS_address),
    .LS_data_input(LS_data_input),
    .LS_data_output(LS_data_output),
    .ls(ls)

);

endmodule