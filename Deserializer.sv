`timescale 1ns / 1ps

module Deserializer #(
    parameter WORD_LENGTH = 16,
    parameter SYSTEM_FREQUENCY = 100000000,
    parameter SAMPLING_FREQUENCY = 1000000)
    (
        input logic clock_i, // 100 Mhz system clock
        input logic enable_i, // Enable passed by Controller(~reset)
        //output signals
        output logic done_o, //Indicates that Data is ready
        output logic [WORD_LENGTH-1:0] data_o, //Output 16-bit Word
    
        //PDM Microphone related signals
        output logic pdm_clk_o,
        input logic pdm_data_i
    );
    
    //Clock frequency divider for the microphone
    logic scaled_clock;
    logic scaled_clock_last;
    logic [WORD_LENGTH-1:0] clock_counter;
    
    assign pdm_clk_o = scaled_clock;

    //Shift register index (0-16)
    logic [7:0] shift_count;

    always_ff @(posedge clock_i) begin
        if (enable_i & ~done_o) begin
            clock_counter = clock_counter + 1;
            if(clock_counter == ((SYSTEM_FREQUENCY/SAMPLING_FREQUENCY)/2)) begin
                scaled_clock = ~scaled_clock;
                clock_counter = 0;
            end
            if (scaled_clock & ~scaled_clock_last) begin
                //insert the sampled value at the current index
                data_o[0] = pdm_data_i;
                data_o = data_o <<< 1;
                shift_count = shift_count + 1;
                if (shift_count == 16) begin
                    //Raise the done signal if we have sampled 16 values
                    done_o = 1;
                end
            end
            scaled_clock_last = scaled_clock;
       end else begin
           done_o = 0;
           
           shift_count = 0;
           
           scaled_clock = 0;
           scaled_clock_last = 0;
           clock_counter = 0;
       end
    end
endmodule
