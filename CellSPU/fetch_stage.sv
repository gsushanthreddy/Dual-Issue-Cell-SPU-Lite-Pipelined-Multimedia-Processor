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

    logic [0:7] instruction_memory[2047], //2KB memory file
    logic last_instruction; // last instruction flag
    int pc;
    initial begin 
        $readmemb("C:/Users/susha/Desktop/Stony Brook/Spring 2024/ESE 545 - Computer Architecture/Project/Parser/InstructionsToBinary.txt", instruction_memory);
    end

    always_ff @(posedge clock) begin
        if(reset==1) begin
            pc <= 0;
        end
        else if(stall==0) begin
            if(last_instruction==1) begin
                first_inst <= {11'b00000000001,21'bx};
                second_inst <= {11'b01000000001, 21'bx};
            end
            else if(branch_taken==0) begin
                pc <= pc_output;
                if({instruction_memory[pc],instruction_memory[pc+1][0:2]} != 11'b0 && {instruction_memory[pc+4],instruction_memory[pc+5][0:2]} != 11'b0) begin
                    first_inst <= {instruction_memory[pc],instruction_memory[pc+1],instruction_memory[pc+2],instruction_memory[pc+3]};
                    second_inst <= {instruction_memory[pc+4],instruction_memory[pc+5],instruction_memory[pc+6],instruction_memory[pc+7]};
                    pc <= pc+8;
                end
                else if({instruction_memory[pc],instruction_memory[pc+1][0:2]} != 11'b0 && {instruction_memory[pc+4],instruction_memory[pc+5][0:2]} == 11'b0) begin
                    last_instruction <= 1;
                    first_inst <= {instruction_memory[pc],instruction_memory[pc+1],instruction_memory[pc+2],instruction_memory[pc+3]};
                    second_inst <= {11'b01000000001,21'bx};
                    pc <= pc;
                end
                else if({instruction_memory[pc],instruction_memory[pc+1][0:2]} == 11'b0) begin
                    last_instruction <= 1;
                    first_inst <= {11'b00000000001,21'bx};
                    second_inst <= {11'b01000000001, 21'bx};
                    pc <= pc;
                end
            end
            else begin // If branch_taken is 1, flush should happen
                pc <= pc_input;
                if(pc_input[29]==1) begin
                    first_inst <= {11'b00000000001,21'bx}; // This hazard should not reflect in the decode stage if the second instruction is odd -> It wont enter hazard checking logic since if condtion blocks '7dx adrresses
                    second_inst <= {instruction_memory[pc],instruction_memory[pc+1],instruction_memory[pc+2],instruction_memory[pc+3]};
                    pc<=pc+4;
                end
                else begin
                    first_inst <= {instruction_memory[pc],instruction_memory[pc+1],instruction_memory[pc+2],instruction_memory[pc+3]};
                    second_inst <= {instruction_memory[pc+4],instruction_memory[pc+5],instruction_memory[pc+6],instruction_memory[pc+7]};
                    pc<=pc+8;
                end
            end
        end

        else begin
            pc<=pc;
        end
        pc_output <= pc;
    end
endmodule