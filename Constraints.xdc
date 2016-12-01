##Clock
create_clock -period 10.000 -name clock_i -waveform {0.000 5.000} [get_ports clock_i]  
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clock_i]
##Switches
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports reset_i]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports play_clip_select_i]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports record_clip_select_i]
##Buttons
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports play_i]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports record_i]
##Record/play indicators
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports playing_o]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports recording_o]
##7-segment display
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports anode_o[0]]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports anode_o[1]]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports anode_o[2]]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports anode_o[3]]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports anode_o[4]]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports anode_o[5]]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports anode_o[6]]
set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports anode_o[7]]

set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports cathode_o[0]]
set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports cathode_o[1]]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports cathode_o[2]]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports cathode_o[3]]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports cathode_o[4]]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports cathode_o[5]]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports cathode_o[6]]

##audio
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports pdm_clk_o]
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports pdm_data_i]
set_property -dict {PACKAGE_PIN F5 IOSTANDARD LVCMOS33} [get_ports pdm_lrsel_o]

set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVCMOS33} [get_ports pwm_audio_o]
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports pwm_sdaudio_o]