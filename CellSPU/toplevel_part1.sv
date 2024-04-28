import descriptions::*;

// this module is the top layer for the part 1 of the project which include 9 stages(RF and forward, pipes, write back to local store and reg file)

module toplevel_part1(

    input clock,
    input reset,

    // data from the instruction of even pipe
    input logic [0:6] ra_ep_address,
    input logic [0:6] rb_ep_address, 
    input logic [0:6] rc_ep_address,
    input logic [0:6] rt_ep_address,
    input logic wrt_en_ep,

    input [0:6] I7_ep,
    input [0:9] I10_ep,
    input [0:15] I16_ep,
    input [0:17] I18_ep,

    input opcode ep_opcode,
    
    // data from the instruction of odd pipe
    input logic [0:6] ra_op_address, 
    input logic [0:6] rb_op_address, 
    input logic [0:6] rt_op_address,
    input logic wrt_en_op,

    input [0:6] I7_op,
    input [0:9] I10_op,
    input [0:15] I16_op,
    input [0:17] I18_op,

    input opcode op_opcode,

    // outputs of every propagation state of even pipe
    output [0:142] fw_ep_st_1,
    output [0:142] fw_ep_st_2,
    output [0:142] fw_ep_st_3,
    output [0:142] fw_ep_st_4,
    output [0:142] fw_ep_st_5,
    output [0:142] fw_ep_st_6,
    output [0:142] fw_ep_st_7,

    // outputs of every propagation state of odd pipe
    output [0:142] fw_op_st_1,
    output [0:142] fw_op_st_2,
    output [0:142] fw_op_st_3,
    output [0:142] fw_op_st_4,
    output [0:142] fw_op_st_5,
    output [0:142] fw_op_st_6,
    output [0:142] fw_op_st_7,

    // Branch related ports
    output logic branch_taken,

    // PC input and output

    input logic [0:31] PC_input,
    output logic [0:31] PC_output,

    // Register file
    output logic [0:127] reg_file [128],

    // Local store
    output logic [0:7] ls [0:32767],

    output logic flush

   // CHECK WITH PROFESSOR THAT WE HAVE TO PUT THE LOCAL STORE AND REGISTER MEMORIES AS OUTPUT IN THE TOP FILE
);

    // Even pipe
    logic [0:127] rt_value_ep;

    // Odd pipe
    logic [0:127] rt_value_op;

    // register file ouputs
    logic [0:127] ra_ep_value;
    logic [0:127] rb_ep_value;
    logic [0:127] rc_ep_value;
    logic [0:127] ra_op_value;
    logic [0:127] rb_op_value;
    //logic [0:127] rc_op_value;

    // forwarding units outputs
    logic [0:127] ra_value_fw_ep;
    logic [0:127] rb_value_fw_ep;
    logic [0:127] rc_value_fw_ep;
    logic [0:127] ra_value_fw_op;
    logic [0:127] rb_value_fw_op;
    logic [0:6] rt_fw_ep_address;
    logic [0:6] rt_fw_op_address;
    logic [0:31] pc_forward_unit_in;
    logic branch_is_first_inst_from_decode;
    opcode opcode_ep_fw;
    opcode opcode_op_fw;
    logic [0:6] I7_fw_ep;
    logic [0:9] I10_fw_ep;
    logic [0:15] I16_fw_ep;
    logic [0:17] I18_fw_ep;
    logic [0:6] I7_fw_op;
    logic [0:9] I10_fw_op;
    logic [0:15] I16_fw_op;
    logic [0:17] I18_fw_op;
    logic wrt_fw_stage_ep;
    logic wrt_fw_stage_op;
    logic [0:31] pc_forward_unit_out;
    logic branch_is_first_inst_from_fw;


    // Local store access logic between odd pipe and the local store

    logic [0:14] LS_address;
    logic [0:127] LS_data_input;
    logic [0:127] LS_data_output;
   
    logic LS_wrt_en;

    registerFile RF (

        .clock(clock),
        .reset(reset),
        .ra_ep_address(ra_ep_address),
        .rb_ep_address(rb_ep_address),
        .rc_ep_address(rc_ep_address),
        .wrt_back_arr_ep(fw_ep_st_7),
        .ra_op_address(ra_op_address),
        .rb_op_address(rb_op_address),
        .wrt_back_arr_op(fw_op_st_7),
        .ra_ep_value(ra_ep_value),
        .rb_ep_value(rb_ep_value),
        .rc_ep_value(rc_ep_value),
        .ra_op_value(ra_op_value),
        .rb_op_value(rb_op_value),
        .reg_file(reg_file)
    );

    forwardunit FW (

        .clock(clock),
        .reset(reset),
        .flush(flush),
        .ep_opcode(ep_opcode),
        .ra_address_ep(ra_ep_address),
        .rb_address_ep(rb_ep_address),
        .rc_address_ep(rc_ep_address),
        .ra_value_ep(ra_ep_value),
        .rb_value_ep(rb_ep_value),
        .rc_value_ep(rc_ep_value),
        .rt_address_ep(rt_ep_address),
        .I7_ep(I7_ep),
        .I10_ep(I10_ep),
        .I16_ep(I16_ep),
        .I18_ep(I18_ep),
        .fw_ep_st_1(fw_ep_st_1),
        .fw_ep_st_2(fw_ep_st_2),
        .fw_ep_st_3(fw_ep_st_3),
        .fw_ep_st_4(fw_ep_st_4),
        .fw_ep_st_5(fw_ep_st_5),
        .fw_ep_st_6(fw_ep_st_6),
        .fw_ep_st_7(fw_ep_st_7),
        .wrt_en_ep(wrt_en_ep),
        .op_opcode(op_opcode),
        .ra_address_op(ra_op_address),
        .rb_address_op(rb_op_address),
        .ra_value_op(ra_op_value),
        .rb_value_op(rb_op_value),
        .rt_address_op(rt_op_address),
        .I7_op(I7_op),
        .I10_op(I10_op),
        .I16_op(I16_op),
        .I18_op(I18_op),
        .fw_op_st_1(fw_op_st_1),
        .fw_op_st_2(fw_op_st_2),
        .fw_op_st_3(fw_op_st_3),
        .fw_op_st_4(fw_op_st_4),
        .fw_op_st_5(fw_op_st_5),
        .fw_op_st_6(fw_op_st_6),
        .fw_op_st_7(fw_op_st_7),
        .wrt_en_op(wrt_en_op),
        .pc_forward_unit_in(pc_forward_unit_in),
        .branch_is_first_inst_from_decode(branch_is_first_inst_from_decode),
        .opcode_ep_fw(opcode_ep_fw),
        .opcode_op_fw(opcode_op_fw),
        .ra_value_fw_ep(ra_value_fw_ep),
        .rb_value_fw_ep(rb_value_fw_ep),
        .rc_value_fw_ep(rc_value_fw_ep),
        .I7_fw_ep(I7_fw_ep),
        .I10_fw_ep(I10_fw_ep),
        .I16_fw_ep(I16_fw_ep),
        .I18_fw_ep(I18_fw_ep),
        .I7_fw_op(I7_fw_op),
        .I10_fw_op(I10_fw_op),
        .I16_fw_op(I16_fw_op),
        .I18_fw_op(I18_fw_op),
        .ra_value_fw_op(ra_value_fw_op),
        .rb_value_fw_op(rb_value_fw_op),
        .rt_fw_ep_address(rt_fw_ep_address),
        .rt_fw_op_address(rt_fw_op_address),
        .wrt_fw_stage_ep(wrt_fw_stage_ep),
        .wrt_fw_stage_op(wrt_fw_stage_op),
        .pc_forward_unit_out(pc_forward_unit_out),
        .branch_is_first_inst_from_fw(branch_is_first_inst_from_fw)
        
    );

    evenpipe EP (

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
        .branch_is_first_inst_from_fw(branch_is_first_inst_from_fw),
        .fw_ep_st_1(fw_ep_st_1),
        .fw_ep_st_2(fw_ep_st_2),
        .fw_ep_st_3(fw_ep_st_3),
        .fw_ep_st_4(fw_ep_st_4),
        .fw_ep_st_5(fw_ep_st_5),
        .fw_ep_st_6(fw_ep_st_6),
        .fw_ep_st_7(fw_ep_st_7)

    );

    oddpipe OP (

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
        .PC_input(PC_input),
        .PC_output(PC_output),
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
