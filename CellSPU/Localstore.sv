module LocalStore(
    input clock,
    input ls_wrt_en,
    input LS_address,
    input LS_data_input,

    output LS_data_output,
);

logic [0:7] ls [0:32767];

always_comb 
begin
    for (int i=0; i<16 ; i++)
    begin
        LS_data_output = ls[i + LS_address];
    end
end

always_ff @(posedge clock) begin
        if(ls_wrt_en) 
        begin
            for(int i=0; i<16 ; i++)
            begin
                ls[i + LS_address] = LS_data_input[i*BYTE : (i+1)*BYTE-1];
            end
        end
end
 
endmodule