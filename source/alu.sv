`include "alu_if.vh"
`include "cpu_types_pkg.vh"

module alu(
  alu_if.alu aluif
);

  import cpu_types_pkg::*;
  always_comb
  begin
    casez(aluif.alu_op)
      ALU_SLL:
        aluif.out = aluif.port_a << aluif.port_b;
      ALU_SRL:
        aluif.out = aluif.port_a >> aluif.port_b;
      ALU_ADD:
        aluif.out = $signed(aluif.port_a) + $signed(aluif.port_b);
      ALU_SUB:
        aluif.out = $signed(aluif.port_a) - $signed(aluif.port_b);
      ALU_AND:
        aluif.out = aluif.port_a & aluif.port_b;
      ALU_OR:
        aluif.out = aluif.port_a | aluif.port_b;
      ALU_XOR:
        aluif.out = aluif.port_a ^ aluif.port_b;
      ALU_NOR:
        aluif.out = ~(aluif.port_a | aluif.port_b);
      ALU_SLT:
        aluif.out = ($signed(aluif.port_a) < $signed(aluif.port_b))? 32'b1: 32'b0;
      ALU_SLTU:
        aluif.out = (aluif.port_a < aluif.port_b)? 32'b1: 32'b0;
    endcase

    if(aluif.alu_op == ALU_ADD)
      aluif.OVER = ((aluif.port_a[31] == aluif.port_b[31]) && aluif.port_a[31] != aluif.out[31]) ? 1: 0;
    else if (aluif.alu_op == ALU_SUB)
      aluif.OVER = ((aluif.port_a[31] == ~aluif.port_b[31]) && aluif.port_a[31] != aluif.out[31]) ? 1:0;
    else
      aluif.OVER = 0;

    aluif.ZERO = ~(|aluif.out);
    aluif.NEG = (aluif.out[31] == 1)? 1: 0;
  end

endmodule
