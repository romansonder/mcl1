#-----------------------------------------------------
# Filename: check.do
# Author  : michael.pichler@fhnw.ch
# Date    : 2014.01.28
# Content : Compiles the de1_soc VHDL files
# Usage   : vsim -c -do check.do
#-----------------------------------------------------

transcript on

if ![file isdirectory work] {
	vlib work
  vmap work work
}

vcom -93 -work work de1_soc_pkg.vhd
vcom -93 -work work de1_soc_top.vhd

echo "Compilation DONE"

quit
