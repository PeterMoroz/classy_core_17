ghdl -a CtrlFetch.vhdl
ghdl -a CtrlFetch_tb.vhdl
ghdl -e CtrlFetch_tb
ghdl -r CtrlFetch_tb --vcd=signals_vhdl.vcd
gtkwave signals_vhdl.vcd