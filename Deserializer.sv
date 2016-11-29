`timescale 1ns / 1ps

/*
 * Divides one input clock frequency into another with a 50% duty cycle
 */
module ClockDivider #(
    parameter WORD_LENGTH = 16,
    parameter FREQUENCY_IN = 100000000,
    parameter FREQUENCY_OUT = 1000000)
    (
        input logic clock_i,
        input logic enable_i,
        output logic clock_o,
    );

    parameter COUNT = (FREQUENCY_IN/(2*FREQUENCY_OUT));

    logic [WORD_LENGTH-1:0] counter;

    always_ff @(posedge clock_i) begin
        if (enable_i) begin
            counter <= counter + 1;
            if (counter == COUNT) begin
                counter <= 0;
                clock_o <= ~clock_o;
            end
        end else begin
            counter <= 1'b0;
            clock_o <= 1'b0;
        end
    end
endmodule

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
    
    ClockDivider #(WORD_LENGTH,SYSTEM_FREQUENCY,SAMPLING_FREQUENCY) pdm_divider(clock_i, enable_i, pdm_clk_o);

    //tie the right/left select to low (left)
    pdm_lrsel_o <= 1'b0;

    //Shift register counter and value
    logic [15:0] shift_register;
    logic [7:0] shift_counter;

    always_ff @(posedge clock_i) begin
        if (enable_i) begin
            //Shift the shift register forward
            shift_register = shift_register << 1;
            //insert the sampled value at the end
            shift_register[0] = pdm_data_i;
            //increment the count
            shift_counter = shift_counter + 1;
            
            //Raise the done signal if we have sampled 16 values
            if (shift_counter == 16) begin
                data_o <= shift_register;
                done_o <= 1'b1;
            end
        end else begin
            //reset
            done_o <= 1'b0;
            shift_counter <= 8'b0;
            shift_register <= 16'b0;
        end
    end
endmodule
