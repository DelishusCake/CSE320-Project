`timescale 1ns / 1ps

/*
 * Divides one input clock frequency into another with a 50% duty cycle
 */
module FrequencyDivider #(
    parameter WORD_LENGTH = 16,
    parameter FREQUENCY_IN = 100000000,
    parameter FREQUENCY_OUT = 1000000)
    (
        input logic clock_i,
        input logic enable_i,
        output logic clock_o
    );

    //Calculate the cycle count needed 

    logic [WORD_LENGTH-1:0] counter;

    always_ff @(posedge clock_i) begin
        if (enable_i) begin
            //increment the count
            counter <= counter + 1;
            if (counter == (FREQUENCY_IN/(2*FREQUENCY_OUT))) begin
                //reset the counter if we've reached the amount needed
                counter <= 0;
                //flip the output clock
                clock_o <= ~clock_o;
            end
        end else begin
            //reset
            counter <= 1'b0;
            clock_o <= 1'b0;
        end
    end
endmodule