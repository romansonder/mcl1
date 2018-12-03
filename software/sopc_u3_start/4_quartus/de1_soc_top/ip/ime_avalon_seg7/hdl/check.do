#-----------------------------------------------------
# Filename: check.do
# Author  : michael.pichler@fhnw.ch
# Date    : 2014.01.28
# Content : Compiles the VHDL files and runs QuestaSim
# Usage   : vsim -do check.do
#-----------------------------------------------------

transcript on

if ![file isdirectory work] {
	vlib work
}

vcom -93 seg7_lut.vhd
vcom -93 ime_avalon_seg7.vhd
vcom -93 ime_avalon_seg7_tb.vhd

echo "Compilation DONE"

vsim work.ime_avalon_seg7_tb

add wave *

run -all
