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
    int pc;
    logic [0:7] instruction_memory[2047]; //2KB memory file
    initial begin 
        $readmemb("C:/Users/susha/Desktop/Stony Brook/Spring 2024/ESE 545 - Computer Architecture/Project/Parser/InstructionsToBinary.txt", instruction_memory);
    end

    always_ff @(posedge clock) begin
        pc <= pc_input;
        if(stall==0) begin
            if(branch_taken==0) begin
                first_inst <= {instruction_memory[pc],instruction_memory[pc+1],instruction_memory[pc+2],instruction_memory[pc+3]};
                second_inst <= {instruction_memory[pc+4],instruction_memory[pc+5],instruction_memory[pc+6],instruction_memory[pc+7]};
            end
            else begin
                if(pc_input[29]==1) begin
                    first_inst <= {11'b00000000001,21'bx};
                    second_inst <= {instruction_memory[pc],instruction_memory[pc+1],instruction_memory[pc+2],instruction_memory[pc+3]};
                end
                else begin
                    first_inst <= {instruction_memory[pc],instruction_memory[pc+1],instruction_memory[pc+2],instruction_memory[pc+3]};
                    second_inst <= {instruction_memory[pc+4],instruction_memory[pc+5],instruction_memory[pc+6],instruction_memory[pc+7]};
                end
            end
            pc<=pc+8;
        end

        else begin
            pc<=pc;
        end
        pc_output <= pc;
    end
endmodule