interface cpuInterfaceTesting(input logic CLK, RESET);

  import dmaRegConfigPkg :: *; //wildcard import

  logic                   IOR_N ;
  logic                   IOW_N ;

  logic                  MEMR_N;
  logic                  MEMW_N;
  logic                  READY ;
  logic                  HLDA  ;
  logic                  ADSTB ;
  logic                  AEN   ;
  logic                  HRQ   ;
  logic                  CS_N  ;
  logic [CHANNELS-1 : 0] DACK  ;
  logic [CHANNELS-1 : 0] DREQ  ;

  logic                   EOP_N ;
  logic                   A0    ;
  logic                   A1    ;
  logic                   A2    ;
  logic                   A3    ;

  logic                  A4    ;
  logic                  A5    ;
  logic                  A6    ;
  logic                  A7    ;
  logic [DATAWIDTH-1 : 0] DB    ;

  /*modport timingAndControl(
    input CLK,
    input RESET,
    input CS_N,
    input READY,

    inout EOP_N,
    inout IOR_N,
    inout IOW_N,

    output AEN,
    output ADSTB,
    output MEMR_N,
    output MEMW_N
  );*/

  modport priorityLogic(
    input DREQ,
    input HLDA,

    output HRQ,
    output DACK
  );

  modport dataPath(
    input CLK,
    input RESET,
    input CS_N,
    input IOR_N,
    input IOW_N,
    input DREQ,
    input DACK,
    input HLDA,

    input A0,
    input A1,
    input A2,
    input A3,
    input DB,

    output A4,
    output A5,
    output A6,
    output A7);


  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0);
    end
endinterface
