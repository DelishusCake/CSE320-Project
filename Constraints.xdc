##Clock
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports clock_i]
##Switches
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33 } [get_ports reset_i]
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports play_clip_select_i]
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports record_clip_select_i]
##Buttons
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports play_i]
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports record_i]
##7-segment display

##audio
set_property -dict { PACKAGE_PIN D12 IOSTANDARD LVCMOS33 } [get_ports pwm_sdaudio_o]
set_property -dict { PACKAGE_PIN J5 IOSTANDARD LVCMOS33 } [get_ports pdm_clk_o]
set_property -dict { PACKAGE_PIN H5 IOSTANDARD LVCMOS33 } [get_ports pdm_data_i]
set_property -dict { PACKAGE_PIN F5 IOSTANDARD LVCMOS33 } [get_ports pdm_lrsel_o]
set_property -dict { PACKAGE_PIN A11 IOSTANDARD LVCMOS33 } [get_ports pwm_audio_o]