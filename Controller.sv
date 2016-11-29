`timescale 1ns / 1ps

typedef enum
{
    CONTROLLER_STATE_RESET,
    CONTROLLER_STATE_IDLE,
    CONTROLLER_STATE_RECORDING,
    CONTROLLER_STATE_PLAYING,
    CONTROLLER_STATE_ERROR
} controller_state_t;

module Controller(
    input logic clock_i,            //100 Mhz Clock input
    input logic reset_i             //Reset signal
    input logic clip_select_i,      //The clip selection from the user (asynchronous switch)
    input logic play_i,             //The play command from the user (asynchronous button)
    input logic record_i,           //The record command from the user (asynchronous button)
    
    output logic serializer_enable_o,
    output logic deserializer_enable_o,
    output logic memory_0_enable_o,
    output logic memory_0_rw_o,
    output logic memory_1_enable_o,
    output logic memory_1_rw_o);

    /*
    Synchronizers: De-bounces asynchronous inputs into synchronous inputs
    TODO: Should these be moved to the main file?
    */
    //Synchronous inputs
    /*
    The current clip selected for recording or playing
        0: Clip 1
        1: Clip 2
    This should be set based on the user's selection via a switch
    */
    logic current_clip;
    logic play_command;
    logic record_command;
    //Synchronizer modules
    Synchronizer play_command_sync(clock_i, reset_i, play_i, play_command);
    Synchronizer record_command_sync(clock_i, reset_i, record_i, record_command);
    Synchronizer clip_selection_sync(clock_i, reset_i, clip_select_i, current_clip);

    controller_state_t state;       //the current state of the controller
    controller_state_t next_state;  //the state of the controller on the next clock tick

    always_ff @(posedge clock_i or negedge reset_i) begin
        if (reset_i) begin
            //Set the reset state
            state = CONTROLLER_STATE_RESET;
        end else begin
            //Set the state to the next state value
            state = next_state;
        end
    end

    //State transition logic
    always_comb begin
        case (state)
            CONTROLLER_STATE_RESET:
                next_state <= CONTROLLER_STATE_IDLE;
            CONTROLLER_STATE_IDLE:
            begin
                if (play_command) 
                    next_state <= CONTROLLER_STATE_PLAYING;
                else if(record_command)
                    next_state <= CONTROLLER_STATE_RECORDING;
            end
            //CONTROLLER_STATE_PLAYING:
            //CONTROLLER_STATE_RECORDING:
            //CONTROLLER_STATE_ERROR:
            default:
                next_state <= CONTROLLER_STATE_RESET;
        endcase // state
    end
    
    //Output logic
    
endmodule