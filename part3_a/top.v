module top
(
	input wire i_clk,
	input wire i_reset,
	// control path
	input wire[1:0] i_mode12K,
	input wire[1:0] i_modeAddZA,
	input wire i_modePCZ,
	input wire i_loadIR,
	input wire i_loadPC,
	// data path
	input wire[15:0] i_K,
	input wire[15:0] i_A,
	input wire[15:0] i_Z,
	output wire[15:0] o_IR,
	output wire[15:0] o_PMDATA,
	// memory interface
	input wire[15:0] i_PMDATA,
	output wire[15:0] o_PMADDR
);

CtrlFetch ctrl_fetch_0(.i_clk(i_clk), .i_reset(i_reset), 
					.i_mode12K(i_mode12K), .i_modeAddZA(i_modeAddZA), .i_modePCZ(i_modePCZ), .i_loadIR(i_loadIR), .i_loadPC(i_loadPC),
					.i_K(i_K), .i_A(i_A), .i_Z(i_Z), .o_IR(o_IR), .o_PMDATA(o_PMDATA),
					.i_PMDATA(i_PMDATA), .o_PMADDR(o_PMADDR));
					
endmodule