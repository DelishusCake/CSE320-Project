`timescale 1ns / 1ps

module Main (
    input logic clock_i,                //100 Mhz Clock input
    input logic reset_i,                 //Reset signal
    input logic play_i,                 //The play command from the user
    input logic record_i,                //The record command from the user
    input logic play_clip_select_i,     //The clip selection from the user
    input logic record_clip_select_i,   //The clip selection from the user

    //Audio I/O
    //PWM Microphone related signals
    output logic pdm_clk_o,
    input logic pdm_data_i,
    output logic pdm_lrsel_o,
    //PWM Speaker signals
    output logic pwm_audio_o
);

    /*
    Synchronizers: De-bounces asynchronous inputs into synchronous inputs
    */
    //Synchronous inputs
    logic play_command;
    logic record_command;
    logic play_clip_selection;
    logic record_clip_selection;
    //Synchronizer modules
    Synchronizer play_command_sync(clock_i, reset_i, play_i, play_command);
    Synchronizer record_command_sync(clock_i, reset_i, record_i, record_command);
    Synchronizer play_clip_selection_sync(clock_i, reset_i, play_clip_select_i, play_clip_selection);
    Synchronizer record_clip_selection_sync(clock_i, reset_i, record_clip_select_i, record_clip_selection);

    //LED
    logic [1:0] play_clip_value;
    logic [1:0] record_clip_value;
    //TODO: LED DRIVER GOES HERE

    //Timer
    logic timer_enable;
    logic timer_done;
    Timer timer(clock_i, timer_enable, timer_done);

    //Serializer
    logic serializer_enable;
    logic serializer_done;
    logic [15:0] serializer_data;
    Serializer serializer(clock_i, serializer_enable, serializer_done, serializer_data, pwm_audio_o);

    //Deserializer
    logic deserializer_enable;
    logic deserializer_done;
    logic [15:0] deserializer_data;
    Deserializer deserializer(
        clock_i,
        deserializer_enable,
        deserializer_done,
        deserializer_data,
        pdm_clk_o,
        pdm_data_i,
        pdm_lrsel_o);

    Controller controller(
        clock_i(clock_i),                //100 Mhz Clock input
        reset_i(reset_i),                 //Reset signal
        play_command_i(play_command),         //The play command from the user (SYNCHRONIZED)
        record_command_i(record_command),        //The record command from the user (SYNCHRONIZED)
        play_clip_select_i(play_clip_selection),     //The clip selection from the user (SYNCHRONIZED)
        record_clip_select_i(record_clip_selection),   //The clip selection from the user (SYNCHRONIZED)
        
        //LED I/O
        play_clip_o(play_clip_value),     //The play clip number for the LED display
        record_clip_o(record_clip_value),   //The record clip number for the LED display

        //Timer I/O
        timer_done_i(timer_done),       //Done signal for the timer
        timer_enable_o(timer_enable),    //Enable for the timer

        //Serializer I/O
        serializer_done_i(serializer_done),      //Done signal for the serializer
        serializer_enable_o(serializer_enable),   //Enable for the serializer

        //Deserializer I/O
        deserializer_done_i(deserializer_done),    //Done signal for the deserializer
        deserializer_enable_o(deserializer_enable), //Enable for the deserializer

        //Memory I/O
        output logic [WORD_LENGTH-1:0] memory_addr_o,   //Address for the memory banks
        output logic memory_rw_o,                       //The read/write switch for memory
        output logic memory_0_enable_o,                 //Enable for memory bank 0
        output logic memory_1_enable_o                  //Enable for memory bank 1
        );
endmodule