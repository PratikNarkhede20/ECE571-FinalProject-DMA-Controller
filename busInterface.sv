//`include "dmaRegConfigPkg.sv"
interface busInterface(input logic CLK, RESET);

  import dmaRegConfigPkg :: *; //wildcard import

  wire                   IOR_N ;
  wire                   IOW_N ;

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

  wire                   EOP_N ;

  wire                   A0    ;
  wire                   A1    ;
  wire                   A2    ;
  wire                   A3    ;

  logic                  A4    ;
  logic                  A5    ;
  logic                  A6    ;
  logic                  A7    ;
  wire [DATAWIDTH-1 : 0] DB    ;

  modport timingAndControl(
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
  );

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

    inout A0,
    inout A1,
    inout A2,
    inout A3,
    inout DB,

    output A4,
    output A5,
    output A6,
    output A7);

  modport cpu(
  input CLK,
  input RESET,
  input HRQ,
  output HLDA,
  output CS_N,
  output IOR_N,
  output IOW_N,
  output A3,
  output A2,
  output A1,
  output A0,
  output DB
  );

  modport memory(
  input CLK,
  input MEMR_N,
  input MEMW_N,
  input ADSTB,
  input A0,
  input A1,
  input A2,
  input A3,
  input A4,
  input A5,
  input A6,
  input A7,
  inout DB
  //input DB
  );

modport peripheral(
input CLK,
input RESET,
input IOR_N,
input IOW_N,
inout DB,
output DREQ,
input DACK
);



endinterface
