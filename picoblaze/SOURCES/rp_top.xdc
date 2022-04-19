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


# USB UART
set_property PACKAGE_PIN G18 [get_ports {UART_RX}]
set_property PACKAGE_PIN G17 [get_ports {UART_TX}]
set_property IOSTANDARD LVCMOS33 [get_ports {UART_RX}]
set_property IOSTANDARD LVCMOS33 [get_ports {UART_TX}]


# 7-segment display
set_property IOSTANDARD LVCMOS33 [get_ports {DISP_SEG[*]}]
set_property DRIVE 4 [get_ports {DISP_SEG[*]}]
set_property PACKAGE_PIN L14 [get_ports {DISP_SEG[0]}]
set_property PACKAGE_PIN J18 [get_ports {DISP_SEG[1]}]
set_property PACKAGE_PIN H18 [get_ports {DISP_SEG[2]}]
set_property PACKAGE_PIN L17 [get_ports {DISP_SEG[3]}]
set_property PACKAGE_PIN L15 [get_ports {DISP_SEG[4]}]
set_property PACKAGE_PIN H17 [get_ports {DISP_SEG[5]}]
set_property PACKAGE_PIN L16 [get_ports {DISP_SEG[6]}]
set_property PACKAGE_PIN J16 [get_ports {DISP_SEG[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {DISP_DIG[*]}]
set_property DRIVE 4 [get_ports {DISP_DIG[*]}]
set_property PACKAGE_PIN K18 [get_ports {DISP_DIG[1]}]
set_property PACKAGE_PIN K17 [get_ports {DISP_DIG[2]}]
set_property PACKAGE_PIN M15 [get_ports {DISP_DIG[3]}]
set_property PACKAGE_PIN M14 [get_ports {DISP_DIG[4]}]
set_property PACKAGE_PIN K16 [get_ports {DISP_DIG[0]}]


# 50 MHz clock (shield oscillator)
set_property PACKAGE_PIN H16 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
create_clock -period 20.000 -name CLK -waveform {0.000 10.000} [get_ports CLK]
set_input_jitter CLK 0.100
