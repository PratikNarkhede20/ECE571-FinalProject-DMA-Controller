module memory(busInterface.memory memory);


  import dmaRegConfigPkg :: *; //wildcard import

  //input logic CLK;
  //input logic MEMW_N, MEMR_N;
  //input logic ADSTB;
  //input logic A0, A1, A2, A3, A4, A5, A6, A7;
  //inout logic [DATAWIDTH-1:0] DB;

  logic [(ADDRESSWIDTH/2)-1:0]  addressHB;
  logic [DATAWIDTH-1:0] dataOut;
  logic [DATAWIDTH-1:0] dataIn;
  logic [ADDRESSWIDTH-1:0] address;
  logic[DATAWIDTH-1:0] mem [10:0];

  assign memory.DB = (!memory.MEMR_N) ? dataOut : 'bz;
  assign addressHB= memory.DB;

  always_comb
    begin
      if(memory.ADSTB)
        address = {addressHB,memory.A7,memory.A6,memory.A5,memory.A4,memory.A3,memory.A2,memory.A1,memory.A0};
      else
        address='z;
    end

  //write operation
  always_ff@(posedge memory.CLK)
    begin
      if(!memory.MEMW_N)
        begin
        mem[address] <= memory.DB;
          $strobe("datamem=%p",mem);
        end

       else
         mem[address] <= mem[address];
    end

     always_comb
       begin
         if(!memory.MEMR_N)
           dataOut = mem[address];
         else
           dataOut = 'z;
       end
endmodule
