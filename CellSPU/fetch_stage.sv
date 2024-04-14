import descriptions::*;

module fetch_stage(
    input clock,
    input reset,
    input logic stall,
    input logic [0:31] pc_input,
    output logic [0:31] pc_output,
    output logic [0:31] first_inst,
    output logic [0:31] second_inst
);
    int pc;
    logic [0:31] instruction_memory[512]; //2KB memory file
    initial begin 
    $readmemb("C:/Users/susha/Desktop/Stony Brook/Spring 2024/ESE 545 - Computer Architecture/Project/Parser/InstructionsToBinary.txt", instruction_memory);
    end
    
    always_ff @(posedge clock) begin 
        if(reset) begin
            pc_output <= 0;
        end

        else if(stall) begin
            pc_output <= pc_output;
        end

        else begin 
            pc_output <= pc_output+8;
        end
    end
    
    always_comb begin 
        if(stall==0) begin
            pc = pc_output;
            first_inst = instruction_memory[pc];
            second_inst = instruction_memory[pc+1];
            $display("first_inst = %b",first_inst);
            $display("second_inst = %b",second_inst); 
        end
    end
endmodule