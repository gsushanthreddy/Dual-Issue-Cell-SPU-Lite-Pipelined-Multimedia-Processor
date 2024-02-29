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
    input [0:127] rc_input,
    input [0:6] rt_address_input,
    input [0:6] I7_input,
    input [0:9] I10_input,
    input [0:15] I16_input,
    input [0:17] I18_input,
    
    output [0:14] LS_address,
    output [0:127] LS_data_input,
    input [0:127] LS_data_output,
   
    output LS_wrt_en, // write enable for storing data in the local store

    output [0:142] out_op;

    input [0:31] PC_input,
    output [0:31] PC_output,
);
    opcode op_op_code;
    logic [0:127] ra, rb, rc, rt_value;
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

    logic LS_wrt_en;

    logic [0:14] LS_address;
    logic [0:127] LS_data_input;
    logic [0:127] LS_data_output;

    logic [0:31] PC_input;
    logic [0:31] PC_output;

    logic [0:142] fw_op_st_1;
    logic [0:142] fw_op_st_2;
    logic [0:142] fw_op_st_3;
    logic [0:142] fw_op_st_4;
    logic [0:142] fw_op_st_5;
    logic [0:142] fw_op_st_6;
    logic [0:142] fw_op_st_7;

    int s;

    always_ff @(posedge clock) begin
        ra <= ra_input;
        rb <= rb_input;
        rc <= rc_input;
        rt_address <= rt_address_input;
        op_op_code <= op_input_op_code;
        I7 <= I7_input;
        I10 <= I10_input;
        I16 <= I16_input;
        I18 <= I18_input;

    end

    always_ff @(posedge clock) begin
        if(reset==1) begin 
            fw_op_st_1 <= 143'd0;
            fw_op_st_2 <= 143'd0;
            fw_op_st_3 <= 143'd0;
            fw_op_st_4 <= 143'd0;
            fw_op_st_5 <= 143'd0;
            fw_op_st_6 <= 143'd0;
            fw_op_st_7 <= 143'd0;
            out_op     <= 143'd0;
        end
        else begin 
            fw_op_st_2 <= fw_op_st_1;
            fw_op_st_3 <= fw_op_st_2;
            fw_op_st_4 <= fw_op_st_3;
            fw_op_st_5 <= fw_op_st_4;
            fw_op_st_6 <= fw_op_st_5;
            fw_op_st_7 <= fw_op_st_6;
            out_op     <= fw_op_st_7;
        end
    end
    
    always_comb begin 
        case(op_op_code)

            // permute block
            SHIFT_LEFT_QUADWORD_BY_BITS:
                $display("Shift left quadword by bits instruction starts...");
                begin
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            SHIFT_LEFT_QUADWORD_BY_BITS_IMMEDIATE:
                $display("Shift left quadword by bits immediate instruction starts...");
                begin
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            SHIFT_LEFT_QUADWORD_BY_BYTES:
                $display("Shift left quadword by bytes instruction starts...");
                begin
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end
            
            SHIFT_LEFT_QUADWORD_BY_BYTE_IMMEDIATE:
                $display("Shift left quadword by byte immediate instruction starts...");
                begin
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            SHIFT_LEFT_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT:
                $display("Shift left quadword by bytes from bit shift count instruction starts...");
                begin
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end
            
            ROTATE_QUADWORD_BY_BYTES:
                $display("Rotate Quadword by bytes instruction starts...");
                begin
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            ROTATE_QUADWORD_BY_BYTES_IMMEDIATE:
                $display("Rotate Quadword by bytes immediate instruction starts...");
                begin
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            ROTATE_QUADWORD_BY_BYTES_FROM_BIT_SHIFT_COUNT:
                $display("Rotate Quadword by bytes from bit shift count instruction starts...");
                begin
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end
            
            ROTATE_QUADWORD_BY_BITS:
                $display("Rotate Quadword by bits instruction starts...");
                begin
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            ROTATE_QUADWORD_BY_BITS_IMMEDIATE:
                $display("Rotate Quadword by bits immediate instruction starts...");
                begin
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            GATHER_BITS_FROM_BYTES:
                $display("Gather bits from bytes instruction starts...");
                begin
                    s6 = 16'd0;
                    for(int j=0;b<16;j++) 
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            GATHER_BITS_FROM_HALFWORDS:
                $display("Gather bits from halfwords instruction starts...");
                begin
                    s5 = 8'd0;
                    for(int j=0;b<8;j++) 
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end
                
            GATHER_BITS_FROM_WORDS:
                $display("Gather bits from words instruction starts...");
                begin
                    s4 = 4'd0;
                    for(int j=0;b<4;j++) 
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
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            // Load and store
            LOAD_QUADFORM_DFORM:
                $display("Load quadform D-form instruction starts...");
                begin
                    LS_address = ($signed({{18{I10[0]}}, I10, 4'b0}) + $signed(ra[0:31])) & LSLR & 32'hFFFFFFF0;
                    rt_value = LS_data_output;

                    unit_latency = 4'd7;
                    unit_id = 3'd6;

                    wrt_en_op = 1'd1;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            LOAD_QUADWORD_AFORM:
                $display("Load quadform A-form instruction starts...");
                begin
                    LS_address = ({{14{I16[0]}}, I16, 2'b0}) & LSLR & 32'hFFFFFFF0;
                    rt_value = LS_data_output;

                    unit_latency = 4'd7;
                    unit_id = 3'd6;

                    wrt_en_op = 1'd1;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            STORE_QUADFORM_DFORM:
                $display("Store quadform D-form instruction starts...");
                begin
                    LS_address = ($signed({{18{I10[0]}}, I10, 4'b0}) + $signed(ra[0:31])) & LSLR & 32'hFFFFFFF0;
                    LS_data_input = rt_value;

                    unit_latency = 4'd7;
                    unit_id = 3'd6;

                    LS_wrt_en = 1'b1;

                    wrt_en_op = 1'd0;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            STORE_QUADFORM_AFORM:
                $display("Store quadform A-form instruction starts...");
                begin
                    LS_address = ({{14{I16[0]}}, I16, 2'b0}) & LSLR & 32'hFFFFFFF0;
                    LS_data_input = rt_value;

                    unit_latency = 4'd7;
                    unit_id = 3'd6;

                    LS_wrt_en = 1'b1;

                    wrt_en_op = 1'd0;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            // Branch
            BRANCH_RELATIVE:
                $display("Branch relative instruction starts...");
                begin
                    PC_output = ($signed(PC_input) + $signed({{14{I16[0]}}, I16, 2'b0})) & LSLR;

                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            BRANCH_ABSOLUTE:
                $display("Branch absolute instruction starts...");
                begin
                    PC_output = ({{14{I16[0]}}, I16, 2'b0}) & LSLR;

                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            BRANCH_RELATIVE_AND_SET_LINK:
                $display("Branch relative and set link instruction starts...");
                begin
                    rt_value[0:31] = (PC_input + 4) & LSLR;
                    rt_value[32:127] = 96'd0;
                    PC_output = (PC_input + $signed({{14{I16[0]}}, I16, 2'b0})) & LSLR;

                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd1;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            BRANCH_ABSOLUTE_AND_SET_LINK:
                $display("Branch absolute and set link instruction starts...");
                begin
                    rt_value[0:31] = (PC_input + 4)& LSLR;
                    rt_value[32:127] = 96'd0;
                    PC_output = ({{14{I16[0]}}, I16, 2'b0}) & LSLR;

                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd1;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            BRANCH_IF_NOT_ZERO_WORD:
                $display("Branch if not zero word instruction starts...");
                begin
                    if (rt_value[0:31] != 0) begin
                        PC_output = (PC_input + $signed({{14{I16[0]}}, I16, 2'b0})) & LSLR & 32'hFFFFFFFC;

                    end 
                    else begin
                        PC_output = (PC_input + 4) & LSLR;
                    end
                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            BRANCH_IF_ZERO_WORD:
                $display("Branch if zero word instruction starts...");
                begin
                    if (rt_value[0:31] = 0) begin
                        PC_output = (PC_input + $signed({{14{I16[0]}}, I16, 2'b0})) & LSLR & 32'hFFFFFFFC;

                    end 
                    else begin
                        PC_output = (PC_input + 4) & LSLR;
                    end
                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            BRANCH_IF_NOT_ZERO_HALFWORD:
                $display("Branch if not zero halfword instruction starts...");
                begin
                    if (rt_value[16:31] != 0) begin
                        PC_output = (PC_input + $signed({{14{I16[0]}}, I16, 2'b0})) & LSLR & 32'hFFFFFFFC;

                    end 
                    else begin
                        PC_output = (PC_input + 4) & LSLR;
                    end
                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

            BRANCH_IF_ZERO_HALFWORD:
                $display("Branch if zero halfword instruction starts...");
                begin
                    if (rt_value[16:31] = 0) begin
                        PC_output = (PC_input + $signed({{14{I16[0]}}, I16, 2'b0})) & LSLR & 32'hFFFFFFFC;

                    end 
                    else begin
                        PC_output = (PC_input + 4) & LSLR;
                    end
                    unit_latency = 4'd1;
                    unit_id = 3'd7;

                    wrt_en_op = 1'd0;
                    fw_op_st_1 = {unit_id, rt_value, wrt_en_op, rt_address, unit_latency};
                end

                // No operation ( load )
                NO_OPERATION_LOAD:
                $display("No operation (load) instruction starts...");
                begin
                   
                   rt_value = 128'd0;
                   PC_output = 32'd0;
                   wrt_en_op = 1'd0;

                end

            
        endcase
    end
            
endmodule           

            