module top
(
	input wire i_clk,
	input wire i_reset_ext,
	// data path
	input wire[15:0] i_A,
	input wire[15:0] i_Z,
	input wire i_ALU_Z,
	output wire[15:0] o_PMDATA
);

// connections between PM and CtrlFetch
wire[15:0] pm_addr, pm_data;

// connections between CtrlFetch and ControlUnit
wire reset;
wire[1:0] mode12K, modeAddZA;
wire modePCZ;
wire loadPC, loadIR;

wire[15:0] rg_IR, rg_K;


CtrlFetch ctrl_fetch_0(.i_clk(i_clk), .i_reset(reset), 
	// control path
	.i_mode12K(mode12K), .i_modeAddZA(modeAddZA), .i_modePCZ(modePCZ), .i_loadIR(loadIR), .i_loadPC(loadPC), 
	// data path
	.i_K(rg_K), .i_A(i_A), .i_Z(i_Z), .o_IR(rg_IR), .o_PMDATA(o_PMDATA),
	// memory interface
	.i_PMDATA(pm_data), .o_PMADDR(pm_addr)
	);
	
ProgramMemory program_memory_0(.i_clk(i_clk), .i_addr(pm_addr), .o_data(pm_data));

ControlUnit control_unit_0(.i_clk(i_clk), .i_reset(i_reset_ext),
	// FSM input
	.i_IR(rg_IR), .i_ALU_Z(i_ALU_Z),
	// control path outputts
	.o_reset(reset), .o_mode12K(mode12K), .o_modeAddZA(modeAddZA), .o_modePCZ(modePCZ), .o_loadPC(loadPC), .o_loadIR(loadIR), 
	// data path
	.o_K(rg_K)
	);

endmodule