`timescale 1ns / 1ps

module LED (
	input logic clock_i,
	input logic reset_i,
	input logic [3:0] play_clip_i,
	input logic [3:0] record_clip_i,
	output logic [7:0] anode_o,
	output logic [6:0] cathode_o
);
	logic display_clock;

	always_ff @(posedge clock_i) begin
		if(~reset_i) begin
            display_clock <= ~display_clock;
            if(display_clock) begin
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
	        anode_o <= 0;
		    cathode_o <= 0;
			display_clock <= 1'b0;
		end
	end
endmodule