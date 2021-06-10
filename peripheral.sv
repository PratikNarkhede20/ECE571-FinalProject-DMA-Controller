`include "memory.sv"
module peripheral(busInterface.peripheral per,
  input logic intEOP,
  input logic inreq);
  parameter ID=0;

  import dmaRegConfigPkg :: *; //wildcard import

  //input logic CLK;
  //input logic RESET;
  /*input logic inreq;
  input logic intEOP;
  input logic IOR_N;
  input logic IOW_N;
  input logic DACK;
  inout logic [DATAWIDTH-1:0] DB;
  output logic DREQ;*/

  logic [ DATAWIDTH-1:0] dataOut;

  assign per.DB = (!per.IOR_N && per.DACK) ? dataOut : 'bz;
  logic [ADDRESSWIDTH-1:0] address;
  //need a flag/input to generate DREQ

  logic[DATAWIDTH-1:0] mem [10:0];
  logic[DATAWIDTH-1:0] temp [10:0];

  //addresss generation
  assign per.DREQ[ID] = (inreq) ? 1'b1 : 1'b0;

  always_comb
    begin
      if(!per.IOW_N || !per.IOR_N)
        address =$urandom_range(4,6);
    end
  //write operation
  always_ff@(posedge per.CLK)
    begin
      if(!per.IOW_N && per.DACK)
        begin

        mem[address] <= per.DB;
          $strobe("IOMEM%0d = %p",ID,mem);
        end

       else
         mem[address] <= mem[address];
    end

     always_comb
       begin
         if(!per.IOR_N && per.DACK)
           dataOut = mem[address];
         else
           dataOut ='z;
       end

endmodule
