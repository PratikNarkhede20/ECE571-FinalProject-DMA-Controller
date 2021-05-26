interface dmaInternalRegistersIf(input logic CLK, RESET);

  import dmaInternalRegistersPkg :: mode   ,
    dmaInternalRegistersPkg :: command,
    dmaInternalRegistersPkg :: mask   ,
    dmaInternalRegistersPkg :: request,
    dmaInternalRegistersPkg :: status ;

  modport PriorityEncoder(
    input CLK,
    input RESET,
    input command,
    input mask,
    input request
  );

  modport TimingControl(
    input CLK,
    input RESET
  );

  modport DataPath(
    input CLK,
    input RESET);

endinterface
