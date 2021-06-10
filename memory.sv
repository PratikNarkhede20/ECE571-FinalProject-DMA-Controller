module memory(clk,memR_N, memW_N, address, data);
  parameter ADDRESSWIDTH=16;
  parameter DATAWIDTH=8;
  input logic clk;
  input logic memW_N, memR_N;
  input logic [ADDRESSWIDTH-1:0]  address;
  inout logic [DATAWIDTH-1:0] data;

  logic [DATAWIDTH-1:0] dataOut;
  logic [DATAWIDTH-1:0] dataIn;

  logic[DATAWIDTH-1:0] mem [10:0];

  assign data = (!memR_N) ? dataOut : 'bz;

  //write operation
  always_ff@(posedge clk)
    begin
      if(!memW_N)
        begin
        mem[address] <= data;
          $strobe("datamem=%p",mem);
        end

       else
         mem[address] <= mem[address];
    end

     always_comb
       begin
         if(!memR_N)
           dataOut = mem[address];
         else
           dataOut = 'z;
       end
endmodule
