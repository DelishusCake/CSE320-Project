`timescale 1ns / 1ps

module Synchronizer(
    input logic clock,
    input logic reset,
    input logic in,
    output logic out);
    
    //Metastable buffer value
    logic buffer; 
    
    always_ff @(posedge clock) begin
        if (reset) begin
            buffer <= 1'b0;
            out <= 1'b0;
        end else begin
            //Swap the two values (double flip-flop)
            buffer <= in;
            out <= buffer;
        end 
    end
endmodule
