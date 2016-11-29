`timescale 1ns / 1ps

module Serializer #(
    parameter WORD_LENGTH = 16,
    parameter SYSTEM_FREQUENCY = 100000000,
    parameter SAMPLING_FREQUENCY = 1000000)
(
    input clock_i,
    input enable_i,

    output done_o,
    input [15:0] Data_i,

    output pwm_audio_o Output   
);
    logic [7:0] counter;

    always_ff @(posedge clock_i) begin
        if(enable_i) begin
            Data_i = Data_i >> 1;
            Output = Data_i[0];

            counter = counter + 1'b1;
            if (counter == 16) begin
                done_o <= 1'b0;
                counter <= 7'b0;
            end 
        end else begin
            counter <= 1'b0;
            done_0 <= 1'b0;
        end
    end
endmodule