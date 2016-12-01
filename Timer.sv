`timescale 1ns / 1ps

module Timer #(
    parameter WORD_LENGTH = 16,
    parameter SYSTEM_FREQUENCY = 100000000,
    parameter SAMPLING_FREQUENCY = 1000000)
(
    input logic clock_i,
    input logic enable_i,
    input logic tick_i,
    output logic done_o
);
    logic [WORD_LENGTH-1:0] counter;
    always_ff @(posedge clock_i) begin
        if (done_o)
            done_o <= 0;
        if (enable_i) begin
            if (tick_i) begin
                counter = counter + 1;
                if (counter == (2*62500)) begin
                    counter <= 0;
                    done_o <= 1'b1;
                end
            end
        end else begin
            counter <= 0;
            done_o <= 0;
        end
    end
endmodule