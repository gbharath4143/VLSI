module tb;
  integer n1;
  integer n2;
  integer n;
  wire integer n3;
  
  alu_op dut (.num1(n1),.num2(n2),.num3(n3),.op(n));
  initial begin
    n1=$urandom_range(1,10);
    n2=$urandom_range(1,10);
    n=$urandom_range(7,0);
    #10;
  end
endmodule