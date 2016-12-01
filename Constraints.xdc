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
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports anode[0]]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports anode[1]]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports anode[2]]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports anode[3]]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports anode[4]]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports anode[5]]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports anode[6]]
set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports anode[7]]

set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports cathode[0]]
set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports cathode[1]]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports cathode[2]]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports cathode[3]]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports cathode[4]]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports cathode[5]]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports cathode[6]]

##audio
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports pdm_clk_o]
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports pdm_data_i]
set_property -dict {PACKAGE_PIN F5 IOSTANDARD LVCMOS33} [get_ports pdm_lrsel_o]

set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVCMOS33} [get_ports pwm_audio_o]
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports pwm_sdaudio_o]