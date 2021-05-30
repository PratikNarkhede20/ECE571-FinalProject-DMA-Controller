interface dmaInternalSignalsIf(input CLK, RESET)

  logic ProgramCondition = 1'b0;
  logic LoadAddr;

  logic HLDA;
  logic HRQ;
  logic AssertDACK;
  logic DeassertDACK;
  logic DREQ0, DREQ1, DREQ2, DREQ3;

  logic intEOP;


endinterface
