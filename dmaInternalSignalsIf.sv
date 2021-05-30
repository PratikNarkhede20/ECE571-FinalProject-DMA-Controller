interface dmaInternalSignalsIf(input CLK, RESET)

  logic ProgramCondition = 1'b0;
  logic LoadAddr;

  logic AssertDACK;
  logic DeassertDACK;

  logic intEOP;

  modport TimingControl(
    output AssertDACK,
    output DeassertDACK
  );

  modport PriorityLogic(
    input AssertDACK,
    input DeassertDACK,
  );


endinterface
