module alu_op(
  input integer num1,
  input integer num2,
  output integer num3,
  input integer op);
  function integer af(input integer a,b,input integer op);begin
    case(op)
          0: af=a+b;
          1: af=a-b;
          2: af=a*b;
          3: af=a/b;
          4: af=a%b;
          5: af=a**b;
          6: af=a>>b;
          7: af=a<<b;
            default: af=0;
      	endcase
  	end
  endfunction
  always @(*) begin
    num3=af(num1,num2,op);
    $display("num1=%0d,num2=%0d,num3=%0d,op=%0d",num1,num2,num3,op);
  end
endmodule