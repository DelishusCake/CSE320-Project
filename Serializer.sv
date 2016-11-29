`timescale 1ns / 1ps

module Serializer #(
    parameter WORD_LENGTH = 16,
    parameter SYSTEM_FREQUENCY = 100000000,
    parameter SAMPLING_FREQUENCY = 1000000)
(
    input logic clock_i,
    input logic enable_i,

    output logic done_o,
    input logic [15:0] Data_i,

    output logic pwm_audio_o   
);
    //holds the current index of the bit
    integer index;

    always_ff @(posedge clock_i) begin
        if (done_o)
            //reset the done signal
            done_o = 0; 
        if(enable_i && !done_o) begin
            //Set the output to the current value 
            pwm_audio_o = Data_i[index];

            if (index == 0) begin
                //raise the done signal if all bits have been shifted out
                done_o <= 1;
                //reset the index
                index <= (WORD_LENGTH-1);
            end else begin
                //decrement the index
                index = index + 1;
            end 
        end else begin
            index <= (WORD_LENGTH-1);
            done_o <= 0;
        end
    end
endmodule