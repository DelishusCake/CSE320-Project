`timescale 1ns / 1ps

module Counter #(
    parameter WORD_LENGTH = 16,
    parameter SYSTEM_FREQUENCY = 100000000,
    parameter SAMPLING_FREQUENCY = 1000000)
(
    input logic clock_i,
    input logic reset_i,
    input logic timer_done_i,
    input logic serializer_done_i,
    input logic deserializer_done_i,
    output logic [WORD_LENGTH:0] memory_address_o
);
    always_ff @(posedge clock_i) begin
        if (~reset_i) begin
            if(deserializer_done_i | serializer_done_i) begin
                memory_address_o <= memory_address_o + 1;
            end 
            if (timer_done_i) begin
                memory_address_o <= 0;
            end
        end else begin
            memory_address_o = 0;
        end
    end
endmodule
