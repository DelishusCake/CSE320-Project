`timescale 1ns / 1ps

/*
Testbed module
*/
module TB;
    logic clock_i;                //100 Mhz Clock input
    //User Input
    logic reset_i;                 //Reset signal
    logic play_i;                 //The play command from the user
    logic record_i;                //The record command from the user
    logic play_clip_select_i;     //The clip selection from the user
    logic record_clip_select_i;   //The clip selection from the user
    
    //LED outputs
    logic [6:0] cathode_play_o;
    logic [6:0] cathode_record_o;
    
    //Audio I/O
    //PWM Microphone related signals
    logic pdm_clk_o;
    logic pdm_data_i;
    logic pdm_lrsel_o;
    //PWM Speaker signals
    logic pwm_audio_o;
    logic pwm_sdaudio_o;
    Main main(
        clock_i,                //100 Mhz Clock input
        //User Input
        reset_i,                 //Reset signal
        play_i,                 //The play command from the user
        record_i,                //The record command from the user
        play_clip_select_i,     //The clip selection from the user
        record_clip_select_i,   //The clip selection from the user
        
        //LED outputs
        cathode_play_o,
        cathode_record_o,
        
        //Audio I/O
        //PWM Microphone related signals
        pdm_clk_o,
        pdm_data_i,
        pdm_lrsel_o,
        //PWM Speaker signals
        pwm_audio_o,
        pwm_sdaudio_o);

    initial begin
        clock_i = 0;
        reset_i = 0;
        play_i = 0;
        record_i = 0;
        play_clip_select_i = 0;
        record_clip_select_i = 0;
    #20 reset_i = 1;
    #20 reset_i = 0;
    #20 play_i = 1;
    #21 play_i = 0;
    end

    always begin
    #5  clock_i = ~clock_i;
    end
endmodule