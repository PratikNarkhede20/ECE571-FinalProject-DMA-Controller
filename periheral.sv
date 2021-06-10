`include "memory.sv"
module peripheral(CLK, RESET, intEOP, IOR_N, IOW_N, DB, inreq, DREQ, DACK);
  parameter ID=0;

  import dmaRegConfigPkg :: *; //wildcard import

  input logic CLK;
  input logic RESET;
  input logic inreq;
  input logic intEOP;
  input logic IOR_N;
  input logic IOW_N;
  input logic DACK;
  inout logic [DATAWIDTH-1:0] DB;
  output logic DREQ;

  logic [ DATAWIDTH-1:0] dataOut;

  assign DB = (!IOR_N && DACK) ? dataOut : 'bz;
  logic [ADDRESSWIDTH-1:0] address;
  //need a flag/input to generate DREQ

  logic[DATAWIDTH-1:0] mem [10:0];
  logic[DATAWIDTH-1:0] temp [10:0];

  //addresss generation
  assign DREQ = (inreq) ? 1'b1 : 1'b0;

  always_comb
    begin
      if(!IOW_N || !IOR_N)
        address =$urandom_range(4,6);
    end
  //write operation
  always_ff@(posedge CLK)
    begin
      if(!IOW_N && DACK)
        begin

        mem[address] <= DB;
          $strobe("IOMEM%0d = %p",ID,mem);
        end

       else
         mem[address] <= mem[address];
    end

     always_comb
       begin
         if(!IOR_N && DACK)
           dataOut = mem[address];
         else
           dataOut ='z;
       end

endmodule
