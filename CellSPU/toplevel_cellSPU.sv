import descriptions::*;

// this module is the top layer for the part 1 of the project which include 9 stages(RF and forward, pipes, write back to local store and reg file)

module toplevel_cellSPU(

    input clock,
    input reset,

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

    // Register file
    output logic [0:127] reg_file [128],

    // Local store
    output logic [0:7] ls [0:32767]
);





endmodule