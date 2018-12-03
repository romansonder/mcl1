#**************************************************************
# Create Clock
#**************************************************************

create_clock -period 20 -name clk [get_ports {clk_50}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks


#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay -clock clk 1 [all_inputs]


#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -clock clk 1 [all_outputs]


#**************************************************************
# Set Output Delay
#**************************************************************
# from asynchronous switches
set_false_path -from {sw[*]}

# from asynchronous reset
#set_false_path -from {ime_reset:i0_ime_reset|sys_rst}

# Clock to the SDRAM
set_false_path -from {i0_system|pll|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} -to {dram_clk}

# InOut-Data of SDRAM
set_false_path -from {dram_dq[*]} -to {system:i0_system|system_dram_ctrl:dram_ctrl|za_data[*]}
