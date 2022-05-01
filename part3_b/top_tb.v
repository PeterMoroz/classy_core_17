`timescale 1 ns/10 ps

module top_tb;

localparam CLK_PERIOD = 10,
	HALF_PERIOD = CLK_PERIOD / 2,
	SIMULATION_TIME = CLK_PERIOD * 10;

// inputs
reg i_clk;
reg i_reset_ext;
reg[15:0] i_A, i_Z;
reg i_ALU_Z;

// outputs
wire[15:0] o_PMDATA;

top uut(.i_clk(i_clk), .i_reset_ext(i_reset_ext), 
	// data path
	.i_A(i_A), .i_Z(i_Z), .i_ALU_Z(i_ALU_Z), .o_PMDATA(o_PMDATA)
	);
	
initial begin
	$dumpfile("signals_verilog.vcd");
	// $dumpvars(0, top_tb);
	$dumpvars(0, top_tb.uut);
	
	i_A = 16'h0000;
	i_Z = 16'h0001;
	i_ALU_Z = 1'b0;	// if set to 1, program enters infinite loop at address 2 instead of 3
	
	
	i_clk = 1'b0;
	i_reset_ext = 1'b1;
	#CLK_PERIOD;
	i_reset_ext = 1'b0;
	#CLK_PERIOD;
		
	#SIMULATION_TIME;
	$finish;
end

always
begin
	i_clk = 1'b0;
	#HALF_PERIOD;
	i_clk = 1'b1;
	#HALF_PERIOD;
end


endmodule