interface CPUinterface(input CLK, RESET);

  logic 		IOR_N  ;
  logic 		IOW_N  ;
  logic 		MEMR_N ;
  logic 		MEMW_N ;
  logic 		READY  ;
  logic 		HLDA   ;
  logic 		ADSTB  ;
  logic 		AEN    ;
  logic 		HRQ    ;
  logic 		CS_N   ; 
  logic 		DACK0  ;
  logic 		DACK1  ;
  logic 		DACK2  ;
  logic 		DACK3  ;
  logic 		DREQ0  ;
  logic 		DREQ1  ;
  logic 		DREQ2  ;
  logic		    DREQ3  ;
  wire 			EOP_N  ;
  wire  [3 : 0] ADDR_LO;
  logic [3 : 0] ADDR_UP; 
  wire  [7 : 0] DB     ;

  modport TimingControl(
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

  modport PriorityLogic(
    input DREQ0,
    input DREQ1,
    input DREQ2,
    input DREQ3,
    input HLDA,

    output HRQ,
    output DACK0,
    output DACK1,
    output DACK2,
    output DACK3
  );

  modport DataPath(
    input CLK,
    input RESET);


endinterface
