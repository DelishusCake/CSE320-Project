`timescale 1ns / 1ps

module Timer #(
    parameter WORD_LENGTH = 16,
    parameter SYSTEM_FREQUENCY = 100000000,
    parameter SAMPLING_FREQUENCY = 1000000)
(
    input logic clock_i,
    input logic enable_i,
    output logic done_o
);
    logic [15:0] counter;
    always_ff @(posedge clock_i) begin
        if (done_o)
            done_o <= 0;
        if (enable_i) begin
            counter = counter + 1;
            if (counter == SYSTEM_FREQUENCY) begin
                counter <= 0;
                done_o <= 1'b1;
            end
        end else begin
            counter <= 0;
            done_o <= 0;
        end
    end
endmodule