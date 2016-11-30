`timescale 1ns / 1ps

/*
 * Simple counter for counting addresses.
 */
module Counter (
	input logic clock_i,
	input logic enable_i,
	output [WORD_LENGTH-1:0] value_o
);
	always_ff @(posedge clock_i) begin
		if (enable_i) begin
			value_o <= value_o + 1;
		end else begin
			value_o <= 0;
		end
	end
endmodule