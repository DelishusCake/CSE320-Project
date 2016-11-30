`timescale 1ns / 1ps

module EdgeDetector(
    input logic clock_i,
    input logic enable_i,
    input logic signal_i,
    output logic rising_o);
    
    logic detected;
    
    always_ff @(posedge clock_i)
    begin
        if (enable_i) begin
            detected <= signal_i;
        end else begin
            detected <= 1'b0; 
        end
    end
    
    assign rising_o = signal_i & (~detected);
endmodule
