module memory(CLK, MEMR_N, MEMW_N, ADSTB, A0, A1, A2, A3, A4, A5, A6, A7, addressHB, DB);

  import dmaRegConfigPkg :: *; //wildcard import

  input logic CLK;
  input logic MEMW_N, MEMR_N;
  input logic ADSTB;
  input logic A0, A1, A2, A3, A4, A5, A6, A7;
  input logic [(ADDRESSWIDTH/2)-1:0]  addressHB;
  inout logic [DATAWIDTH-1:0] DB;

  logic [DATAWIDTH-1:0] dataOut;
  logic [DATAWIDTH-1:0] dataIn;
  logic [ADDRESSWIDTH-1:0] address;
  logic[DATAWIDTH-1:0] mem [10:0];

  assign DB = (!MEMR_N) ? dataOut : 'bz;

  always_comb
    begin
      if(ADSTB)
        address = {addressHB,A7,A6,A5,A4,A3,A2,A1,A0};
      else
        address='z;
    end

  //write operation
  always_ff@(posedge CLK)
    begin
      if(!MEMW_N)
        begin
        mem[address] <= DB;
          $strobe("datamem=%p",mem);
        end

       else
         mem[address] <= mem[address];
    end

     always_comb
       begin
         if(!MEMR_N)
           dataOut = mem[address];
         else
           dataOut = 'z;
       end
endmodule
