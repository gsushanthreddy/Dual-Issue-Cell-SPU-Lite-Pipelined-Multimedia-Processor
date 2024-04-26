module registerFile(
    input clock,
    input reset,
    input logic [0:6] ra_ep_address,
    input logic [0:6] rb_ep_address, 
    input logic [0:6] rc_ep_address,
    input logic [0:142] wrt_back_arr_ep,
 
    input logic [0:6] ra_op_address, 
    input logic [0:6] rb_op_address, 
    input logic [0:142] wrt_back_arr_op,

    output logic [0:127] ra_ep_value,
    output logic [0:127] rb_ep_value,
    output logic [0:127] rc_ep_value,
    output logic [0:127] ra_op_value,
    output logic [0:127] rb_op_value,
    output logic [0:127] reg_file[128]
);
    
    always_comb
    begin
        ra_ep_value = reg_file[ra_ep_address];
        rb_ep_value = reg_file[rb_ep_address];
        rc_ep_value = reg_file[rc_ep_address];
        ra_op_value = reg_file[ra_op_address];
        rb_op_value = reg_file[rb_op_address];
    end

    always_ff @(posedge clock) begin
        if(reset) begin
            for(int i = 0; i < 128; i++) begin
                reg_file[i] <= 128'd0;
            end
        end
        if(wrt_back_arr_ep[131]) 
        begin
            reg_file[wrt_back_arr_ep[132:138]] <= wrt_back_arr_ep[3:130];
        end

        if(wrt_back_arr_op[131])
        begin
            reg_file[wrt_back_arr_op[132:138]] <= wrt_back_arr_op[3:130];
        end 
    end

endmodule