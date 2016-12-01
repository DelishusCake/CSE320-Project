`timescale 1ns / 1ps

module LED (
	input logic clock_i,
	input logic reset_i,
	input logic [3:0] play_clip_i,
	input logic [3:0] record_clip_i,
	output logic [7:0] anode_o,
	output logic [6:0] cathode_o
);
	logic [6:0] play_clip_anode;
	logic [6:0] record_clip_anode;

	logic display_clock;

	always_ff @(posedge clock_i or negedge reset_i)
		if(~reset_i) begin
			case (play_clip_i)
				0: play_clip_anode <= 8'b00000001;
				1: play_clip_anode <= 8'b01001111;
				2: play_clip_anode <= 8'b00010010;
				3: play_clip_anode <= 8'b00000110;
				4: play_clip_anode <= 8'b01001100;
				5: play_clip_anode <= 8'b00000000;
				6: play_clip_anode <= 8'b00000000;
				7: play_clip_anode <= 8'b00000000;
				8: play_clip_anode <= 8'b00000000;
				9: play_clip_anode <= 8'b00000000;
				default:
					play_clip_anode <= 8'b11111111;
			endcase

			case (record_clip_i)
				0: record_clip_anode <= 8'b10000001;
				1: record_clip_anode <= 8'b11001111;
				2: record_clip_anode <= 8'b10010010;
				3: record_clip_anode <= 8'b10000110;
				4: record_clip_anode <= 8'b11001100;
				5: record_clip_anode <= 8'b10000000;
				6: record_clip_anode <= 8'b10000000;
				7: record_clip_anode <= 8'b10000000;
				8: record_clip_anode <= 8'b10000000;
				9: record_clip_anode <= 8'b10000000;
				default:
					record_clip_anode <= 8'b1111111;
			endcase

			if(display_clock) begin
				cathode_o <= 7'b00000010;
				anode_o <= play_clip_anode;
			end else begin 
				cathode_o <= 7'b00000001;
				anode_o <= record_clip_anode;
			end
		end else begin
			play_clip_anode <= 7'b0;
			record_clip_anode <= 7'b0;
		end
		display_clock <= ~display_clock;
	end
endmodule