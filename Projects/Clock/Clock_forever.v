module tb();
  reg clk;
  initial begin
    clk=0;
    forever begin
      #1 clk=~clk;
      $display(clk);
    end
    $finish;
  end
endmodule