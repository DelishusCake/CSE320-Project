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
    output logic current_clip_o
    );
    
    logic play_command_last;
    logic record_command_last;
    
    always_ff @(negedge clock_i or negedge reset_i) begin
        if(reset_i) begin
            play_command_last <= 0;
            record_command_last <= 0;
        end else begin
            play_command_last <= play_command_i;
            record_command_last <= record_command_i;
        end
    end
    
    //LED ouput logic
    assign play_clip_o = play_clip_select_i + 1'b1;
    assign record_clip_o = record_clip_select_i + 1'b1;

    //State variables
    controller_state_t state;       //the current state of the controller
    controller_state_t next_state;  //the state of the controller on the next clock tick
    
    //State swap
    always_ff @(posedge clock_i or negedge reset_i) begin
        if (reset_i) begin
            //Set the reset state
            state <= CONTROLLER_STATE_RESET;
        end else begin
            //Set the state to the next state value
            state <= next_state;
        end
    end

    //State transition logic
    always_comb begin
        case (state)
            CONTROLLER_STATE_RESET:
            begin
                //reset all state and components
                current_clip_o <= 0;
                memory_rw_o <= 0;
                timer_enable_o <= 0;
                serializer_enable_o <= 0;
                deserializer_enable_o <= 0;
                
                next_state <= CONTROLLER_STATE_IDLE;
            end
            CONTROLLER_STATE_IDLE:
            begin
                if (play_command_i && !play_command_last) 
                begin
                    //Sample the clip 
                    current_clip_o <= play_clip_select_i;
                    //Set the state
                    next_state <= CONTROLLER_STATE_PLAYING;
                end else if(record_command_i && !record_command_last) begin
                    current_clip_o <= record_clip_select_i;
                    next_state <= CONTROLLER_STATE_RECORDING;
                end
            end
            CONTROLLER_STATE_PLAYING:
            begin
                //Set the memory bus to read
                memory_rw_o <= 1'b0;
                //Enable the timer
                timer_enable_o <= 1'b1;
                //Enable the serializer
                serializer_enable_o <= 1'b1;

                //If the timer says we're done, go back to the reset state
                if (timer_done_i) begin
                    next_state <= CONTROLLER_STATE_RESET;
                end
            end
            CONTROLLER_STATE_RECORDING:
            begin
                //Set the memory bus to write
                memory_rw_o <= 1;
                //Enable the timer
                timer_enable_o <= 1;
                //Enable the deserializer
                deserializer_enable_o <= 1;
                
                //If the timer says we're done, go back to the reset state
                if (timer_done_i) begin
                    next_state <= CONTROLLER_STATE_RESET;
                end
            end
            default:
                next_state <= CONTROLLER_STATE_RESET;
        endcase // state
    end
endmodule