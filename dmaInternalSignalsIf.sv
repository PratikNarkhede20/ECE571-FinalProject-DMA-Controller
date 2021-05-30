interface dmaInternalSignalsIf;

  logic ProgramCondition;
  logic LoadAddr;

  logic AssertDACK;
  logic DeassertDACK;

  logic intEOP;

  modport TimingControl(
    output AssertDACK,
    output DeassertDACK,
    output intEOP,
    output LoadAddr,
    output ProgramCondition
  );

  modport PriorityLogic(
    input AssertDACK,
    input DeassertDACK,
  );

  modport DataPath(
    input intEOP,
    input LoadAddr,
    input ProgramCondition,
  );

endinterface
