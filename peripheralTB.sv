module peripheralTB();
  parameter PERIPHERALS=2;
  parameter DATAWIDTH=8;
  parameter ADDRESSWIDTH =16;
  parameter CYCLETIME=10;
  parameter ONTIME =CYCLETIME/2;
  parameter GLOBALTIME=200;
  bit CLK;
  logic RESET;
  logic IOR_N;
  logic IOW_N;
  wire [DATAWIDTH-1:0] data;
  logic[DATAWIDTH-1:0] dataIn;
  logic inreq[PERIPHERALS-1:0];
  logic DREQ [PERIPHERALS-1:0];
  logic intEOP;
  logic DACK[PERIPHERALS-1:0];
  genvar i;


  logic MEMR_N,MEMW_N;
  logic[(ADDRESSWIDTH/2)-1:0] addressHB;
  logic A0,A1,A2,A3,A4,A5,A6,A7;
  logic ADSTB;

  initial CLK='1;
  always #ONTIME CLK = ~CLK;

  generate
    for(i=0 ; i<PERIPHERALS; i++)
      begin
        peripheral #(i) p1(CLK,RESET,intEOP,IOR_N, IOW_N, data, inreq[i], DREQ[i], DACK[i]);
      end
  endgenerate

  //peripheral #(0) p1(CLK,RESET, IOR_N, IOW_N, data, inreq1, dreq1, dack1);
  //peripheral #(1)p2(CLK,RESET, IOR_N, IOW_N, data, inreq2, dreq2, dack2);

  assign data = (!IOW_N) ? dataIn :'bz;

  memory memory(CLK,MEMR_N, MEMW_N, ADSTB, A0, A1, A2, A3,A4, A5,A6,A7,addressHB, data);

  assign dack1 = DACK[0];
  task ioMemWrite(logic [DATAWIDTH-1:0] writeData);
    @(posedge CLK);
      MEMW_N='1;
      MEMR_N='1;
      IOW_N ='0;
      IOR_N ='1;
      dataIn =writeData;
  endtask
  task ioWrite();
    @(posedge CLK);
      MEMW_N='1;
      MEMR_N='0;
      IOW_N ='0;
      IOR_N ='1;
  endtask

  task sendRequest1(int inReqWait) ;
    repeat(inReqWait)@(posedge CLK);
    inreq[0] ='1;
  endtask
  task sendRequest2(int inReqWait) ;
    repeat(inReqWait)@(posedge CLK);
    inreq[1] ='1;
  endtask
  task noOpearation();
    @(posedge CLK);
      IOW_N ='1;
      IOR_N ='1;
      MEMW_N='1;
      MEMR_N='1;
  endtask

  task ioRead();
      @(posedge CLK);
      MEMW_N='0;
      MEMR_N='1;
      IOW_N ='1;
      IOR_N ='0;
    ADSTB='1;
    {addressHB,A7,A6,A5,A4,A3,A2,A1,A0}= 16'h0005;
  endtask


  initial
    begin

      sendRequest1(2);
      ioMemWrite(8'h24);
      intEOP ='0;
      @(posedge CLK);
      wait (DREQ[0]);
      DACK[0] ='1;
      DACK[1] ='0;
      noOpearation();
      ioRead();
      noOpearation();
      sendRequest2(2);
      wait (DREQ[1]);
      DACK[1] ='1;
      DACK[0]='0;
      ioWrite();
       noOpearation();


    end
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      #GLOBALTIME;
      $finish;
    end

endmodule
