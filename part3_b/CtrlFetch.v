// Responsible for managing the program counter
module CtrlFetch
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
  

// registers
reg[15:0] r_PC, r_IR;

reg[15:0] r_adderOutput, r_pcInput, r_addr;

// adder with multiplexer for second operand (1, 2, K)
always @(*)
begin
	if (i_mode12K == 2'b00)
		r_adderOutput = r_PC + 1;
	else if (i_mode12K == 2'b01)
		r_adderOutput = r_PC + 2;
	else
		r_adderOutput = r_PC + i_K;
end


always @(*)
begin
	if (i_modeAddZA == 2'b10)
		r_pcInput = i_Z;
	else if (i_modeAddZA == 2'b11)
		r_pcInput = i_A;
	else
		r_pcInput = r_adderOutput;
end

// multiplexer for the PM address
always @(*)
begin
	r_addr = i_modePCZ == 0 ? r_PC : i_Z;
end

// memory interface
assign o_PMADDR = r_addr;
assign o_PMDATA = i_PMDATA;

assign o_IR = r_IR;

// synchronously loading PC and IR
  always @(posedge i_clk)
begin
  if (i_clk == 1'b1)
	begin
      if (i_reset)
		begin
			r_PC <= 16'h0000;
			r_IR <= 16'h0000;
		end
		else
		begin
			if (i_loadPC == 1'b1)
				r_PC <= r_pcInput;
			if (i_loadIR == 1'b1)
				r_IR <= i_PMDATA;
		end
	end
end

endmodule