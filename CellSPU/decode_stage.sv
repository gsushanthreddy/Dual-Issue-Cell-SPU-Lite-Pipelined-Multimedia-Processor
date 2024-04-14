import descriptions::*;

module decode_stage(
    input clock,
    input reset,
    input [0:31] first_inst,
    input [0:31] second_inst,
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

    output logic opcode_instruction_even,
    output logic ra_even_address,
    output logic rb_even_address,
    output logic rc_even_address,
    output logic rt_even_address,
    output logic I7_even,
    output logic I10_even,
    output logic I16_even,
    output logic I18_even,

    output logic opcode_instruction_odd,
    output logic ra_odd_address,
    output logic rb_odd_address,
    output logic rt_odd_address,
    output logic I7_odd,
    output logic I10_odd,
    output logic I16_odd,
    output logic I18_odd,

    output logic stall
);
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

    assign first_inst_4 = first_inst[0:3];
    assign first_inst_7 = first_inst[0:6];
    assign first_inst_8 = first_inst[0:7];
    assign first_inst_9 = first_inst[0:8];
    assign first_inst_11 = first_inst[0:10];

    assign second_inst_4 = second_inst[0:3];
    assign second_inst_7 = second_inst[0:6];
    assign second_inst_8 = second_inst[0:7];
    assign second_inst_9 = second_inst[0:8];
    assign second_inst_11 = second_inst[0:10];

    logic ep_inst1_flag;
    logic op_inst1_flag;
    logic ep_inst2_flag;
    logic op_inst2_flag;

    logic previous_even_structural_hazard_flag;
    logic previous_odd_structural_hazard_flag;
    logic previous_waw_hazard_flag;

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
    
    logic structural_hazard_warning_even;
    logic structural_hazard_warning_odd;
    logic no_structural_hazard;
    logic waw_hazard_warning;
    logic raw_hazard_warning_instr_1;
    logic raw_hazard_warning_instr_2;

    logic opcode_instruction_even_temporary;
    logic ra_even_address_temporary;
    logic rb_even_address_temporary;
    logic rc_even_address_temporary;
    logic rt_even_address_temporary;
    logic I7_even_temporary;
    logic I10_even_temporary;
    logic I16_even_temporary;
    logic I18_even_temporary;

    logic opcode_instruction_odd_temporary;
    logic ra_odd_address_temporary;
    logic rb_odd_address_temporary;
    logic rt_odd_address_temporary;
    logic I7_odd_temporary;
    logic I10_odd_temporary;
    logic I16_odd_temporary;
    logic I18_odd_temporary;

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
    
    always_comb begin // Combinational Logic for RAW hazard
        if( // RAW hazard check for instruction 1
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
            (   ((ra_1_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((ra_1_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((ra_1_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_ep == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((ra_1_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_ep == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((ra_1_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_ep == 1) && (fw_op_st_5_unit_latency > 4'd6)) ||
            ) ||
            (   ((rb_1_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((rb_1_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((rb_1_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_ep == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((rb_1_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_ep == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((rb_1_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_ep == 1) && (fw_op_st_5_unit_latency > 4'd6)) ||
            ) ||
            (   ((rc_1_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((rc_1_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((rc_1_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_ep == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((rc_1_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_ep == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((rc_1_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_ep == 1) && (fw_op_st_5_unit_latency > 4'd6)) ||
            )
            ) begin
                raw_hazard_warning_instr_1 = 1;
        end
        
        else begin
            raw_hazard_warning_instr_1 = 0;
        end

        if( // RAW hazard check for instruction 2
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
            (   ((ra_2_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((ra_2_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((ra_2_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_ep == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((ra_2_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_ep == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((ra_2_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_ep == 1) && (fw_op_st_5_unit_latency > 4'd6)) ||
            ) ||
            (   ((rb_2_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((rb_2_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((rb_2_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_ep == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((rb_2_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_ep == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((rb_2_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_ep == 1) && (fw_op_st_5_unit_latency > 4'd6)) ||
            ) ||
            (   ((rc_2_address == fw_op_st_1_rt_address) && (fw_op_st_1_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd2)) ||
                ((rc_2_address == fw_op_st_2_rt_address) && (fw_op_st_2_wrt_en_ep == 1) && (fw_op_st_2_unit_latency > 4'd3)) ||
                ((rc_2_address == fw_op_st_3_rt_address) && (fw_op_st_3_wrt_en_ep == 1) && (fw_op_st_3_unit_latency > 4'd4)) || 
                ((rc_2_address == fw_op_st_4_rt_address) && (fw_op_st_4_wrt_en_ep == 1) && (fw_op_st_4_unit_latency > 4'd5)) || 
                ((rc_2_address == fw_op_st_5_rt_address) && (fw_op_st_5_wrt_en_ep == 1) && (fw_op_st_5_unit_latency > 4'd6)) ||
            )
            ) begin
                raw_hazard_warning_instr_2 = 1;
        end

        else begin 
            raw_hazard_warning_instr_2 = 0;
        end

        if((ep_inst1_flag == 1 && ep_inst2_flag == 1)) begin // Structural Hazard for even instructions
            structural_hazard_warning_even = 1;
            structural_hazard_warning_odd = 0;
            no_structural_hazard = 0;
        end

        else if((op_inst1_flag == 1 && op_inst2_flag == 1)) begin // Structural Hazard for odd instructions
            structural_hazard_warning_odd = 1;
            structural_hazard_warning_even = 0;
            no_structural_hazard = 0;
        end

        else begin
            structural_hazard_warning_even = 0;
            structural_hazard_warning_odd = 0;
            no_structural_hazard = 1;
        end

        if(rt_1_address == rt_2_address) begin // WAW Hazard
            waw_hazard_warning = 1;
        end

        else begin 
            waw_hazard_warning = 0;
        end
    end

    always_comb begin
        if(structural_hazard_warning_even && previous_even_structural_hazard_flag==0 && raw_hazard_warning_instr_1==0) begin
            opcode_instruction_even_temporary = ep_opcode_1;
            ra_even_address_temporary = ra_1_address;
            rb_even_address_temporary = rb_1_address;
            rc_even_address_temporary = rc_1_address
            rt_even_address_temporary = rt_1_address;
            I7_even_temporary = ep_I7_1;
            I10_even_temporary = ep_I10_1;
            I16_even_temporary = ep_I16_1;
            I18_even_temporary = ep_I18_1;

            opcode_instruction_odd_temporary = 11'b00000000001;
            ra_odd_address_temporary = 7'd0;
            rb_odd_address_temporary = 7'd0;
            rt_odd_address_temporary = 7'd0;
            I7_odd_temporary = 7'd0;
            I10_odd_temporary = 10'd0;
            I16_odd_temporary = 16'd0;
            I18_odd_temporary = 18'd0;
        end

        else if(structural_hazard_warning_odd && previous_odd_structural_hazard_flag==0 && raw_hazard_warning_instr_1==0) begin
            opcode_instruction_odd_temporary = op_opcode_1;
            ra_odd_address_temporary = ra_1_address;
            rb_odd_address_temporary = rb_1_address;
            rt_odd_address_temporary = rt_1_address;
            I7_odd_temporary = op_I7_1;
            I10_odd_temporary = op_I10_1;
            I16_odd_temporary = op_I16_1;
            I18_odd_temporary = op_I18_1;

            opcode_instruction_even_temporary = 11'b01000000001;
            ra_even_address_temporary = 7'd0;
            rb_even_address_temporary = 7'd0;
            rc_even_address_temporary = 7'd0;
            rt_even_address_temporary = 7'd0;
            I7_even_temporary = 7'd0;
            I10_even_temporary = 10'd0;
            I16_even_temporary = 16'd0;
            I18_even_temporary = 18'd0;
        end

        else if(waw_hazard_warning && previous_waw_hazard_flag==0 && raw_hazard_warning_instr_1==0) begin
            if (ep_inst1_flag == 1) begin
                opcode_instruction_even_temporary = ep_opcode_1;
                ra_even_address_temporary = ra_1_address;
                rb_even_address_temporary = rb_1_address;
                rc_even_address_temporary = rc_1_address
                rt_even_address_temporary = rt_1_address;
                I7_even_temporary = ep_I7_1;
                I10_even_temporary = ep_I10_1;
                I16_even_temporary = ep_I16_1;
                I18_even_temporary = ep_I18_1;

                opcode_instruction_odd_temporary = 11'b00000000001;
                ra_odd_address_temporary = 7'd0;
                rb_odd_address_temporary = 7'd0;
                rt_odd_address_temporary = 7'd0;
                I7_odd_temporary = 7'd0;
                I10_odd_temporary = 10'd0;
                I16_odd_temporary = 16'd0;
                I18_odd_temporary = 18'd0;
            end

            else if (op_inst1_flag == 1) begin
                opcode_instruction_odd_temporary = op_opcode_1;
                ra_odd_address_temporary = ra_1_address;
                rb_odd_address_temporary = rb_1_address;
                rt_odd_address_temporary = rt_1_address;
                I7_odd_temporary = op_I7_1;
                I10_odd_temporary = op_I10_1;
                I16_odd_temporary = op_I16_1;
                I18_odd_temporary = op_I18_1;

                opcode_instruction_even_temporary = 11'b01000000001;
                ra_even_address_temporary = 7'd0;
                rb_even_address_temporary = 7'd0;
                rc_even_address_temporary = 7'd0;
                rt_even_address_temporary = 7'd0;
                I7_even_temporary = 7'd0;
                I10_even_temporary = 10'd0;
                I16_even_temporary = 16'd0;
                I18_even_temporary = 18'd0;  
            end
        end

        else if(structural_hazard_warning_even==0 && previous_even_structural_hazard_flag==0 && raw_hazard_warning_instr_1==1) begin
            opcode_instruction_even_temporary = 11'b01000000001;
            ra_even_address_temporary = 7'd0;
            rb_even_address_temporary = 7'd0;
            rc_even_address_temporary = 7'd0;
            rt_even_address_temporary = 7'd0;
            I7_even_temporary = 7'd0;
            I10_even_temporary = 10'd0;
            I16_even_temporary = 16'd0;
            I18_even_temporary = 18'd0; 

            opcode_instruction_odd_temporary = 11'b00000000001;
            ra_odd_address_temporary = 7'd0;
            rb_odd_address_temporary = 7'd0;
            rt_odd_address_temporary = 7'd0;
            I7_odd_temporary = 7'd0;
            I10_odd_temporary = 10'd0;
            I16_odd_temporary = 16'd0;
            I18_odd_temporary = 18'd0;
        end

        else if(structural_hazard_warning_even==0 && previous_even_structural_hazard_flag==0 && raw_hazard_warning_instr_2==1) begin 
            if (ep_inst2_flag == 1) begin
                opcode_instruction_even_temporary = ep_opcode_2;
                ra_even_address_temporary = ra_2_address;
                rb_even_address_temporary = rb_2_address;
                rc_even_address_temporary = rc_2_address
                rt_even_address_temporary = rt_2_address;
                I7_even_temporary = ep_I7_2;
                I10_even_temporary = ep_I10_2;
                I16_even_temporary = ep_I16_2;
                I18_even_temporary = ep_I18_2;

                opcode_instruction_odd_temporary = 11'b00000000001;
                ra_odd_address_temporary = 7'd0;
                rb_odd_address_temporary = 7'd0;
                rt_odd_address_temporary = 7'd0;
                I7_odd_temporary = 7'd0;
                I10_odd_temporary = 10'd0;
                I16_odd_temporary = 16'd0;
                I18_odd_temporary = 18'd0;
            end

            else if (op_inst2_flag == 1) begin
                opcode_instruction_odd_temporary = op_opcode_2;
                ra_odd_address_temporary = ra_2_address;
                rb_odd_address_temporary = rb_2_address;
                rt_odd_address_temporary = rt_2_address;
                I7_odd_temporary = op_I7_2;
                I10_odd_temporary = op_I10_2;
                I16_odd_temporary = op_I16_2;
                I18_odd_temporary = op_I18_2;

                opcode_instruction_even_temporary = 11'b01000000001;
                ra_even_address_temporary = 7'd0;
                rb_even_address_temporary = 7'd0;
                rc_even_address_temporary = 7'd0;
                rt_even_address_temporary = 7'd0;
                I7_even_temporary = 7'd0;
                I10_even_temporary = 10'd0;
                I16_even_temporary = 16'd0;
                I18_even_temporary = 18'd0;  
            end
        end

        else begin
            if((op_inst1_flag == 1) && (op_inst2_flag == 0)) begin
                opcode_instruction_odd_temporary = op_opcode_1;
                ra_odd_address_temporary = ra_1_address;
                rb_odd_address_temporary = rb_1_address;
                rt_odd_address_temporary = rt_1_address;
                I7_odd_temporary = op_I7_1;
                I10_odd_temporary = op_I10_1;
                I16_odd_temporary = op_I16_1;
                I18_odd_temporary = op_I18_1;

                opcode_instruction_even_temporary = ep_opcode_2;
                ra_even_address_temporary = ra_2_address;
                rb_even_address_temporary = rb_2_address;
                rc_even_address_temporary = rc_2_address
                rt_even_address_temporary = rt_2_address;
                I7_even_temporary = ep_I7_2;
                I10_even_temporary = ep_I10_2;
                I16_even_temporary = ep_I16_2;
                I18_even_temporary = ep_I18_2;
            end

            else if ((op_inst1_flag == 0) && (op_inst2_flag == 1)) begin  
                opcode_instruction_even_temporary = ep_opcode_1;
                ra_even_address_temporary = ra_1_address;
                rb_even_address_temporary = rb_1_address;
                rc_even_address_temporary = rc_1_address
                rt_even_address_temporary = rt_1_address;
                I7_even_temporary = ep_I7_1;
                I10_even_temporary = ep_I10_1;
                I16_even_temporary = ep_I16_1;
                I18_even_temporary = ep_I18_1;

                opcode_instruction_odd_temporary = op_opcode_2;
                ra_odd_address_temporary = ra_2_address;
                rb_odd_address_temporary = rb_2_address;
                rt_odd_address_temporary = rt_2_address;
                I7_odd_temporary = op_I7_2;
                I10_odd_temporary = op_I10_2;
                I16_odd_temporary = op_I16_2;
                I18_odd_temporary = op_I18_2;
            end
        end

    end

    always_ff @(posedge clock) begin
        if(structural_hazard_warning_even) begin
            previous_even_structural_hazard_flag <= 1;
            structural_hazard_warning_even <= 0;
        end

        if(structural_hazard_warning_odd) begin
            previous_odd_structural_hazard_flag <= 1;
            structural_hazard_warning_odd <= 0;
        end

        if(waw_hazard_warning) begin
            previous_waw_hazard_flag <= 1;
            waw_hazard_warning <= 0;
        end

        if(structural_hazard_warning_even || structural_hazard_warning_odd || waw_hazard_warning || raw_hazard_warning_instr_1 || raw_hazard_warning_instr_2) begin
            stall <= 1;
        end
    end

    always_comb begin
        if(previous_even_structural_hazard_flag && raw_hazard_warning_instr_2==0) begin
            opcode_instruction_even_temporary = ep_opcode_2;
            ra_even_address_temporary = ra_2_address;
            rb_even_address_temporary = rb_2_address;
            rc_even_address_temporary = rc_2_address
            rt_even_address_temporary = rt_2_address;
            I7_even_temporary = ep_I7_2;
            I10_even_temporary = ep_I10_2;
            I16_even_temporary = ep_I16_2;
            I18_even_temporary = ep_I18_2;

            opcode_instruction_odd_temporary = 11'b00000000001;
            ra_odd_address_temporary = 7'd0;
            rb_odd_address_temporary = 7'd0;
            rt_odd_address_temporary = 7'd0;
            I7_odd_temporary = 7'd0;
            I10_odd_temporary = 10'd0;
            I16_odd_temporary = 16'd0;
            I18_odd_temporary = 18'd0;
            previous_even_structural_hazard_flag = 0;
        end

        else if(previous_odd_structural_hazard_flag && raw_hazard_warning_instr_2==0) begin
            opcode_instruction_odd_temporary = op_opcode_2;
            ra_odd_address_temporary = ra_2_address;
            rb_odd_address_temporary = rb_2_address;
            rt_odd_address_temporary = rt_2_address;
            I7_odd_temporary = op_I7_2;
            I10_odd_temporary = op_I10_2;
            I16_odd_temporary = op_I16_2;
            I18_odd_temporary = op_I18_2;

            opcode_instruction_even_temporary = 11'b01000000001;
            ra_even_address_temporary = 7'd0;
            rb_even_address_temporary = 7'd0;
            rc_even_address_temporary = 7'd0;
            rt_even_address_temporary = 7'd0;
            I7_even_temporary = 7'd0;
            I10_even_temporary = 10'd0;
            I16_even_temporary = 16'd0;
            I18_even_temporary = 18'd0;
            previous_odd_structural_hazard_flag = 0;
        end

        else if(previous_waw_hazard_flag && raw_hazard_warning_instr_2==0) begin
            if (ep_inst2_flag == 1) begin
                opcode_instruction_even_temporary = ep_opcode_2;
                ra_even_address_temporary = ra_2_address;
                rb_even_address_temporary = rb_2_address;
                rc_even_address_temporary = rc_2_address
                rt_even_address_temporary = rt_2_address;
                I7_even_temporary = ep_I7_2;
                I10_even_temporary = ep_I10_2;
                I16_even_temporary = ep_I16_2;
                I18_even_temporary = ep_I18_2;

                opcode_instruction_odd_temporary = 11'b00000000001;
                ra_odd_address_temporary = 7'd0;
                rb_odd_address_temporary = 7'd0;
                rt_odd_address_temporary = 7'd0;
                I7_odd_temporary = 7'd0;
                I10_odd_temporary = 10'd0;
                I16_odd_temporary = 16'd0;
                I18_odd_temporary = 18'd0;
            end

            else if (op_inst2_flag == 1) begin
                opcode_instruction_odd_temporary = op_opcode_2;
                ra_odd_address_temporary = ra_2_address;
                rb_odd_address_temporary = rb_2_address;
                rt_odd_address_temporary = rt_2_address;
                I7_odd_temporary = op_I7_2;
                I10_odd_temporary = op_I10_2;
                I16_odd_temporary = op_I16_2;
                I18_odd_temporary = op_I18_2;

                opcode_instruction_even_temporary = 11'b01000000001;
                ra_even_address_temporary = 7'd0;
                rb_even_address_temporary = 7'd0;
                rc_even_address_temporary = 7'd0;
                rt_even_address_temporary = 7'd0;
                I7_even_temporary = 7'd0;
                I10_even_temporary = 10'd0;
                I16_even_temporary = 16'd0;
                I18_even_temporary = 18'd0;  
            end
            previous_waw_hazard_flag = 0;
        end
    end
    
    always_ff @(posedge clock) begin
        opcode_instruction_even <= opcode_instruction_even_temporary;
        ra_even_address <= ra_even_address_temporary;
        rb_even_address <= rb_even_address_temporary;
        rc_even_address <= rc_even_address_temporary;
        rt_even_address <= rt_even_address_temporary;
        I7_even <= I7_even_temporary;
        I10_even <= I10_even_temporary;
        I16_even <= I16_even_temporary;
        I18_even <= I18_even_temporary;
        
        opcode_instruction_odd <= opcode_instruction_odd_temporary;
        ra_odd_address <= ra_odd_address_temporary;
        rb_odd_address <= rb_odd_address_temporary;
        rt_odd_address <= rt_odd_address_temporary;
        I7_odd <= I7_odd_temporary;
        I10_odd <= I10_odd_temporary;
        I16_odd <= I16_odd_temporary;
        I18_odd <= I18_odd_temporary;
    end

    always_comb begin

        ep_inst1_flag = 0;
        op_inst2_flag = 0;

        ra_1_address = 7'd0;
        rb_1_address = 7'd0;
        rc_1_address = 7'd0;
        rt_1_address = 7'd0;

        ra_2_address = 7'd0;
        rb_2_address = 7'd0;
        rc_2_address = 7'd0;
        rt_2_address = 7'd0;

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

        else if(first_inst_7 == 7'b0100001 ) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_I18_1 = first_inst[7:24]
            rt_1_address = first_inst[25:31];
            ep_opcode_1 = IMMEDIATE_LOAD_ADDRESS;
        end

        else if(first_inst_8 == 8'b00011101 || first_inst_8 == 8'b00011100 || first_inst_8 == 8'b00001101 || first_inst_8 == 8'b00001100 || first_inst_8 == 8'b00010101 || first_inst_8 == 8'b00010100 || first_inst_8 == 8'b00000101 || first_inst_8 == 8'b00000100 || first_inst_8 == 8'b01000101 || first_inst_8 == 8'b01000100 || first_inst_8 == 8'b01111101 || first_inst_8 = 8'b01111100 || first_inst_8 == 8'b01001101 || first_inst_8 == 8'b01001100 || first_inst_8 == 8'b01011101 || first_inst_8 == 8'b01011100 || first_inst_8 == 8'b01110100 || first_inst_8 == 8'b01110101) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_I10_1 = first_inst[8:17];
            ra_1_address = first_inst[18:24];
            rt_1_address = first_inst[25:31];
            
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
              
        end

        else if(first_inst_8 == 8'b00100100) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I10_1 = first_inst[8:17];
            ra_1_address = first_inst[18:24];
            rb_1_address = first_inst[25:31];
                       
            op_opcode_1 = STORE_QUADFORM_DFORM;
        end

        else if(first_inst_9 == 9'b010000011 || first_inst_9 == 9'b010000010 || first_inst_9 == 9'b010000001) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            ep_I16_1 = first_inst[9:24];
            rt_1_address = first_inst[25:31];
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
            case(first_inst_9) 
                9'b001100001:
                    begin
                        op_opcode_1 = LOAD_QUADWORD_AFORM;
                    end
                9'b001100110:
                    begin
                        op_opcode_1 = BRANCH_RELATIVE_AND_SET_LINK;
                    end
                9'b001100010:
                    begin
                        op_opcode_1 = BRANCH_ABSOLUTE_AND_SET_LINK;
                    end
            endcase
        end

        else if(first_inst_9 == 9'b001000001 || first_inst_9 == 9'b001000010 || first_inst_9 == 9'b001000000 || first_inst_9 == 9'b001000110 || first_inst_9 == 9'b001000100) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I16_1 = first_inst[9:24];
            rb_1_address = first_inst[25:31];
            case(first_inst_9) 
                9'b001000001:
                    begin
                        op_opcode_1 = STORE_QUADFORM_AFORM;
                    end
                9'b001000010:
                    begin
                        op_opcode_1 = BRANCH_IF_NOT_ZERO_WORD;
                    end
                9'b001000000:
                    begin
                        op_opcode_1 = BRANCH_IF_ZERO_WORD;
                    end
                9'b001000110:
                    begin
                        op_opcode_1 = BRANCH_IF_NOT_ZERO_HALFWORD;
                    end
                9'b001000100:
                    begin
                        op_opcode_1 = BRANCH_IF_ZERO_HALFWORD;
                    end
            endcase
        end

        else if(first_inst_9 == 9'b001100100 || first_inst_9 == 9'b001100000) begin
            ep_inst1_flag = 0;
            op_inst1_flag = 1;
            op_I16_1 = first_inst[9:24];
            case(first_inst_9)
                9'b001100100:
                    begin
                        op_opcode_1 = BRANCH_RELATIVE;
                    end
                9'b001100000:
                    begin
                        op_opcode_1 = BRANCH_ABSOLUTE;
                    end
            endcase
        end

        else if(first_inst_11 == 11'b00011000000 || first_inst_11 == 11'b00011001000 || first_inst_11 == 11'b00001000000 || first_inst_11 == 11'b00001001000 || first_inst_11 == 11'b01101000000 || first_inst_11 == 11'b01101000001 || first_inst_11 == 11'b00011000010 || first_inst_11 == 11'b00001000010 || first_inst_11 == 11'b00011000001 || first_inst_11 == 11'b01011000001 || first_inst_11 == 11'b00001000001 || first_inst_11 = 11'b01011001001 || first_inst_11 == 11'b01001000001 || first_inst_11 == 11'b00011001001 || first_inst_11 == 11'b00001001001 || first_inst_11 == 11'b01111001000 || first_inst_11 == 11'b01111000000 || first_inst_11 == 11'b01001001000 || first_inst_11 == 11'b01001000000 || first_inst_11 == 11'b01011001000 || first_inst_11 == 11'b01011000000 || first_inst_11 == 11'b00001011111 || first_inst_11 == 11'b00001011011 || first_inst_11 == 11'b00001011100 || first_inst_11 == 11'b00001011000 || first_inst_11 == 11'b01011000110 || first_inst_11 = 11'b01111000100 || first_inst_11 == 11'b01111001100 || first_inst_11 == 11'b01111000101 || first_inst_11 == 11'b00001010011 || first_inst_11 == 11'b00011010011 || first_inst_11 == 11'b01001010011) begin
            ep_inst1_flag = 1;
            op_inst1_flag = 0;
            rb_1_address = first_inst[11:17];
            ra_1_address = first_inst[18:24];
            rt_1_address = first_inst[25:31];
            
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
            op_I16_1 = first_inst[9:24];
            rt_1_address = first_inst[25:31];
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
            ep_I18_2 = second_inst[7:24]
            rt_2_address = second_inst[25:31];
            ep_opcode_2 = IMMEDIATE_LOAD_ADDRESS;
    
        end

        else if(second_inst_8 == 8'b00011101 || second_inst_8 == 8'b00011100 || second_inst_8 == 8'b00001101 || second_inst_8 == 8'b00001100 || second_inst_8 == 8'b00010101 || second_inst_8 == 8'b00010100 || second_inst_8 == 8'b00000101 || second_inst_8 == 8'b00000100 || second_inst_8 == 8'b01000101 || second_inst_8 == 8'b01000100 || second_inst_8 == 8'b01111101 || second_inst_8 = 8'b01111100 || second_inst_8 == 8'b01001101 || second_inst_8 == 8'b01001100 || second_inst_8 == 8'b01011101 || second_inst_8 == 8'b01011100 || second_inst_8 == 8'b01110100 || second_inst_8 == 8'b01110101) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_I10_2 = second_inst[8:17];
            ra_2_address = second_inst[18:24];
            rt_2_address = second_inst[25:31];
            
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

            op_opcode_2 = LOAD_QUADFORM_DFORM;
                        
        end

        else if(second_inst_8 == 8'b00100100) begin
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            op_I10_2 = second_inst[8:17];
            ra_2_address = second_inst[18:24];
            rb_2_address = second_inst[25:31];
            
            op_opcode_2 = STORE_QUADFORM_DFORM;
        end

        else if(second_inst_9 == 9'b010000011 || second_inst_9 == 9'b010000010 || second_inst_9 == 9'b010000001) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            ep_I16_2 = second_inst[9:24];
            rt_2_address = second_inst[25:31];
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

        else if(second_inst_11 == 11'b00011000000 || second_inst_11 == 11'b00011001000 || second_inst_11 == 11'b00001000000 || second_inst_11 == 11'b00001001000 || second_inst_11 == 11'b01101000000 || second_inst_11 == 11'b01101000001 || second_inst_11 == 11'b00011000010 || second_inst_11 == 11'b00001000010 || second_inst_11 == 11'b00011000001 || second_inst_11 == 11'b01011000001 || second_inst_11 == 11'b00001000001 || second_inst_11 = 11'b01011001001 || second_inst_11 == 11'b01001000001 || second_inst_11 == 11'b00011001001 || second_inst_11 == 11'b00001001001 || second_inst_11 == 11'b01111001000 || second_inst_11 == 11'b01111000000 || second_inst_11 == 11'b01001001000 || second_inst_11 == 11'b01001000000 || second_inst_11 == 11'b01011001000 || second_inst_11 == 11'b01011000000 || second_inst_11 == 11'b00001011111 || second_inst_11 == 11'b00001011011 || second_inst_11 == 11'b00001011100 || second_inst_11 == 11'b00001011000 || second_inst_11 == 11'b01011000110 || second_inst_11 = 11'b01111000100 || second_inst_11 == 11'b01111001100 || second_inst_11 == 11'b01111000101 || second_inst_11 == 11'b00001010011 || second_inst_11 == 11'b00011010011 || second_inst_11 == 11'b01001010011) begin
            ep_inst2_flag = 1;
            op_inst2_flag = 0;
            rb_2_address = second_inst[11:17];
            ra_2_address = second_inst[18:24];
            rt_2_address = second_inst[25:31];
            
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
            op_I16_2 = second_inst[9:24];
            rt_2_address = second_inst[25:31];
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
            ep_inst2_flag = 0;
            op_inst2_flag = 1;
            case(second_inst_11)
                11'b00000000001:
                    begin
                        op_opcode_2 = NO_OPERATION_LOAD;
                    end
            endcase
        end

        else begin

            $display(" enter valid instructions ");

        end
    end

endmodule