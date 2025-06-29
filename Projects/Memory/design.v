module memory(clk,res,wr_rd,addr,wdata,rdata,valid,ready,mem);

  parameter w=4;
  parameter d=16;
  parameter n=$clog2(d);

  input clk,res,wr_rd,valid;
  input [w-1:0] wdata;
  input [n-1:0] addr;

  output reg [w-1:0] rdata;
  output reg ready;
  output reg [w-1:0] mem [d-1:0];

  integer i;

  task reset(); begin 
    ready=0;
  end 
  endtask

  always @(*) begin
    if(res==1) reset();
    else begin
      if(wr_rd==1) begin
        mem[addr]=wdata;
        ready=1;
        #5;
        reset();
      end
      else begin
        rdata=mem[addr];
        ready=1;
        #5;
        reset();
      end
    end
  end
endmodule