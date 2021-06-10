`include "dma.sv"
`include "busInterface.sv"
module environment(CLK, RESET, cmdData,
modeData, baseAddrLB, baseChannelAddrLW,
baseAddrHB, baseChannelAddrHB, baseWordLB,
baseChannelWordLB, baseWordHB, baseChannelWordHB, inreq);

  import dmaRegConfigPkg :: *; //wildcard import

  input logic CLK;
  input logic RESET;
  input logic [DATAWIDTH-1:0] cmdData;
  input logic [DATAWIDTH-1:0] modeData;
  input logic [(ADDRESSWIDTH/2)-1:0] baseAddrLB;
  input logic [REGISTERADDRESS-1:0] baseChannelAddrLW;
  input logic [(ADDRESSWIDTH/2)-1:0] baseAddrHB;
  input logic [REGISTERADDRESS-1:0] baseChannelAddrHB;
  input logic [(ADDRESSWIDTH/2)-1:0]baseWordLB;
  input logic [REGISTERADDRESS-1:0] baseChannelWordLB;
  input logic [(ADDRESSWIDTH/2)-1:0] baseWordHB;
  input logic [REGISTERADDRESS-1:0] baseChannelWordHB;
  input logic inreq [PERIPHERALS-1 : 0];

  genvar i;


  busInterface busIf (CLK, RESET);

  dma DMA(busIf);

  cpu processor(busIf.cpu, cmdData,
  modeData, baseAddrLB, baseChannelAddrLW,
  baseAddrHB, baseChannelAddrHB, baseWordLB,
  baseChannelWordLB, baseWordHB, baseChannelWordHB,
  DMA.intSigIf.intEOP);

  memory mem(busIf.memory);

  generate
    for(i=0; i < PERIPHERALS; i++)
      begin
        peripheral #(i) p1(busIf.peripheral, DMA.intSigIf.intEOP, inreq[i]);
      end
  endgenerate

endmodule
