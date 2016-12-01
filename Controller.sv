`timescale 1ns / 1ps

typedef enum
{
    CONTROLLER_STATE_RESET,
    CONTROLLER_STATE_IDLE,
    CONTROLLER_STATE_PLAYING,
    CONTROLLER_STATE_RECORDING
} controller_state_t;

module Controller #(
    parameter WORD_LENGTH = 16,
    parameter SYSTEM_FREQUENCY = 100000000,
    parameter SAMPLING_FREQUENCY = 1000000)
(
    input logic clock_i,                //100 Mhz Clock input
    input logic reset_i,                 //Reset signal
    input logic play_command_i,         //The play command from the user (SYNCHRONIZED)
    input logic record_command_i,        //The record command from the user (SYNCHRONIZED)
    input logic play_clip_select_i,     //The clip selection from the user (SYNCHRONIZED)
    input logic record_clip_select_i,   //The clip selection from the user (SYNCHRONIZED)
    
    output logic playing_o,
    output logic recording_o,
    
    //LED I/O
    output logic [3:0] play_clip_o,     //The play clip number for the LED display
    output logic [3:0] record_clip_o,   //The record clip number for the LED display

    //Timer I/O
    input logic timer_done_i,       //Done signal for the timer
    output logic timer_enable_o,    //Enable for the timer

    //Serializer I/O
    input logic serializer_done_i,      //Done signal for the serializer
    output logic serializer_enable_o,   //Enable for the serializer

    //Deserializer I/O
    input logic deserializer_done_i,    //Done signal for the deserializer
    output logic deserializer_enable_o, //Enable for the deserializer

    //Memory I/O
    output logic memory_rw_o,            //The read/write switch for memory
    output logic memory_0_enable_o,
    output logic memory_1_enable_o
    );
    
    //LED ouput logic
    assign play_clip_o = play_clip_select_i + 1'b1;
    assign record_clip_o = record_clip_select_i + 1'b1;

    logic current_clip;

    controller_state_t state;       //the current state of the controller
    
    always_ff @(posedge clock_i) begin
        if (~reset_i) begin
            case (state)
            CONTROLLER_STATE_RESET:
            begin
                //reset all state and components
                current_clip = 0;
                memory_rw_o = 0;
                timer_enable_o = 0;
                serializer_enable_o = 0;
                deserializer_enable_o = 0;
                memory_1_enable_o = 1'b0;
                memory_0_enable_o = 1'b0;
                playing_o = 1'b0;
                recording_o = 1'b0;
                
                state = CONTROLLER_STATE_IDLE;
            end
            CONTROLLER_STATE_IDLE:
            begin
                if (play_command_i & ~record_command_i) begin
                    //Sample the clip 
                    current_clip = play_clip_select_i;
                    //Set the state
                    state = CONTROLLER_STATE_PLAYING;
                end 
                if(~play_command_i & record_command_i) begin
                    current_clip = record_clip_select_i;
                    state = CONTROLLER_STATE_RECORDING;
                end
            end
            CONTROLLER_STATE_PLAYING:
            begin
            //If the timer says we're done, go back to the reset state
                if (~timer_done_i) begin
                    playing_o = 1'b1;
                    //Set the memory bus to read
                    memory_rw_o = 1'b0;
                    //Enable the timer
                    timer_enable_o = 1'b1;
                    //Enable the serializer
                    serializer_enable_o = 1'b1;
    
                    if (current_clip)
                        memory_1_enable_o = 1'b1;
                    else
                        memory_0_enable_o = 1'b1;
                end else begin
                    state = CONTROLLER_STATE_RESET;
                end
            end
            CONTROLLER_STATE_RECORDING:
            begin
                //If the timer says we're done, go back to the reset state
                if (~timer_done_i) begin
                    recording_o = 1'b1;
                    //Set the memory bus to write
                    memory_rw_o = 1;
                    //Enable the timer
                    timer_enable_o = 1;
                    //Enable the deserializer
                    deserializer_enable_o = 1;
                    
                    if (current_clip)
                        memory_1_enable_o = 1'b1;
                    else
                        memory_0_enable_o = 1'b1;
                end else begin
                    state = CONTROLLER_STATE_RESET;
                end
            end
            endcase // state
        end else begin
            state = CONTROLLER_STATE_RESET;
        end
    end
endmodule