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
vcom -93 ime_avalon_keypad.vhd
vcom -93 ime_avalon_keypad_tb.vhd

echo "Compilation DONE"

vsim work.ime_avalon_keypad_tb

add wave *

run -all
