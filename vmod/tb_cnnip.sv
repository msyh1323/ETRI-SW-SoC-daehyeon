`timescale 1ns / 1ps

module tb_cnnip;
reg  clk;
reg  rst;
reg [16 : 0] s00_axi_awaddr;
reg [2 : 0] s00_axi_awprot;
reg  s00_axi_awvalid;
wire  s00_axi_awready;
reg[31 : 0] s00_axi_wdata;
reg [3 : 0] s00_axi_wstrb;
reg  s00_axi_wvalid;
wire  s00_axi_wready;
wire [1 : 0] s00_axi_bresp;
wire  s00_axi_bvalid;
reg s00_axi_bready;
reg [16 : 0] s00_axi_araddr;
reg [2 : 0] s00_axi_arprot;
reg  s00_axi_arvalid;
wire  s00_axi_arready;
wire [31 : 0] s00_axi_rdata;
wire [1 : 0] s00_axi_rresp;
wire  s00_axi_rvalid;
reg  s00_axi_rready;

cnnip_v1_0 #
(
  .C_S00_AXI_DATA_WIDTH(32),
  .C_S00_AXI_ADDR_WIDTH(16)
)
cnnip_v1_0_inst (  // Ports of Axi Slave Bus Interface S00_AXI
  .s00_axi_aclk(clk),
  .s00_axi_aresetn(rst),
  .s00_axi_awaddr(s00_axi_awaddr),
  .s00_axi_awprot(s00_axi_awprot),
  .s00_axi_awvalid(s00_axi_awvalid),
  .s00_axi_awready(s00_axi_awready),
  .s00_axi_wdata(s00_axi_wdata),
  .s00_axi_wstrb(s00_axi_wstrb),
  .s00_axi_wvalid(s00_axi_wvalid),
  .s00_axi_wready(s00_axi_wready),
  .s00_axi_bresp(s00_axi_bresp),
  .s00_axi_bvalid(s00_axi_bvalid),
  .s00_axi_bready(s00_axi_bready),
  .s00_axi_araddr(s00_axi_araddr),
  .s00_axi_arprot(s00_axi_arprot),
  .s00_axi_arvalid(s00_axi_arvalid),
  .s00_axi_arready(s00_axi_arready),
  .s00_axi_rdata(s00_axi_rdata),
  .s00_axi_rresp(s00_axi_rresp),
  .s00_axi_rvalid(s00_axi_rvalid),
  .s00_axi_rready(s00_axi_rready)
);



always #5 clk = ~clk;

integer i;
initial begin
    clk=0;
    rst=0;
    s00_axi_awprot=0;
    s00_axi_awvalid=0;
    s00_axi_awaddr=0;
    s00_axi_wdata=0;
    s00_axi_wvalid=0;
    
    s00_axi_rready=0;
    s00_axi_araddr = 0;
    s00_axi_arprot = 0;
    s00_axi_arvalid = 0;
    
    s00_axi_wstrb=0;
    
    s00_axi_arvalid=0;
    s00_axi_araddr=0;
    
    s00_axi_bready=0;
    
    @(posedge clk);
    #1 rst = 1;
    @(posedge clk);
    #1 rst = 0;
    @(posedge clk);
    #1 rst = 1;
    s00_axi_bready=1;
    for(i=0; i<1024*4; i=i+4)begin
        repeat(3)@(posedge clk);
        #1 s00_axi_awvalid = 1'b1; s00_axi_awaddr = 16'h1000+i; s00_axi_wvalid = 1'b1;  s00_axi_wdata = 1; s00_axi_wstrb=1;
    end
    repeat(3)@(posedge clk);
    #1 s00_axi_awvalid = 1'b0; s00_axi_awaddr = 0; s00_axi_wvalid = 1'b0; s00_axi_wdata = 1'b0;
    
    @(posedge clk);
    #1 s00_axi_bready=1;
    for(i=0; i<25*4; i=i+4)begin
        repeat(3)@(posedge clk);
        #1 s00_axi_awvalid = 1'b1; s00_axi_awaddr = 16'h2000+i; s00_axi_wvalid = 1'b1; s00_axi_wdata = i/4+1; s00_axi_wstrb=1;
    end
    
    s00_axi_bready=0;
//    s00_axi_awvalid = 1'b0; s00_axi_awaddr = 0; s00_axi_bready=0; s00_axi_wvalid = 1'b0; s00_axi_wdata = 1'b0;
    repeat(2)@(posedge clk);
    #1 
    s00_axi_awvalid = 1'b1; s00_axi_awaddr = 0; s00_axi_bready=1; s00_axi_wvalid = 1'b1; s00_axi_wstrb = 4'b1111;
    s00_axi_wdata = 32'b11111111_11111111_11111111_11111111;
    //assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
    //assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
    repeat(5)@(posedge clk);
    #1 
    
    repeat(5)@(posedge clk);
    #1  s00_axi_awvalid = 1'b0; s00_axi_awaddr = 0; s00_axi_bready=0; s00_axi_wvalid = 1'b0; s00_axi_wstrb = 4'b0000; s00_axi_wdata = 0;
    repeat(5)@(posedge clk);
    #1 
    repeat(6000) @(posedge clk);
    for(i=0; i<800*4; i=i+4)begin
        repeat(2)@(posedge clk);
        #1 s00_axi_arvalid = 1'b1; s00_axi_araddr = 16'h3000+i; s00_axi_wstrb=1;
        repeat(3)@(posedge clk);
        #1 s00_axi_arvalid = 1'b0; s00_axi_araddr = 0; s00_axi_wstrb=0;
    end
    repeat(3)@(posedge clk);
    #1 s00_axi_arvalid = 1'b1; s00_axi_araddr = 16'h3c41; s00_axi_wstrb=1;
    repeat(3)@(posedge clk);
    #1 s00_axi_arvalid = 1'b0; s00_axi_araddr = 16'h0000; s00_axi_wstrb=0;
    repeat(3)@(posedge clk);
    #1 s00_axi_arvalid = 1'b0; s00_axi_araddr = 0; s00_axi_wstrb=0;
end
endmodule
