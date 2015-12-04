## Generated SDC file "Final_Project.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 15.0.0 Build 145 04/22/2015 SJ Web Edition"

## DATE    "Tue Dec 01 17:46:12 2015"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLOCK_50} -period 10.000 -waveform { 0.000 5.000 } [get_ports {CLOCK_50}]
create_clock -name {altera_generated_clk} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {VGA_CLK} -source [get_ports {CLOCK_50}] -divide_by 2 -master_clock {CLOCK_50} [get_ports {VGA_CLK}] 
create_generated_clock -name {nios_system|sdram_pll|sd1|pll7|clk[0]} -source [get_pins {nios_system|sdram_pll|sd1|pll7|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -master_clock {CLOCK_50} [get_pins {nios_system|sdram_pll|sd1|pll7|clk[0]}] 
create_generated_clock -name {nios_system|sdram_pll|sd1|pll7|clk[1]} -source [get_pins {nios_system|sdram_pll|sd1|pll7|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -phase -54.000 -master_clock {CLOCK_50} [get_pins {nios_system|sdram_pll|sd1|pll7|clk[1]}] 

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

