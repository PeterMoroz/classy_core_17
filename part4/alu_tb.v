`timescale 1 ns/10 ps

module alu_tb;

localparam clk_period = 20;


reg clk, reset;


// inputs
reg[3:0] operation;
reg zero_input, carry_input;
reg[3:0] operation_ix;
reg[7:0] rd, rs, rd2, state;

// outputs
wire[7:0] result;
wire halfcarry, sign, overflow, negative, zero, carry;

reg ignore_result;


// files' stuff
integer in_file, out_file;
integer line_number;
reg[16 * 8 - 1 : 0] out_buffer;
reg[16 * 8 - 1 : 0] in_buffer;
integer rc;



// instantiate the Unit Under Test (UUT)
alu uut(.i_clk(clk), .i_reset(reset),
	// control path
	.i_operation(operation),
	// data path
	.i_op1(rd), .i_op2(rs), .o_result(result),
	//
	.i_halfcarry(state[5]), .i_sign(state[4]), .i_overflow(state[3]), .i_negative(state[2]), .i_zero(zero_input), .i_carry(carry_input),	// use value from reference data to check for 'unchanged'
	//
	.o_halfcarry(halfcarry), .o_sign(sign), .o_overflow(overflow), .o_negative(negative), .o_zero(zero), .o_carry(carry) );

initial
begin

	//$dumpfile("signals_verilog.vcd");
	//$dumpvars(0, alu_tb.uut);

	clk = 1'b0;
	reset = 1'b0;

	operation = 4'b0000;
	rd = 8'b00000000;
	rs = 8'b00000000;
	rd2 = 8'b00000000;
	state = 8'b00000000;
	operation_ix = 4'b0000;

	zero_input = 1'b0;
	carry_input = 1'b0;
	ignore_result = 1'b0;

end


always
begin
	clk = 1'b0;
	#(clk_period / 2);
	clk = 1'b1;
	#(clk_period / 2);
end


// For some instructions, we use fixed zero flag values in the stimuli.
always @(operation_ix, state)
begin
	if (operation_ix == 4'b0010)		// ADC Z=0
		zero_input = 0;
	else if (operation_ix == 4'b0011)	// ADC Z=1
		zero_input = 1;
	else if (operation_ix == 4'b0101)	// SBC Z=0
		zero_input = 0;
	else if (operation_ix == 4'b0110)	// SBC Z=1
		zero_input = 1;
	else if (operation_ix == 4'b1100)	// CPC Z=0
		zero_input = 0;
	else if (operation_ix == 4'b1101)	// CPC Z=1
		zero_input = 1;
	else
		zero_input = state[1];
end

// For some instructions, we use fixed carry flag values in the stimuli.
always @(operation_ix, state)
begin
	if (operation_ix == 4'b0010)		// ADC C=0
		carry_input = 0;
	else if (operation_ix == 4'b0011)	// ADC C=1
		carry_input = 1;
	else if (operation_ix == 4'b0101)	// SBC C=0
		carry_input = 0;
	else if (operation_ix == 4'b0110)	// SBC C=1
		carry_input = 1;
	else if (operation_ix == 4'b1100)	// CPC C=0
		carry_input = 0;
	else if (operation_ix == 4'b1101)	// CPC C=1
		carry_input = 1;
	else
		carry_input = state[0];
end

// For some instructions the ALU result is ignored and only the status is considered.
always @(operation_ix)
begin
	if (operation_ix == 4'b1011)		// CP
		ignore_result = 1;
	else if (operation_ix == 4'b1100)	// CPC C=0
		ignore_result = 1;
	else if (operation_ix == 4'b1101)	// CPC C=1
		ignore_result = 1;
	else if (operation_ix == 4'b1110)	// CPSE
		ignore_result = 1;
	else
		ignore_result = 0;
end


always @(operation_ix)
begin
	if (operation_ix == 4'b0001)		// ADD
		operation = 4'b0011;
	else if (operation_ix == 4'b0010)	// ADC
		operation = 4'b0111;
	else if (operation_ix == 4'b0011)	// ADC
		operation = 4'b0111;
	else if (operation_ix == 4'b0100)	// SUB
		operation = 4'b0110;
	else if (operation_ix == 4'b0101)	// SBC
		operation = 4'b0010;
	else if (operation_ix == 4'b0110)	// SBC
		operation = 4'b0010;
	else if (operation_ix == 4'b0111)	// AND
		operation = 4'b1000;		
	else if (operation_ix == 4'b1000)	// EOR
		operation = 4'b1001;
	else if (operation_ix == 4'b1001)	// OR
		operation = 4'b1010;
	else if (operation_ix == 4'b1010)	// MOV
		operation = 4'b1011;
	else if (operation_ix == 4'b1011)	// CP
		operation = 4'b0101;
	else if (operation_ix == 4'b1100)	// CPC
		operation = 4'b0001;
	else if (operation_ix == 4'b1101)	// CPC
		operation = 4'b0001;
	else if (operation_ix == 4'b1110)	// CPSE
		operation = 4'b0100;
	else
		operation = 4'b0001;
end


always
begin
	reset = 1'b1;
	#100
	reset = 1'b0;

	in_file = $fopen("stimuli/alu_dump.txt", "r");
	if (in_file == 0)
		$fatal(0, "File 'stimuli/alu_dump.txt' could not be opened.");
	out_file = $fopen("stimuli/alu_diff.txt", "w");
	if (out_file == 0)
		$fatal(0, "File 'stimuli/alu_diff.txt' could not be opened.");
	line_number = 0;

	while (!$feof(in_file))
	begin
		in_buffer = "0000000000000000";
		rc = $fgets(in_buffer, in_file);	
		if (in_buffer[103:96] == 8'h20 && in_buffer[79:72] == 8'h20 && in_buffer[55:48] == 8'h20 && in_buffer[31:24] == 8'h20)
			begin
				// read one line (one set of input and reference output data)
				rc = $sscanf(in_buffer, "%h %h %h %h %h", operation_ix, rd, rs, rd2, state);
				/* $display(" read %d fields: %d %d %d %d %d", rc, operation_ix, rd, rs, rd2, state); */
				// let the ALU do its job
				#(clk_period);
				// check if the reference and the result from ALU match
				if ((ignore_result == 1'b0 && rd2 != result) || (state != {2'b00, halfcarry, sign, overflow, negative, zero, carry}))
					begin
						$fwrite(out_file, "%05d %h %h\t%h %h\t%h %h\n", line_number, rd, rs, rd2, result, state, {2'b00, halfcarry, sign, overflow, negative, zero, carry});
						/* 
						$fwrite(out_file, "%05d %h %h\t%h %h\t%h %h\toperation_ix = %d, carry_input = %b, state[0] = %b\n", 
							line_number, rd, rs, rd2, result, state, {2'b00, halfcarry, sign, overflow, negative, zero, carry}, operation_ix, carry_input, state[0]); */
					end
			end
		else
			$fwrite(out_file, "%s", in_buffer);
		
		line_number = line_number + 1;
		#(clk_period);
		
/*
		$fwrite(out_file, "%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h\n", 
			in_buffer[127:120], in_buffer[119:112], in_buffer[111:104], in_buffer[103:96], 
			in_buffer[95:88], in_buffer[87:80], in_buffer[79:72], in_buffer[71:64],
			in_buffer[63:56], in_buffer[55:48], in_buffer[47:40], in_buffer[39:32],
			in_buffer[31:24], in_buffer[23:16], in_buffer[15:8], in_buffer[7:0]);
			*/
	end

	$fclose(in_file);
	$fclose(out_file);
	
	$stop;

end

endmodule