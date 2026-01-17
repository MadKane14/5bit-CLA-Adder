# cla5.xdc - edit the PACKAGE_PIN placeholders to match your Spartan-7 board

# Clock (replace <PIN_CLK> with the board clock pin)
set_property PACKAGE_PIN F14 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name clk_100MHz [get_ports clk]

# Inputs a[4:0]  <-- replace <PIN_A0>.. with actual pins (or map to switches)
set_property PACKAGE_PIN V2 [get_ports A[0]]
set_property IOSTANDARD LVCMOS33 [get_ports A[0]]
set_property PACKAGE_PIN U2 [get_ports A[1]]
set_property IOSTANDARD LVCMOS33 [get_ports A[1]]
set_property PACKAGE_PIN U1 [get_ports A[2]]
set_property IOSTANDARD LVCMOS33 [get_ports A[2]]
set_property PACKAGE_PIN T2 [get_ports A[3]]
set_property IOSTANDARD LVCMOS33 [get_ports A[3]]
set_property PACKAGE_PIN T1 [get_ports A[4]]
set_property IOSTANDARD LVCMOS33 [get_ports A[4]]

# Inputs b[4:0]
set_property PACKAGE_PIN R2 [get_ports B[0]]
set_property IOSTANDARD LVCMOS33 [get_ports B[0]]
set_property PACKAGE_PIN R1 [get_ports B[1]]
set_property IOSTANDARD LVCMOS33 [get_ports B[1]]
set_property PACKAGE_PIN P2 [get_ports B[2]]
set_property IOSTANDARD LVCMOS33 [get_ports B[2]]
set_property PACKAGE_PIN P1 [get_ports B[3]]
set_property IOSTANDARD LVCMOS33 [get_ports B[3]]
set_property PACKAGE_PIN N2 [get_ports B[4]]
set_property IOSTANDARD LVCMOS33 [get_ports B[4]]

#input Cin
set_property PACKAGE_PIN N1 [get_ports Cin]
set_property IOSTANDARD LVCMOS33 [get_ports Cin]

# Outputs s[4:0]
set_property PACKAGE_PIN G1 [get_ports Sum[0]]
set_property IOSTANDARD LVCMOS33 [get_ports Sum[0]]
set_property PACKAGE_PIN G2 [get_ports Sum[1]]
set_property IOSTANDARD LVCMOS33 [get_ports Sum[1]]
set_property PACKAGE_PIN F1 [get_ports Sum[2]]
set_property IOSTANDARD LVCMOS33 [get_ports Sum[2]]
set_property PACKAGE_PIN F2 [get_ports Sum[3]]
set_property IOSTANDARD LVCMOS33 [get_ports Sum[3]]
set_property PACKAGE_PIN E1 [get_ports Sum[4]]
set_property IOSTANDARD LVCMOS33 [get_ports Sum[4]]

# Carry out
set_property PACKAGE_PIN E2 [get_ports Cout]
set_property IOSTANDARD LVCMOS33 [get_ports Cout]