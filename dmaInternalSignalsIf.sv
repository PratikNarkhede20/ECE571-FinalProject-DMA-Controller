interface dmaInternalSignalsIf(input logic CLK, RESET);

  logic programCondition;
  logic loadAddr;

  logic assertDACK;
  logic deassertDACK;

  logic intEOP;
  logic updateCurrentWordCountReg;
  logic updateCurrentAddressReg;
  logic decrTemporaryWordCountReg;

  modport timingAndControl(
    output assertDACK,
    output deassertDACK,
    output intEOP,
    output loadAddr,
    output programCondition,
    output updateCurrentWordCountReg,
    output updateCurrentAddressReg,
    output decrTemporaryWordCountReg
  );

  modport priorityLogic(
    input assertDACK,
    input deassertDACK
  );

  modport dataPath(
    input intEOP,
    input loadAddr,
    input programCondition,
    input updateCurrentWordCountReg,
    input updateCurrentAddressReg
  );

endinterface
