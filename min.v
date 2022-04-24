`timescale 1ns / 1ps

module min(clk,rst,pc,irf,ire,a,b,t1,t2,edb,ao,di,do);
input clk,rst;
output reg [3:0]pc;
output reg [15:0]irf,ire,a,b,t1,t2,edb,ao,do,di;
reg [15:0]bits;

reg z;
reg [5:0]inst;
reg [3:0]rx;
reg [1:0]am,ty;
reg [3:0]ry;
reg [15:0]temp;
reg [5:0]opera;
wire [15:0]t11;
reg zflag;
reg [15:0]r0,r1,r2,r3,r7,r8,r9,r10,r12,r13,r14,r15;
reg [4:0]state;
reg [15:0]R[0:15];
reg [15:0]tmp;

integer i;

parameter ib=2'b00,db=2'b01,sb=2'b10,bc=2'b11, abdm1=5'b00001, abdm2=5'b00010, abdm3=5'b00011,
abdm4=5'b00100, adrm1=5'b00101, oprr1=5'b00110, oprr2=5'b00111, ldrr1=5'b01000, ldrm2=5'b01001, strr1=5'b01010,
brzz1=5'b01011, brzz2=5'b01100, brzz3=5'b01101, ldrm1=5'b01110, oprm1=5'b01111, oprm2=5'b10000, strm1=5'b10001,
test1=5'b10010, popr1=5'b10011, popr2=5'b10100, push1=5'b10101, push2=5'b10110,

ADDO=6'b00000, SUBO=6'b000001,
ANDO=6'b000010, NANDO=6'b000011, ORO=6'b000100, NORO=6'b000101, XORO=6'b000110, XNORO=6'b000111;

initial
    begin                                      // storing instruction data into memory
    MEM(5'd0,16'h4497,1'b1,1'b0,bits); 
    MEM(5'd0,16'h4497,1'b0,1'b1,bits);
    MEM(5'd1,16'h0047,1'b1,1'b0,bits);
    MEM(5'd2,16'h44D7,1'b1,1'b0,bits);
    MEM(5'd3,16'h248F,1'b1,1'b0,bits);
    MEM(5'd4,16'h24CF,1'b1,1'b0,bits);
    MEM(5'd5,16'h04E8,1'b1,1'b0,bits);
    MEM(5'd6,16'h0001,1'b1,1'b0,bits);
    MEM(5'd7,16'h6419,1'b1,1'b0,bits);
    MEM(5'd8,16'h601A,1'b1,1'b0,bits);
    MEM(5'd9,16'h0047,1'b1,1'b0,bits);
    MEM(5'd10,16'h234F,1'b1,1'b0,bits);
    MEM(5'd11,16'h230F,1'b1,1'b0,bits);
    MEM(5'd12,16'h188C,1'b1,1'b0,bits);
    MEM(5'd13,16'h1CCD,1'b1,1'b0,bits);
    MEM(5'd14,16'h08C2,1'b1,1'b0,bits);
    MEM(5'd15,16'h1083,1'b1,1'b0,bits);

    end

always @(posedge clk or posedge rst)
begin
if(rst)
begin
pc = 4'b0000;                               // initialization of registers and storing in programmers register bank
r0 = 16'h0000;
R[0]=r0;
r1 = 16'h0001;
R[1]=r1;
r2 = 16'hAAAA;
R[2]=r2;
r3 = 16'h5555;
R[3]=r3;
r7 = 16'h0010;
R[7]=r7;
r8 = 16'h0010;
R[8]=r8;
r9 = 16'h0011;
R[9]=r9;
r10 = 16'h000A;
R[10]=r10;
R[12]=r12;
R[13]=r13;
r15 = 16'h001F;
R[15]=r15;
irf = bits;
pc = pc + 1'b1;
ire = irf;
inst = ire[15:10];
rx = ire[9:6];
am = ire[5:4];
ry = ire[3:0];
state = ib;
t1 = t11;
end

else
begin

case(state)

ib : begin
rx = ire[9:6];
am = ire[5:4];
ry = ire[3:0];
$display(" {ib}    ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	

$display("Registers\n %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h ",R[0],R[1],R[2],R[3],R[4],R[5],R[6],R[7],R[8],R[9],R[10],R[11],R[12],R[13],R[14],R[15]);

case(ire[5:4])
2'b00:                                            // Address Mode Sequence operation calculation
    begin
 	if (ire[15:13] == 3'b000) begin 
 	state = oprr1;  end 
 	else if (ire[15:13] == 3'b001) begin          // Instruction Decoder for different operation depending on Address mode sequence        
                                      	if (ire[12:10] == 3'b000)
                                      	begin
                                      	state = popr1;
                                      	end
                                      	else if (ire[12:10] == 3'b001)
                                      	begin
                                      	state = push1;
                                      	end  
                                	end
 	else if (ire[15:13] == 3'b010) begin
                                      	if (ire[12:10] == 3'b000)
                                      	begin
                                      	state = ldrr1;
                                      	end
                                      	else if (ire[12:10] == 3'b001)
                                      	begin
                                      	state = strr1;
                                      	end  
                                	end
 	else if (ire[15:13] == 3'b011) begin state = brzz1;  end
 	ty=ib;
    $display(" {ar}    ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	 	
 	end
2'b01:	 
    begin
 	state = adrm1;
 	ty=ib;
    $display(" {ai}    ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	
    end
2'b10:
    begin
 	state = abdm1;
 	ty=ib;
    $display(" {ab}    ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	
    end
endcase
end
    	oprr1:
        	begin
        	a = R[rx];
        	b = R[ry];
        	if(ire[12:10]==3'b000) begin opera = ADDO;  end         // next state calculation of ALU operation
        	else if(ire[12:10]==3'b001) begin opera = SUBO;  end
        	else if(ire[12:10]==3'b010) begin opera = ANDO;  end
        	else if(ire[12:10]==3'b011) begin opera = NANDO;  end
        	else if(ire[12:10]==3'b100) begin opera = ORO;  end
        	else if(ire[12:10]==3'b101) begin opera = NORO;  end
        	else if(ire[12:10]==3'b110) begin opera = XORO;  end
        	else if(ire[12:10]==3'b111) begin opera = XNORO;  end
        	alu_main (a, b, opera, zflag, t1);
        	state = oprr2;
        	ty = db;
        	$display(" {oprr1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
    	oprr2:
        	begin
        	a=pc;
        	ao=a;
        	MEM(ao,do,1'b0,1'b1,edb);  
        	b=t1;
        	R[ry]=b;	 
        	alu_main (a, 1'b1, ADDO, zflag, t1);
        	irf=edb;
        	state = brzz2;
        	ty = db;
        	$display(" {oprr2} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
   	 
    	abdm1:
        	begin       	
        	a=pc;
        	ao=a;
        	alu_main (a, 1'b1, ADDO, zflag, t1);
        	MEM(ao,do,1'b0,1'b1,edb);
        	di=edb;
        	state = abdm2;
        	ty = db;
        	$display(" {abdm1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
    	abdm2:
        	begin
        	a=t1;
        	pc=a;
        	state = abdm3;
        	ty = db;
        	$display(" {abdm2} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
    	abdm3:
        	begin
        	b=di;
        	a=R[ry];
        	alu_main (a, b, ADDO, zflag, t1);
        	state = abdm4;
        	ty = db;
        	$display(" {abdm3} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	                	
        	end
    	abdm4:
        	begin
        	a=t1;
        	ao=a;
        	t2=a;
        	MEM(ao,do,1'b0,1'b1,edb);
        	di=edb;
        	if (ire[15:13] == 3'b000) begin state = oprm1;  end      // Execution Mode Sequencing for next state logic
        	else if (ire[15:13]==3'b010) begin
                                        	if (ire[12:10] == 3'b000)
                                        	begin
                                        	state = ldrm1;
                                        	end
                                        	else if (ire[12:10] == 3'b001)
                                        	begin
                                        	state = strm1;
                                        	end  
                                       	end
        	else if (ire[15:13]==3'b011) begin 
        	                                if (ire[12:10] == 3'b000)
                                        	begin
                                        	state = brzz1;
                                        	end
                                        	else if (ire[12:10] == 3'b001)
                                        	begin
                                        	state = test1;
                                        	end  
        	                             end
            ty = sb;
        	$display(" {abdm4} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	                    	                             
        	end
    	adrm1:
        	begin
        	b=R[ry];
        	ao=b;
        	t2=b;
        	MEM(ao,do,1'b0,1'b1,edb);
        	di=edb;
        	if (ire[15:13] == 3'b000) begin state = oprm1;  end      // Execution Mode Sequencing for next state logic
        	else if (ire[15:13]==3'b010) begin
                                        	if (ire[12:10] == 3'b000)
                                        	begin
                                        	state = ldrm1;
                                        	end
                                        	else if (ire[12:10] == 3'b001)
                                        	begin
                                        	state = strm1;
                                        	end  
                                     	 end
        	else if (ire[15:13]==3'b011) begin        	                                 
        	                                if (ire[12:10] == 3'b000)
                                        	begin
                                        	state = brzz1;
                                        	end
                                        	else if (ire[12:10] == 3'b001)
                                        	begin
                                        	state = test1;
                                        	end  
        	                             end
            ty = sb; 
        	$display(" {adrm1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	                   	                             
           end
    	brzz1:
        	begin
        	z = zflag;
        	a=R[ry];
        	ao=a;
        	alu_main (a, 1'b1, ADDO, zflag, t1);
        	MEM(ao,do,1'b0,1'b1,edb);
        	irf=edb;
        	ty = bc;
        	if(z==1)
        	begin 
        	state = brzz2;
        	$display(" {brzz1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
        	else
        	state = brzz3;
        	$display(" {brzz1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end  	 
    	brzz2:
        	begin
        	ire=irf;
        	b=t1;
        	pc=b;
        	state = ib;
        	ty = ib;
        	$display(" {brzz2} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
    	brzz3:
        	begin
        	a=pc;
        	ao=a;
        	alu_main (a, 1'b1, ADDO, zflag, t1);
        	MEM(ao,do,1'b0,1'b1,edb);
        	irf=edb;
        	state = brzz2;
        	ty = db;
        	$display(" {brzz3} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
    	ldrm1:
        	begin
        	a=pc;
        	ao=a;
        	MEM(ao,do,1'b0,1'b1,edb);
        	irf=edb;
        	alu_main (a, 1'b1, ADDO, zflag, t1);
        	b=di;
        	R[rx]=b;
        	t2=b;
        	state = ldrm2;
        	ty = db;
        	$display(" {ldrm1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
    	ldrm2:
        	begin
        	b=t1;
        	pc=b;
        	ire=irf;
        	a=t2;
        	alu_main (a, 1'b0, ADDO, zflag, t1);
        	state = ib;
        	ty = ib;
        	$display(" {ldrm2} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
    	strm1:
        	begin
        	a=R[rx];
        	alu_main (a, 1'b0, ADDO, zflag, t1);
        	do=a;
        	b=t2;
        	ao=b;
        	MEM(ao,do,1'b1,1'b0,edb);
        	state = brzz3;
        	ty = db;
        	$display(" {strm1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
    	test1:
        	begin
        	b=di;
        	t2=b;
        	a=pc;
        	ao=a;
        	alu_main (a, 1'b1, ADDO, zflag, t1);
        	MEM(ao,do,1'b0,1'b1,edb);
        	irf=edb;
        	state = ldrm2;
        	ty = db;
        	$display(" {test1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
    	oprm1:
        	begin
        	b=di;
        	a=R[rx];
        	if(ire[12:10]==3'b000) begin opera = ADDO;  end           // next state calculation of ALU operation
        	else if(ire[12:10]==3'b001) begin opera = SUBO;  end
        	else if(ire[12:10]==3'b010) begin opera = ANDO;  end
        	else if(ire[12:10]==3'b011) begin opera = NANDO;  end
        	else if(ire[12:10]==3'b100) begin opera = ORO;  end
        	else if(ire[12:10]==3'b101) begin opera = NORO;  end
        	else if(ire[12:10]==3'b110) begin opera = XORO;  end
        	else if(ire[12:10]==3'b111) begin opera = XNORO;  end
        	alu_main (a, b, opera, zflag, t1);
        	state = oprm2;
        	ty = db;
        	$display(" {oprm1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
    	oprm2:
        	begin
        	a=t1;
        	do=a;
        	b=t2;
        	ao=b;
        	MEM(ao,do,1'b1,1'b0,edb);
        	MEM(ao,do,1'b0,1'b1,temp);        	
        	state = brzz3;
        	ty = db;
        	$display(" {oprm2} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
     	ldrr1:
        	begin
        	a=pc;
        	ao=a;
        	alu_main (a, 1'b1, ADDO, zflag, t1);
        	MEM(ao,do,1'b0,1'b1,edb);
        	irf=edb;
        	b=R[ry];
        	R[rx]=b;
        	t2=b;
        	state = ldrm2;
        	ty = db;
        	$display(" {ldrr1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
     	strr1:
        	begin
        	a=pc;
        	ao=a;
        	alu_main (a, 1'b1, ADDO, zflag, t1);
        	MEM(ao,do,1'b0,1'b1,edb);
        	irf=edb;
        	b=R[rx];
        	R[ry]=b;
        	R[ry]=t2;
        	state = ldrm2;
        	ty = db;
        	$display(" {strr1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	        	
        	end
     	popr1:
        	begin
        	a=R[ry];
        	ao=a;
        	alu_main (a, 1'b1, ADDO, zflag, t1);
        	MEM(ao,do,1'b0,1'b1,edb);
        	di=edb;
        	state = popr2;
        	ty = db;
        	$display(" {popr1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	
        	end
     	popr2:
        	begin
        	a=t1;
        	R[ry]=a;
        	b=di;
        	R[rx]=b;
        	state = brzz3;
        	ty = db;
        	$display(" {popr2} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	        	
        	end
     	push1:
        	begin
        	a=R[ry];
        	alu_main (a, 1'b1, SUBO, zflag, t1);
        	state = push2;
        	ty = db;
        	$display(" {push1} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	
        	end
     	push2:
        	begin
        	a=R[rx];
        	do=a;
        	b=t1;
        	ao=b;
        	MEM(ao,do,1'b1,1'b0,edb);
        	R[ry]=b;
        	state = brzz3;
        	ty = db;
        	$display(" {push2} ty=%b, a = %h, ao = %h, irf= %h, ire=%h, edb = %h, b=%h, R[ry]=%h, R[rx]=%h, t2=%h, pc=%h, t1=%h",ty,a,ao,irf,ire,edb,b,R[ry],R[rx],t2,pc,t1);        	        	
        	end
                                      	 
    	endcase
end
end



////////////////////////////////////////////////////////
//                     ALU task                       //
////////////////////////////////////////////////////////


task alu_main(input [15:0]abus, bbus, input [5:0]opintr, output reg zf, output reg [15:0]t1);
begin
case (opintr)
6'b000000 :  begin  
    		 t1 = (abus + bbus);
    		 end
6'b000001 :  begin  
    		 t1 = (abus - bbus);
    		 end
6'b000010 :  begin  
    		 t1 = (abus & bbus);
    		 end
6'b000011 :  begin  
    		 t1 = ~(abus & bbus);
    		 end
6'b000100 :  begin  
    		 t1 = (abus | bbus);
    		 end
6'b000101 :  begin  
    		 t1 = ~(abus | bbus);
    		 end
6'b000110 :  begin  
    		 t1 = (abus ^ bbus);
    		 end
6'b000111 :  begin  
    		 t1 = ~(abus ^ bbus);
    		 end
default   :  begin  
    		 t1 = ~(abus ^ bbus);
    		 end
endcase
if (t1 == 16'h0000)   begin    zf = 1'b1;    end
else if (t1 != 16'h0000)   begin    zf = 1'b0;    end
end
endtask



////////////////////////////////////////////////////////
//                     Memory task                    //
////////////////////////////////////////////////////////


task MEM(input [4:0]Addr,input [15:0]data_in,input Wen,Ren,output [15:0]data_out);
    reg [15:0]memory[31:0];
    integer i;
    begin
        if(Wen)
            memory[Addr]=data_in;
        if(Ren)
            begin
            data_out=memory[Addr];
            if(Addr>5'd15)
            $display("Memory(data)\n %h %h %h %h %h %h %h %h \n Stack\n %h %h %h %h %h %h %h %h",memory[16],memory[17],memory[18],memory[19],memory[20],memory[21],memory[22],memory[23],memory[24],memory[25],memory[26],memory[27],memory[28],memory[29],memory[30],memory[31]);
            end
    end
endtask
endmodule