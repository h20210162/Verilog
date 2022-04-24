`timescale 1ns / 1ps

module min_tb();
reg clk,rst;
wire [15:0]irf,ire,a,b,t1,t2,edb,ao,di,do;
wire [3:0]pc;
min dut(clk,rst,pc,irf,ire,a,b,t1,t2,edb,ao,di,do);

initial begin
rst=1'b1;#5 rst=1'b0;
clk=1'b0;
forever #50 clk=~clk;
end
endmodule

