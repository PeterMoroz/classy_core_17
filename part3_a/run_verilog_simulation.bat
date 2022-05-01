del *.vvp
iverilog -o CtrlFetch.vvp CtrlFetch.v CtrlFetch_tb.v
vvp CtrlFetch.vvp
gtkwave signals_verilog.vcd