`timescale 1ns / 1ps

/*
Testbed module
*/
module TB;
    logic clock;
    logic enable;
    logic done;
    logic [15:0] data;
    logic audio_out;

    Serializer serializer(clock, enable, done, data, audio_out);

    initial begin
        clock = 0;
        data = 16'b0101101011010111;
        enable = 0;
    #10 enable = 1;
    end

    always begin
    #5  clock = ~clock;
    end
endmodule