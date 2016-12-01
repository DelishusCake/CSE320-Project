`timescale 1ns / 1ps

module Serializer #(
    parameter WORD_LENGTH = 16,
    parameter SYSTEM_FREQUENCY = 100000000,
    parameter SAMPLING_FREQUENCY = 1000000)
(
    input logic clock_i,
    input logic enable_i,

    output logic done_o,
    input logic [WORD_LENGTH-1:0] Data_i,

    output logic pwm_audio_o   
);
    //Clock frequency divider for the microphone
    logic scaled_clock;
    logic scaled_clock_last;
    logic [WORD_LENGTH-1:0] clock_counter;

    //Shift register index (0-16)
    logic [7:0] shift_index;

    always_ff @(posedge clock_i) begin
        if (done_o)
            done_o <= 0;
        if (enable_i & ~done_o) begin
            clock_counter = clock_counter + 1;
            if(clock_counter == ((SYSTEM_FREQUENCY/SAMPLING_FREQUENCY)/2)) begin
                scaled_clock = ~scaled_clock;
                clock_counter = 0;
            end
            if (scaled_clock & ~scaled_clock_last) begin
                //insert the sampled value at the current index
                pwm_audio_o = Data_i[shift_index];
                if (shift_index == 0) begin
                    //Raise the done signal if we have sampled 16 values
                    done_o <= 1;
                    shift_index <= (WORD_LENGTH-1);
                end else begin
                    shift_index = shift_index - 1;
                end
            end
            scaled_clock = scaled_clock_last;
       end else begin
           done_o <= 0;
           
           shift_index <= (WORD_LENGTH-1);
           
           scaled_clock <= 0;
           scaled_clock_last <= 0;
           clock_counter <= 0;
       end
    end
endmodule