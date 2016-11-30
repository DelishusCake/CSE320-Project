`timescale 1ns / 1ps

typedef enum
{
    CONTROLLER_STATE_RESET,
    CONTROLLER_STATE_IDLE,
    CONTROLLER_STATE_PLAYING,
    CONTROLLER_STATE_RECORDING
} controller_state_t;

module Controller(
    input logic clock_i,                //100 Mhz Clock input
    input logic reset_i                 //Reset signal
    input logic play_command_i,         //The play command from the user (SYNCHRONIZED)
    input logic record_command_i,        //The record command from the user (SYNCHRONIZED)
    input logic play_clip_select_i,     //The clip selection from the user (SYNCHRONIZED)
    input logic record_clip_select_i,   //The clip selection from the user (SYNCHRONIZED)
    
    //LED I/O
    output logic [1:0] play_clip_o,     //The play clip number for the LED display
    output logic [1:0] record_clip_o,   //The record clip number for the LED display

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
    output logic [WORD_LENGTH-1:0] memory_addr_o,   //Address for the memory banks
    output logic memory_rw_o,                       //The read/write switch for memory
    output logic memory_0_enable_o,                 //Enable for memory bank 0
    output logic memory_1_enable_o                  //Enable for memory bank 1
    );

    //LED ouput logic
    assign play_clip_o = play_clip_select_i + 1'b1;
    assign record_clip_o = record_clip_select_i + 1'b1;

    //Counter for the address
    logic address_counter_enable;
    Counter address_counter(clock_i, address_counter_enable, memory_addr_o);

    //State variables
    controller_state_t state;       //the current state of the controller
    controller_state_t next_state;  //the state of the controller on the next clock tick

    /*
    The current clip selected for recording or playing
        0: Clip 1
        1: Clip 2
    This should be set based on the user's selection via a switch
    */
    logic current_clip;

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
                //reset all state and components
                current_clip <= 1'b0;
                timer_enable_o <= 1'b0;
                serializer_enable_o <= 1'b0;
                deserializer_enable_o <= 1'b0;
                address_counter_enable <= 1'b0;

                next_state <= CONTROLLER_STATE_IDLE;
            CONTROLLER_STATE_IDLE:
            begin
                if (play_command_i) 
                begin
                    //Sample the clip 
                    current_clip <= play_clip_select_i;
                    //Set the state
                    next_state <= CONTROLLER_STATE_PLAYING;
                end else if(record_command_i) begin
                    current_clip <= record_clip_select_i;
                    next_state <= CONTROLLER_STATE_RECORDING;
                end
            end
            CONTROLLER_STATE_PLAYING:
            begin
                //Begin the address counter
                address_counter_enable <= 1'b1;
                //Set the memory bus to read
                memory_rw_o <= 1'b0;
                //Enable the timer
                timer_enable_o <= 1'b1;
                //Enable the deserializer
                deserializer_enable_o <= 1'b1;

                //Test the clip selection
                if (current_clip) begin
                    //Clip 2 is selected for playing
                    memory_0_enable_o <= 1'b0;
                    memory_1_enable_o <= 1'b1;
                end else begin
                    //Clip 1 is selected for playing
                    memory_0_enable_o <= 1'b1;
                    memory_1_enable_o <= 1'b0;
                end

                //If the timer says we're done, go back to the reset state
                if (timer_done_i) begin
                    next_state <= CONTROLLER_STATE_RESET;
                end
            end
            CONTROLLER_STATE_RECORDING:
            begin
                //Begin the address counter
                address_counter_enable <= 1'b1;
                //Set the memory bus to write
                memory_rw_o <= 1'b1;
                //Enable the timer
                timer_enable_o <= 1'b1;
                //Enable the serializer
                serializer_enable_o <= 1'b1;

                //Test the clip selection
                if (current_clip) begin
                    //Clip 2 is selected for recording
                    memory_0_enable_o <= 1'b0;
                    memory_1_enable_o <= 1'b1;
                end else begin
                    //Clip 1 is selected for recording
                    memory_0_enable_o <= 1'b1;
                    memory_1_enable_o <= 1'b0;
                end

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