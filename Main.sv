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
        
    //Memory
    logic [16:0] memory_address;
    logic memory_current_bank;  //The current memory bank for the action
    logic memory_rw;            //Will be 0 for read, 1 for write
    
    logic memory_block_0_wea;   //Bank 0 write enable
    logic memory_block_0_enable;//Bank 0 enable
    //Enable writing if the current bank is 0 and we need to write
    assign memory_block_0_wea = (!memory_current_bank && memory_rw);
    //Enable memory bank 0 if the current bank is 0 and the serializer or deserializer is done
    assign memory_block_0_enable = (!memory_current_bank && (serializer_done || deserializer_done));
    
    //Memory bank 0
    blk_mem_gen_0 memory_block_0 (
      .clka(clock_i),    // input wire clka
      .ena(memory_block_0_enable),      // input wire ena
      .wea(memory_block_0_wea),      // input wire [0 : 0] wea
      .addra(memory_address),  // input wire [16 : 0] addra
      .dina(serializer_data),    // input wire [15 : 0] dina
      .douta(deserializer_data)  // output wire [15 : 0] douta
    );
    
    logic memory_block_1_wea;
    logic memory_block_1_enable;
    //Enable writing if the current bank is 1 and we need to write
    assign memory_block_1_wea = (memory_current_bank && memory_rw);
    //Enable memory bank 1 if the current bank is ` and the serializer or deserializer is done
    assign memory_block_1_enable = (memory_current_bank && (serializer_done || deserializer_done));
    
    blk_mem_gen_0 memory_block_1 (
      .clka(clock_i),    // input wire clka
      .ena(memory_block_1_enable),      // input wire ena
      .wea(memory_block_1_wea),      // input wire [0 : 0] wea
      .addra(memory_address),  // input wire [16 : 0] addra
      .dina(serializer_data),    // input wire [15 : 0] dina
      .douta(deserializer_data)  // output wire [15 : 0] douta
    );

    Controller controller(
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
        .memory_addr_o(memory_address),   //Address for the memory banks
        .memory_rw_o(memory_rw),                       //The read/write switch for memory
        .memory_current_bank_o(memory_current_bank)
        );
endmodule