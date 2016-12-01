`timescale 1ns / 1ps

module Main #(
    parameter WORD_LENGTH = 16,
    parameter SYSTEM_FREQUENCY = 100000000,
    parameter SAMPLING_FREQUENCY = 1000000)
(
    input logic clock_i,                //100 Mhz Clock input
    //User Input
    input logic reset_i,                 //Reset signal
    input logic play_i,                 //The play command from the user
    input logic record_i,                //The record command from the user
    input logic play_clip_select_i,     //The clip selection from the user
    input logic record_clip_select_i,   //The clip selection from the user
    
    //LED outputs
    output logic [6:0] cathode_o,
    output logic [7:0] anode_o,
    
    //Audio I/O
    //PWM Microphone related signals
    output logic pdm_clk_o,
    input logic pdm_data_i,
    output logic pdm_lrsel_o,
    //PWM Speaker signals
    output logic pwm_audio_o,
    output logic pwm_sdaudio_o
);
    assign pwm_sdaudio_o = 1'b1;  
    
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
    logic [3:0] play_clip_value;
    logic [3:0] record_clip_value;
    LED led(
        .clock_i(clock_i),
        .reset_i(reset_i),
        .play_clip_i(play_clip_value),
        .record_clip_i(record_clip_value),
        .anode_o(anode_o),
        .cathode_o(cathode_o)
    );

    //Serializer
    logic serializer_enable;
    logic serializer_done;
    logic [15:0] serializer_data;
    Serializer #(WORD_LENGTH, SYSTEM_FREQUENCY, SAMPLING_FREQUENCY) serializer(clock_i, serializer_enable, serializer_done, serializer_data, pwm_audio_o);

    //Deserializer
    logic deserializer_enable;
    logic deserializer_done;
    logic [15:0] deserializer_data;
    Deserializer #(WORD_LENGTH, SYSTEM_FREQUENCY, SAMPLING_FREQUENCY) deserializer(
        clock_i,
        deserializer_enable,
        deserializer_done,
        deserializer_data,
        pdm_clk_o,
        pdm_data_i,
        pdm_lrsel_o);

    //Timer
    logic timer_enable;
    logic timer_tick;
    logic timer_done;
    Timer #(WORD_LENGTH, SYSTEM_FREQUENCY, SAMPLING_FREQUENCY) timer(clock_i, timer_enable, timer_tick, timer_done);
    
    assign timer_tick = timer_enable & (deserializer_done | serializer_done);

    //Memory
    logic [16:0] memory_address;
    logic current_clip;
    logic memory_rw;            //Will be 0 for read, 1 for write
    
    logic memory_block_0_enable;//Bank 0 enable
    logic memory_block_1_enable;
    
    assign memory_block_0_enable = !current_clip;
    assign memory_block_1_enable = current_clip;
    
    logic [15:0] memory_block_0_data;
    logic [15:0] memory_block_1_data;
    
    always_ff @(posedge clock_i) begin
        if (~reset_i) begin
            //we are in the play state
            if (serializer_enable) begin
                serializer_data <= (current_clip ? memory_block_0_data : memory_block_1_data);
                if (serializer_done) begin
                    memory_address <= memory_address + 1;
                end
            //we are in the record state
            end else if (deserializer_enable) begin
                if(deserializer_done) begin
                    memory_address <= memory_address + 1;
                end
            end else begin
                serializer_data <= 0;
                memory_address <= 0;
            end
        end else begin
            memory_address = 0;
        end
    end
    
    //Memory bank 0
    blk_mem_gen_0 memory_block_0 (
      .clka(clock_i),    // input wire clka
      .ena(memory_block_0_enable),      // input wire ena
      .wea(memory_rw),      // input wire [0 : 0] wea
      .addra(memory_address),  // input wire [16 : 0] addra
      .dina(deserializer_data),    // input wire [15 : 0] dina
      .douta(memory_block_0_data)  // output wire [15 : 0] douta
    );
    
    //Memory block 1
    blk_mem_gen_0 memory_block_1 (
      .clka(clock_i),    // input wire clka
      .ena(memory_block_1_enable),      // input wire ena
      .wea(memory_rw),      // input wire [0 : 0] wea
      .addra(memory_address),  // input wire [16 : 0] addra
      .dina(deserializer_data),    // input wire [15 : 0] dina
      .douta(memory_block_1_data)  // output wire [15 : 0] douta
    );
    
    Controller #(WORD_LENGTH, SYSTEM_FREQUENCY, SAMPLING_FREQUENCY) controller(
        .clock_i(clock_i),                //100 Mhz Clock input
        .reset_i(reset_i),                 //Reset signal
        .play_command_i(play_command),         //The play command from the user (SYNCHRONIZED)
        .record_command_i(record_command),        //The record command from the user (SYNCHRONIZED)
        .play_clip_select_i(play_clip_selection),     //The clip selection from the user (SYNCHRONIZED)
        .record_clip_select_i(record_clip_selection),   //The clip selection from the user (SYNCHRONIZED)
        
        //LED I/O
        .play_clip_o(play_clip_value),     //The play clip number for the LED display
        .record_clip_o(record_clip_value),   //The record clip number for the LED display

        //Timer I/O
        .timer_done_i(timer_done),       //Done signal for the timer
        .timer_enable_o(timer_enable),    //Enable for the timer

        //Serializer I/O
        .serializer_done_i(serializer_done),      //Done signal for the serializer
        .serializer_enable_o(serializer_enable),   //Enable for the serializer

        //Deserializer I/O
        .deserializer_done_i(deserializer_done),    //Done signal for the deserializer
        .deserializer_enable_o(deserializer_enable), //Enable for the deserializer

        //Memory I/O
        .memory_rw_o(memory_rw),                       //The read/write switch for memory
        .current_clip_o(current_clip)
        );
endmodule