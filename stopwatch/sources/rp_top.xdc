# Buttons
set_property IOSTANDARD LVCMOS18 [get_ports {BTN_I[*]}]
set_property PACKAGE_PIN P15 [get_ports {BTN_I[3]}]
set_property PACKAGE_PIN U13 [get_ports {BTN_I[2]}]
set_property PACKAGE_PIN T10 [get_ports {BTN_I[1]}]
set_property PACKAGE_PIN T11 [get_ports {BTN_I[0]}]
set_property PULLDOWN true [get_ports {BTN_I[3]}]
set_property PULLDOWN true [get_ports {BTN_I[2]}]
set_property PULLDOWN true [get_ports {BTN_I[1]}]
set_property PULLDOWN true [get_ports {BTN_I[0]}]


# Switches
set_property IOSTANDARD LVCMOS33 [get_ports {SW_I[*]}]
set_property PACKAGE_PIN E18 [get_ports {SW_I[3]}]
set_property PACKAGE_PIN E17 [get_ports {SW_I[2]}]
set_property PACKAGE_PIN C20 [get_ports {SW_I[1]}]
set_property PACKAGE_PIN B19 [get_ports {SW_I[0]}]


# LEDs
set_property IOSTANDARD LVCMOS33 [get_ports {LED_O[*]}]
set_property DRIVE 4 [get_ports {LED_O[*]}]
set_property PACKAGE_PIN F16 [get_ports {LED_O[0]}]
set_property PACKAGE_PIN F17 [get_ports {LED_O[1]}]
set_property PACKAGE_PIN G15 [get_ports {LED_O[2]}]
set_property PACKAGE_PIN H15 [get_ports {LED_O[3]}]
set_property PACKAGE_PIN K14 [get_ports {LED_O[4]}]
set_property PACKAGE_PIN G14 [get_ports {LED_O[5]}]
set_property PACKAGE_PIN J15 [get_ports {LED_O[6]}]
set_property PACKAGE_PIN J14 [get_ports {LED_O[7]}]

# 7-segment display
set_property IOSTANDARD LVCMOS33 [get_ports {DISP_SEG_O[*]}]
set_property DRIVE 4 [get_ports {DISP_SEG_O[*]}]
set_property PACKAGE_PIN L14 [get_ports {DISP_SEG_O[0]}]
set_property PACKAGE_PIN J18 [get_ports {DISP_SEG_O[1]}]
set_property PACKAGE_PIN H18 [get_ports {DISP_SEG_O[2]}]
set_property PACKAGE_PIN L17 [get_ports {DISP_SEG_O[3]}]
set_property PACKAGE_PIN L15 [get_ports {DISP_SEG_O[4]}]
set_property PACKAGE_PIN H17 [get_ports {DISP_SEG_O[5]}]
set_property PACKAGE_PIN L16 [get_ports {DISP_SEG_O[6]}]
set_property PACKAGE_PIN J16 [get_ports {DISP_SEG_O[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {DISP_DIG_O[*]}]
set_property DRIVE 4 [get_ports {DISP_DIG_O[*]}]
set_property PACKAGE_PIN K18 [get_ports {DISP_DIG_O[1]}]
set_property PACKAGE_PIN K17 [get_ports {DISP_DIG_O[2]}]
set_property PACKAGE_PIN M15 [get_ports {DISP_DIG_O[3]}]
set_property PACKAGE_PIN M14 [get_ports {DISP_DIG_O[4]}]
# DISP_POS_L_O => DISP_DIG_O[0]
set_property PACKAGE_PIN K16 [get_ports {DISP_DIG_O[0]}]

# 50 MHz clock (shield oscillator)
set_property PACKAGE_PIN H16 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
# create_clock -period 2.000 -name CLK -waveform {0.000 1.000} [get_ports CLK]

create_clock -period 20.000 -name CLK -waveform {0.000 10.000} [get_ports CLK]
set_input_jitter CLK 0.100



# set_switching_activity -toggle_rate 0.000 -static_probability 1.000 [get_nets {ce_gen_i/E[0]}]
# set_switching_activity -toggle_rate 0.500 -static_probability 0.500 [get_nets {ce_gen_i/E[0]}]
