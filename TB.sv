`timescale 1ns / 1ps

/*
Testbed module
*/
module TB;
    logic clock;
    logic enable;
    logic done;
    logic [15:0] data;
    logic audio_out;
    
    logic pdm_clk;
    logic pdm_data;
    logic pdm_lr;
    
    Deserializer #(16, 10, 1) deserializer(clock, enable, done, data, pdm_clk, pdm_data, pdm_lr);

    initial begin
        clock = 0;
        enable = 0;
        pdm_data = 0;
    #10 enable = 1;
    #100 pdm_data = 1;
    #100 pdm_data = 1;
    #100 pdm_data = 0;
    end

    always begin
    #5  clock = ~clock;
    end
endmodule