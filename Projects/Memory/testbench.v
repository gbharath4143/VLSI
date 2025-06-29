module tb();

  parameter w=4;
  parameter d=16;
  parameter n=$clog2(d);

  reg clk,res,wr_rd,valid;
  reg [w-1:0] wdata;
  reg [n-1:0] addr;
  reg [w:0] start;
  reg [w:0] num;
  
  reg [32*8-1:0]oper;

  wire [w-1:0] rdata;
  wire ready;
  wire [w-1:0] mem [d-1:0];

  integer i,j;

  memory dut (.clk(clk),.res(res),.wr_rd(wr_rd),.addr(addr),.wdata(wdata),.rdata(rdata),.valid(valid),.ready(ready),.mem(mem));

  task reset(); begin 
    res=1;    
    wr_rd=0;
    addr=0;
    wdata=0;
    valid=0;
    @(posedge clk)
    res=0;
  end 
  endtask

  task writes(input reg [w:0] start,num); begin
    for(i=start;i<start+num;i=i+1) begin
      @(posedge clk)
      wr_rd=1;
      addr=i;
      wdata=d-i;
      valid=1;
      wait(ready==1);
    end
  end
  endtask

  task reads(input reg [w:0] start,num); begin
    for(i=start;i<start+num;i=i+1) begin
      @(posedge clk)
      wr_rd=0;
      addr=i;
      valid=1;
      wait(ready==1);
    end
  end
  endtask

  task operation(input reg [w:0] start,num); begin
    case(oper)
      
      "fd_wr_fd_rd": begin
        writes(start,num);
        reads(start,num);
      end
      
      "fd_wr_bd_rd": begin
        for(j=start;j<=d;j=j+1) begin
          writes(j,1);
          $writememh("output.hex", dut.mem);
        end
      end
      
      "bd_wr_bd_rd": begin
        $readmemb("input.bin", dut.mem);
        $writememb("output.bin", dut.mem);
      end
      
      "bd_wr_fd_rd": begin
        for(j=start;j<=d;j=j+1) begin
          $readmemh("input.hex", dut.mem);
          reads(j,1);
        end
      end
      
      "o_wr_rd": begin
        writes(start,1);
        reads(start,1);
      end
      
      "q_wr_rd": begin
        for(j=start;j<=d;j=j+(num/4)) begin
          writes(j,(num/4));
          reads(j,(num/4));
        end
      end
      
      "c_wr_rd": begin
        for(j=start;j<=d;j=j+1) begin
          writes(j,1);
          reads(j,1);
        end
      end
      
    endcase
  end
  endtask
  
  always #5 clk=~clk;

  initial begin
    clk=0;
    reset();
    $value$plusargs("TestCase=%s",oper);
    $value$plusargs("start=%d",start);
    $value$plusargs("num=%d",num);
    operation(start,num);
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #350 $finish;
  end
  
endmodule