module PE
#(parameter BW1=34, BW2=35)
(
 input iCLK,iRSTn,
 input signed [15:0] iX,
 input signed [15:0] iW,
 input signed [BW1-1:0] iPsum,
 output reg signed [BW2-1:0] oPsum
 );
//reg signed [BW2-1:0] dPsum;
wire signed [31:0] Mul;

assign Mul = iW*iX;
//assign oPsum = dPsum;

always@(posedge iCLK, negedge iRSTn)
begin
	if(!iRSTn)begin
		oPsum<=0;
	end
	else begin
		oPsum <= Mul+iPsum;
	end
end
endmodule

