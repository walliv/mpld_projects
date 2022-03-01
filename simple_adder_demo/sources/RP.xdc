# Buttons
set_property IOSTANDARD LVCMOS18 [get_ports {BTN[*]}]
set_property PACKAGE_PIN P15 [get_ports {BTN[3]}]
set_property PACKAGE_PIN U13 [get_ports {BTN[2]}]
set_property PACKAGE_PIN T10 [get_ports {BTN[1]}]
set_property PACKAGE_PIN T11 [get_ports {BTN[0]}]
set_property PULLDOWN true [get_ports {BTN[3]}]
set_property PULLDOWN true [get_ports {BTN[2]}]
set_property PULLDOWN true [get_ports {BTN[1]}]
set_property PULLDOWN true [get_ports {BTN[0]}]


# Switches
set_property IOSTANDARD LVCMOS33 [get_ports {SW[*]}]
set_property PACKAGE_PIN E18 [get_ports {SW[3]}]
set_property PACKAGE_PIN E17 [get_ports {SW[2]}]
set_property PACKAGE_PIN C20 [get_ports {SW[1]}]
set_property PACKAGE_PIN B19 [get_ports {SW[0]}]


# LEDs
set_property IOSTANDARD LVCMOS33 [get_ports {LED[*]}]
set_property DRIVE 4 [get_ports {LED[*]}]
set_property PACKAGE_PIN F16 [get_ports {LED[0]}]
set_property PACKAGE_PIN F17 [get_ports {LED[1]}]
set_property PACKAGE_PIN G15 [get_ports {LED[2]}]
set_property PACKAGE_PIN H15 [get_ports {LED[3]}]
set_property PACKAGE_PIN K14 [get_ports {LED[4]}]
set_property PACKAGE_PIN G14 [get_ports {LED[5]}]
set_property PACKAGE_PIN J15 [get_ports {LED[6]}]
set_property PACKAGE_PIN J14 [get_ports {LED[7]}]

# set maximum delay [ns] between all inputs and outputs
set_max_delay 60 -from [all_inputs] -to [all_outputs]
