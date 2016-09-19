`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

module register_file(
  input logic CLK, nRST,
  register_file_if.rf rfif
);

  import cpu_types_pkg::*;
  word_t register[31:0];

  always_ff @(negedge CLK, negedge nRST)
  begin
    if(!nRST)
      register <= '{default: '0};
    else if(rfif.WEN)
    begin
      if(rfif.wsel != '0)
        register[rfif.wsel] <= rfif.wdat;
    end
  end

  always_comb
  begin
    rfif.rdat1 = register[rfif.rsel1];
    rfif.rdat2 = register[rfif.rsel2];
  end
endmodule
