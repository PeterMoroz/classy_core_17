module ProgramMemory
(
input wire i_clk,
input wire[15:0] i_addr,
output reg[15:0] o_data
);

reg[15:0] memory_cells[7:0];

initial
begin
	memory_cells[0] = 16'hc003; // rjmp .+6
	memory_cells[1] = 16'hfe00; // sbrs r0, 0
	memory_cells[2] = 16'hcfff; // rjmp .-2
	memory_cells[3] = 16'hcfff; // rjmp .-2
	memory_cells[4] = 16'h9409; // ijmp
	memory_cells[5] = 16'h0000;
	memory_cells[6] = 16'h0000;
	memory_cells[7] = 16'h0000;
end

always @(posedge i_clk)
begin
  if (i_clk == 1'b1)
  	o_data <= memory_cells[i_addr];
end

endmodule