module ProgramMemory
  (
    input wire i_clk,
    input wire[15:0] i_addr,
    output reg[15:0] o_data
  );
  
  /*
  reg[15:0] cells[7:0];
  
  cells[7] = 16'h0000; // unused
  cells[6] = 16'h0000; // unused
  cells[5] = 16'h0000; // unused
  cells[4] = 16'h9409; // ijmp
  cells[3] = 16'hcfff; // rjmp .-2
  cells[2] = 16'hcfff; // rjmp .-2
  cells[1] = 16'hfe00; // sbrs r0, 0  
  cells[0] = 16'hc003; // rjmp .+6
  
  always @(posedge i_clk)
    begin
      if (i_clk == 1'b1)
        o_data = cells[i_addr];
    end
    */
  
  always @(posedge i_clk)
    begin
      if (i_clk == 1'b1)
        case(i_addr)
          16'h0000: o_data = 16'hc003; // rjmp .+6
          16'h0001: o_data = 16'hfe00; // sbrs r0, 0
          16'h0002,
          16'h0003: o_data = 16'hcfff; // rjmp .-2		  
          16'h0004: o_data = 16'h9409; // ijmp
          16'h0005,
          16'h0006,
          16'h0007: o_data = 16'h0000;
          default:  o_data = 16'h0000;
        endcase
    end  
  
endmodule