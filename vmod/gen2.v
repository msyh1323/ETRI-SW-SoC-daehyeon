module gen2
#(parameter BW=32)
(
		input iCLK,iRSTn,
		input [BW-1:0] iData,
		output reg [BW-1:0] oData
		);
always@(posedge iCLK, negedge iRSTn)
begin
	if(!iRSTn)begin
		oData<=0;
	end
	else begin
		oData<=iData;
	end
end
endmodule
