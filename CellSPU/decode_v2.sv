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
    
    always_comb begin // Change this to always_ff
        if(stall==0) begin
            if(branch==1) begin
                
            end
            else begin 
                pc = pc_output;
                first_inst = instruction_memory[pc];
                second_inst = instruction_memory[pc+1];
                $display("first_inst = %b",first_inst);
                $display("second_inst = %b",second_inst); 
            end
        end
    end