# Buttons
set_property IOSTANDARD LVCMOS18 [get_ports {btn_i[*]}]
set_property PACKAGE_PIN P15 [get_ports {btn_i[3]}]
set_property PACKAGE_PIN U13 [get_ports {btn_i[2]}]
set_property PACKAGE_PIN T10 [get_ports {btn_i[1]}]
set_property PACKAGE_PIN T11 [get_ports {btn_i[0]}]
set_property PULLDOWN true [get_ports {btn_i[3]}]
set_property PULLDOWN true [get_ports {btn_i[2]}]
set_property PULLDOWN true [get_ports {btn_i[1]}]
set_property PULLDOWN true [get_ports {btn_i[0]}]


# Switches
set_property IOSTANDARD LVCMOS33 [get_ports {sw_i[*]}]
set_property PACKAGE_PIN E18 [get_ports {sw_i[3]}]
set_property PACKAGE_PIN E17 [get_ports {sw_i[2]}]
set_property PACKAGE_PIN C20 [get_ports {sw_i[1]}]
set_property PACKAGE_PIN B19 [get_ports {sw_i[0]}]


# LEDs
set_property IOSTANDARD LVCMOS33 [get_ports {led_o[*]}]
set_property DRIVE 4 [get_ports {led_o[*]}]
set_property PACKAGE_PIN F16 [get_ports {led_o[0]}]
set_property PACKAGE_PIN F17 [get_ports {led_o[1]}]
set_property PACKAGE_PIN G15 [get_ports {led_o[2]}]
set_property PACKAGE_PIN H15 [get_ports {led_o[3]}]
set_property PACKAGE_PIN K14 [get_ports {led_o[4]}]
set_property PACKAGE_PIN G14 [get_ports {led_o[5]}]
set_property PACKAGE_PIN J15 [get_ports {led_o[6]}]
set_property PACKAGE_PIN J14 [get_ports {led_o[7]}]

# 7-segment display
set_property IOSTANDARD LVCMOS33 [get_ports {disp_seg_o[*]}]
set_property DRIVE 4 [get_ports {disp_seg_o[*]}]
set_property PACKAGE_PIN L14 [get_ports {disp_seg_o[0]}]
set_property PACKAGE_PIN J18 [get_ports {disp_seg_o[1]}]
set_property PACKAGE_PIN H18 [get_ports {disp_seg_o[2]}]
set_property PACKAGE_PIN L17 [get_ports {disp_seg_o[3]}]
set_property PACKAGE_PIN L15 [get_ports {disp_seg_o[4]}]
set_property PACKAGE_PIN H17 [get_ports {disp_seg_o[5]}]
set_property PACKAGE_PIN L16 [get_ports {disp_seg_o[6]}]
set_property PACKAGE_PIN J16 [get_ports {disp_seg_o[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {disp_dig_o[*]}]
set_property DRIVE 4 [get_ports {disp_dig_o[*]}]
set_property PACKAGE_PIN K18 [get_ports {disp_dig_o[1]}]
set_property PACKAGE_PIN K17 [get_ports {disp_dig_o[2]}]
set_property PACKAGE_PIN M15 [get_ports {disp_dig_o[3]}]
set_property PACKAGE_PIN M14 [get_ports {disp_dig_o[4]}]
# disp_pos_l_o => disp_dig_o[0]
set_property PACKAGE_PIN K16 [get_ports {disp_dig_o[0]}]

# 50 MHz clock (shield oscillator)
set_property PACKAGE_PIN H16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
# create_clock -period 2.000 -name clk -waveform {0.000 1.000} [get_ports clk]

create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports clk]
set_input_jitter clk 0.100



# set_switching_activity -toggle_rate 0.000 -static_probability 1.000 [get_nets {ce_gen_i/E[0]}]
# set_switching_activity -toggle_rate 0.500 -static_probability 0.500 [get_nets {ce_gen_i/E[0]}]
