ghdl -a ControlUnit.vhd
ghdl -a CtrlFetch.vhd
ghdl -a ProgramMemory.vhd
ghdl -a top.vhd
ghdl -a top_tb.vhd
ghdl -e top_tb
ghdl -r top_tb --vcd=signals_vhdl.vcd
gtkwave signals_vhdl.vcd