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
        output logic [15:0] data_o, //Output 16-bit Word
    
        //PDM Microphone related signals
        output logic pdm_clk_o,
        input logic pdm_data_i,
        output logic pdm_lrsel_o
    );
    
    //Clock frequency divider for the microphone
    FrequencyDivider #(WORD_LENGTH,SYSTEM_FREQUENCY,SAMPLING_FREQUENCY) pdm_divider(clock_i, enable_i, pdm_clk_o);

    //tie the right/left select to low (left)
    //TODO: I don't think this needs to be different, but it can be changed if needed
    assign pdm_lrsel_o = 1'b0;

    //Shift register index (0-16)
    logic [7:0] shift_index;

    always_ff @(posedge clock_i) begin
        if (done_o)
            done_o = 1'b0; //reset the done signal
        if (enable_i) begin
            //Shift the shift register forward
            shift_index = shift_index + 1;
            if (shift_index == 16) begin
                //Raise the done signal if we have sampled 16 values
                done_o <= 1'b1;
            end else begin
                //insert the sampled value at the current index
                data_o[shift_index] = pdm_data_i;
            end
        end else begin
            //reset
            done_o <= 1'b0;
            shift_index <= 8'b0;
        end
    end
endmodule
