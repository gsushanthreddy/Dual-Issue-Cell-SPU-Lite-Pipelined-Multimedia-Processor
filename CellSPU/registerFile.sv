module registerFile(
    input clock,
    input reset,
    input logic [0:6] ra_ep_address,
    input logic [0:6] rb_ep_address, 
    input logic [0:6] rc_ep_address,
    input logic [0:6] rt_ep_address,
    input logic [0:142] wrt_back_arr_ep,
    input wrt_en_ep, 
    input logic [0:6] ra_op_address, 
    input logic [0:6] rb_op_address, 
    input logic [0:6] rt_op_address,
    input logic [0:142] wrt_back_arr_op,
    input wrt_en_op,
    output logic [0:127] ra_ep_value,
    output logic [0:127] rb_ep_value,
    output logic [0:127] rc_ep_value,
    output logic [0:127] ra_op_value,
    output logic [0:127] rb_op_value
);
    logic [0:127] reg_file[128];
    always_comb
    begin
        ra_ep_value = reg_file[ra_ep_address];
        rb_ep_value = reg_file[rb_ep_address];
        rc_ep_value = reg_file[rc_ep_address];
        ra_op_value = reg_file[ra_op_address];
        rb_op_value = reg_file[rb_op_address];
    end

    always_ff @(posedge clock) begin
        if(wrt_en_ep) 
        begin
            reg_file[rt_ep_address] <= wrt_back_arr_ep[3:130];
        end

        if(wrt_en_op)
        begin
            reg_file[rt_op_address] <= wrt_back_arr_op[3:130];
        end
        // What if wrt_en_ep and wrt_en_op are both 1 and they write to same RT address? Which value from either of the pipes should RT store? Stall odd pipe 
    end

endmodule