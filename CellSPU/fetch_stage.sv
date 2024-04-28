import descriptions::*;

module fetch_stage(
    input clock,
    input reset,
    input logic stall,
    input logic branch_taken,
    input logic [0:31] pc_input,
    output logic [0:31] pc_output,
    output logic [0:31] first_inst,
    output logic [0:31] second_inst
);

    logic [0:7] instruction_memory[2048];
    logic [0:31] instruction_memory_temporary[64]; //2KB memory file
    logic last_instruction; // last instruction flag
    int pc;
    initial begin 
        $readmemb("C:/Users/susha/Desktop/Stony Brook/Spring 2024/ESE 545 - Computer Architecture/Project/Parser/InstructionsToBinary.txt", instruction_memory_temporary);
        
        for(int i=0;i<64;i++) begin
            instruction_memory[4*i] = instruction_memory_temporary[i][0:7];
            instruction_memory[(4*i)+1] = instruction_memory_temporary[i][8:15];
            instruction_memory[(4*i)+2] = instruction_memory_temporary[i][16:23];
            instruction_memory[(4*i)+3] = instruction_memory_temporary[i][24:31];
        end
    end

    always_ff @(posedge clock) begin
        if(reset==1) begin
            first_inst <= {11'b00000000001,21'b0};
            second_inst <= {11'b01000000001, 21'b0};
            pc <= 0;
            pc_output = pc;
        end
        else if(branch_taken==1) begin
            $display("Branchhh Takenn");
            pc = pc_input;
            $display("PCC here: %d",pc);
            if(pc_input[29]==1) begin
                first_inst <= {11'b00000000000,21'b0}; // This hazard should not reflect in the decode stage if the second instruction is odd -> It wont enter hazard checking logic since if condtion blocks '7dx adrresses
                second_inst <= {instruction_memory[pc],instruction_memory[pc+1],instruction_memory[pc+2],instruction_memory[pc+3]};
                pc=pc+4;
            end
            else begin
                first_inst <= {instruction_memory[pc],instruction_memory[pc+1],instruction_memory[pc+2],instruction_memory[pc+3]};
                second_inst <= {instruction_memory[pc+4],instruction_memory[pc+5],instruction_memory[pc+6],instruction_memory[pc+7]};
                pc=pc+8;
                $display("PC here for branch : %d",pc);
            end
            pc_output <= pc;
        end
        else if(stall==1) begin
            pc = pc;
            pc_output = pc;
        end
        else begin 
            if(last_instruction==1) begin
                first_inst <= {11'b00000000001,21'b0};
                second_inst <= {11'b01000000001, 21'b0};
            end
            else begin
                pc = pc_output;
                $display("PC for br 0 : %d",pc);
                if({instruction_memory[pc],instruction_memory[pc+1][0:2]} != 11'b0 && {instruction_memory[pc+4],instruction_memory[pc+5][0:2]} != 11'b0) begin
                    first_inst <= {instruction_memory[pc],instruction_memory[pc+1],instruction_memory[pc+2],instruction_memory[pc+3]};
                    second_inst <= {instruction_memory[pc+4],instruction_memory[pc+5],instruction_memory[pc+6],instruction_memory[pc+7]};
                    pc = pc+8;
                end
                else if({instruction_memory[pc],instruction_memory[pc+1][0:2]} != 11'b0 && {instruction_memory[pc+4],instruction_memory[pc+5][0:2]} == 11'b0) begin
                    $display("PC ENDD");
                    last_instruction <= 1;
                    first_inst <= {instruction_memory[pc],instruction_memory[pc+1],instruction_memory[pc+2],instruction_memory[pc+3]};
                    second_inst <= {11'b01000000001,21'b0};
                    pc = pc+4;
                end
                else if({instruction_memory[pc],instruction_memory[pc+1][0:2]} == 11'b0) begin
                    last_instruction <= 1;
                    first_inst <= {11'b00000000001,21'b0};
                    second_inst <= {11'b01000000001, 21'b0};
                    pc = pc;
                end
            end
            pc_output = pc;
        end    
    end
endmodule