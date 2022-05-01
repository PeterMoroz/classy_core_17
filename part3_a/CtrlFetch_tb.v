`timescale 1 ns/10 ps

module CtrlFetch_tb;

localparam CLK_PERIOD = 10, HALF_PERIOD = CLK_PERIOD / 2;


reg clk;
reg reset;

reg[1:0] mode12K;
reg[1:0] modeAddZA;
reg modePCZ;
reg loadPC;
reg loadIR;

reg[15:0] A;
reg[15:0] K;
reg[15:0] Z;

wire[15:0] IR;
reg[15:0] in_PMDATA;
wire[15:0] out_PMDATA;
wire[15:0] out_PMADDR;


CtrlFetch uut(.i_clk(clk), .i_reset(reset), .i_mode12K(mode12K), .i_modeAddZA(modeAddZA), .i_modePCZ(modePCZ), .i_loadIR(loadIR), .i_loadPC(loadPC), .i_K(K), .i_A(A), .i_Z(Z), .o_IR(IR), .o_PMDATA(out_PMDATA), .i_PMDATA(in_PMDATA), .o_PMADDR(out_PMADDR));

initial begin
	$dumpfile("signals_verilog.vcd");
	//$dumpvars(0, CtrlFetch_tb.uut);
	$dumpvars(0, CtrlFetch_tb);
	
	loadIR = 1'b0;
	loadPC = 1'b0;
	modePCZ = 1'b0;
	mode12K = 2'b00;
	modeAddZA = 2'b00;
	
	A = 16'b0000000000000000;
	K = 16'b0000000000000000;
	Z = 16'b0000000000000000;
	
	reset = 1'b1;
	#CLK_PERIOD;
	reset = 1'b0;
		
	/////////////////////////////////
	in_PMDATA = 16'b0000000000000000;
	#CLK_PERIOD;
	in_PMDATA = 16'b0000000000000001;
	#CLK_PERIOD;	
	in_PMDATA = 16'b0000000000000010;
	#CLK_PERIOD;
	in_PMDATA = 16'b0000000000000011;
	#CLK_PERIOD;
	in_PMDATA = 16'b0000000000000100;
	#CLK_PERIOD;

	in_PMDATA = 16'b0000000000001000;
	loadIR = 1'b1;
	#CLK_PERIOD;
	loadIR = 1'b0;
	#CLK_PERIOD;

	in_PMDATA = 16'b0000000000001001;
	loadIR = 1'b1;
	#CLK_PERIOD;
	loadIR = 1'b0;
	#CLK_PERIOD;

	in_PMDATA = 16'b0000000000001010;
	loadIR = 1'b1;
	#CLK_PERIOD;
	loadIR = 1'b0;
	#CLK_PERIOD;

	in_PMDATA = 16'b0000000000001011;
	loadIR = 1'b1;
	#CLK_PERIOD;
	loadIR = 1'b0;
	#CLK_PERIOD;

	in_PMDATA = 16'b0000000000001100;
	loadIR = 1'b1;
	#CLK_PERIOD;
	loadIR = 1'b0;
	#CLK_PERIOD;
	
	/////////////////////////////////
	modePCZ = 1'b1;
	Z = 16'b0000000000000000;
	#CLK_PERIOD;
	Z = 16'b0000000000000001;
	#CLK_PERIOD;
	Z = 16'b0000000000000010;
	#CLK_PERIOD;
	Z = 16'b0000000000000011;
	#CLK_PERIOD;
	modePCZ = 1'b0;
	#CLK_PERIOD;
	
	
	////////////////////////////////
	modeAddZA = 2'b10;
	Z = 16'b0000000000000000;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;
	
	Z = 16'b0000000000000001;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	
	Z = 16'b0000000000000010;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;
	
	Z = 16'b0000000000000011;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;
	
	modeAddZA = 2'b00;
	#CLK_PERIOD;
	
	
	////////////////////////////////
	modeAddZA = 2'b11;
	A = 16'b0000000000000000;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;
	
	A = 16'b0000000000000001;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	
	A = 16'b0000000000000010;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;
	
	A = 16'b0000000000000011;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;
	
	modeAddZA = 2'b00;
	#CLK_PERIOD;
	
	
	////////////////////////////////
	modeAddZA = 2'b00;	
	mode12K = 2'b00;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;
	
	mode12K = 2'b01;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	
	mode12K = 2'b00;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	
	mode12K = 2'b01;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	

	modeAddZA = 2'b01;
	mode12K = 2'b00;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;
	
	mode12K = 2'b01;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	
	mode12K = 2'b00;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	
	mode12K = 2'b01;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;
	
	
	////////////////////////////////
	modeAddZA = 2'b00;	
	mode12K = 2'b10;
	
	K = 16'b0000000000000100;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;
	
	K = 16'b0000000000001000;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	
	mode12K = 2'b11;
	
	K = 16'b0000000000000100;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	
	K = 16'b0000000000001000;	
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	

	modeAddZA = 2'b01;
	mode12K = 2'b10;
	
	K = 16'b0000000000000100;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;
	
	K = 16'b0000000000000100;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	
	mode12K = 2'b11;
	K = 16'b0000000000001000;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;	
	#CLK_PERIOD;
	
	K = 16'b0000000000001000;
	loadPC = 1'b1;
	#CLK_PERIOD;
	loadPC = 1'b0;
	#CLK_PERIOD;	
		
	
	#100;
	$finish;
	
end

always
begin
	clk = 1'b0;
	#HALF_PERIOD;
	clk = 1'b1;
	#HALF_PERIOD;
end

endmodule