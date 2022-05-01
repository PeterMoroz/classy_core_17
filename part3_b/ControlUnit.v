module ControlUnit
(
	input wire i_clk,
	input wire i_reset,
	// FSM inputs
	input wire[15:0] i_IR,
	input wire i_ALU_Z,
	// control path outputs
	output reg o_reset,
	output reg[1:0] o_mode12K,
	output reg[1:0] o_modeAddZA,
	output wire o_modePCZ,
	output reg o_loadPC,
	output reg o_loadIR,
	// data path
	output reg[15:0] o_K
);
  
localparam [3:0]  
	CUS_RESET = 4'b0000, 	// initial state, reset all registers
	CUS_FETCH_1 = 4'b0001,	// fetch the next instruction into IR
	CUS_FETCH_2 = 4'b0010,	//  wait for memory
	CUS_DECODE = 4'b0011,	// decode the instruction in IR
	CUS_EXEC_IJMP = 4'b0100,	// execute IJMP instruction
	CUS_EXEC_RJMP = 4'b0101,	// execute RJMP instruction
	CUS_EXEC_SBRS_1 = 4'b0110,	// execute SBRS instruction
	CUS_EXEC_SBRS_2 = 4'b0111,	// handle bit test instruction
	CUS_EXEC_SBRS_3 = 4'b1000;	// skip next instruction

reg[3:0] state;

// combinational logic
always @(*)
begin
  o_reset = (state == CUS_RESET) ? 1'b1 : 1'b0;
end

always @(*)
begin
  o_mode12K = (state == CUS_FETCH_1 || state == CUS_EXEC_SBRS_3) 
			? 2'b00 : (state == CUS_EXEC_RJMP) ? 2'b10 : 2'bXX;
end

always @(*)
begin
  o_modeAddZA = (state == CUS_FETCH_1 || state == CUS_EXEC_RJMP || state == CUS_EXEC_SBRS_3) 
			  ? 2'b00 : (state == CUS_EXEC_IJMP) ? 2'b10 : 2'bXX;
end

assign o_modePCZ = 1'b0;	// unused at the moment because we don't fetch data from PM

always @(*)
begin
  o_loadPC = (state == CUS_FETCH_1 || state == CUS_EXEC_IJMP || state == CUS_EXEC_RJMP || state == CUS_EXEC_SBRS_3) 
		   ? 1'b1 : (state == CUS_DECODE || state == CUS_EXEC_SBRS_1 || state == CUS_EXEC_SBRS_2) ? 1'b0 : 1'bX;
end  

always @(*)
begin
  o_loadIR = (state == CUS_FETCH_2) ? 1'b1 : 1'b0;
end

// data path
always @(*)
begin
  o_K = (state == CUS_EXEC_RJMP) ? {4'b0000, i_IR[11:0]} : 16'bXXXXXXXXXXXXXXXX;
end

  
// synchronous logic
always @(posedge i_clk)
begin
  if (i_clk == 1'b1)
	begin
	  if (i_reset == 1'b1)
		state <= CUS_RESET;
	  else
		begin
		  case (state)
			CUS_RESET: state <= CUS_FETCH_1;
			CUS_FETCH_1: state <= CUS_FETCH_2;
			CUS_FETCH_2: state <= CUS_DECODE;
			CUS_DECODE: 
			  case (i_IR[15:12])
				4'b1001: state <= CUS_EXEC_IJMP;
				4'b1100: state <= CUS_EXEC_RJMP;
				4'b1111: state <= CUS_EXEC_SBRS_1;
				default: state <= CUS_FETCH_1;	// skip unknown instruction for now
			  endcase
			 
			CUS_EXEC_IJMP: state <= CUS_FETCH_1;
			CUS_EXEC_RJMP: state <= CUS_FETCH_1;
			CUS_EXEC_SBRS_1: state <= CUS_EXEC_SBRS_2;
			CUS_EXEC_SBRS_2: 
			  if (i_ALU_Z == 1'b1)	// bit not set, don't skip
				state <= CUS_FETCH_1;
			  else					// bit set, skip instruction
				state <= CUS_EXEC_SBRS_3;

			CUS_EXEC_SBRS_3: state <= CUS_FETCH_1;
			default: state <= CUS_RESET;
		  endcase
		end
	end
end
  
endmodule