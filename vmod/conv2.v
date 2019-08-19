module conv2
(
		input iCLK,iRSTn,iWren,iValid,
		input [4:0] iADDR,
		input signed [15:0] iX,iW,
		output signed [31:0] oY,
		output oValid
		);
reg signed [15:0] w[24:0];
wire signed [32:0] pSum0,pSum5,pSum10,pSum15,pSum20;
wire signed [32:0] pSum1,pSum6,pSum11,pSum16,pSum21;
wire signed [33:0] pSum2,pSum3,pSum7,pSum8,pSum12,
				   pSum13,pSum17,pSum18,pSum22,pSum23;
wire signed [34:0] pSum4,pSum9,pSum14,pSum19,pSum24;
reg [10:0] control;
reg [4:0] oCnt;
reg [4:0] rest;
reg signed [15:0] x_s;
reg x_valid;

always@(posedge iCLK, negedge iRSTn)
begin
	if(!iRSTn)begin
		x_valid<=0;
	end
	else begin
		x_valid<=iValid;
	end
end

always@(posedge iCLK, negedge iRSTn)
begin
	if(!iRSTn)begin
		x_s<=0;
	end
	else begin
		x_s<=iX;
	end
end


//oValid
assign oValid = (oCnt>0 && oCnt<=28 && control>=(32*4)+4)? 1:0;

//control
always@(posedge iCLK, negedge iRSTn)
begin
	if(!iRSTn)begin
		control<=0;
	end
	else begin
		if(x_valid==1&&control<1024)begin
			control<= control+1;
		end
		else if(control==1024)begin
			control <= 0;	
		end
	end
end

//y out
always@(posedge iCLK, negedge iRSTn)
begin
	if(!iRSTn)begin
		rest<=0;
	end
	else begin
		if(oCnt==28)begin
			rest<= rest+1;
		end
		if(rest==28)begin
			rest<=0;
		end
	end
end

always@(posedge iCLK, negedge iRSTn)
begin
	if(!iRSTn)begin
		oCnt<=0;
	end
	else begin
		if(control>=(32*4+4)+((32-5)/1+1)*rest+(4*rest))begin
			oCnt<=oCnt+1;
		end
		if(oCnt==28)begin
			oCnt<=0;
		end
	end
end

assign oY = (oValid==1)? pSum24[31:0]:0;

//W save
integer j;
always@(posedge iCLK, negedge iRSTn)
begin
	if(!iRSTn)begin
		for(j=0; j<25; j=j+1)begin
	        w[j] <= 0;
		end
	end
	else begin
		if(iWren==1)begin
			w[iADDR] <= iW;
		end
	end
end
PE #(32,33) block0
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[0]),.iPsum(32'b0),.oPsum(pSum0));
PE #(33,33) block1
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[1]),.iPsum(pSum0),.oPsum(pSum1));
PE #(33,34) block2
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[2]),.iPsum(pSum1),.oPsum(pSum2));
PE #(34,34) block3
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[3]),.iPsum(pSum2),.oPsum(pSum3));
PE #(34,35) block4
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[4]),.iPsum(pSum3),.oPsum(pSum4));
wire signed [31:0] data_arr1[27:0];
assign data_arr1[0] = (pSum4>2147483647)?2147483647:
				      (pSum4<-2147483647)? -2147483647: pSum4[31:0];
genvar i;
generate for(i=0; i<27; i=i+1)begin:gen1
	gen2 #(32) u_gen1(
			.iCLK(iCLK),
			.iRSTn(iRSTn),
			.iData(data_arr1[i]),
			.oData(data_arr1[i+1])
			);
	end
endgenerate

PE #(32,33) block5
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[5]),.iPsum(data_arr1[27]),.oPsum(pSum5));
PE #(33,33) block6
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[6]),.iPsum(pSum5),.oPsum(pSum6));
PE #(33,34) block7
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[7]),.iPsum(pSum6),.oPsum(pSum7));
PE #(34,34) block8
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[8]),.iPsum(pSum7),.oPsum(pSum8));
PE #(34,35) block9
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[9]),.iPsum(pSum8),.oPsum(pSum9));
wire signed [31:0] data_arr2[27:0];
assign data_arr2[0] = (pSum9>2147483647)?2147483647:
				      (pSum9<-2147483647)? -2147483647: pSum9[31:0];
generate for(i=0; i<27; i=i+1)begin:gen2
	gen2 #(32) u_gen2(
			.iCLK(iCLK),
			.iRSTn(iRSTn),
			.iData(data_arr2[i]),
			.oData(data_arr2[i+1])
			);
	end
endgenerate

PE #(32,33) block10
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[10]),.iPsum(data_arr2[27]),.oPsum(pSum10));
PE #(33,33) block11
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[11]),.iPsum(pSum10),.oPsum(pSum11));
PE #(33,34) block12
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[12]),.iPsum(pSum11),.oPsum(pSum12));
PE #(34,34) block13
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[13]),.iPsum(pSum12),.oPsum(pSum13));
PE #(34,35) block14
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[14]),.iPsum(pSum13),.oPsum(pSum14));
wire signed [31:0] data_arr3[27:0];
assign data_arr3[0] = (pSum14>2147483647)?2147483647:
				      (pSum14<-2147483647)? -2147483647: pSum14[31:0];
generate for(i=0; i<27; i=i+1)begin:gen3
	gen2 #(32) u_gen3(
			.iCLK(iCLK),
			.iRSTn(iRSTn),
			.iData(data_arr3[i]),
			.oData(data_arr3[i+1])
			);
	end
endgenerate

PE #(32,33) block15
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[15]),.iPsum(data_arr3[27]),.oPsum(pSum15));
PE #(33,33) block16
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[16]),.iPsum(pSum15),.oPsum(pSum16));
PE #(33,34) block17
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[17]),.iPsum(pSum16),.oPsum(pSum17));
PE #(34,34) block18
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[18]),.iPsum(pSum17),.oPsum(pSum18));
PE #(34,35) block19
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[19]),.iPsum(pSum18),.oPsum(pSum19));
wire signed [31:0] data_arr4[27:0];
assign data_arr4[0] = (pSum19>2147483647)?2147483647:
				      (pSum19<-2147483647)? -2147483647: pSum19[31:0];
generate for(i=0; i<27; i=i+1)begin:gen4
	gen2 #(32) u_gen4(
			.iCLK(iCLK),
			.iRSTn(iRSTn),
			.iData(data_arr4[i]),
			.oData(data_arr4[i+1])
			);
	end
endgenerate

PE #(32,33) block20
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[20]),.iPsum(data_arr4[27]),.oPsum(pSum20));
PE #(33,33) block21
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[21]),.iPsum(pSum20),.oPsum(pSum21));
PE #(33,34) block22
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[22]),.iPsum(pSum21),.oPsum(pSum22));
PE #(34,34) block23
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[23]),.iPsum(pSum22),.oPsum(pSum23));
PE #(34,35) block24
(.iCLK(iCLK),.iRSTn(iRSTn),.iX(x_s),.iW(w[24]),.iPsum(pSum23),.oPsum(pSum24));

endmodule
