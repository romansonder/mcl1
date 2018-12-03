#
# ime_avalon_seg7p_driver.tcl
#

# Create a new driver
create_driver ime_avalon_seg7p_driver

# Associate it with some hardware known as "ime_avalon_seg7p"
set_sw_property hw_class_name ime_avalon_seg7p

# The version of this driver
set_sw_property version 13.0

# Multiple-Version compatibility was introduced in version 7.1;
# prior versions are therefore excluded.
set_sw_property min_compatible_hw_version 7.1

# Initialize the driver in alt_sys_init()
set_sw_property auto_initialize true

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory drivers

#
# Source file listings...
#

# C/C++ source files
add_sw_property c_source HAL/src/ime_avalon_seg7.c

# Include files
add_sw_property include_source HAL/inc/ime_avalon_seg7.h
add_sw_property include_source inc/ime_avalon_seg7_regs.h

# This driver supports HAL only BSP (OS) types (no support for UCOSII)
add_sw_property supported_bsp_type HAL
# add_sw_property supported_bsp_type UCOSII

# End of file
