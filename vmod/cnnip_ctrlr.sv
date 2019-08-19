/*
 *  cnnip_ctrlr.sv -- CNN IP controller
 *  ETRI <SW-SoC AI Deep Learning HW Accelerator RTL Design> course material
 *
 *  first draft by Junyoung Park
 */

module cnnip_ctrlr
(
  // clock and reset signals from domain a
  input wire clk_a,
  input wire arstz_aq,

  // internal memories
  cnnip_mem_if.master to_input_mem,
  cnnip_mem_if.master to_weight_mem,
  cnnip_mem_if.master to_feature_mem,

  // configuration registers
  input wire         CMD_START,
  input wire   [7:0] MODE_KERNEL_SIZE,
  input wire   [7:0] MODE_KERNEL_NUMS,
  input wire   [1:0] MODE_STRIDE,
  input wire         MODE_PADDING,
  output wire        CMD_DONE,
  output wire        CMD_DONE_VALID
);

  // sample FSM
  enum { IDLE, SOURCEREAD, CONV, WRITE, DONE } state_aq, state_next;

  // internal registers
  reg [15:0] iW[24:0];
  reg [15:0] iX[1023:0];
  reg [31:0] oF[783:0];
  reg [4:0] w_cnt;
  reg [10:0] x_cnt;
  wire [1:0]p;
  reg [10:0] c_cnt;
  reg [9:0] write;
//  reg [4:0] iADDR;
  reg iWren;
  reg iValid;
  wire [31:0] oY;
  wire oValid;
  reg [15:0] iX_conv;
  reg [10:0] f_cnt;
  reg [15:0] iW_conv;
  wire [4:0] cw_cnt;
  reg count;
  
  conv2 conv2_inst(
		.iCLK(clk_a),
		.iRSTn(arstz_aq),
		.iWren(iWren),
		.iValid(iValid),
		.iADDR(cw_cnt),
		.iX(iX_conv),
		.iW(iW_conv),
		.oY(oY),
		.oValid(oValid)
  );
  
  assign cw_cnt = w_cnt-2;
  
  always@(posedge clk_a,negedge arstz_aq)
  begin
    if(!arstz_aq) count<=0;
    else begin
        count <= count+1;
    end
  end
  
  
  always@(*)begin
    iW_conv = 0;
    if(iWren == 1 && (cw_cnt>=0&&cw_cnt<25))begin
        iW_conv = iW[cw_cnt];
    end
    else iW_conv = 0;
  end
  // use wires as shortcuts
  wire wait_done = (f_cnt == 754);
  
  assign p=2'd2;
   
  //source read
  
  
  
  //weights read
  always@(posedge clk_a,negedge arstz_aq)
  begin
    if(!arstz_aq) w_cnt<=0;
    else begin
        if(iWren==1&&count==1) w_cnt <= w_cnt+1'b1;
        else if(state_aq == DONE) w_cnt<=0;
        if(w_cnt==27) w_cnt<= w_cnt;
    end
  end
  
  integer i;
  always@(posedge clk_a,negedge arstz_aq)
  begin
    if(!arstz_aq) begin
        for(i=0; i<25; i=i+1)begin
	        iW[i] <= 0;
	    end
    end
    else if(iWren==1)begin
        iW[w_cnt-1] <= to_weight_mem.dout;
    end
  end
  
  
  
  //input read
  always@(posedge clk_a,negedge arstz_aq)
  begin
    if(!arstz_aq) x_cnt<=0;
    else begin
        if(iWren==1&&count==1) x_cnt<= x_cnt+1'b1;
        else if(state_aq == DONE) x_cnt <= 0;
    end
  end
  
  always@(posedge clk_a,negedge arstz_aq)
  begin
    if(!arstz_aq) begin
        for(i=0; i<1024; i=i+1)begin
	        iX[i] <= 0;
	    end
    end
    else if(iWren==1)begin
        iX[x_cnt-1] <= to_input_mem.dout;
    end
  end
  
  //CONVOLUTION
  always@(posedge clk_a,negedge arstz_aq)
  begin
    if(!arstz_aq) c_cnt<=0;
    else begin
        if(state_aq == CONV) c_cnt<= c_cnt+1;
        else if(state_aq == IDLE) c_cnt <= 0;
    end
  end
  always@(*)
  begin
    if(iValid==1)begin
            iX_conv = iX[c_cnt];
    end
    else iX_conv = 0;
  end
  
  
  
  // Write feature
  always@(posedge clk_a,negedge arstz_aq)
  begin
    if(!arstz_aq) f_cnt<=0;
    else begin
        if(oValid) f_cnt<= f_cnt+1;
        else if(state_aq == IDLE) f_cnt <= 0;
    end
  end
  
  
  always@(posedge clk_a,negedge arstz_aq)
  begin
    if(!arstz_aq) begin
        for(i=0; i<784; i=i+1)begin
	        oF[i] <= 0;
	    end
    end
    else if(oValid==1)begin
        oF[f_cnt] <= oY;
    end
  end
  
  always@(posedge clk_a,negedge arstz_aq)
  begin
    if(!arstz_aq) begin
        write <= 0;
    end
    else if(state_aq==WRITE && count==1)begin
        write <= write+1;
    end
  end
  
  
  // state transition
  always @(posedge clk_a, negedge arstz_aq)
    if (arstz_aq == 1'b0) state_aq <= IDLE;
    else state_aq <= state_next;

  // state transition condition
  always @(*)
  begin
    state_next = state_aq;
    iWren=0;
    iValid=0;
    case (state_aq)
      IDLE:
        if (CMD_START) state_next = SOURCEREAD;
      SOURCEREAD:begin
        iWren=1;
        if(x_cnt==11'd1026) state_next = CONV;
      end
      CONV:begin
        iWren=0;
        iValid = 1;
        if(c_cnt==11'd1023) state_next = WRITE;
      end
      WRITE:begin
        if(write == 784) state_next = DONE;
      end
      DONE:begin
        iValid = 0;
        state_next = IDLE;
      end
    endcase
  end
  
  // output signals
  assign CMD_DONE = (state_aq == DONE);
  assign CMD_DONE_VALID = (state_aq == DONE);

  
  reg [15:0] w_addr;
  reg [15:0] x_addr;
  reg [15:0] f_addr;
  assign x_addr = 16'h1000+x_cnt*4;
  assign w_addr = 16'h2000+w_cnt*4;
  assign f_addr = 16'h3000+write*4;
  // control signals
  assign to_input_mem.en   = (state_aq==SOURCEREAD)? 1'b1:0;
  assign to_input_mem.we   = (state_aq==SOURCEREAD)? 1'b0:0;
  assign to_input_mem.addr = (state_aq == SOURCEREAD)? x_addr:0;
  assign to_input_mem.din  = 'b0;

  assign to_weight_mem.en   = (state_aq==SOURCEREAD)? 1'b1:0;
  assign to_weight_mem.we   = (state_aq==SOURCEREAD)? 1'b0:0;
  assign to_weight_mem.addr = (state_aq == SOURCEREAD)? w_addr:0;
  assign to_weight_mem.din  = 'b0;
  

  assign to_feature_mem.en   = (state_aq==WRITE&&write<784)? 1'b1:0;
  assign to_feature_mem.we   = (state_aq==WRITE&&write<784)? 4'b1111:0;
  assign to_feature_mem.addr = (state_aq==WRITE&&write<784)? f_addr:0;
  assign to_feature_mem.din  = (state_aq==WRITE&&write<784)? oF[write]:0;

endmodule // cnnip_ctrlr
