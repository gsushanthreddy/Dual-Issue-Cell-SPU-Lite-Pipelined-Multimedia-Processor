import descriptions::*;

module forwardunit(
    input clock,
    input reset,
    input flush,
    input opcode ep_opcode,
    input [0:6] ra_address_ep,
    input [0:6] rb_address_ep,
    input [0:6] rc_address_ep,
    input [0:127] ra_value_ep,
    input [0:127] rb_value_ep,
    input [0:127] rc_value_ep,
    input [0:6] rt_address_ep,
    input [0:6] I7_ep,
    input [0:9] I10_ep,
    input [0:15] I16_ep,
    input [0:17] I18_ep,
    input [0:142] fw_ep_st_1,
    input [0:142] fw_ep_st_2,
    input [0:142] fw_ep_st_3,
    input [0:142] fw_ep_st_4,
    input [0:142] fw_ep_st_5,
    input [0:142] fw_ep_st_6,
    input [0:142] fw_ep_st_7,
    input wrt_en_ep,

    input opcode op_opcode,
    input [0:6] ra_address_op,
    input [0:6] rb_address_op,
    input [0:127] ra_value_op,
    input [0:127] rb_value_op,
    input [0:6] rt_address_op,
    input [0:6] I7_op,
    input [0:9] I10_op,
    input [0:15] I16_op,
    input [0:17] I18_op,
    input [0:142] fw_op_st_1,
    input [0:142] fw_op_st_2,
    input [0:142] fw_op_st_3,
    input [0:142] fw_op_st_4,
    input [0:142] fw_op_st_5,
    input [0:142] fw_op_st_6,
    input [0:142] fw_op_st_7,
    input wrt_en_op,

    output logic [0:127] ra_value_fw_ep,
    output logic [0:127] rb_value_fw_ep,
    output logic [0:127] rc_value_fw_ep,
    output logic [0:127] ra_value_fw_op,
    output logic [0:127] rb_value_fw_op,
    output logic [0:6] rt_fw_ep_address,
    output logic [0:6] rt_fw_op_address
);
    logic [0:2] fw_ep_st_1_unitid, fw_ep_st_2_unitid, fw_ep_st_3_unitid, fw_ep_st_4_unitid, fw_ep_st_5_unitid, fw_ep_st_6_unitid, fw_ep_st_7_unitid;
    logic [0:127] fw_ep_st_1_rt_value, fw_ep_st_2_rt_value, fw_ep_st_3_rt_value, fw_ep_st_4_rt_value, fw_ep_st_5_rt_value, fw_ep_st_6_rt_value, fw_ep_st_7_rt_value;
    logic fw_ep_st_1_wrt_en_ep, fw_ep_st_2_wrt_en_ep, fw_ep_st_3_wrt_en_ep, fw_ep_st_4_wrt_en_ep, fw_ep_st_5_wrt_en_ep, fw_ep_st_6_wrt_en_ep, fw_ep_st_7_wrt_en_ep;
    logic [0:6] fw_ep_st_1_rt_address, fw_ep_st_2_rt_address, fw_ep_st_3_rt_address, fw_ep_st_4_rt_address, fw_ep_st_5_rt_address, fw_ep_st_6_rt_address, fw_ep_st_7_rt_address;
    logic [0:3] fw_ep_st_1_unit_latency, fw_ep_st_2_unit_latency, fw_ep_st_3_unit_latency, fw_ep_st_4_unit_latency, fw_ep_st_5_unit_latency, fw_ep_st_6_unit_latency, fw_ep_st_7_unit_latency;

    logic [0:2] fw_op_st_1_unitid, fw_op_st_2_unitid, fw_op_st_3_unitid, fw_op_st_4_unitid, fw_op_st_5_unitid, fw_op_st_6_unitid, fw_op_st_7_unitid;
    logic [0:127] fw_op_st_1_rt_value, fw_op_st_2_rt_value, fw_op_st_3_rt_value, fw_op_st_4_rt_value, fw_op_st_5_rt_value, fw_op_st_6_rt_value, fw_op_st_7_rt_value;
    logic fw_op_st_1_wrt_en_op, fw_op_st_2_wrt_en_op, fw_op_st_3_wrt_en_op, fw_op_st_4_wrt_en_op, fw_op_st_5_wrt_en_op, fw_op_st_6_wrt_en_op, fw_op_st_7_wrt_en_op;
    logic [0:6] fw_op_st_1_rt_address, fw_op_st_2_rt_address, fw_op_st_3_rt_address, fw_op_st_4_rt_address, fw_op_st_5_rt_address, fw_op_st_6_rt_address, fw_op_st_7_rt_address;
    logic [0:3] fw_op_st_1_unit_latency, fw_op_st_2_unit_latency, fw_op_st_3_unit_latency, fw_op_st_4_unit_latency, fw_op_st_5_unit_latency, fw_op_st_6_unit_latency, fw_op_st_7_unit_latency;
    logic [0:127] ra_value_fw_ep_temp, rb_value_fw_ep_temp, rc_value_fw_ep_temp, ra_value_fw_op_temp, rb_value_fw_op_temp;

    assign fw_ep_st_1_unitid       = fw_ep_st_1[0:2];
    assign fw_ep_st_1_rt_value     = fw_ep_st_1[3:130];
    assign fw_ep_st_1_wrt_en_ep    = fw_ep_st_1[131];
    assign fw_ep_st_1_rt_address   = fw_ep_st_1[132:138];
    assign fw_ep_st_1_unit_latency = fw_ep_st_1[139:142];

    assign fw_ep_st_2_unitid       = fw_ep_st_2[0:2];
    assign fw_ep_st_2_rt_value     = fw_ep_st_2[3:130];
    assign fw_ep_st_2_wrt_en_ep    = fw_ep_st_2[131];
    assign fw_ep_st_2_rt_address   = fw_ep_st_2[132:138];
    assign fw_ep_st_2_unit_latency = fw_ep_st_2[139:142];

    assign fw_ep_st_3_unitid       = fw_ep_st_3[0:2];
    assign fw_ep_st_3_rt_value     = fw_ep_st_3[3:130];
    assign fw_ep_st_3_wrt_en_ep    = fw_ep_st_3[131];
    assign fw_ep_st_3_rt_address   = fw_ep_st_3[132:138];
    assign fw_ep_st_3_unit_latency = fw_ep_st_3[139:142];

    assign fw_ep_st_4_unitid       = fw_ep_st_4[0:2];
    assign fw_ep_st_4_rt_value     = fw_ep_st_4[3:130];
    assign fw_ep_st_4_wrt_en_ep    = fw_ep_st_4[131];
    assign fw_ep_st_4_rt_address   = fw_ep_st_4[132:138];
    assign fw_ep_st_4_unit_latency = fw_ep_st_4[139:142];

    assign fw_ep_st_5_unitid       = fw_ep_st_5[0:2];
    assign fw_ep_st_5_rt_value     = fw_ep_st_5[3:130];
    assign fw_ep_st_5_wrt_en_ep    = fw_ep_st_5[131];
    assign fw_ep_st_5_rt_address   = fw_ep_st_5[132:138];
    assign fw_ep_st_5_unit_latency = fw_ep_st_5[139:142];

    assign fw_ep_st_6_unitid       = fw_ep_st_6[0:2];
    assign fw_ep_st_6_rt_value     = fw_ep_st_6[3:130];
    assign fw_ep_st_6_wrt_en_ep    = fw_ep_st_6[131];
    assign fw_ep_st_6_rt_address   = fw_ep_st_6[132:138];
    assign fw_ep_st_6_unit_latency = fw_ep_st_6[139:142];

    assign fw_ep_st_7_unitid       = fw_ep_st_7[0:2];
    assign fw_ep_st_7_rt_value     = fw_ep_st_7[3:130];
    assign fw_ep_st_7_wrt_en_ep    = fw_ep_st_7[131];
    assign fw_ep_st_7_rt_address   = fw_ep_st_7[132:138];
    assign fw_ep_st_7_unit_latency = fw_ep_st_7[139:142]; 

    assign fw_op_st_1_unitid       = fw_op_st_1[0:2];
    assign fw_op_st_1_rt_value     = fw_op_st_1[3:130];
    assign fw_op_st_1_wrt_en_op    = fw_op_st_1[131];
    assign fw_op_st_1_rt_address   = fw_op_st_1[132:138];
    assign fw_op_st_1_unit_latency = fw_op_st_1[139:142];

    assign fw_op_st_2_unitid       = fw_op_st_2[0:2];
    assign fw_op_st_2_rt_value     = fw_op_st_2[3:130];
    assign fw_op_st_2_wrt_en_op    = fw_op_st_2[131];
    assign fw_op_st_2_rt_address   = fw_op_st_2[132:138];
    assign fw_op_st_2_unit_latency = fw_op_st_2[139:142];

    assign fw_op_st_3_unitid       = fw_op_st_3[0:2];
    assign fw_op_st_3_rt_value     = fw_op_st_3[3:130];
    assign fw_op_st_3_wrt_en_op    = fw_op_st_3[131];
    assign fw_op_st_3_rt_address   = fw_op_st_3[132:138];
    assign fw_op_st_3_unit_latency = fw_op_st_3[139:142];

    assign fw_op_st_4_unitid       = fw_op_st_4[0:2];
    assign fw_op_st_4_rt_value     = fw_op_st_4[3:130];
    assign fw_op_st_4_wrt_en_op    = fw_op_st_4[131];
    assign fw_op_st_4_rt_address   = fw_op_st_4[132:138];
    assign fw_op_st_4_unit_latency = fw_op_st_4[139:142];

    assign fw_op_st_5_unitid       = fw_op_st_5[0:2];
    assign fw_op_st_5_rt_value     = fw_op_st_5[3:130];
    assign fw_op_st_5_wrt_en_op    = fw_op_st_5[131];
    assign fw_op_st_5_rt_address   = fw_op_st_5[132:138];
    assign fw_op_st_5_unit_latency = fw_op_st_5[139:142];

    assign fw_op_st_6_unitid       = fw_op_st_6[0:2];
    assign fw_op_st_6_rt_value     = fw_op_st_6[3:130];
    assign fw_op_st_6_wrt_en_op    = fw_op_st_6[131];
    assign fw_op_st_6_rt_address   = fw_op_st_6[132:138];
    assign fw_op_st_6_unit_latency = fw_op_st_6[139:142];

    assign fw_op_st_7_unitid       = fw_op_st_7[0:2];
    assign fw_op_st_7_rt_value     = fw_op_st_7[3:130];
    assign fw_op_st_7_wrt_en_op    = fw_op_st_7[131];
    assign fw_op_st_7_rt_address   = fw_op_st_7[132:138];
    assign fw_op_st_7_unit_latency = fw_op_st_7[139:142];

    always_ff @(posedge clock) begin
        if(reset==1 || flush==1) begin
            ra_value_fw_ep <= 0;
            rb_value_fw_ep <= 0;
            rc_value_fw_ep <= 0;
            ra_value_fw_op <= 0;
            rb_value_fw_op <= 0;
            rt_fw_ep_address <= 0;
            rt_fw_op_address <= 0;

        end
        else begin 
            ra_value_fw_ep <= ra_value_fw_ep_temp;
            rb_value_fw_ep <= rb_value_fw_ep_temp;
            rc_value_fw_ep <= rc_value_fw_ep_temp;
            ra_value_fw_op <= ra_value_fw_op_temp;
            rb_value_fw_op <= rb_value_fw_op_temp;
            rt_fw_ep_address <= rt_address_ep;
            rt_fw_op_address <= rt_address_op;
        end
    end    

    always_comb begin 
        /* Forwarding logic to forward ra in even pipe */
            if((fw_op_st_1_rt_address == ra_address_ep) && (fw_op_st_1_wrt_en_op == 1) && (fw_op_st_1_unit_latency==4'd1)) begin
                ra_value_fw_ep_temp = fw_op_st_1_rt_value;
            end
            else if((fw_op_st_2_rt_address == ra_address_ep) && (fw_op_st_2_wrt_en_op == 1) && (fw_op_st_2_unit_latency==4'd1)) begin
                ra_value_fw_ep_temp = fw_op_st_2_rt_value;
            end
            else if((fw_ep_st_3_rt_address == ra_address_ep) && (fw_ep_st_3_wrt_en_ep == 1) && (fw_ep_st_3_unit_latency==4'd3)) begin
                ra_value_fw_ep_temp = fw_ep_st_3_rt_value;
            end
            else if((fw_op_st_3_rt_address == ra_address_ep) && (fw_op_st_3_wrt_en_op == 1) && (fw_op_st_3_unit_latency==4'd1)) begin
                ra_value_fw_ep_temp = fw_op_st_3_rt_value;
            end
            else if((fw_ep_st_4_rt_address == ra_address_ep) && (fw_ep_st_4_wrt_en_ep == 1) && (fw_ep_st_4_unit_latency==4'd3 || fw_ep_st_4_unit_latency==4'd4)) begin
                ra_value_fw_ep_temp = fw_ep_st_4_rt_value;
            end
            else if((fw_op_st_4_rt_address == ra_address_ep) && (fw_op_st_4_wrt_en_op == 1) && (fw_op_st_4_unit_latency==4'd1 || fw_op_st_4_unit_latency==4'd4)) begin
                ra_value_fw_ep_temp = fw_op_st_4_rt_value;
            end
            else if((fw_ep_st_5_rt_address == ra_address_ep) && (fw_ep_st_5_wrt_en_ep == 1) && (fw_ep_st_5_unit_latency==4'd3 || fw_ep_st_5_unit_latency==4'd4)) begin
                ra_value_fw_ep_temp = fw_ep_st_5_rt_value;
            end
            else if((fw_op_st_5_rt_address == ra_address_ep) && (fw_op_st_5_wrt_en_op == 1) && (fw_op_st_5_unit_latency==4'd1 || fw_op_st_5_unit_latency==4'd4)) begin
                ra_value_fw_ep_temp = fw_op_st_5_rt_value;
            end
            else if((fw_ep_st_6_rt_address == ra_address_ep) && (fw_ep_st_6_wrt_en_ep == 1) && (fw_ep_st_6_unit_latency==4'd3 || fw_ep_st_6_unit_latency==4'd4)) begin
                ra_value_fw_ep_temp = fw_ep_st_6_rt_value;
            end
            else if((fw_op_st_6_rt_address == ra_address_ep) && (fw_op_st_6_wrt_en_op == 1) && (fw_op_st_6_unit_latency==4'd1 || fw_op_st_6_unit_latency==4'd4)) begin
                ra_value_fw_ep_temp = fw_op_st_6_rt_value;
            end
            else if((fw_ep_st_7_rt_address == ra_address_ep) && (fw_ep_st_7_wrt_en_ep == 1) && (fw_ep_st_7_unit_latency==4'd3 || fw_ep_st_7_unit_latency==4'd4 || fw_ep_st_7_unit_latency==4'd7)) begin
                ra_value_fw_ep_temp = fw_ep_st_7_rt_value;
            end
            else if((fw_op_st_7_rt_address == ra_address_ep) && (fw_op_st_7_wrt_en_op == 1) && (fw_op_st_7_unit_latency==4'd1 || fw_op_st_7_unit_latency==4'd4 || fw_op_st_7_unit_latency==4'd7)) begin
                ra_value_fw_ep_temp = fw_op_st_7_rt_value;
            end
            else begin
                ra_value_fw_ep_temp = ra_value_ep;
            end

            /* Forwarding logic to forward ra in odd pipe */
            if((fw_op_st_1_rt_address == ra_address_op) && (fw_op_st_1_wrt_en_op == 1) && (fw_op_st_1_unit_latency==4'd1)) begin
                ra_value_fw_op_temp = fw_op_st_1_rt_value;
            end
            else if((fw_op_st_2_rt_address == ra_address_op) && (fw_op_st_2_wrt_en_op == 1) && (fw_op_st_2_unit_latency==4'd1)) begin
                ra_value_fw_op_temp = fw_op_st_2_rt_value;
            end
            else if((fw_op_st_3_rt_address == ra_address_op) && (fw_op_st_3_wrt_en_op == 1) && (fw_op_st_3_unit_latency==4'd1)) begin
                ra_value_fw_op_temp = fw_op_st_3_rt_value;
            end
            else if((fw_ep_st_3_rt_address == ra_address_op) && (fw_ep_st_3_wrt_en_ep == 1) && (fw_ep_st_3_unit_latency==4'd3)) begin
                ra_value_fw_op_temp = fw_ep_st_3_rt_value;
            end
            else if((fw_op_st_4_rt_address == ra_address_op) && (fw_op_st_4_wrt_en_op == 1) && (fw_op_st_4_unit_latency==4'd1 || fw_op_st_4_unit_latency==4'd4)) begin
                ra_value_fw_op_temp = fw_op_st_4_rt_value;
            end
            else if((fw_ep_st_4_rt_address == ra_address_op) && (fw_ep_st_4_wrt_en_ep == 1) && (fw_ep_st_4_unit_latency==4'd3 || fw_ep_st_4_unit_latency==4'd4)) begin
                ra_value_fw_op_temp = fw_ep_st_4_rt_value;
            end
            else if((fw_op_st_5_rt_address == ra_address_op) && (fw_op_st_5_wrt_en_op == 1) && (fw_op_st_5_unit_latency==4'd1 || fw_op_st_5_unit_latency==4'd4)) begin
                ra_value_fw_op_temp = fw_op_st_5_rt_value;
            end
            else if((fw_ep_st_5_rt_address == ra_address_op) && (fw_ep_st_5_wrt_en_ep == 1) && (fw_ep_st_5_unit_latency==4'd3 || fw_ep_st_5_unit_latency==4'd4)) begin
                ra_value_fw_op_temp = fw_ep_st_5_rt_value;
            end
            else if((fw_op_st_6_rt_address == ra_address_op) && (fw_op_st_6_wrt_en_op == 1) && (fw_op_st_6_unit_latency==4'd1 || fw_op_st_6_unit_latency==4'd4)) begin
                ra_value_fw_op_temp = fw_op_st_6_rt_value;
            end
            else if((fw_ep_st_6_rt_address == ra_address_op) && (fw_ep_st_6_wrt_en_ep == 1) && (fw_ep_st_6_unit_latency==4'd3 || fw_ep_st_6_unit_latency==4'd4)) begin
                ra_value_fw_op_temp = fw_ep_st_6_rt_value;
            end
            else if((fw_op_st_7_rt_address == ra_address_op) && (fw_op_st_7_wrt_en_op == 1) && (fw_op_st_7_unit_latency==4'd1 || fw_op_st_7_unit_latency==4'd4 || fw_op_st_7_unit_latency==4'd7)) begin
                ra_value_fw_op_temp = fw_op_st_7_rt_value;
            end
            else if((fw_ep_st_7_rt_address == ra_address_op) && (fw_ep_st_7_wrt_en_ep == 1) && (fw_ep_st_7_unit_latency==4'd3 || fw_ep_st_6_unit_latency==4'd4 || fw_ep_st_7_unit_latency==4'd7)) begin
                ra_value_fw_op_temp = fw_ep_st_7_rt_value;
            end
            else begin
                ra_value_fw_op_temp = ra_value_op;
            end

        /* Forwarding logic to forward rb in even pipe */ 

            if((fw_op_st_1_rt_address == rb_address_ep) && (fw_op_st_1_wrt_en_op == 1) && (fw_op_st_1_unit_latency==4'd1)) begin
                rb_value_fw_ep_temp = fw_op_st_1_rt_value;
            end
            else if((fw_op_st_2_rt_address == rb_address_ep) && (fw_op_st_2_wrt_en_op == 1) && (fw_op_st_2_unit_latency==4'd1)) begin
                rb_value_fw_ep_temp = fw_op_st_2_rt_value;
            end
            else if((fw_ep_st_3_rt_address == rb_address_ep) && (fw_ep_st_3_wrt_en_ep == 1) && (fw_ep_st_3_unit_latency==4'd3)) begin
                rb_value_fw_ep_temp = fw_ep_st_3_rt_value;
            end
            else if((fw_op_st_3_rt_address == rb_address_ep) && (fw_op_st_3_wrt_en_op == 1) && (fw_op_st_3_unit_latency==4'd1)) begin
                rb_value_fw_ep_temp = fw_op_st_3_rt_value;
            end
            else if((fw_ep_st_4_rt_address == rb_address_ep) && (fw_ep_st_4_wrt_en_ep == 1) && (fw_ep_st_4_unit_latency==4'd3 || fw_ep_st_4_unit_latency==4'd4)) begin
                rb_value_fw_ep_temp = fw_ep_st_4_rt_value;
            end
            else if((fw_op_st_4_rt_address == rb_address_ep) && (fw_op_st_4_wrt_en_op == 1) && (fw_op_st_4_unit_latency==4'd1 || fw_op_st_4_unit_latency==4'd4)) begin
                rb_value_fw_ep_temp = fw_op_st_4_rt_value;
            end
            else if((fw_ep_st_5_rt_address == rb_address_ep) && (fw_ep_st_5_wrt_en_ep == 1) && (fw_ep_st_5_unit_latency==4'd3 || fw_ep_st_5_unit_latency==4'd4)) begin
                rb_value_fw_ep_temp = fw_ep_st_5_rt_value;
            end
            else if((fw_op_st_5_rt_address == rb_address_ep) && (fw_op_st_5_wrt_en_op == 1) && (fw_op_st_5_unit_latency==4'd1 || fw_op_st_5_unit_latency==4'd4)) begin
                rb_value_fw_ep_temp = fw_op_st_5_rt_value;
            end
            else if((fw_ep_st_6_rt_address == rb_address_ep) && (fw_ep_st_6_wrt_en_ep == 1) && (fw_ep_st_6_unit_latency==4'd3 || fw_ep_st_6_unit_latency==4'd4)) begin
                rb_value_fw_ep_temp = fw_ep_st_6_rt_value;
            end
            else if((fw_op_st_6_rt_address == rb_address_ep) && (fw_op_st_6_wrt_en_op == 1) && (fw_op_st_6_unit_latency==4'd1 || fw_op_st_6_unit_latency==4'd4)) begin
                rb_value_fw_ep_temp = fw_op_st_6_rt_value;
            end
            else if((fw_ep_st_7_rt_address == rb_address_ep) && (fw_ep_st_7_wrt_en_ep == 1) && (fw_ep_st_7_unit_latency==4'd3 || fw_ep_st_7_unit_latency==4'd4 || fw_ep_st_7_unit_latency==4'd7)) begin
                rb_value_fw_ep_temp = fw_ep_st_7_rt_value;
            end
            else if((fw_op_st_7_rt_address == rb_address_ep) && (fw_op_st_7_wrt_en_op == 1) && (fw_op_st_7_unit_latency==4'd1 || fw_op_st_7_unit_latency==4'd4 || fw_op_st_7_unit_latency==4'd7)) begin
                rb_value_fw_ep_temp = fw_op_st_7_rt_value;
            end
            else begin
                rb_value_fw_ep_temp = rb_value_ep;
            end

        /* Forwarding logic to forward rb in odd pipe */
            if((fw_op_st_1_rt_address == rb_address_op) && (fw_op_st_1_wrt_en_op == 1) && (fw_op_st_1_unit_latency==4'd1)) begin
                rb_value_fw_op_temp = fw_op_st_1_rt_value;
            end
            else if((fw_op_st_2_rt_address == rb_address_op) && (fw_op_st_2_wrt_en_op == 1) && (fw_op_st_2_unit_latency==4'd1)) begin
                rb_value_fw_op_temp = fw_op_st_2_rt_value;
            end
            else if((fw_op_st_3_rt_address == rb_address_op) && (fw_op_st_3_wrt_en_op == 1) && (fw_op_st_3_unit_latency==4'd1)) begin
                rb_value_fw_op_temp = fw_op_st_3_rt_value;
            end
            else if((fw_ep_st_3_rt_address == rb_address_op) && (fw_ep_st_3_wrt_en_ep == 1) && (fw_ep_st_3_unit_latency==4'd3)) begin
                rb_value_fw_op_temp = fw_ep_st_3_rt_value;
            end
            else if((fw_op_st_4_rt_address == rb_address_op) && (fw_op_st_4_wrt_en_op == 1) && (fw_op_st_4_unit_latency==4'd1 || fw_op_st_4_unit_latency==4'd4)) begin
                rb_value_fw_op_temp = fw_op_st_4_rt_value;
            end
            else if((fw_ep_st_4_rt_address == rb_address_op) && (fw_ep_st_4_wrt_en_ep == 1) && (fw_ep_st_4_unit_latency==4'd3 || fw_ep_st_4_unit_latency==4'd4)) begin
                rb_value_fw_op_temp = fw_ep_st_4_rt_value;
            end
            else if((fw_op_st_5_rt_address == rb_address_op) && (fw_op_st_5_wrt_en_op == 1) && (fw_op_st_5_unit_latency==4'd1 || fw_op_st_5_unit_latency==4'd4)) begin
                rb_value_fw_op_temp = fw_op_st_5_rt_value;
            end
            else if((fw_ep_st_5_rt_address == rb_address_op) && (fw_ep_st_5_wrt_en_ep == 1) && (fw_ep_st_5_unit_latency==4'd3 || fw_ep_st_5_unit_latency==4'd4)) begin
                rb_value_fw_op_temp = fw_ep_st_5_rt_value;
            end
            else if((fw_op_st_6_rt_address == rb_address_op) && (fw_op_st_6_wrt_en_op == 1) && (fw_op_st_6_unit_latency==4'd1 || fw_op_st_6_unit_latency==4'd4)) begin
                rb_value_fw_op_temp = fw_op_st_6_rt_value;
            end
            else if((fw_ep_st_6_rt_address == rb_address_op) && (fw_ep_st_6_wrt_en_ep == 1) && (fw_ep_st_6_unit_latency==4'd3 || fw_ep_st_6_unit_latency==4'd4)) begin
                rb_value_fw_op_temp = fw_ep_st_6_rt_value;
            end
            else if((fw_op_st_7_rt_address == rb_address_op) && (fw_op_st_7_wrt_en_op == 1) && (fw_op_st_7_unit_latency==4'd1 || fw_op_st_7_unit_latency==4'd4 || fw_op_st_7_unit_latency==4'd7 )) begin
                rb_value_fw_op_temp = fw_op_st_7_rt_value;
            end
            else if((fw_ep_st_7_rt_address == rb_address_op) && (fw_ep_st_7_wrt_en_ep == 1) && (fw_ep_st_7_unit_latency==4'd3 || fw_ep_st_6_unit_latency==4'd4 || fw_ep_st_7_unit_latency==4'd7)) begin
                rb_value_fw_op_temp = fw_ep_st_7_rt_value;
            end
            else begin
                rb_value_fw_op_temp = rb_value_op;
            end

        /* Forwarding logic to forward rc in even pipe */
            if((fw_op_st_1_rt_address == rc_address_ep) && (fw_op_st_1_wrt_en_op == 1) && (fw_op_st_1_unit_latency==4'd1)) begin
                rc_value_fw_ep_temp = fw_op_st_1_rt_value;
            end
            else if((fw_op_st_2_rt_address == rc_address_ep) && (fw_op_st_2_wrt_en_op == 1) && (fw_op_st_2_unit_latency==4'd1)) begin
                rc_value_fw_ep_temp = fw_op_st_2_rt_value;
            end
            else if((fw_ep_st_3_rt_address == rc_address_ep) && (fw_ep_st_3_wrt_en_ep == 1) && (fw_ep_st_3_unit_latency==4'd3)) begin
                rc_value_fw_ep_temp = fw_ep_st_3_rt_value;
            end
            else if((fw_op_st_3_rt_address == rc_address_ep) && (fw_op_st_3_wrt_en_op == 1) && (fw_op_st_3_unit_latency==4'd1)) begin
                rc_value_fw_ep_temp = fw_op_st_3_rt_value;
            end
            else if((fw_ep_st_4_rt_address == rc_address_ep) && (fw_ep_st_4_wrt_en_ep == 1) && (fw_ep_st_4_unit_latency==4'd3 || fw_ep_st_4_unit_latency==4'd4)) begin
                rc_value_fw_ep_temp = fw_ep_st_4_rt_value;
            end
            else if((fw_op_st_4_rt_address == rc_address_ep) && (fw_op_st_4_wrt_en_op == 1) && (fw_op_st_4_unit_latency==4'd1 || fw_op_st_4_unit_latency==4'd4)) begin
                rc_value_fw_ep_temp = fw_op_st_4_rt_value;
            end
            else if((fw_ep_st_5_rt_address == rc_address_ep) && (fw_ep_st_5_wrt_en_ep == 1) && (fw_ep_st_5_unit_latency==4'd3 || fw_ep_st_5_unit_latency==4'd4)) begin
                rc_value_fw_ep_temp = fw_ep_st_5_rt_value;
            end
            else if((fw_op_st_5_rt_address == rc_address_ep) && (fw_op_st_5_wrt_en_op == 1) && (fw_op_st_5_unit_latency==4'd1 || fw_op_st_5_unit_latency==4'd4)) begin
                rc_value_fw_ep_temp = fw_op_st_5_rt_value;
            end
            else if((fw_ep_st_6_rt_address == rc_address_ep) && (fw_ep_st_6_wrt_en_ep == 1) && (fw_ep_st_6_unit_latency==4'd3 || fw_ep_st_6_unit_latency==4'd4)) begin
                rc_value_fw_ep_temp = fw_ep_st_6_rt_value;
            end
            else if((fw_op_st_6_rt_address == rc_address_ep) && (fw_op_st_6_wrt_en_op == 1) && (fw_op_st_6_unit_latency==4'd1 || fw_op_st_6_unit_latency==4'd4)) begin
                rc_value_fw_ep_temp = fw_op_st_6_rt_value;
            end
            else if((fw_ep_st_7_rt_address == rc_address_ep) && (fw_ep_st_7_wrt_en_ep == 1) && (fw_ep_st_7_unit_latency==4'd3 || fw_ep_st_7_unit_latency==4'd4 || fw_ep_st_7_unit_latency==4'd7)) begin
                rc_value_fw_ep_temp = fw_ep_st_7_rt_value;
            end
            else if((fw_op_st_7_rt_address == rc_address_ep) && (fw_op_st_7_wrt_en_op == 1) && (fw_op_st_7_unit_latency==4'd1 || fw_op_st_7_unit_latency==4'd4 || fw_op_st_7_unit_latency==4'd7)) begin
                rc_value_fw_ep_temp = fw_op_st_7_rt_value;
            end
            else begin
                rc_value_fw_ep_temp = rc_value_ep;
            end         
    end

endmodule