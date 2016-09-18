`include "cpu_types_pkg.vh"
`include "request_if.vh"

module request (
	input CLK, nRST, 
	request_if.rq rqif
);	

	assign rqif.pcen = rqif.ihit;
	//logic next_dmemren, next_dmemwen;

	always_ff @(posedge CLK, negedge nRST)
	begin		
		if(!nRST)
		begin
			rqif.dmemren <= 0; //next_dmemren <= 0;
			rqif.dmemwen <= 0; //next_dmemwen <= 0;
		end

		else
		begin
			if(rqif.dhit)
			begin
				rqif.dmemren <= 0;//next_dmemren <= 0;
				rqif.dmemwen <= 0; //next_dmemwen <= 0;
			end
			else if(rqif.ihit && rqif.dwen)
				rqif.dmemwen <= 1;// next_dmemwen <= 1;
			else if(rqif.ihit && rqif.dren)
				rqif.dmemren <= 1; //next_dmemren <= 1;
		end
		//rqif.dmemren <= next_dmemren;
		//rqif.dmemwen <= next_dmemwen;

	end
endmodule // request