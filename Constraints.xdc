##Clock
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clock_i]
##Switches
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports reset_i]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports play_clip_select_i]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports record_clip_select_i]
##Buttons
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports play_i]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports record_i]
##7-segment display

##audio
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports pdm_clk_o]
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports pdm_data_i]
set_property -dict {PACKAGE_PIN F5 IOSTANDARD LVCMOS33} [get_ports pdm_lrsel_o]

set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVCMOS33} [get_ports pwm_audio_o]
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports pwm_sdaudio_o]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clock_i_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list serializer_enable]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clock_i_IBUF_BUFG]
