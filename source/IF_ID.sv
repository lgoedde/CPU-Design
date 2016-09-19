`include "IF_ID_if.vh"
`include "cpu_types_pkg.vh"


module IF_ID (
  input CLK,nRST,
  IF_ID_if.if_id ifid
);

  import cpu_types_pkg::*;


  always_ff @ (posedge CLK, negedge nRST)
  begin
  	if (ifid.flush == 1 || !nRST) begin
  		ifid.instr <= 0;
  		ifid.pcp4_out <= 0;
  	end
  	else if (ifid.iHit) begin
  		ifid.instr <= ifid.imemload;
  		ifid.pcp4_out <= ifid.pcp4;
  	end
  end
endmodule // IF_ID