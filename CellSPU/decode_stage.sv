import descriptions::*;

module decode_stage(
    input clock,
    input reset,
    input flush,
    input [0:31] first_inst_input,
    input [0:31] second_inst_input,
    input [0:6] rt_ep_address,
    input [0:6] rt_op_address,
    input logic [0:6] rt_fw_stage_ep_address,
    input logic [0:6] rt_fw_stage_op_address,
    input logic wrt_en_fw_ep,
    input logic wrt_en_fw_op,
    input logic wrt_fw_stage_ep_in,
    input logic wrt_fw_stage_op_in,
    input logic [0:142] fw_ep_st_1,
    input logic [0:142] fw_ep_st_2,
    input logic [0:142] fw_ep_st_3,
    input logic [0:142] fw_ep_st_4,
    input logic [0:142] fw_ep_st_5,
    input logic [0:142] fw_ep_st_6,
    input logic [0:142] fw_ep_st_7,
    input logic [0:142] fw_op_st_1,
    input logic [0:142] fw_op_st_2,
    input logic [0:142] fw_op_st_3,
    input logic [0:142] fw_op_st_4,
    input logic [0:142] fw_op_st_5,
    input logic [0:142] fw_op_st_6,
    input logic [0:142] fw_op_st_7,

    input logic [0:31] pc_decode_in,

    output opcode opcode_instruction_even,
    output logic [0:6] ra_even_address,
    output logic [0:6] rb_even_address,
    output logic [0:6] rc_even_address,
    output logic [0:6] rt_even_address,
    output logic [0:6] I7_even,
    output logic [0:9] I10_even,
    output logic [0:15] I16_even,
    output logic [0:17] I18_even,

    output opcode opcode_instruction_odd,
    output logic [0:6] ra_odd_address,
    output logic [0:6] rb_odd_address,
    output logic [0:6] rt_odd_address,
    output logic [0:6] I7_odd,
    output logic [0:9] I10_odd,
    output logic [0:15] I16_odd,
    output logic [0:17] I18_odd,

    output logic stall,
    output logic dependency_stall_1,
    output logic dependency_stall_2,
    output logic previous_stall,
    output logic wrt_en_decode_ep,
    output logic wrt_en_decode_op,
    
    output logic [0:31] pc_decode_out,
    output logic branch_is_first_inst
);
    logic [0:31] first_inst;
    logic [0:31] second_inst;

    logic [0:3] first_inst_4;
    logic [0:6] first_inst_7;
    logic [0:7] first_inst_8;
    logic [0:8] first_inst_9;
    logic [0:10] first_inst_11;

    logic [0:3] second_inst_4;
    logic [0:6] second_inst_7;
    logic [0:7] second_inst_8;
    logic [0:8] second_inst_9;
    logic [0:10] second_inst_11;

    logic ep_inst1_flag;
    logic op_inst1_flag;
    logic ep_inst2_flag;
    logic op_inst2_flag;

    opcode ep_opcode_1;
    opcode ep_opcode_2;
    opcode op_opcode_1;
    opcode op_opcode_2;

    logic [0:6] rt_1_address;
    logic [0:6] ra_1_address;
    logic [0:6] rc_1_address;
    logic [0:6] rb_1_address;

    logic [0:6] rt_2_address;
    logic [0:6] ra_2_address;
    logic [0:6] rb_2_address;
    logic [0:6] rc_2_address;

    logic [0:17] ep_I18_1;
    logic [0:15] ep_I16_1;
    logic [0:9] ep_I10_1;
    logic [0:6] ep_I7_1;
    logic [0:17] ep_I18_2;
    logic [0:15] ep_I16_2;
    logic [0:9] ep_I10_2;
    logic [0:6] ep_I7_2;

    logic [0:17] op_I18_1;
    logic [0:15] op_I16_1;
    logic [0:9] op_I10_1;
    logic [0:6] op_I7_1;
    logic [0:17] op_I18_2;
    logic [0:15] op_I16_2;
    logic [0:9] op_I10_2;
    logic [0:6] op_I7_2;

    opcode opcode_instruction_even_temporary;
    logic [0:6] ra_even_address_temporary;
    logic [0:6] rb_even_address_temporary;
    logic [0:6] rc_even_address_temporary;
    logic [0:6] rt_even_address_temporary;
    logic [0:6] I7_even_temporary;
    logic [0:9] I10_even_temporary;
    logic [0:15] I16_even_temporary;
    logic [0:17] I18_even_temporary;

    opcode opcode_instruction_odd_temporary;
    logic [0:6] ra_odd_address_temporary;
    logic [0:6] rb_odd_address_temporary;
    logic [0:6] rt_odd_address_temporary;
    logic [0:6] I7_odd_temporary;
    logic [0:9] I10_odd_temporary;
    logic [0:15] I16_odd_temporary;
    logic [0:17] I18_odd_temporary;
    logic wrt_en_decode_1;
    logic wrt_en_decode_2;


    /* wrt enables are not there for 
        -store
        -all branches except set links 
        -no operations 

    */      
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

    always_comb  begin
        if(reset==1) begin 
            first_inst = {11'b01000000001,21'd0}; 
            second_inst = {11'b00000000001,21'd0};
        end
        else begin 
            first_inst = first_inst_input;
            second_inst = second_inst_input;
        end
    end

    always_comb begin
        first_inst_4 = first_inst[0:3];
        first_inst_7 = first_inst[0:6];
        first_inst_8 = first_inst[0:7];
        first_inst_9 = first_inst[0:8];
        first_inst_11 = first_inst[0:10];

        second_inst_4 = second_inst[0:3];
        second_inst_7 = second_inst[0:6];
        second_inst_8 = second_inst[0:7];
        second_inst_9 = second_inst[0:8];
        second_inst_11 = second_inst[0:10];
    end

    always_comb begin // Combinational Logic for RAW hazard
        dependency_stall_1 = 0;
        dependency_stall_2 = 0;
        stall = 0;
        if( // RAW hazard check for instruction 1
            (   (ra_1_address == rt_ep_address) ||
                (rb_1_address == rt_ep_address) ||
                (rc_1_address == rt_ep_address) ||
                (ra_1_address == rt_op_address) ||
                (rb_1_address == rt_op_address) ||
                (rc_1_address == rt_op_address)
            ) ||
            (
                (wrt_fw_stage_ep_in == 1 && (ra_1_address == rt_fw_stage_ep_address)) ||
                (wrt_fw_stage_ep_in == 1 && (rb_1_address == rt_fw_stage_ep_address)) ||
                (wrt_fw_stage_ep_in == 1 && (rc_1_address == rt_fw_stage_ep_address)) ||
                (wrt_fw_stage_op_in == 1 && (ra_1_address == rt_fw_stage_op_address)) ||
                (wrt_fw_stage_op_in == 1 && (rb_1_address == rt_fw_stage_op_address)) ||
                (wrt_fw_stage_op_in == 1 && (rc_1_address == rt_fw_stage_op_address))
            ) ||
            (   ((ra_1_address == fw_ep_st_1_rt_address) && (fw_ep_st_1_wrt_en_ep == 1)) ||
                ((ra_1_address == fw_ep_st_2_rt_address) && (fw_ep_st_2_wrt_en_ep == 1) && (fw_ep_st_2_unit_latency > 4'd3)) ||
                ((ra_1_address == fw_ep_st_3_rt_address) && (fw_ep_st_3_wrt_en_ep == 1) && (fw_ep_st_3_unit_latency > 4'd4)) || 
                ((ra_1_address == fw_ep_st_4_rt_address) && (fw_ep_st_4_wrt_en_ep == 1) && (fw_ep_st_4_unit_latency > 4'd5)) || 
                ((ra_1_address == fw_ep_st_5_rt_address) && (fw_ep_st_5_wrt_en_ep == 1) && (fw_ep_st_5_unit_latency > 4'd6)) ||
                ((ra_1_address == fw_ep_st_6_rt_address) && (fw_ep_st_6_wrt_en_ep == 1) && (fw_ep_st_6_unit_latency > 4'd7))
            ) ||
            (   ((rb_1_address == fw_ep_st_1_rt_address) && (fw_ep_st_1_wrt_en_ep == 1)) ||
                ((rb_1_address == fw_ep_st_2_rt_address) && (fw_ep_st_2_wrt_en_ep == 1) && (fw_ep_st_2_unit_latency > 4'd3)) ||
                ((rb_1_address == fw_ep_st_3_rt_address) && (fw_ep_st_3_wrt_en_ep == 1) && (fw_ep_st_3_unit_latency > 4'd4)) || 
                ((rb_1_address == fw_ep_st_4_rt_address) && (fw_ep_st_4_wrt_en_ep == 1) && (fw_ep_st_4_unit_latency > 4'd5)) || 
                ((rb_1_address == fw_ep_st_5_rt_address) && (fw_ep_st_5_wrt_en_ep == 1) && (fw_ep_st_5_unit_latency > 4'd6)) ||
                ((rb_1_address == fw_ep_st_6_rt_address) && (fw_ep_st_6_wrt_en_ep == 1) && (fw_ep_st_6_unit_latency > 4'd7))
            ) ||
            (   ((rc_1_address == fw_ep_st_1_rt_address) && (fw_ep_st_1_wrt_en_ep == 1)) ||
                ((rc_1_address == fw_ep_st_2_rt_address) && (fw_ep_st_2_wrt_en_ep == 1) && (fw_ep_st_2_unit_latency > 4'd3)) ||
                ((rc_1_address == fw_ep_st_3_rt_address) && (fw_ep_st_3_wrt_en_ep == 1) && (fw_ep_st_3_unit_latency > 4'd4)) || 
                ((rc_1_address == fw_ep_st_4_rt_address) && (fw_ep_st_4_wrt_en_ep == 1) && (fw_ep_st_4_unit_latency > 4'd5)) || 
                ((rc_1_address == fw_ep_st_5_rt_address) && (fw_ep_st_5_wrt_en_ep == 1) && (fw_ep_st_5_unit_latency > 4'd6)) ||
                ((rc_1_address == fw_ep_st_6_rt_address) && (fw_ep_st_6_wrt_en_ep == 1) && (fw_ep_st_6_unit_latency > 4'd7))
            ) || 
            (   ((ra_1_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((ra_1_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((ra_1_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_op == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((ra_1_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_op == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((ra_1_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_op == 1) && (fw_op_st_5_unit_latency > 4'd6)) 
            ) ||
            (   ((rb_1_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((rb_1_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((rb_1_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_op == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((rb_1_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_op == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((rb_1_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_op == 1) && (fw_op_st_5_unit_latency > 4'd6)) 
            ) ||
            (   ((rc_1_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((rc_1_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((rc_1_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_op == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((rc_1_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_op == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((rc_1_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_op == 1) && (fw_op_st_5_unit_latency > 4'd6)) 
            )
            ) begin
                dependency_stall_1 = 1;
                $display("hello dep stall 1");
        end
        
        else begin
            dependency_stall_1 = 0;
        end

        if( // RAW hazard check for instruction 2
                (((previous_stall == 0) && (wrt_en_decode_1 == 1) && (ra_2_address == rt_1_address)) ||
                 ((previous_stall == 0) && (wrt_en_decode_1 == 1) && (rb_2_address == rt_1_address)) || 
                 ((previous_stall == 0) && (wrt_en_decode_1 == 1) && (rc_2_address == rt_1_address))  
            ) ||
            (   (wrt_en_fw_ep == 1 && (ra_2_address == rt_ep_address)) ||
                (wrt_en_fw_ep == 1 && (rb_2_address == rt_ep_address)) ||
                (wrt_en_fw_ep == 1 && (rc_2_address == rt_ep_address)) ||
                (wrt_en_fw_op == 1 && (ra_2_address == rt_op_address)) ||
                (wrt_en_fw_op == 1 && (rb_2_address == rt_op_address)) ||
                (wrt_en_fw_op == 1 && (rc_2_address == rt_op_address)) 
            ) ||
            (
                (wrt_fw_stage_ep_in == 1 && (ra_2_address == rt_fw_stage_ep_address)) ||
                (wrt_fw_stage_ep_in == 1 && (rb_2_address == rt_fw_stage_ep_address)) ||
                (wrt_fw_stage_ep_in == 1 && (rc_2_address == rt_fw_stage_ep_address)) ||
                (wrt_fw_stage_op_in == 1 && (ra_2_address == rt_fw_stage_op_address)) ||
                (wrt_fw_stage_op_in == 1 && (rb_2_address == rt_fw_stage_op_address)) ||
                (wrt_fw_stage_op_in == 1 && (rc_2_address == rt_fw_stage_op_address))
            ) ||
            (   ((ra_2_address == fw_ep_st_1_rt_address) && (fw_ep_st_1_wrt_en_ep == 1)) ||
                ((ra_2_address == fw_ep_st_2_rt_address) && (fw_ep_st_2_wrt_en_ep == 1) && (fw_ep_st_2_unit_latency > 4'd3)) ||
                ((ra_2_address == fw_ep_st_3_rt_address) && (fw_ep_st_3_wrt_en_ep == 1) && (fw_ep_st_3_unit_latency > 4'd4)) || 
                ((ra_2_address == fw_ep_st_4_rt_address) && (fw_ep_st_4_wrt_en_ep == 1) && (fw_ep_st_4_unit_latency > 4'd5)) || 
                ((ra_2_address == fw_ep_st_5_rt_address) && (fw_ep_st_5_wrt_en_ep == 1) && (fw_ep_st_5_unit_latency > 4'd6)) ||
                ((ra_2_address == fw_ep_st_6_rt_address) && (fw_ep_st_6_wrt_en_ep == 1) && (fw_ep_st_6_unit_latency > 4'd7))
            ) ||
            (   ((rb_2_address == fw_ep_st_1_rt_address) && (fw_ep_st_1_wrt_en_ep == 1)) ||
                ((rb_2_address == fw_ep_st_2_rt_address) && (fw_ep_st_2_wrt_en_ep == 1) && (fw_ep_st_2_unit_latency > 4'd3)) ||
                ((rb_2_address == fw_ep_st_3_rt_address) && (fw_ep_st_3_wrt_en_ep == 1) && (fw_ep_st_3_unit_latency > 4'd4)) || 
                ((rb_2_address == fw_ep_st_4_rt_address) && (fw_ep_st_4_wrt_en_ep == 1) && (fw_ep_st_4_unit_latency > 4'd5)) || 
                ((rb_2_address == fw_ep_st_5_rt_address) && (fw_ep_st_5_wrt_en_ep == 1) && (fw_ep_st_5_unit_latency > 4'd6)) ||
                ((rb_2_address == fw_ep_st_6_rt_address) && (fw_ep_st_6_wrt_en_ep == 1) && (fw_ep_st_6_unit_latency > 4'd7))
            ) ||
            (   ((rc_2_address == fw_ep_st_1_rt_address) && (fw_ep_st_1_wrt_en_ep == 1)) ||
                ((rc_2_address == fw_ep_st_2_rt_address) && (fw_ep_st_2_wrt_en_ep == 1) && (fw_ep_st_2_unit_latency > 4'd3)) ||
                ((rc_2_address == fw_ep_st_3_rt_address) && (fw_ep_st_3_wrt_en_ep == 1) && (fw_ep_st_3_unit_latency > 4'd4)) || 
                ((rc_2_address == fw_ep_st_4_rt_address) && (fw_ep_st_4_wrt_en_ep == 1) && (fw_ep_st_4_unit_latency > 4'd5)) || 
                ((rc_2_address == fw_ep_st_5_rt_address) && (fw_ep_st_5_wrt_en_ep == 1) && (fw_ep_st_5_unit_latency > 4'd6)) ||
                ((rc_2_address == fw_ep_st_6_rt_address) && (fw_ep_st_6_wrt_en_ep == 1) && (fw_ep_st_6_unit_latency > 4'd7))
            ) || 
            (   ((ra_2_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((ra_2_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((ra_2_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_op == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((ra_2_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_op == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((ra_2_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_op == 1) && (fw_op_st_5_unit_latency > 4'd6))
            ) ||
            (   ((rb_2_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((rb_2_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((rb_2_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_op == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((rb_2_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_op == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((rb_2_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_op == 1) && (fw_op_st_5_unit_latency > 4'd6))
            ) ||
            (   ((rc_2_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((rc_2_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_op == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((rc_2_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_op == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((rc_2_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_op == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((rc_2_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_op == 1) && (fw_op_st_5_unit_latency > 4'd6))
            )
            ) begin
                dependency_stall_2 = 1;
                $display("hello dep stall 2.1");
        end

        else if((wrt_en_decode_1 == 1 && wrt_en_decode_2 == 1) && (rt_1_address == rt_2_address)) begin // WAW Hazard
            if( previous_stall == 1'dx || previous_stall == 0 ) begin
                dependency_stall_2 = 1;
                $display("hello dep stall 2.3");
            end
        end
    
        else if(((ep_inst1_flag == 1 && ep_inst2_flag == 1) || (op_inst1_flag == 1 && op_inst2_flag == 1))) begin // Structural Hazard 
            if( previous_stall == 1'dx || previous_stall == 0 ) begin
                dependency_stall_2 = 1;
                $display("hello dep stall 2.2");
            end
        end

        else begin 
            dependency_stall_2 = 0;
        end

        if(dependency_stall_1 || dependency_stall_2) begin
            stall = 1;
        end

        else begin 
            stall = 0;
        end
    end

    always_ff @(posedge clock) begin
        if(reset==1) begin
            opcode_instruction_even <= NO_OPERATION_EXECUTE;
            ra_even_address <= 7'dx;
            rb_even_address <= 7'dx;
            rc_even_address <= 7'dx;
            rt_even_address <= 7'dx;
            I7_even <= 7'dx;
            I10_even <= 7'dx;
            I16_even <= 7'dx;
            I18_even <= 7'dx;
            wrt_en_decode_ep <= 0;
            
            opcode_instruction_odd <= NO_OPERATION_LOAD;
            ra_odd_address <= 7'dx;
            rb_odd_address <= 7'dx;
            rt_odd_address <= 7'dx;
            I7_odd <= 7'dx;
            I10_odd <= 7'dx;
            I16_odd <= 7'dx;
            I18_odd <= 7'dx;
            wrt_en_decode_op <= 0;
            pc_decode_out <= 0;

            previous_stall <= 0;
            
        end

        else if(flush==1) begin
            opcode_instruction_even <= NO_OPERATION_EXECUTE;
            ra_even_address <= 7'dx;
            rb_even_address <= 7'dx;
            rc_even_address <= 7'dx;
            rt_even_address <= 7'dx;
            I7_even <= 7'dx;
            I10_even <= 7'dx;
            I16_even <= 7'dx;
            I18_even <= 7'dx;
            wrt_en_decode_ep <= 0;
            
            opcode_instruction_odd <= NO_OPERATION_LOAD;
            ra_odd_address <= 7'dx;
            rb_odd_address <= 7'dx;
            rt_odd_address <= 7'dx;
            I7_odd <= 7'dx;
            I10_odd <= 7'dx;
            I16_odd <= 7'dx;
            I18_odd <= 7'dx;
            wrt_en_decode_op <= 0;
            pc_decode_out <= pc_decode_in; ////check

            previous_stall <= 0;
        end

        else if(dependency_stall_1==1) begin
            opcode_instruction_even <= NO_OPERATION_EXECUTE;
            ra_even_address <= 7'dx;
            rb_even_address <= 7'dx;
            rc_even_address <= 7'dx;
            rt_even_address <= 7'dx;
            I7_even <= 7'd0;
            I10_even <= 10'd0;
            I16_even <= 16'd0;
            I18_even <= 18'd0;
            wrt_en_decode_ep <= 0; 

            opcode_instruction_odd <= NO_OPERATION_LOAD;
            ra_odd_address <= 7'dx;
            rb_odd_address <= 7'dx;
            rt_odd_address <= 7'dx;
            I7_odd <= 7'd0;
            I10_odd <= 10'd0;
            I16_odd <= 16'd0;
            I18_odd <= 18'd0;
            wrt_en_decode_op <= 0;

            pc_decode_out <= pc_decode_in;
        end

        else if(dependency_stall_2==1) begin
            if(previous_stall==1) begin
                opcode_instruction_even <= NO_OPERATION_EXECUTE;
                ra_even_address <= 7'dx;
                rb_even_address <= 7'dx;
                rc_even_address <= 7'dx;
                rt_even_address <= 7'dx;
                I7_even <= 7'd0;
                I10_even <= 10'd0;
                I16_even <= 16'd0;
                I18_even <= 18'd0;
                wrt_en_decode_ep <= 0; 

                opcode_instruction_odd <= NO_OPERATION_LOAD;
                ra_odd_address <= 7'dx;
                rb_odd_address <= 7'dx;
                rt_odd_address <= 7'dx;
                I7_odd <= 7'd0;
                I10_odd <= 10'd0;
                I16_odd <= 16'd0;
                I18_odd <= 18'd0;
                wrt_en_decode_op <= 0;

                pc_decode_out <= pc_decode_in;
            end 
            
            else begin
                if (ep_inst1_flag == 1) begin
                    opcode_instruction_even <= ep_opcode_1;
                    ra_even_address <= ra_1_address;
                    rb_even_address <= rb_1_address;
                    rc_even_address <= rc_1_address;
                    rt_even_address <= rt_1_address;
                    I7_even <= ep_I7_1;
                    I10_even <= ep_I10_1;
                    I16_even <= ep_I16_1;
                    I18_even <= ep_I18_1;
                    wrt_en_decode_ep <= wrt_en_decode_1;


                    opcode_instruction_odd <= NO_OPERATION_LOAD;
                    ra_odd_address <= 7'dx;
                    rb_odd_address <= 7'dx;
                    rt_odd_address <= 7'dx;
                    I7_odd <= 7'd0;
                    I10_odd <= 10'd0;
                    I16_odd <= 16'd0;
                    I18_odd <= 18'd0;
                    wrt_en_decode_op <= 0;
                end

                else if (op_inst1_flag == 1) begin
                    opcode_instruction_odd <= op_opcode_1;
                    ra_odd_address <= ra_1_address;
                    rb_odd_address <= rb_1_address;
                    rt_odd_address <= rt_1_address;
                    I7_odd <= op_I7_1;
                    I10_odd <= op_I10_1;
                    I16_odd <= op_I16_1;
                    I18_odd <= op_I18_1;
                    wrt_en_decode_op <= wrt_en_decode_1;

                    opcode_instruction_even <= NO_OPERATION_EXECUTE;
                    ra_even_address <= 7'dx;
                    rb_even_address <= 7'dx;
                    rc_even_address <= 7'dx;
                    rt_even_address <= 7'dx;
                    I7_even <= 7'd0;
                    I10_even <= 10'd0;
                    I16_even <= 16'd0;
                    I18_even <= 18'd0;
                    wrt_en_decode_ep <= 0;  
                end
            end
            previous_stall<=1;

            pc_decode_out <= pc_decode_in;
        end

        else begin
            if(previous_stall==1) begin
                if (ep_inst2_flag == 1) begin
                    opcode_instruction_even <= ep_opcode_2;
                    ra_even_address <= ra_2_address;
                    rb_even_address <= rb_2_address;
                    rc_even_address <= rc_2_address;
                    rt_even_address <= rt_2_address;
                    I7_even <= ep_I7_2;
                    I10_even <= ep_I10_2;
                    I16_even <= ep_I16_2;
                    I18_even <= ep_I18_2;
                    wrt_en_decode_ep <= wrt_en_decode_2;


                    opcode_instruction_odd <= NO_OPERATION_LOAD;
                    ra_odd_address <= 7'dx;
                    rb_odd_address <= 7'dx;
                    rt_odd_address <= 7'dx;
                    I7_odd <= 7'd0;
                    I10_odd <= 10'd0;
                    I16_odd <= 16'd0;
                    I18_odd <= 18'd0;
                    wrt_en_decode_op <= 0;
                end

                else if (op_inst2_flag == 1) begin
                    opcode_instruction_odd <= op_opcode_2;
                    ra_odd_address <= ra_2_address;
                    rb_odd_address <= rb_2_address;
                    rt_odd_address <= rt_2_address;
                    I7_odd <= op_I7_2;
                    I10_odd <= op_I10_2;
                    I16_odd <= op_I16_2;
                    I18_odd <= op_I18_2;
                    wrt_en_decode_op <= wrt_en_decode_2;

                    opcode_instruction_even <= NO_OPERATION_EXECUTE;
                    ra_even_address <= 7'dx;
                    rb_even_address <= 7'dx;
                    rc_even_address <= 7'dx;
                    rt_even_address <= 7'dx;
                    I7_even <= 7'd0;
                    I10_even <= 10'd0;
                    I16_even <= 16'd0;
                    I18_even <= 18'd0;
                    wrt_en_decode_ep <= 0;
                end
                previous_stall<=0;

                pc_decode_out <= pc_decode_in;
            end

            else begin 
                if((op_inst1_flag == 1) && (ep_inst2_flag == 1)) begin
                    opcode_instruction_odd <= op_opcode_1;
                    ra_odd_address <= ra_1_address;
                    rb_odd_address <= rb_1_address;
                    rt_odd_address <= rt_1_address;
                    I7_odd <= op_I7_1;
                    I10_odd <= op_I10_1;
                    I16_odd <= op_I16_1;
                    I18_odd <= op_I18_1;
                    wrt_en_decode_op <= wrt_en_decode_1;

                    opcode_instruction_even <= ep_opcode_2;
                    ra_even_address <= ra_2_address;
                    rb_even_address <= rb_2_address;
                    rc_even_address <= rc_2_address;
                    rt_even_address <= rt_2_address;
                    I7_even <= ep_I7_2;
                    I10_even <= ep_I10_2;
                    I16_even <= ep_I16_2;
                    I18_even <= ep_I18_2;
                    wrt_en_decode_ep <= wrt_en_decode_2;
                end

                else if ((ep_inst1_flag == 1) && (op_inst2_flag == 1)) begin  
                    opcode_instruction_even <= ep_opcode_1;
                    ra_even_address <= ra_1_address;
                    rb_even_address <= rb_1_address;
                    rc_even_address <= rc_1_address;
                    rt_even_address <= rt_1_address;
                    I7_even <= ep_I7_1;
                    I10_even <= ep_I10_1;
                    I16_even <= ep_I16_1;
                    I18_even <= ep_I18_1;
                    wrt_en_decode_ep <= wrt_en_decode_1;

                    opcode_instruction_odd <= op_opcode_2;
                    ra_odd_address <= ra_2_address;
                    rb_odd_address <= rb_2_address;
                    rt_odd_address <= rt_2_address;
                    I7_odd <= op_I7_2;
                    I10_odd <= op_I10_2;
                    I16_odd <= op_I16_2;
                    I18_odd <= op_I18_2;
                    wrt_en_decode_op <= wrt_en_decode_2;
                end

                pc_decode_out <= pc_decode_in;
            end
        end
    end

    always_comb begin
        // Add NO OP opcodes checking
        ep_inst1_flag = 0;
        ep_inst2_flag = 0;
        op_inst1_flag = 0;
        op_inst2_flag = 0;
        wrt_en_decode_1 = 0;
        wrt_en_decode_2 = 0;

        ra_1_address = 7'dx;
        rb_1_address = 7'dx;
        rc_1_address = 7'dx;
        rt_1_address = 7'dx;

        ra_2_address = 7'dx;
        rb_2_address = 7'dx;
        rc_2_address = 7'dx;
        rt_2_address = 7'dx;

        ep_I7_1 = 7'd0;
        ep_I10_1 = 10'd0;
        ep_I16_1 = 16'd0;
        ep_I18_1 = 18'd0;

        op_I7_1 = 7'd0;
        op_I10_1 = 10'd0;
        op_I16_1 = 16'd0;
        op_I18_1 = 18'd0;

        ep_I7_2 = 7'd0;
        ep_I10_2 = 10'd0;
        ep_I16_2 = 16'd0;
        ep_I18_1 = 18'd0;

        op_I7_2 = 7'd0;
        op_I10_2 = 10'd0;
        op_I16_2 = 16'd0;
        op_I18_2 = 18'd0;

        if(first_inst_4 == 4'b1110 || first_inst_4 == 4'b1101 || first_inst_4 == 4'b1111 || first_inst_4 == 4'b1100) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            rt_1_address = first_inst[4:10];
            rb_1_address = first_inst[11:17];
            ra_1_address = first_inst[18:24];
            rc_1_address = first_inst[25:31];
            wrt_en_decode_1 = 1;
            case(first_inst_4)
                4'b1110:
                    begin
                        ep_opcode_1 = FLOATING_MULTIPLY_AND_ADD;
                    end
                4'b1101:
                    begin
                        ep_opcode_1 = FLOATING_NEGATIVE_MULTIPLY_AND_SUBTRACT;
                    end
                4'b1111:
                    begin
                        ep_opcode_1 = FLOATING_MULTIPLY_AND_SUBTRACT;
                    end
                4'b1100:
                    begin
                        ep_opcode_1 = MULTIPLY_AND_ADD;
                    end
            endcase
        end

        else if(first_inst_7 == 7'b0100001) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_I18_1 = first_inst[7:24];
            rt_1_address = first_inst[25:31];
            ep_opcode_1 = IMMEDIATE_LOAD_ADDRESS;
            wrt_en_decode_1 = 1;
        end

        else if(first_inst_8 == 8'b00011101 || first_inst_8 == 8'b00011100 || first_inst_8 == 8'b00001101 || first_inst_8 == 8'b00001100 || first_inst_8 == 8'b00010101 || first_inst_8 == 8'b00010100 || first_inst_8 == 8'b00000101 || first_inst_8 == 8'b00000100 || first_inst_8 == 8'b01000101 || first_inst_8 == 8'b01000100 || first_inst_8 == 8'b01111101 || first_inst_8 == 8'b01111100 || first_inst_8 == 8'b01001101 || first_inst_8 == 8'b01001100 || first_inst_8 == 8'b01011101 || first_inst_8 == 8'b01011100 || first_inst_8 == 8'b01110100 || first_inst_8 == 8'b01110101) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_I10_1 = first_inst[8:17];
            ra_1_address = first_inst[18:24];
            rt_1_address = first_inst[25:31];
            wrt_en_decode_1 = 1;
            case(first_inst_8)
                8'b00011101:
                    begin
                        ep_opcode_1 = ADD_HALFWORD_IMMEDIATE;
                    end
                8'b00011100:
                    begin
                        ep_opcode_1 = ADD_WORD_IMMEDIATE;
                    end
                8'b00001101:
                    begin
                        ep_opcode_1 = SUBTRACT_FROM_HALFWORD_IMMEDIATE;
                    end
                8'b00001100:
                    begin
                        ep_opcode_1 = SUBTRACT_FROM_WORD_IMMEDIATE;
                    end
                8'b00010101:
                    begin
                        ep_opcode_1 = AND_HALFWORD_IMMEDIATE;
                    end
                8'b00010100:
                    begin
                        ep_opcode_1 = AND_WORD_IMMEDIATE;
                    end
                8'b00000101:
                    begin
                        ep_opcode_1 = OR_HALFWORD_IMMEDIATE;
                    end
                8'b00000100:
                    begin
                        ep_opcode_1 = OR_WORD_IMMEDIATE;
                    end
                8'b01000101:
                    begin
                        ep_opcode_1 = EXCLUSIVE_OR_HALFWORD_IMMEDIATE;
                    end
                8'b01000100:
                    begin
                        ep_opcode_1 = EXCLUSIVE_OR_WORD_IMMEDIATE;
                    end
                8'b01111101:
                    begin
                        ep_opcode_1 = COMPARE_EQUAL_HALFWORD_IMMEDIATE;
                    end
                8'b01111100:
                    begin
                        ep_opcode_1 = COMPARE_EQUAL_WORD_IMMEDIATE;
                    end
                8'b01001101:
                    begin
                        ep_opcode_1 = COMPARE_GREATER_THAN_HALFWORD_IMMEDIATE;
                    end
                8'b01001100:
                    begin
                        ep_opcode_1 = COMPARE_GREATER_THAN_WORD_IMMEDIATE;
                    end
                8'b01011101:
                    begin
                        ep_opcode_1 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD_IMMEDIATE;
                    end
                8'b01011100:
                    begin
                        ep_opcode_1 = COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE;
                    end
                8'b01110100:
                    begin
                        ep_opcode_1 = MULTIPLY_IMMEDIATE;
                    end
                8'b01110101:
                    begin
                        ep_opcode_1 = MULTIPLY_UNSIGNED_IMMEDIATE;
                    end
            endcase
        end

        else if(first_inst_8 == 8'b00110100) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I10_1 = first_inst[8:17];
            ra_1_address = first_inst[18:24];
            rt_1_address = first_inst[25:31];
            
            op_opcode_1 = LOAD_QUADFORM_DFORM;
            wrt_en_decode_1 = 1;
              
        end

        else if(first_inst_8 == 8'b00100100) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I10_1 = first_inst[8:17];
            ra_1_address = first_inst[18:24];
            rb_1_address = first_inst[25:31];
                       
            op_opcode_1 = STORE_QUADFORM_DFORM;
            wrt_en_decode_1 = 0;
        end

        else if(first_inst_9 == 9'b010000011 || first_inst_9 == 9'b010000010 || first_inst_9 == 9'b010000001) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_I16_1 = first_inst[9:24];
            rt_1_address = first_inst[25:31];
            wrt_en_decode_1 = 1;
            case(first_inst_9)
                9'b010000011:
                    begin
                        ep_opcode_1 = IMMEDIATE_LOAD_HALFWORD;
                    end
                9'b010000010:
                    begin
                        ep_opcode_1 = IMMEDIATE_LOAD_HALFWORD_UPPER;
                    end
                9'b010000001:
                    begin
                        ep_opcode_1 = IMMEDIATE_LOAD_WORD;
                    end
            endcase
        end

        else if(first_inst_9 == 9'b001100001 || first_inst_9 == 9'b001100110 || first_inst_9 == 9'b001100010) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I16_1 = first_inst[9:24];
            rt_1_address = first_inst[25:31];
            wrt_en_decode_1 = 1;
            case(first_inst_9) 
                9'b001100001:
                    begin
                        op_opcode_1 = LOAD_QUADWORD_AFORM;
                    end
                9'b001100110:
                    begin
                        op_opcode_1 = BRANCH_RELATIVE_AND_SET_LINK;
                        branch_is_first_inst = 1;
                    end
                9'b001100010:
                    begin
                        op_opcode_1 = BRANCH_ABSOLUTE_AND_SET_LINK;
                        branch_is_first_inst = 1;
                    end
            endcase
        end

        else if(first_inst_9 == 9'b001000001 || first_inst_9 == 9'b001000010 || first_inst_9 == 9'b001000000 || first_inst_9 == 9'b001000110 || first_inst_9 == 9'b001000100) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I16_1 = first_inst[9:24];
            rb_1_address = first_inst[25:31];
            wrt_en_decode_1 = 0;
            case(first_inst_9) 
                9'b001000001:
                    begin
                        op_opcode_1 = STORE_QUADFORM_AFORM;
                    end
                9'b001000010:
                    begin
                        op_opcode_1 = BRANCH_IF_NOT_ZERO_WORD;
                        branch_is_first_inst = 1;
                    end
                9'b001000000:
                    begin
                        op_opcode_1 = BRANCH_IF_ZERO_WORD;
                        branch_is_first_inst = 1;
                    end
                9'b001000110:
                    begin
                        op_opcode_1 = BRANCH_IF_NOT_ZERO_HALFWORD;
                        branch_is_first_inst = 1;
                    end
                9'b001000100:
                    begin
                        op_opcode_1 = BRANCH_IF_ZERO_HALFWORD;
                        branch_is_first_inst = 1;

                    end
            endcase
        end

        else if(first_inst_9 == 9'b001100100 || first_inst_9 == 9'b001100000) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I16_1 = first_inst[9:24];
            wrt_en_decode_1 = 0;
            case(first_inst_9)
                9'b001100100:
                    begin
                        op_opcode_1 = BRANCH_RELATIVE;
                        branch_is_first_inst = 1;
                    end
                9'b001100000:
                    begin
                        op_opcode_1 = BRANCH_ABSOLUTE;
                        branch_is_first_inst = 1;
                    end
            endcase
        end

        else if(first_inst_11 == 11'b00011000000 || first_inst_11 == 11'b00011001000 || first_inst_11 == 11'b00001000000 || first_inst_11 == 11'b00001001000 || first_inst_11 == 11'b01101000000 || first_inst_11 == 11'b01101000001 || first_inst_11 == 11'b00011000010 || first_inst_11 == 11'b00001000010 || first_inst_11 == 11'b00011000001 || first_inst_11 == 11'b01011000001 || first_inst_11 == 11'b00001000001 || first_inst_11 == 11'b01011001001 || first_inst_11 == 11'b01001000001 || first_inst_11 == 11'b00011001001 || first_inst_11 == 11'b00001001001 || first_inst_11 == 11'b01111001000 || first_inst_11 == 11'b01111000000 || first_inst_11 == 11'b01001001000 || first_inst_11 == 11'b01001000000 || first_inst_11 == 11'b01011001000 || first_inst_11 == 11'b01011000000 || first_inst_11 == 11'b00001011111 || first_inst_11 == 11'b00001011011 || first_inst_11 == 11'b00001011100 || first_inst_11 == 11'b00001011000 || first_inst_11 == 11'b01011000110 || first_inst_11 == 11'b01111000100 || first_inst_11 == 11'b01111001100 || first_inst_11 == 11'b01111000101 || first_inst_11 == 11'b00001010011 || first_inst_11 == 11'b00011010011 || first_inst_11 == 11'b01001010011) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            rb_1_address = first_inst[11:17];
            ra_1_address = first_inst[18:24];
            rt_1_address = first_inst[25:31];
            wrt_en_decode_1 = 1;
            case(first_inst_11)
                11'b00011000000:
                    begin
                        ep_opcode_1 = ADD_WORD;
                    end
                11'b00011001000:
                    begin
                        ep_opcode_1 = ADD_HALFWORD;
                    end
                11'b00001000000:
                    begin
                        ep_opcode_1 = SUBTRACT_FROM_WORD;
                    end
                11'b00001001000:
                    begin
                        ep_opcode_1 = SUBTRACT_FROM_HALFWORD;
                    end
                11'b01101000000:
                    begin
                        ep_opcode_1 = ADD_EXTENDED;
                        rc_1_address = rt_1_address;
                    end
                11'b01101000001:
                    begin
                        ep_opcode_1 = SUBTRACT_FROM_EXTENDED;
                        rc_1_address = rt_1_address;
                    end
                11'b00011000010:
                    begin
                        ep_opcode_1 = CARRY_GENERATE;
                    end
                11'b00001000010:
                    begin
                        ep_opcode_1 = BORROW_GENERATE;
                    end
                11'b00011000001:
                    begin
                        ep_opcode_1 = AND;
                    end
                11'b01011000001:
                    begin
                        ep_opcode_1 = AND_WITH_COMPLEMENT;
                    end
                11'b00001000001:
                    begin
                        ep_opcode_1 = OR;
                    end
                11'b01011001001:
                    begin
                        ep_opcode_1 = OR_COMPLEMENT;
                    end
                11'b01001000001:
                    begin
                        ep_opcode_1 = EXCLUSIVE_OR;
                    end
                11'b00011001001:
                    begin
                        ep_opcode_1 = NAND;
                    end
                11'b00001001001:
                    begin
                        ep_opcode_1 = NOR;
                    end
                11'b01111001000:
                    begin
                        ep_opcode_1 = COMPARE_EQUAL_HALFWORD;
                    end
                11'b01111000000:
                    begin
                        ep_opcode_1 = COMPARE_EQUAL_WORD;
                    end
                11'b01001001000:
                    begin
                        ep_opcode_1 = COMPARE_GREATER_THAN_HALFWORD;
                    end
                11'b01001000000:
                    begin
                        ep_opcode_1 = COMPARE_GREATER_THAN_WORD;
                    end
                11'b01011001000:
                    begin
                        ep_opcode_1 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD;
                    end
                11'b01011000000:
                    begin
                        ep_opcode_1 = COMPARE_LOGICAL_GREATER_THAN_WORD;
                    end
                11'b00001011111:
                    begin
                        ep_opcode_1 = SHIFT_LEFT_HALFWORD;
                    end
                11'b00001011011:
                    begin
                        ep_opcode_1 = SHIFT_LEFT_WORD;
                    end
                11'b00001011100:
                    begin
                        ep_opcode_1 = ROTATE_HALFWORD;
                    end
                11'b00001011000:
                    begin
                        ep_opcode_1 = ROTATE_WORD;
                    end
                11'b01011000110:
                    begin
                        ep_opcode_1 = FLOATING_MULTIPLY;
                    end
                11'b01111000100:
                    begin
                        ep_opcode_1 = MULTIPLY;
                    end
                111'b01111001100:
                    begin
                        ep_opcode_1 = MULTIPLY_UNSIGNED;
                    end
                11'b01111000101:
                    begin
                        ep_opcode_1 = MULTIPLY_HIGH;
                    end
                11'b00001010011:
                    begin
                        ep_opcode_1 = ABSOLUTE_DIFFERENCES_OF_BYTES;
                    end
                11'b00011010011:
                    begin
                        ep_opcode_1 = AVERAGE_BYTES;
                    end
                11'b01001010011:
                    begin
                        ep_opcode_1 = SUM_BYTES_INTO_HALFWORDS;
                    end
            endcase
        end

        else if(first_inst_11 == 11'b00111011011 || first_inst_11 == 11'b00111011111 || first_inst_11 == 11'b00111001111 || first_inst_11 == 11'b00111011100 || first_inst_11 == 11'b00111001100 || first_inst_11 == 11'b00111011000) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            rb_1_address = first_inst[11:17];
            ra_1_address = first_inst[18:24];
            rt_1_address = first_inst[25:31];
            wrt_en_decode_1 = 1;
            case(first_inst_11)
                11'b00111011011:
                    begin
                        op_opcode_1 = SHIFT_LEFT_QUADWORD_BY_BITS;
                    end
                11'b00111011111:
                    begin
                        op_opcode_1 = SHIFT_LEFT_QUADWORD_BY_BYTES;
                    end
                11'b00111001111:
                    begin
                        op_opcode_1 = SHIFT_LEFT_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
                    end
                11'b00111011100:
                    begin
                        op_opcode_1 = ROTATE_QUADWORD_BY_BYTES;
                    end
                11'b00111001100:
                    begin
                        op_opcode_1 = ROTATE_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
                    end
                11'b00111011000:
                    begin
                        op_opcode_1 = ROTATE_QUADWORD_BY_BITS;
                    end
            endcase
        end

        else if(first_inst_11 == 11'b01010100101 || first_inst_11 == 11'b00110110101 || first_inst_11 == 11'b00110110100 || first_inst_11 == 11'b01010110100) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ra_1_address = first_inst[18:24];
            rt_1_address = first_inst[25:31];
            wrt_en_decode_1 = 1;
            case(first_inst_11)
                11'b01010100101:
                    begin
                        ep_opcode_1 = COUNT_LEADING_ZEROS;
                    end
                11'b00110110101:
                    begin
                        ep_opcode_1 = FORM_SELECT_MASK_FOR_HALFWORDS;
                    end
                11'b00110110100:
                    begin
                        ep_opcode_1 = FORM_SELECT_MASK_FOR_WORDS;
                    end
                11'b01010110100:
                    begin
                        ep_opcode_1 = COUNT_ONES_IN_BYTES;
                    end
            endcase
        end

        else if(first_inst_11 == 11'b00111111011 || first_inst_11 == 11'b00111111111 || first_inst_11 == 11'b00111111100 || first_inst_11 == 11'b00111111000) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I7_1 = first_inst[11:17];
            ra_1_address = first_inst[18:24];
            rt_1_address = first_inst[25:31];
            wrt_en_decode_1 = 1;
            case(first_inst_11)
                11'b00111111011:
                    begin
                        op_opcode_1 = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE;
                    end
                11'b00111111111:
                    begin
                        op_opcode_1 = SHIFT_LEFT_QUADWORD_BY_BYTE_IMMEDIATE;
                    end
                11'b00111111100:
                    begin
                        op_opcode_1 = ROTATE_QUADWORD_BY_BYTES_IMMEDIATE;
                    end
                11'b00111111000:
                    begin
                        op_opcode_1 = ROTATE_QUADWORD_BY_BITS_IMMEDIATE;
                    end
            endcase
        end

        else if(first_inst_11 == 11'b00001111111 || first_inst_11 == 11'b00001111011 || first_inst_11 == 11'b00001111100 || first_inst_11 == 11'b00001111000) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_I7_1 = first_inst[11:17];
            ra_1_address = first_inst[18:24];
            rt_1_address = first_inst[25:31];
            wrt_en_decode_1 = 1;
            case(first_inst_11)
                11'b00001111111:
                    begin
                        ep_opcode_1 = SHIFT_LEFT_HALFWORD_IMMEDIATE;
                    end
                11'b00001111011:
                    begin
                        ep_opcode_1 = SHIFT_LEFT_WORD_IMMEDIATE;
                    end
                11'b00001111100:
                    begin
                        ep_opcode_1 = ROTATE_HALFWORD_IMMEDIATE;
                    end
                11'b00001111000:
                    begin
                        ep_opcode_1 = ROTATE_WORD_IMMEDIATE;
                    end
            endcase
        end

        else if(first_inst_11 == 11'b00110110010 || first_inst_11 == 11'b00110110001 || first_inst_11 == 11'b00110110000) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            ra_1_address = first_inst[18:24];
            rt_1_address = first_inst[25:31];
            wrt_en_decode_1 = 1;
            case(first_inst_11)
                11'b00110110010:
                    begin
                        op_opcode_1 = GATHER_BITS_FROM_BYTES;
                    end
                11'b00110110001:
                    begin
                        op_opcode_1 = GATHER_BITS_FROM_HALFWORDS;
                    end
                11'b00110110000:
                    begin
                        op_opcode_1 = GATHER_BITS_FROM_WORDS;
                    end
            endcase
        end

        else if (first_inst_11 == 11'b01000000001) begin
            wrt_en_decode_1 = 0;
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            case(first_inst_11)
                11'b01000000001:
                    begin
                        ep_opcode_1 = NO_OPERATION_EXECUTE;
                    end
            endcase
        end

        else if (first_inst_11 == 11'b00000000001) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            wrt_en_decode_1 = 0;
            case(first_inst_11)
                11'b00000000001:
                    begin
                        op_opcode_1 = NO_OPERATION_LOAD;
                    end
            endcase
        end

        if(second_inst_4 == 4'b1110 || second_inst_4 == 4'b1101 || second_inst_4 == 4'b1111 || second_inst_4 == 4'b1100) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            rt_2_address = second_inst[4:10];
            rb_2_address = second_inst[11:17];
            ra_2_address = second_inst[18:24];
            rc_2_address = second_inst[25:31];
            wrt_en_decode_2 = 1;
            case(second_inst_4)
                4'b1110:
                    begin
                        ep_opcode_2 = FLOATING_MULTIPLY_AND_ADD;
                    end
                4'b1101:
                    begin
                        ep_opcode_2 = FLOATING_NEGATIVE_MULTIPLY_AND_SUBTRACT;
                    end
                4'b1111:
                    begin
                        ep_opcode_2 = FLOATING_MULTIPLY_AND_SUBTRACT;
                    end
                4'b1100:
                    begin
                        ep_opcode_2 = MULTIPLY_AND_ADD;
                    end
            endcase
        end

        else if(second_inst_7 == 7'b0100001 ) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_I18_2 = second_inst[7:24];
            rt_2_address = second_inst[25:31];
            ep_opcode_2 = IMMEDIATE_LOAD_ADDRESS;
            wrt_en_decode_2 = 1;
    
        end

        else if(second_inst_8 == 8'b00011101 || second_inst_8 == 8'b00011100 || second_inst_8 == 8'b00001101 || second_inst_8 == 8'b00001100 || second_inst_8 == 8'b00010101 || second_inst_8 == 8'b00010100 || second_inst_8 == 8'b00000101 || second_inst_8 == 8'b00000100 || second_inst_8 == 8'b01000101 || second_inst_8 == 8'b01000100 || second_inst_8 == 8'b01111101 || second_inst_8 == 8'b01111100 || second_inst_8 == 8'b01001101 || second_inst_8 == 8'b01001100 || second_inst_8 == 8'b01011101 || second_inst_8 == 8'b01011100 || second_inst_8 == 8'b01110100 || second_inst_8 == 8'b01110101) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_I10_2 = second_inst[8:17];
            ra_2_address = second_inst[18:24];
            rt_2_address = second_inst[25:31];
            wrt_en_decode_2 = 1;
            case(second_inst_8)
                8'b00011101:
                    begin
                        ep_opcode_2 = ADD_HALFWORD_IMMEDIATE;
                    end
                8'b00011100:
                    begin
                        ep_opcode_2 = ADD_WORD_IMMEDIATE;
                    end
                8'b00001101:
                    begin
                        ep_opcode_2 = SUBTRACT_FROM_HALFWORD_IMMEDIATE;
                    end
                8'b00001100:
                    begin
                        ep_opcode_2 = SUBTRACT_FROM_WORD_IMMEDIATE;
                    end
                8'b00010101:
                    begin
                        ep_opcode_2 = AND_HALFWORD_IMMEDIATE;
                    end
                8'b00010100:
                    begin
                        ep_opcode_2 = AND_WORD_IMMEDIATE;
                    end
                8'b00000101:
                    begin
                        ep_opcode_2 = OR_HALFWORD_IMMEDIATE;
                    end
                8'b00000100:
                    begin
                        ep_opcode_2 = OR_WORD_IMMEDIATE;
                    end
                8'b01000101:
                    begin
                        ep_opcode_2 = EXCLUSIVE_OR_HALFWORD_IMMEDIATE;
                    end
                8'b01000100:
                    begin
                        ep_opcode_2 = EXCLUSIVE_OR_WORD_IMMEDIATE;
                    end
                8'b01111101:
                    begin
                        ep_opcode_2 = COMPARE_EQUAL_HALFWORD_IMMEDIATE;
                    end
                8'b01111100:
                    begin
                        ep_opcode_2 = COMPARE_EQUAL_WORD_IMMEDIATE;
                    end
                8'b01001101:
                    begin
                        ep_opcode_2 = COMPARE_GREATER_THAN_HALFWORD_IMMEDIATE;
                    end
                8'b01001100:
                    begin
                        ep_opcode_2 = COMPARE_GREATER_THAN_WORD_IMMEDIATE;
                    end
                8'b01011101:
                    begin
                        ep_opcode_2 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD_IMMEDIATE;
                    end
                8'b01011100:
                    begin
                        ep_opcode_2 = COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE;
                    end
                8'b01110100:
                    begin
                        ep_opcode_2 = MULTIPLY_IMMEDIATE;
                    end
                8'b01110101:
                    begin
                        ep_opcode_2 = MULTIPLY_UNSIGNED_IMMEDIATE;
                    end
            endcase
        end

        else if(second_inst_8 == 8'b00110100) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I10_2 = second_inst[8:17];
            ra_2_address = second_inst[18:24];
            rt_2_address = second_inst[25:31];
            wrt_en_decode_2 = 1;
            op_opcode_2 = LOAD_QUADFORM_DFORM;
                        
        end

        else if(second_inst_8 == 8'b00100100) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I10_2 = second_inst[8:17];
            ra_2_address = second_inst[18:24];
            rb_2_address = second_inst[25:31];
            wrt_en_decode_2 = 0;
            op_opcode_2 = STORE_QUADFORM_DFORM;
        end

        else if(second_inst_9 == 9'b010000011 || second_inst_9 == 9'b010000010 || second_inst_9 == 9'b010000001) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_I16_2 = second_inst[9:24];
            rt_2_address = second_inst[25:31];
            wrt_en_decode_2 = 1;
            case(first_inst_9)
                9'b010000011:
                    begin
                        ep_opcode_2 = IMMEDIATE_LOAD_HALFWORD;
                    end
                9'b010000010:
                    begin
                        ep_opcode_2 = IMMEDIATE_LOAD_HALFWORD_UPPER;
                    end
                9'b010000001:
                    begin
                        ep_opcode_2 = IMMEDIATE_LOAD_WORD;
                    end
            endcase
        end

        else if(second_inst_9 == 9'b001100001 || second_inst_9 == 9'b001100110 || second_inst_9 == 9'b001100010) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I16_2 = second_inst[9:24];
            rt_2_address = second_inst[25:31];
            wrt_en_decode_2 = 1;
            case(second_inst_9)  
                9'b001100001:
                    begin
                        op_opcode_2 = LOAD_QUADWORD_AFORM;
                    end
                9'b001100110:
                    begin
                        op_opcode_2 = BRANCH_RELATIVE_AND_SET_LINK;
                    end
                9'b001100010:
                    begin
                        op_opcode_2 = BRANCH_ABSOLUTE_AND_SET_LINK;
                    end
            endcase
        end

        else if(second_inst_9 == 9'b001000001 || second_inst_9 == 9'b001000010 || second_inst_9 == 9'b001000000 || second_inst_9 == 9'b001000110 || second_inst_9 == 9'b001000100) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I16_2 = second_inst[9:24];
            rb_2_address = second_inst[25:31];
            wrt_en_decode_2 = 0;
            case(second_inst_9)  
                9'b001000001:
                    begin
                        op_opcode_2 = STORE_QUADFORM_AFORM;
                    end
                9'b001000010:
                    begin
                        op_opcode_2 = BRANCH_IF_NOT_ZERO_WORD;
                    end
                9'b001000000:
                    begin
                        op_opcode_2 = BRANCH_IF_ZERO_WORD;
                    end
                9'b001000110:
                    begin
                        op_opcode_2 = BRANCH_IF_NOT_ZERO_HALFWORD;
                    end
                9'b001000100:
                    begin
                        op_opcode_2 = BRANCH_IF_ZERO_HALFWORD;
                    end
            endcase
        end

        else if(second_inst_9 == 9'b001100100 || second_inst_9 == 9'b001100000) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I16_2 = second_inst[9:24];
            wrt_en_decode_2 = 0;
            case(second_inst_9)
                9'b001100100:
                    begin
                        op_opcode_2 = BRANCH_RELATIVE;
                    end
                9'b001100000:
                    begin
                        op_opcode_2 = BRANCH_ABSOLUTE;
                    end
            endcase
        end

        else if(second_inst_11 == 11'b00011000000 || second_inst_11 == 11'b00011001000 || second_inst_11 == 11'b00001000000 || second_inst_11 == 11'b00001001000 || second_inst_11 == 11'b01101000000 || second_inst_11 == 11'b01101000001 || second_inst_11 == 11'b00011000010 || second_inst_11 == 11'b00001000010 || second_inst_11 == 11'b00011000001 || second_inst_11 == 11'b01011000001 || second_inst_11 == 11'b00001000001 || second_inst_11 == 11'b01011001001 || second_inst_11 == 11'b01001000001 || second_inst_11 == 11'b00011001001 || second_inst_11 == 11'b00001001001 || second_inst_11 == 11'b01111001000 || second_inst_11 == 11'b01111000000 || second_inst_11 == 11'b01001001000 || second_inst_11 == 11'b01001000000 || second_inst_11 == 11'b01011001000 || second_inst_11 == 11'b01011000000 || second_inst_11 == 11'b00001011111 || second_inst_11 == 11'b00001011011 || second_inst_11 == 11'b00001011100 || second_inst_11 == 11'b00001011000 || second_inst_11 == 11'b01011000110 || second_inst_11 == 11'b01111000100 || second_inst_11 == 11'b01111001100 || second_inst_11 == 11'b01111000101 || second_inst_11 == 11'b00001010011 || second_inst_11 == 11'b00011010011 || second_inst_11 == 11'b01001010011) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            rb_2_address = second_inst[11:17];
            ra_2_address = second_inst[18:24];
            rt_2_address = second_inst[25:31];
            wrt_en_decode_2 = 1;
            case(second_inst_11)
                11'b00011000000:
                    begin
                        ep_opcode_2 = ADD_WORD;
                    end
                11'b00011001000:
                    begin
                        ep_opcode_2 = ADD_HALFWORD;
                    end
                11'b00001000000:
                    begin
                        ep_opcode_2 = SUBTRACT_FROM_WORD;
                    end
                11'b00001001000:
                    begin
                        ep_opcode_2 = SUBTRACT_FROM_HALFWORD;
                    end
                11'b01101000000:
                    begin
                        ep_opcode_2 = ADD_EXTENDED;
                        rc_2_address = rt_2_address;
                    end
                11'b01101000001:
                    begin
                        ep_opcode_2 = SUBTRACT_FROM_EXTENDED;
                        rc_2_address = rt_2_address;
                    end
                11'b00011000010:
                    begin
                        ep_opcode_2 = CARRY_GENERATE;
                    end
                11'b00001000010:
                    begin
                        ep_opcode_2 = BORROW_GENERATE;
                    end
                11'b00011000001:
                    begin
                        ep_opcode_2 = AND;
                    end
                11'b01011000001:
                    begin
                        ep_opcode_2 = AND_WITH_COMPLEMENT;
                    end
                11'b00001000001:
                    begin
                        ep_opcode_2 = OR;
                    end
                11'b01011001001:
                    begin
                        ep_opcode_2 = OR_COMPLEMENT;
                    end
                11'b01001000001:
                    begin
                        ep_opcode_2 = EXCLUSIVE_OR;
                    end
                11'b00011001001:
                    begin
                        ep_opcode_2 = NAND;
                    end
                11'b00001001001:
                    begin
                        ep_opcode_2 = NOR;
                    end
                11'b01111001000:
                    begin
                        ep_opcode_2 = COMPARE_EQUAL_HALFWORD;
                    end
                11'b01111000000:
                    begin
                        ep_opcode_2 = COMPARE_EQUAL_WORD;
                    end
                11'b01001001000:
                    begin
                        ep_opcode_2 = COMPARE_GREATER_THAN_HALFWORD;
                    end
                11'b01001000000:
                    begin
                        ep_opcode_2 = COMPARE_GREATER_THAN_WORD;
                    end
                11'b01011001000:
                    begin
                        ep_opcode_2 = COMPARE_LOGICAL_GREATER_THAN_HALFWORD;
                    end
                11'b01011000000:
                    begin
                        ep_opcode_2 = COMPARE_LOGICAL_GREATER_THAN_WORD;
                    end
                11'b00001011111:
                    begin
                        ep_opcode_2 = SHIFT_LEFT_HALFWORD;
                    end
                11'b00001011011:
                    begin
                        ep_opcode_2 = SHIFT_LEFT_WORD;
                    end
                11'b00001011100:
                    begin
                        ep_opcode_2 = ROTATE_HALFWORD;
                    end
                11'b00001011000:
                    begin
                        ep_opcode_2 = ROTATE_WORD;
                    end
                11'b01011000110:
                    begin
                        ep_opcode_2 = FLOATING_MULTIPLY;
                    end
                11'b01111000100:
                    begin
                        ep_opcode_2 = MULTIPLY;
                    end
                111'b01111001100:
                    begin
                        ep_opcode_2 = MULTIPLY_UNSIGNED;
                    end
                11'b01111000101:
                    begin
                        ep_opcode_2 = MULTIPLY_HIGH;
                    end
                11'b00001010011:
                    begin
                        ep_opcode_2 = ABSOLUTE_DIFFERENCES_OF_BYTES;
                    end
                11'b00011010011:
                    begin
                        ep_opcode_2 = AVERAGE_BYTES;
                    end
                11'b01001010011:
                    begin
                        ep_opcode_2 = SUM_BYTES_INTO_HALFWORDS;
                    end
            endcase
        end

        else if(second_inst_11 == 11'b01010100101 || second_inst_11 == 11'b00110110101 || second_inst_11 == 11'b00110110100 || second_inst_11 == 11'b01010110100) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ra_2_address = second_inst[18:24];
            rt_2_address = second_inst[25:31];
            wrt_en_decode_2 = 1;
            case(second_inst_11)
                11'b01010100101:
                    begin
                        ep_opcode_2 = COUNT_LEADING_ZEROS;
                    end
                11'b00110110101:
                    begin
                        ep_opcode_2 = FORM_SELECT_MASK_FOR_HALFWORDS;
                    end
                11'b00110110100:
                    begin
                        ep_opcode_2 = FORM_SELECT_MASK_FOR_WORDS;
                    end
                11'b01010110100:
                    begin
                        ep_opcode_2 = COUNT_ONES_IN_BYTES;
                    end
            endcase
        end

        else if(second_inst_11 == 11'b00001111111 || second_inst_11 == 11'b00001111011 || second_inst_11 == 11'b00001111100 || second_inst_11 == 11'b00001111000) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_I7_2 = second_inst[11:17];
            ra_2_address = second_inst[18:24];
            rt_2_address = second_inst[25:31];
            wrt_en_decode_2 = 1;
            case(second_inst_11)
                11'b00001111111:
                    begin
                        ep_opcode_2 = SHIFT_LEFT_HALFWORD_IMMEDIATE;
                    end
                11'b00001111011:
                    begin
                        ep_opcode_2 = SHIFT_LEFT_WORD_IMMEDIATE;
                    end
                11'b00001111100:
                    begin
                        ep_opcode_2 = ROTATE_HALFWORD_IMMEDIATE;
                    end
                11'b00001111000:
                    begin
                        ep_opcode_2 = ROTATE_WORD_IMMEDIATE;
                    end
            endcase
        end

        else if(second_inst_11 == 11'b00111011011 || second_inst_11 == 11'b00111011111 || second_inst_11 == 11'b00111001111 || second_inst_11 == 11'b00111011100 || second_inst_11 == 11'b00111001100 || second_inst_11 == 11'b00111011000) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            rb_2_address = second_inst[11:17];
            ra_2_address = second_inst[18:24];
            rt_2_address = second_inst[25:31];
            wrt_en_decode_2 = 1;
            case(second_inst_11)
                11'b00111011011:
                    begin
                        op_opcode_2 = SHIFT_LEFT_QUADWORD_BY_BITS;
                    end
                11'b00111011111:
                    begin
                        op_opcode_2 = SHIFT_LEFT_QUADWORD_BY_BYTES;
                    end
                11'b00111001111:
                    begin
                        op_opcode_2 = SHIFT_LEFT_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
                    end
                11'b00111011100:
                    begin
                        op_opcode_2 = ROTATE_QUADWORD_BY_BYTES;
                    end
                11'b00111001100:
                    begin
                        op_opcode_2 = ROTATE_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT;
                    end
                11'b00111011000:
                    begin
                        op_opcode_2 = ROTATE_QUADWORD_BY_BITS;
                    end
            endcase
        end

        else if(second_inst_11 == 11'b00111111011 || second_inst_11 == 11'b00111111111 || second_inst_11 == 11'b00111111100 || second_inst_11 == 11'b00111111000) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I7_2 = second_inst[11:17];
            ra_2_address = second_inst[18:24];
            rt_2_address = second_inst[25:31];
            wrt_en_decode_2 = 1;
            case(second_inst_11)
                11'b00111111011:
                    begin
                        op_opcode_2 = SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE;
                    end
                11'b00111111111:
                    begin
                        op_opcode_2 = SHIFT_LEFT_QUADWORD_BY_BYTE_IMMEDIATE;
                    end
                11'b00111111100:
                    begin
                        op_opcode_2 = ROTATE_QUADWORD_BY_BYTES_IMMEDIATE;
                    end
                11'b00111111000:
                    begin
                        op_opcode_2 = ROTATE_QUADWORD_BY_BITS_IMMEDIATE;
                    end
            endcase
        end

        else if(second_inst_11 == 11'b00110110010 || second_inst_11 == 11'b00110110001 || second_inst_11 == 11'b00110110000) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            ra_2_address = second_inst[18:24];
            rt_2_address = second_inst[25:31];
            wrt_en_decode_2 = 1;
            case(second_inst_11)
                11'b00110110010:
                    begin
                        op_opcode_2 = GATHER_BITS_FROM_BYTES;
                    end
                11'b00110110001:
                    begin
                        op_opcode_2 = GATHER_BITS_FROM_HALFWORDS;
                    end
                11'b00110110000:
                    begin
                        op_opcode_2 = GATHER_BITS_FROM_WORDS;
                    end
            endcase
        end

        else if (second_inst_11 == 11'b01000000001) begin
            wrt_en_decode_2 = 0;
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            case(second_inst_11)
                11'b01000000001:
                    begin
                        ep_opcode_2 = NO_OPERATION_EXECUTE;
                    end
            endcase
        end

        else if (second_inst_11 == 11'b00000000001) begin
            wrt_en_decode_2 = 0;
            ep_inst2_flag = 0;
            op_inst2_flag =1;
            case(second_inst_11)
                11'b00000000001:
                    begin
                        op_opcode_2 = NO_OPERATION_LOAD;
                    end
            endcase
        end

        else begin
            if(ep_inst2_flag==1) begin
                op_opcode_1 = NO_OPERATION_LOAD;
                ep_inst1_flag = 0;
                op_inst1_flag = 1;
                ra_1_address = 7'dx;
                rb_1_address = 7'dx;
                rc_1_address = 7'dx;
                rt_1_address = 7'dx;
                wrt_en_decode_1 = 0;
            end
            else if(op_inst2_flag==1) begin
                op_opcode_2 = NO_OPERATION_EXECUTE;
                ep_inst1_flag = 1;
                op_inst1_flag = 0;
                ra_1_address = 7'dx;
                rb_1_address = 7'dx;
                rc_1_address = 7'dx;
                rt_1_address = 7'dx;
                wrt_en_decode_1 = 0;
            end
        end
    end

endmodule