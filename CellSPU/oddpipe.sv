import descriptions::*;

// op_input_op_code = odd pipe op code given as input (declaring port)
// op_op_code = odd pipe op code
// wrt_en_op = write enable
// fw_op_st_X = forward odd pipe stage X = Total 143 bits = 3 bits uid + 128 bits rt_value + 1 bit write enable + 7 bits rt address value + 4 bits instruction latency
//ls_wrt_en = write enable for local store for store instructions

module oddpipe(
    input clock,
    input reset,
    input opcode op_input_op_code,
    input [0:127] ra_input,
    input [0:127] rb_input,
    input [0:6] rt_address_input,
    input [0:6] I7_input,
    input [0:9] I10_input,
    input [0:15] I16_input,
    input [0:17] I18_input,
    
    output logic flush,
    output logic [0:14] LS_address,
    output logic [0:127] LS_data_input,
    input logic [0:127] LS_data_output,
   
    output logic LS_wrt_en, // write enable for storing data in the local store
    
    output logic [0:142] fw_op_st_1,
    output logic [0:142] fw_op_st_2,
    output logic [0:142] fw_op_st_3,
    output logic [0:142] fw_op_st_4,
    output logic [0:142] fw_op_st_5,
    output logic [0:142] fw_op_st_6,
    output logic [0:142] fw_op_st_7,

    output logic branch_taken,

    input logic [0:31] PC_input,
    output logic [0:31] PC_output
);
    opcode op_op_code;
    logic [0:127] ra, rb, rt_value;
    logic [0:6] rt_address;
    logic [0:6] I7;
    logic [0:9] I10;
    logic [0:15] I16;
    logic [0:17] I18;

    logic [0:3] s4;
    logic [0:7] s5;
    logic [0:15] s6;
    
    logic [0:3] unit_latency;
    logic [0:2] unit_id; 
    logic [0:127] t_128;

    logic wrt_en_op;

    logic [0:31] pc_input;

    int s;

    always_ff @(posedge clock) begin// do we have to add reset and flush logic constarint in triggering this register
        if(reset == 1) begin
            ra <= 127'd0;
            rb <= 127'd0;
            rt_address <= 7'dx;
            op_op_code <= NO_OPERATION_LOAD;
            I7 <= 7'd0;
            I10 <= 10'd0;
            I16 <= 16'd0;
            I18 <= 18'd0;
            //pc_input <= PC_input;// check this
        end
        else if (flush==1) begin
            ra <= 127'd0;
            rb <= 127'd0;
            rt_address <= 7'dx;
            op_op_code <= NO_OPERATION_LOAD;
            I7 <= 7'd0;
            I10 <= 10'd0;
            I16 <= 16'd0;
            I18 <= 18'd0;
            //pc_input <= PC_input;// check this
        end
        else begin
            ra <= ra_input;
            rb <= rb_input;
            rt_address <= rt_address_input;
            op_op_code <= op_input_op_code;
            I7 <= I7_input;
            I10 <= I10_input;
            I16 <= I16_input;
            I18 <= I18_input;
            pc_input <= PC_input;
        end

    end

    always_ff @(posedge clock) begin
        if(reset==1) begin 
            fw_op_st_2 <= 143'd0;
            fw_op_st_3 <= 143'd0;
            fw_op_st_4 <= 143'd0;
            fw_op_st_5 <= 143'd0;
            fw_op_st_6 <= 143'd0;
            fw_op_st_7 <= 143'd0;
        end
        else begin 
            if(flush==1) begin
                fw_op_st_2 <= 143'd0;
                fw_op_st_3 <= fw_op_st_2;
                fw_op_st_4 <= fw_op_st_3;
                fw_op_st_5 <= fw_op_st_4;
                fw_op_st_6 <= fw_op_st_5;
                fw_op_st_7 <= fw_op_st_6;
            end
            else begin 
                fw_op_st_2 <= fw_op_st_1;
                fw_op_st_3 <= fw_op_st_2;
                fw_op_st_4 <= fw_op_st_3;
                fw_op_st_5 <= fw_op_st_4;
                fw_op_st_6 <= fw_op_st_5;
                fw_op_st_7 <= fw_op_st_6;
            end
        end
    end
    
    always_comb begin
        branch_taken = 1'd0;
        flush = 1'd0; 
        case(op_op_code)

            // permute block
            SHIFT_LEFT_QUADWORD_BY_BITS:
                begin
                    $display("Shift left quadword by bits instruction starts...");
                    s = rb[29:31];
                    for(int b=0;b<128;b++) 
                        begin
                            if (b+s < 128) begin
                                t_128[b] = ra[b+s];
                            end 
                            else begin
                                t_128[b] = 0;
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h, rb value = %h,rt_value = %h",ra,rb,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE:
                begin
                    $display("Shift left quadword by bits immediate instruction starts...");
                    s = I7 & 7'h07;
                    for(int b=0;b<128;b++) 
                        begin
                            if (b+s < 128) begin
                                t_128[b] = ra[b+s];
                            end 
                            else begin
                                t_128[b] = 0;
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h, I7 value = %h,rt_value = %h",ra,I7,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            SHIFT_LEFT_QUADWORD_BY_BYTES:
                begin
                    $display("Shift left quadword by bytes instruction starts...");
                    s = rb[27:31];
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = 8'd0;
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h, rb value = %h,rt_value = %h",ra,rb,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end
            
            SHIFT_LEFT_QUADWORD_BY_BYTE_IMMEDIATE:
                begin
                    $display("Shift left quadword by byte immediate instruction starts...");
                    s = I7 & 7'h1F;
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = 8'd0;
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h, I7 value = %h,rt_value = %h",ra,I7,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            SHIFT_LEFT_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT:
                begin
                    $display("Shift left quadword by bytes from bit shift count instruction starts...");
                    s = rb[24:28];
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = 8'd0;
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h, rb value = %h,rt_value = %h",ra,rb,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end
            
            ROTATE_QUADWORD_BY_BYTES:
                begin
                    $display("Rotate Quadword by bytes instruction starts...");
                    s = rb[28:31];
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s-16)*BYTE) +: BYTE];
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h, rb value = %h,rt_value = %h",ra,rb,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            ROTATE_QUADWORD_BY_BYTES_IMMEDIATE:
                begin
                    $display("Rotate Quadword by bytes immediate instruction starts...");
                    s = I7[3:6];
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s-16)*BYTE) +: BYTE];
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h, I7 value = %h,rt_value = %h",ra,I7,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            ROTATE_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT:
                begin
                    $display("Rotate Quadword by bytes from bit shift count instruction starts...");
                    s = rb[24:28];
                    for(int b=0;b<16;b++) 
                        begin
                            if (b+s < 16) begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s)*BYTE) +: BYTE];
                            end 
                            else begin
                                t_128[(b*BYTE) +: BYTE] = ra[((b+s-16)*BYTE) +: BYTE];
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h, rb value = %h,rt_value = %h",ra,rb,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end
            
            ROTATE_QUADWORD_BY_BITS:
                begin
                    $display("Rotate Quadword by bits instruction starts...");
                    s = rb[29:31];
                    for(int b=0;b<128;b++) 
                        begin
                            if (b+s < 128) begin
                                t_128[b] = ra[b+s];
                            end 
                            else begin
                                t_128[b] = ra[b+s-128];
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h, rb value = %h,rt_value = %h",ra,rb,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            ROTATE_QUADWORD_BY_BITS_IMMEDIATE:
                begin
                    $display("Rotate Quadword by bits immediate instruction starts...");
                    s = I7[4:6];
                    for(int b=0;b<128;b++) 
                        begin
                            if (b+s < 128) begin
                                t_128[b] = ra[b+s];
                            end 
                            else begin
                                t_128[b] = ra[b+s-128];
                            end
                        end
                    rt_value = t_128;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h, I7 value = %h,rt_value = %h",ra,I7,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            GATHER_BITS_FROM_BYTES:
                begin
                    $display("Gather bits from bytes instruction starts...");
                    s6 = 16'd0;
                    for(int j=0;j<16;j++) 
                        begin
                            s6[j] = ra[(j*BYTE + (BYTE-1))];
                        end
                    rt_value[0 : 31] = {16'd0, s6};
                    rt_value[32 : 63] = 32'd0;
                    rt_value[64 : 95] = 32'd0;
                    rt_value[96 : 127] = 32'd0;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h,rt_value = %h",ra,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            GATHER_BITS_FROM_HALFWORDS:
                begin
                    $display("Gather bits from halfwords instruction starts...");
                    s5 = 8'd0;
                    for(int j=0;j<8;j++) 
                        begin
                            s5[j] = ra[(j*HALFWORD + (HALFWORD-1))];
                        end
                    rt_value[0 : 31] = {24'd0, s5};
                    rt_value[32 : 63] = 32'd0;
                    rt_value[64 : 95] = 32'd0;
                    rt_value[96 : 127] = 32'd0;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h,rt_value = %h",ra,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end
                
            GATHER_BITS_FROM_WORDS:
                begin
                    $display("Gather bits from words instruction starts...");
                    s4 = 4'd0;
                    for(int j=0;j<4;j++) 
                        begin
                            s4[j] = ra[(j*WORD + (WORD-1))];
                        end
                    rt_value[0 : 31] = {28'd0, s4};
                    rt_value[32 : 63] = 32'd0;
                    rt_value[64 : 95] = 32'd0;
                    rt_value[96 : 127] = 32'd0;
                    unit_latency = 4'd4;
                    unit_id = 3'd5;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h,rt_value = %h",ra,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            // Load and store
            LOAD_QUADFORM_DFORM:
                begin
                    $display("Load quadform D-form instruction starts...");
                    LS_address = ($signed({{18{I10[0]}}, I10, 4'b0}) + $signed(ra[0:31])) & 32'hFFFFFFF0;
                    rt_value = LS_data_output;

                    unit_latency = 4'd7;
                    unit_id = 3'd6;

                    LS_wrt_en = 1'b0;

                    wrt_en_op = 1'd1;
                    $display("ra value = %h, I10 value = %h,LS address = %h, LS value = %h, rt loaded value = %h",ra,I10,LS_address,LS_data_output,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            LOAD_QUADWORD_AFORM:
                begin
                    $display("Load quadform A-form instruction starts...");
                    LS_address = ({{14{I16[0]}}, I16, 2'b0}) & 32'hFFFFFFF0;
                    rt_value = LS_data_output;

                    unit_latency = 4'd7;
                    unit_id = 3'd6;

                    LS_wrt_en = 1'b0;

                    wrt_en_op = 1'd1;
                    $display("I10 value = %h,LS address = %h, LS value = %h, rt loaded value = %h",I10,LS_address,LS_data_output,rt_value);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            STORE_QUADFORM_DFORM:
                begin
                    $display("Store quadform D-form instruction starts...");
                    LS_address = ($signed({{18{I10[0]}}, I10, 4'b0}) + $signed(ra[0:31])) & 32'hFFFFFFF0;
                    LS_data_input = rb;

                    unit_latency = 4'd7;
                    unit_id = 3'd6;

                    LS_wrt_en = 1'b1;

                    wrt_en_op = 1'd0;
                    $display("ra value = %h, I10 value = %h,LS address = %h, LS loaded value = %h, value to load from reg = %h",ra,I10,LS_address,LS_data_input,rb);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            STORE_QUADFORM_AFORM:
                begin
                    $display("Store quadform A-form instruction starts...");
                    LS_address = ({{14{I16[0]}}, I16, 2'b0}) & 32'hFFFFFFF0;
                    LS_data_input = rb;

                    unit_latency = 4'd7;
                    unit_id = 3'd6;

                    LS_wrt_en = 1'b1;

                    wrt_en_op = 1'd0;
                    $display("I10 value = %h,LS address = %h, LS loaded value = %h, value to br loaded from reg = %h",I10,LS_address,LS_data_input,rb);
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            // Branch
            BRANCH_RELATIVE:
                begin
                    $display("Branch relative instruction starts...");
                    PC_output = ($signed(pc_input) + $signed({{14{I16[0]}}, I16, 2'b0}));

                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;

                    branch_taken = 1'd1;
                    flush = 1'd1;
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                    $display("PC output = %h,PC input = %h,Branch taken = %b",PC_output,pc_input,branch_taken);

                end

            BRANCH_ABSOLUTE:
                begin
                    $display("Branch absolute instruction starts...");
                    PC_output = ({{14{I16[0]}}, I16, 2'b0});

                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;

                    branch_taken = 1'd1;
                    flush = 1'd1;
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                    $display("PC output = %h,Branch taken = %b",PC_output,branch_taken);
                end

            BRANCH_RELATIVE_AND_SET_LINK:
                begin
                    $display("Branch relative and set link instruction starts...");
                    rt_value[0:31] = (pc_input + 4);
                    rt_value[32:127] = 96'd0;
                    PC_output = (pc_input + $signed({{14{I16[0]}}, I16, 2'b0}));

                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd1;

                    branch_taken = 1'd1;
                    flush = 1'd1;
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                    $display("PC output = %h,PC input = %h,Branch taken = %b,rt value = %h",PC_output,pc_input,branch_taken,rt_value);
                end

            BRANCH_ABSOLUTE_AND_SET_LINK:
                begin
                    $display("Branch absolute and set link instruction starts...");
                    rt_value[0:31] = (pc_input + 4);
                    rt_value[32:127] = 96'd0;
                    PC_output = ({{14{I16[0]}}, I16, 2'b0});

                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd1;

                    branch_taken = 1'd1;
                    flush = 1'd1;
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                    $display("PC output = %h,PC input = %h,Branch taken = %b,rt value = %h",PC_output,pc_input,branch_taken,rt_value);
                end

            BRANCH_IF_NOT_ZERO_WORD:
                begin
                    $display("Branch if not zero word instruction starts...");
                    if (rb[0:31] != 0) begin
                        PC_output = (pc_input + $signed({{14{I16[0]}}, I16, 2'b0})) & 32'hFFFFFFFC;
                        branch_taken = 1'd1;
                        flush = 1'd1;
                    end 

                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                    $display("PC output = %h,PC input = %h,Branch taken = %b",PC_output,pc_input,branch_taken);
                end

            BRANCH_IF_ZERO_WORD:
                begin
                    $display("Branch if zero word instruction starts...");
                    if (rb[0:31] == 0) begin
                        PC_output = (pc_input + $signed({{14{I16[0]}}, I16, 2'b0})) & 32'hFFFFFFFC;
                        branch_taken = 1'd1;
                        flush = 1'd1;
                    end 
                    
                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                    $display("PC output = %h,PC input = %h,Branch taken = %b",PC_output,pc_input,branch_taken);
                end

            BRANCH_IF_NOT_ZERO_HALFWORD:
                begin
                    $display("Branch if not zero halfword instruction starts...");
                    if (rb[16:31] != 0) begin
                        PC_output = (pc_input + $signed({{14{I16[0]}}, I16, 2'b0})) & 32'hFFFFFFFC;
                        branch_taken = 1'd1;
                        flush = 1'd1;
                    end 
                    
                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                    $display("PC output = %h,PC input = %h,Branch taken = %b",PC_output,pc_input,branch_taken);
                end

            BRANCH_IF_ZERO_HALFWORD:
                begin
                    $display("Branch if zero halfword instruction starts...");
                    if (rb[16:31] == 0) begin
                        PC_output = (pc_input + $signed({{14{I16[0]}}, I16, 2'b0})) & 32'hFFFFFFFC;
                        branch_taken = 1'd1;
                        flush = 1'd1;
                    end 
                    
                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;
                    //fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                    $display("PC output = %h,PC input = %h,Branch taken = %b",PC_output,pc_input,branch_taken); 
                end

            // No operation ( load )
            NO_OPERATION_LOAD:
                begin
                   $display("No operation (load) instruction starts...");
                   rt_value = 128'd0;
                   PC_output = 32'd0;
                   wrt_en_op = 1'd0;
                end

        endcase
        fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
    end
            
endmodule           

            