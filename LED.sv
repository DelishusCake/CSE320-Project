`timescale 1ns / 1ps

module LED #(
    parameter WORD_LENGTH = 16,
    parameter SYSTEM_FREQUENCY = 100000000,
    parameter SAMPLING_FREQUENCY = 1000000)
(
	input logic clock_i,
	input logic reset_i,
	input logic [3:0] play_clip_i,
	input logic [3:0] record_clip_i,
	output logic [7:0] anode_o,
	output logic [6:0] cathode_o
);
    `LED_FREQUENCY 1000;
    
	logic scaled_clock;
    logic [31:0] clock_counter;

	always_ff @(posedge clock_i) begin
		if(~reset_i) begin
            clock_counter = clock_counter + 1;
            if(clock_counter == ((SYSTEM_FREQUENCY/LED_FREQUENCY)/2)) begin
                scaled_clock = ~scaled_clock;
                clock_counter = 0;
            end
            if (scaled_clock) begin
                anode_o <= 8'b11111110;
                case (play_clip_i)
                    0: cathode_o <= 7'b1000000;
                    1: cathode_o <= 7'b1111001;
                    2: cathode_o <= 7'b0100100;
                    3: cathode_o <= 7'b0000000;
                    4: cathode_o <= 7'b0000000;
                    5: cathode_o <= 7'b0000000;
                    6: cathode_o <= 7'b0000000;
                    7: cathode_o <= 7'b0000000;
                    8: cathode_o <= 7'b0000000;
                    9: cathode_o <= 7'b0000000;
                    default:
                        cathode_o<= 7'b1111111;
                endcase
            end else begin
				anode_o <= 8'b11111101;
				case (record_clip_i)
                    0: cathode_o <= 7'b1000000;
                    1: cathode_o <= 7'b1111001;
                    2: cathode_o <= 7'b0100100;
                    3: cathode_o <= 7'b0000000;
                    4: cathode_o <= 7'b0000000;
                    5: cathode_o <= 7'b0000000;
                    6: cathode_o <= 7'b0000000;
                    7: cathode_o <= 7'b0000000;
                    8: cathode_o <= 7'b0000000;
                    9: cathode_o <= 7'b0000000;
                    default:
                        cathode_o<= 7'b1111111;
                endcase
			end
		end else begin
	        anode_o <= 8'b11111111;
		    cathode_o <= 7'b1111111;
		    clock_counter <= 0;
			scaled_clock <= 1'b0;
		end
	end
endmodule