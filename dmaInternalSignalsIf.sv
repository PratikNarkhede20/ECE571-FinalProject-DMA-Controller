interface dmaInternalSignalsIf(input CLK, RESET)

  logic ProgramCondition = 1'b0; //INTERNAL SIGNAL
  logic HLDA; //INTERNAL SIGNAL
  logic HRQ; //INTERNAL SIGNAL
  logic LoadAddr; //INTERNAL SIGNAL
  logic LoadDACK; //INTERNAL SIGNAL
  logic DREQ0, DREQ1, DREQ2, DREQ3; //INTERNAL SIGNAL
  logic intEOP; //INTERNAL SIGNAL

  
endinterface
