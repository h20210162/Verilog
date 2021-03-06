

//     VEMPARALA SAI KUMAR : 2021H1400155P    //

//     RANGU SUHAS RAHUL   : 2021H1400162P    //




//            IBWT            //


module sort_basic(charac, num2, dataout, dataout4, we, addr, clk, addr6, done6);
input [7:0] charac;
input [9:0] num2;
input [9:0] addr;
input we;
input clk;
output [7:0] dataout, dataout4;
output [9:0] addr6;
output done6;
reg [7:0] dataout, dataout2, dataout3, dataout4;
wire we;
wire clk;
wire [9:0] addr;
reg [7:0] RAMM [0:1023];
reg [7:0] RAMM_sort [0:1023];
reg [7:0] RAMM_req [0:1023];
reg [9:0] RAMM_index [0:1023];
wire [9:0] num2;
reg [9:0] addr2, addr3, addr4, addr5, addr6, temp_suff;
reg [7:0] temp, tempo;
reg done1, done2, done3, done4, donee, done5, done6;
always @ (posedge clk)
begin
if (we==1'b1)
begin
if (addr==10'b0) begin done2 = 1'b0; done3 = 1'b0;  donee = 1'b0;  done4 = 1'b0; done5 =1'b0; done6 =1'b0; end
RAMM[addr] = charac;
RAMM_sort[addr] = charac;
RAMM_index[addr] = addr;
if (addr==10'b0000000000) begin    done1 = 1'b1;  addr2=(num2-1); addr3=10'b0000000000;  end
end
else if (we == 1'b0)
begin

if((done1 == 1'b1)&&(addr2 >= 0))
begin

if (RAMM_sort[addr3] > RAMM_sort[addr3+1])
begin
temp = RAMM_sort[addr3];
temp_suff = RAMM_index[addr3];
RAMM_sort[addr3] = RAMM_sort[addr3+1];
RAMM_index[addr3] = RAMM_index[addr3+1];
RAMM_sort[addr3+1] = temp;
RAMM_index[addr3+1] = temp_suff;
end
addr3 = addr3+1;
if (addr3 == (num2))   begin    addr2 = addr2 - 1;  done4 = 1'b1; addr3=10'b0000000000;  end
if ((addr2 == 10'b0000000000)&&(done4==1))   begin     donee = 1'b1;    addr4 = 10'b0000000000; done1 = 1'b0 ; end
end

dataout = RAMM[addr];

if ((donee==1'b1)&&(addr4 < num2))
begin
dataout2 = RAMM_sort[addr4];
dataout3 = RAMM_index[addr4];
addr4 = addr4 +1;
if(addr4 == num2)   begin   done5 = 1'b1;  addr5 = 10'b0000000000; end
end

if(addr5 == 10'b0000000000) begin     tempo = RAMM_index[0];     end
if((done5 == 1'b1)&&(addr5 < num2))
begin
RAMM_req[addr5] = RAMM_sort[tempo];
tempo = RAMM_index[tempo];
addr5 = addr5 +1;
if(addr5 == num2)     begin   done6 = 1'b1;   addr6 = 10'b0000000000;  end
end

if ((done6==1'b1)&&(addr6 < num2))
begin
dataout4 = RAMM_req[addr6];
addr6 = addr6 +1;
end

end
end
endmodule

`timescale 1ns / 1ps
module sort_tb();
reg [8*1024-1:0] str;
reg [7:0] charac, tempee;
reg clk;
integer fd, fd2; 
integer j, i;
reg [9:0] num2, count;
reg [7:0] iibwt [0:1023];
reg we;
wire [7:0] dataout, dataout4;
reg [9:0] addr;
wire done6;
wire [9:0] addr6;
sort_basic DUT (charac, num2, dataout, dataout4, we, addr, clk, addr6, done6);

initial
begin
clk = 1'b0;
end
always #1 clk = ~clk; 

initial 
begin  
count = 10'b0000000000;
j = 0;
fd = $fopen("C:\\Users\\BlacQuine\\Desktop\\BITS\\BITS Sem_1\\General\\Homeworks and assignments\\RC\\assignment_2\\strrr_ibwt.txt", "r");  
while (! $feof (fd)) 
begin    
$fgets(str, fd);  
$display("%0s", str);  
end  
$fclose(fd);  
$display ("%s %h %b %d",str,str,str,str);
num2 = 10'b0000000000;
for (j=0; str[j+:7] != 8'b00000000; j = j+8) begin num2 = num2+10'b0000000001; end
$display ("%d ", num2);
$display ("%d ", j);

we = 1'b1;
#2 addr = num2-1;
for (i=0; i<j; i=i+8)
begin
charac = str[i+:7];
#2 $display ("%s %h", charac, addr);
addr = addr -1;
end

we=1'b0;
addr=10'b0000000000;
for (i=0; i<=num2; i=i+1)
begin
$display ("%d   %s  ",addr,  dataout);
#2 addr = addr +1;
end

while(done6 == 1'b0)     begin    #2 count = count +1;         end


fd2 = $fopen("C:\\Users\\BlacQuine\\Desktop\\BITS\\BITS Sem_1\\General\\Homeworks and assignments\\RC\\assignment_2\\strrr_write_ibwt_new.txt", "w");
if (done6 == 1'b1)
begin
for (i=0; i<num2; i=i+1)
begin
iibwt[addr6-1] = dataout4;
$fwrite(fd2,"%s",dataout4);
tempee = dataout4;
$display ("count %d %d %s",count, addr6, dataout4);
#2 count = count + 1;

end
end
$fclose(fd2);
end  
endmodule

//     BWT    //

`timescale 1ns / 1ps

module BWT(clk,rst,str,d1,n);

input clk,rst;
output reg [7:0]d1;
output reg [9:0]n;
reg [9:0]k;
input [(1024*8)-1:0]str;

reg [7:0] RAM[1023:0];
reg [7:0] RAM_sort[1023:0];
reg [7:0] RAM_bwt[1023:0];
reg [9:0] sa[1023:0];
reg [9:0] sa_sort[1023:0];
reg [9:0] sa_sort_bwt[1023:0];
reg [7:0] t1;
reg [9:0] t2;
reg [9:0] addr; 
integer i,j,a,b,c,p,q,r,x,y,z,u,v;



always@(posedge clk or negedge rst)
begin
if(rst)
    begin
    n=10'b0;
    i=0;
    a=0;
    end
else
    begin   
      if(a==0)
      begin
         if(str[i+:8]!=0)
         begin            
         n=n+1;
         RAM[i/8]=str[i+:8];
         RAM_sort[i/8]=str[i+:8];         
         sa[i/8]=i/8;
         sa_sort[i/8]=i/8;
         sa_sort_bwt[i/8]=i/8;
         i=i+8;
         end
         else
         begin
         a=1;
         k=n-1; 
         p=n-1;                
         j=0;
         q=0;
         x=0;
         r=0;
         y=0;
         z=1500;
         u=0;
         y=0;
         end
     end       
      
      if (j>=0 && j<=k && k<=(n-1) && k>=0 && a==1 && y==0)
      begin 
            if (RAM_sort[j] > RAM_sort[j+1])        
            begin 
              t1 = RAM_sort[j];
              t2 = sa_sort[j];
              RAM_sort[j] = RAM_sort[j+1];
              sa_sort[j] = sa_sort[j+1];
              sa_sort_bwt[j]=sa_sort[j];
              RAM_sort[j+1] = t1;
              sa_sort[j+1] = t2;  
              sa_sort_bwt[j+1]=sa_sort[j+1];         
            end             
            else begin end
         j=j+1;            
       end
        
      else
      begin
            if(k!=0)
            begin
            k=k-1;
            j=0;
            end
            else
            begin
            y=1'b1;
            end     
      end     
      
    if(k==0)
    begin 
    
           sa_sort_bwt[p]=sa_sort[p]+1;
           RAM_bwt[p]=RAM[sa_sort_bwt[p]];
           
           if(sa_sort[p]==(n-1))
           begin
              sa_sort_bwt[n-1]=0;
              RAM_bwt[p]=RAM[0];
           end
 
        if( (RAM_sort[p] == RAM_sort[p-1]) && p<=(n-1) && p>=0 && x>=0 && x<=p)
          begin 

             q=sa_sort[p]-1;
             r=sa_sort[p-1]-1;

              if(RAM[q] < RAM[r])
                begin

                 t1 = RAM_sort[p-1];
                 t2 = sa_sort[p-1];
                 RAM_sort[p-1] = RAM_sort[p];
                 sa_sort[p-1] = sa_sort[p];
                 sa_sort_bwt[p-1]=sa_sort[p-1];
                 RAM_sort[p] = t1;
                 sa_sort[p] = t2;
                 sa_sort_bwt[p]=sa_sort[p];
                end
              else
              begin
              end
         x=x+1; 
         end      
         
        else
        begin
            if(p!=0)
            begin
            p=p-1; 
            x=0;
            end
            else
            begin
            p=n-1;
            end
        end
   
       end
 
     end 
       
  end

endmodule


//      TESTBENCH    //


`timescale 1ns / 1ps
module Tb();
reg clk,rst,set,S;
reg [(1024*8)-1:0]x,yy;
wire [9:0]y;
integer fd;
Length_str A (.clk(clk),.rst(rst),.str(yy),.N(y));
BWT B(.clk(clk),.rst(rst),.set(set),.str(yy));

initial begin
rst<=1'b1;
#2 rst<=1'b0;
end


initial begin
clk<=1'b0;
forever #2 clk=~clk;
end
initial 
begin 
fd = $fopen("C:\\Users\\BlacQuine\\Desktop\\BITS\\BITS Sem_1\\General\\Homeworks and assignments\\RC\\assignment_2\\string.txt","r");  
while (! $feof (fd)) 
begin    
$fgets(x, fd);  
$display("string x is %0s",x);  
end  
$fclose(fd);
yy = x;
$display("string yy is %0s",yy);
end
endmodule
