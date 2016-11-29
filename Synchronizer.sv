`timescale 1ns / 1ps

module Synchronizer(
    input logic clock_i,
    input logic reset_i,
    input logic value_i,
    output logic value_o);
    
    //Metastable buffer value
    logic buffer; 
    
    always_ff @(posedge clock_i or posedge reset_i) begin
        if (reset_i) begin
            buffer <= 1'b0;
            value_o <= 1'b0;
        end else begin
            //Swap the two values (double flip-flop)
            buffer <= value_i;
            value_o <= buffer;
        end 
    end
endmodule
