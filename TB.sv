`timescale 1ns / 1ps

/*
Testbed module
*/
module TB #(
    parameter WORD_LENGTH = 16,
    parameter SYSTEM_FREQUENCY = 100,
    parameter SAMPLING_FREQUENCY = 10);
    logic clock_i;
    logic reset_i;
    logic play_i;
    logic record_i;
    logic play_clip_select_i;
    logic record_clip_select_i;
    logic [6:0] cathode_o;
    logic [7:0] anode_o;
    logic playing_o;
    logic recording_o;
    logic pdm_clk_o;
    logic pdm_data_i;
    logic pdm_lrsel_o;
    logic pwm_audio_o;
    logic pwm_sdaudio_o;
    
    /*logic play_command_i;
    logic record_command_i;
    logic play_clip_i;
    logic record_clip_i;
    
    logic [3:0] play_clip_o;
    logic [3:0] record_clip_o;
    
    logic timer_done_i;
    logic timer_tick_i;
    logic timer_enable_o;
    
    logic serializer_done_i;
    logic serializer_enable_o;
    
    logic deserializer_done_i;
    logic deserializer_enable_o;
    
    logic [15:0] serializer_data_o;
    logic [15:0] deserializer_data_o;
    
    logic memory_rw_o;
    logic [16:0] memory_address;
    logic memory_0_enable_o;
    logic memory_1_enable_o;
    
    logic [15:0] memory_0_data;
    logic [15:0] memory_1_data;
    
    assign pdm_lrsel_o = 1'b1;
    assign pwm_sdaudio_o = 1'b1;
    assign timer_tick_i = (serializer_done_i | deserializer_done_i);
    assign serializer_data_o = (memory_0_enable_o ? memory_0_data : (memory_1_enable_o ? memory_1_data : 0));
    
    LED led(
        .clock_i(clock_i),
        .reset_i(reset_i),
        .play_clip_i(play_clip_o),
        .record_clip_i(record_clip_o),
        .anode_o(anode_o),
        .cathode_o(cathode_o)
    );
    
    Synchronizer play_command_sync(
        .clock_i(clock_i),
        .reset_i(reset_i),
        .value_i(play_i),
        .value_o(play_command_i)
    );
    Synchronizer record_command_sync(
        .clock_i(clock_i),
        .reset_i(reset_i),
        .value_i(record_i),
        .value_o(record_command_i)
    );
    Synchronizer play_clip_selection_sync(
        .clock_i(clock_i),
        .reset_i(reset_i),
        .value_i(play_clip_select_i),
        .value_o(play_clip_i)
    );
    Synchronizer record_clip_selection_sync(
        .clock_i(clock_i),
        .reset_i(reset_i),
        .value_i(record_clip_select_i),
        .value_o(record_clip_i)
    );
    
    Deserializer #(WORD_LENGTH, SYSTEM_FREQUENCY, SAMPLING_FREQUENCY) deserializer(
        .clock_i(clock_i),
        .enable_i(deserializer_enable_o), 
        .done_o(deserializer_done_i),
        .data_o(deserializer_data_o), 
        .pdm_clk_o(pdm_clock_o),
        .pdm_data_i(pdm_data_i)
    );
    
    Serializer #(WORD_LENGTH, SYSTEM_FREQUENCY, SAMPLING_FREQUENCY) serializer(
        .clock_i(clock_i),
        .enable_i(serializer_enable_o), 
        .done_o(serializer_done_i),
        .Data_i(serializer_data_o), 
        .pwm_audio_o(pwm_audio_o)
    );
    
    Timer #(WORD_LENGTH, SYSTEM_FREQUENCY, SAMPLING_FREQUENCY) timer(
        .clock_i(clock_i),
        .enable_i(timer_enable_o),
        .tick_i(timer_tick_i),
        .done_o(timer_done_i)
    );
    
    Counter #(WORD_LENGTH, SYSTEM_FREQUENCY, SAMPLING_FREQUENCY) counter(
        .clock_i(clock_i),
        .reset_i(reset_i),
        .timer_done_i(timer_done_i),
        .serializer_done_i(serializer_done_i),
        .deserializer_done_i(deserializer_done_i),
        .memory_address_o(memory_address)
    );
    
    blk_mem_gen_0 memory_block_0 (
      .clka(clock_i),    // input wire clka
      .ena(memory_0_enable_o),      // input wire ena
      .wea(memory_rw_o),      // input wire [0 : 0] wea
      .addra(memory_address),  // input wire [16 : 0] addra
      .dina(deserializer_data_o),    // input wire [15 : 0] dina
      .douta(memory_0_data)  // output wire [15 : 0] douta
    );    
    blk_mem_gen_0 memory_block_1 (
      .clka(clock_i),    // input wire clka
      .ena(memory_1_enable_o),      // input wire ena
      .wea(memory_rw_o),      // input wire [0 : 0] wea
      .addra(memory_address),  // input wire [16 : 0] addra
      .dina(deserializer_data_o),    // input wire [15 : 0] dina
      .douta(memory_1_data)  // output wire [15 : 0] douta
    );
    
    Controller #(WORD_LENGTH, SYSTEM_FREQUENCY, SAMPLING_FREQUENCY) controller(
        .clock_i(clock_i),
        .reset_i(reset_i),
        .play_command_i(play_command_i),
        .record_command_i(record_command_i),
        .play_clip_select_i(play_clip_i),
        .record_clip_select_i(record_clip_i),
        .playing_o(playing_o),
        .recording_o(recording_o),
        .play_clip_o(play_clip_o),
        .record_clip_o(record_clip_o),
        .timer_done_i(timer_done_i),
        .timer_enable_o(timer_enable_o),
        .serializer_done_i(serializer_done_i),
        .serializer_enable_o(serializer_enable_o),
        .deserializer_done_i(deserializer_done_i),
        .deserializer_enable_o(deserializer_enable_o),
        .memory_rw_o(memory_rw_o),
        .memory_0_enable_o(memory_0_enable_o),
        .memory_1_enable_o(memory_1_enable_o)
    );*/
    Main #(WORD_LENGTH, SYSTEM_FREQUENCY, SAMPLING_FREQUENCY) main(
        .clock_i(clock_i),
        .reset_i(reset_i),
        .play_i(play_i),
        .record_i(record_i),
        .play_clip_select_i(play_clip_select_i),
        .record_clip_select_i(record_clip_select_i),
        .cathode_o(cathode_o),
        .anode_o(anode_o),
        .playing_o(playing_o),
        .recording_o(recording_o),
        .pdm_clk_o(pdm_clk_o),
        .pdm_data_i(pdm_data_i),
        .pdm_lrsel_o(pdm_lrsel_o),
        .pwm_audio_o(pwm_audio_o),
        .pwm_sdaudio_o(pwm_sdaudio_o)
    );
    
    initial begin
        clock_i = 0;
        reset_i = 1;
        pdm_data_i = 0;
        play_clip_select_i = 0;
        record_clip_select_i = 0;
        play_i = 0;
        record_i = 0;
    #10 reset_i = 0;
    #10 play_i = 1;
    #10 play_i = 0;
    end
    
    always begin
    #5  clock_i = ~clock_i;
    end
    
    always begin
    #50 pdm_data_i = ~pdm_data_i;
    end
endmodule