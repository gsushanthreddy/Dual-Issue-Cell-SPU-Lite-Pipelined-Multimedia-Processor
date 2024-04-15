always_comb begin
    if(raw_hazard_warning_instr_1 || (raw_hazard_warning_instr_2==1 && previous_raw_instr_2_flag==1)) begin
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

    else if(raw_hazard_warning_instr_2 && previous_raw_instr_2_flag==0) begin
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
        structural_hazard_warning_even = 0; // Resolving RAW will automatically resolve Structural Hazards and WAW
        structural_hazard_warning_odd = 0;
        waw_hazard_warning = 0;
        previous_raw_instr_2_flag = 1;
    end

    else if(structural_hazard_warning_even && previous_even_structural_hazard_flag==0) begin
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
        structural_hazard_warning_even = 0;
        waw_hazard_warning = 0; // Resolving Structural Hazard will automatically resolve WAW
        previous_even_structural_hazard_flag = 1;
    end

    else if(structural_hazard_warning_odd && previous_odd_structural_hazard_flag==0) begin
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
        structural_hazard_warning_odd = 0;
        waw_hazard_warning = 0; // Resolving Structural Hazard will automatically resolve WAW
        previous_odd_structural_hazard_flag = 1;
    end

    else if(waw_hazard_warning && previous_waw_hazard_flag==0) begin
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
        waw_hazard_warning = 0;
        previous_waw_hazard_flag = 1;
    end

    else begin
        if(previous_raw_instr_2_flag==0 && previous_even_structural_hazard_flag==0 && previous_odd_structural_hazard_flag==0 && previous_waw_hazard_flag==0) begin
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
end

always_ff @(posedge clock) begin // Check Stall signal logic again 
    if(structural_hazard_warning_even || structural_hazard_warning_odd || waw_hazard_warning || raw_hazard_warning_instr_1 || raw_hazard_warning_instr_2) begin
        stall <= 1;
    end

    else begin
        stall <= 0;
    end
end

always_comb begin
    if(raw_hazard_warning_instr_2==0 && previous_raw_instr_2_flag) begin
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
        previous_raw_instr_2_flag = 0;
    end
    
    else if(raw_hazard_warning_instr_2==0 && previous_even_structural_hazard_flag) begin
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

    else if(raw_hazard_warning_instr_2==0 && previous_odd_structural_hazard_flag) begin
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

    else if(raw_hazard_warning_instr_2==0 && previous_waw_hazard_flag) begin
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