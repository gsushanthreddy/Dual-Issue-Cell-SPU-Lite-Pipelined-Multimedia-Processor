module registerFile(
    input clock;
    input reset;
    input logic [6:0] ra_ep_address;
    input logic [6:0] rb_ep_address; 
    input logic [6:0] rc_ep_address;
    input logic [6:0] rt_ep_address;
    input logic [127:0] rt_value_ep;
    input wrt_en_ep; 
    input logic [6:0] ra_op_address; 
    input logic [6:0] rb_op_address; 
    input logic [6:0] rc_op_address;
    input logic [6:0] rt_op_address;
    input logic [127:0] rt_value_op;
    input wrt_en_op;
    output logic [127:0] ra_ep_value;
    output logic [127:0] rb_ep_value;
    output logic [127:0] rc_ep_value;
    output logic [127:0] ra_op_value;
    output logic [127:0] rb_op_value;
    output logic [127:0] rc_op_value;
);
    logic [127:0] reg_file[128];
    always_comb
    begin
        ra_ep_value = reg_file[ra_ep_address];
        rb_ep_value = reg_file[rb_ep_address];
        rc_ep_value = reg_file[rc_ep_address];
        ra_op_value = reg_file[ra_op_address];
        rb_op_value = reg_file[rb_op_address];
        rc_op_value = reg_file[rc_op_address];
    end

    always_ff @(posedge clock) begin
        if(wrt_en_ep) 
        begin
            reg_file[rt_ep_address] <= rt_value_ep;
        end

        if(wrt_en_op)
        begin
            reg_file[rt_op_address] <= rt_value_op;
        end
        // What if wrt_en_ep and wrt_en_op are both 1 and they write to same RT address? Which value from either of the pipes should RT store?
    end

endmodule