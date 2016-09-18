`include "IF_ID_if.vh"
`include "cpu_types_pkg.vh"


module IF_ID (
  IF_ID_if.if_id ifid
);

  import cpu_types_pkg::*;


  always_ff(posedge ifid.iHit)
  begin
  	if (ifid.flush == 1) begin
  		ifid.instr <= 0;
  		ifid.pcp4_out <= 0;
  	end
  	else begin
  		ifid.instr <= ifid.imemload;
  		ifid.pcp4_out <= ifid.pcp4;
  	end
  end
endmodule // IF_ID