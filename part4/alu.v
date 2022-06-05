
// Responsible for arithmetic and logic operations on 2 operands.
module alu
(
	input wire i_clk,
	input wire i_reset,
	// control path
	input wire[3:0] i_operation,
	// data path
	input wire[7:0] i_op1,	// Rd
	input wire[7:0] i_op2,	// Rr
	output wire[7:0] o_result,
	//
	input wire i_halfcarry,
	input wire i_sign,
	input wire i_overflow,
	input wire i_negative,
	input wire i_zero,
	input wire i_carry,
	//
	output wire o_halfcarry,	// unsigned
	output wire o_sign,			// 2's complement
	output wire o_overflow,		// 2's complement
	output wire o_negative,		// 2's complement
	output wire o_zero,			// arith + logic
	output wire o_carry			// unsigned
);


reg[7:0] result;
reg overflow;

reg halfcarry;
reg sign;
reg negative;
reg zero;
reg carry;

reg op1_3;
reg op2_3;
reg op1_7;
reg op2_7;
reg[5:0] hsonzc;

reg sub;
reg log;
reg mov_cpse;
reg use_old_zero;


// ignore for CP, CPC
assign o_result = result;


// ADD, ADC (sub==0) and SUB, SBC, CP, CPC (sub==1)
// ignore for AND, EOR, OR, MOV
always @(*)
begin
	halfcarry = (log == 1 || mov_cpse == 1)
			? hsonzc[5] 
			: ((op1_3 ^ sub) & op2_3) | ((~result[3] ^ sub) & op2_3) | ((~result[3] ^ sub) & (op1_3 ^ sub));
end

assign o_halfcarry = halfcarry;

// use for ADD, ADC (sub==0) and SUB, SBC, CP, CPC (sub==1)
// ignore for AND, EOR, OR, MOV, CPSE
always @(*)
begin
	carry = (log == 1 || mov_cpse == 1) 
		? hsonzc[0] 
		: ((op1_7 ^ sub) & op2_7) | ((~result[7] ^ sub) & op2_7) | ((~result[7] ^ sub) & (op1_7 ^ sub));
end

assign o_carry = carry;

// ADD, ADC, AND, EOR, OR, SUB
// ignore for MOV
always @(*)
begin
	sign = mov_cpse == 1 ? hsonzc[4] : result[7] ^ overflow;
end

assign o_sign = sign;

// ADD, ADC (sub==0) and SUB, SBC, CP, CPC (sub==1)
// 0 for AND, EOR, OR
// ignore for MOV
always @(*)
begin
	if (mov_cpse == 1)
		overflow = hsonzc[3];
	else if (log == 1)
		overflow = 0;
	else
		overflow = (op1_7 & (op2_7 ^ sub) & ~result[7]) | (~op1_7 & (~op2_7 ^ sub) & result[7]);
end

assign o_overflow = overflow;

// ADD, ADC, SUB, AND, EOR, OR
// ignore for MOV
always @(*)
begin
	negative = mov_cpse == 1 ? hsonzc[2] : result[7];
end

assign o_negative = negative;

// ADD, ADC, SUB, SBC, CP, AND, EOR, OR
// ignore for MOV
// SBC, CPC: previous value remains unchanged when the result is zero; cleared otherwise
always @(*)
begin
	zero = mov_cpse == 1
		? hsonzc[1]
		: ~(result[0] | result[1] | result[2] | result[3] | result[4] | result[5] | result[6] | result[7]) & (~use_old_zero | hsonzc[1]);
end

assign o_zero = zero;

// synchronously reading and writing data
always @(posedge i_clk)
begin
	if (i_clk == 1'b1)
		begin
			if (i_reset == 1'b1)
				begin
					op1_3 <= 0;
					op2_3 <= 0;
					op1_7 <= 0;
					op2_7 <= 0;
					sub <= 0;
					use_old_zero <= 0;
					hsonzc <= 6'b000000;
				end
			else
				begin
					op1_3 <= i_op1[3];
					op2_3 <= i_op2[3];
					op1_7 <= i_op1[7];
					op2_7 <= i_op2[7];
					hsonzc <= {i_halfcarry, i_sign, i_overflow, i_negative, i_zero, i_carry};
					
					case (i_operation)
						// ARITHMETIC
						4'b0011, 4'b0111:	// ADD, ADC
							begin
								sub <= 0;
								log <= 0;
								mov_cpse <= 0;
								use_old_zero <= 0;
								result <= i_operation[2] == 1 && i_carry == 1
										? i_op1 + i_op2 + 1	// ADDC C=1
										: i_op1 + i_op2;	// ADD, ADDC C=0
							end
						4'b0110, 4'b0010, 4'b0101, 4'b0001, 4'b0100:	// SUB, CBC, CP, CPC, CPSE
							// for CP and CPC, ignore the result
							// for CPSE ignore everything but skip next instruction if Z=1
							begin
								sub <= 1;
								log <= 0;
								mov_cpse <= i_operation == 4'b0100 ? 1 : 0;
								use_old_zero <= ~i_operation[2];
								result <= i_operation[2] == 0 && i_carry == 1
										? i_op1 - i_op2 - 1
										: i_op1 - i_op2;
							end
						// LOGIC
						4'b1000:	// AND
							begin
								sub <= 0;
								log <= 1;
								mov_cpse <= 0;
								use_old_zero <= 0;
								result <= i_op1 & i_op2;
							end
						4'b1001:	// EOR
							begin
								sub <= 0;
								log <= 1;
								mov_cpse <= 0;
								use_old_zero <= 0;
								result <= i_op1 ^ i_op2;
							end
						4'b1010:	// OR
							begin
								sub <= 0;
								log <= 1;
								mov_cpse <= 0;
								use_old_zero <= 0;
								result <= i_op1 | i_op2;
							end
						4'b1011:	// MOV
							begin
								sub <= 0;
								log <= 1;
								mov_cpse <= 1;
								use_old_zero <= 0;
								result <= i_op2;
							end
						default:
							begin
								sub <= 0;
								log <= 0;
								mov_cpse <= 1;
								use_old_zero <= 0;
								result <= 8'b00000000;
							end
					endcase
				end
		end
end


endmodule