del *.vvp
iverilog -o CpuVerilog.vvp ControlUnit.v CtrlFetch.v ProgramMemory.v top.v top_tb.v
vvp CpuVerilog.vvp
gtkwave signals_verilog.vcd