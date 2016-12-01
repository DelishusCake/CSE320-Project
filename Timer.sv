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
    logic [31:0] counter;
    always_ff @(posedge clock_i) begin
        if (enable_i & ~done_o) begin
            if (tick_i) begin
                counter = counter + 1;
                if (counter == (2*62500)) begin
                    done_o <= 1'b1;
                end
            end
        end else begin
            counter <= 0;
            done_o <= 0;
        end
    end
endmodule