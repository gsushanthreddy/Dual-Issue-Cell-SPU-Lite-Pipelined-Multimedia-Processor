import descriptions::*;

module LocalStore(
    input clock,
    input localstore_wrt_en,
    input [0:14] LS_address,
    input [0:127] LS_data_input,

    output [0:127] LS_data_output,
);

logic [0:7] ls [0:32767];

always_comb 
begin
    for (int i=0; i<16 ; i++)
    begin
        LS_data_output[i*BYTE : (i+1)*BYTE-1] = ls[i + LS_address];
    end
end

always_ff @(posedge clock) begin
        if(localstore_wrt_en) 
        begin
            for(int i=0; i<16 ; i++)
            begin
                ls[i + LS_address] <= LS_data_input[i*BYTE : (i+1)*BYTE-1];
            end
        end
end
 
endmodule