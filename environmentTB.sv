module top();

  import dmaRegConfigPkg :: *; //wildcard import


  parameter CYCLETIME=10;
  localparam ONTIME =CYCLETIME/2;
  parameter GLOBALTIME=1000;

  bit CLK;
  logic RESET;

  logic [DATAWIDTH-1        : 0] cmdData;
  logic [DATAWIDTH-1        : 0] modeData;
  logic [(ADDRESSWIDTH/2)-1 : 0] baseAddrLB;
  logic [REGISTERADDRESS-1  : 0] baseChannelAddrLW;
  logic [(ADDRESSWIDTH/2)-1 : 0] baseAddrHB;
  logic [REGISTERADDRESS-1  : 0] baseChannelAddrHB;
  logic [(ADDRESSWIDTH/2)-1 : 0] baseWordLB;
  logic [REGISTERADDRESS-1  : 0] baseChannelWordLB;
  logic [(ADDRESSWIDTH/2)-1 : 0] baseWordHB;
  logic [REGISTERADDRESS-1  : 0] baseChannelWordHB;
  logic inreq [PERIPHERALS-1 : 0];

  always #ONTIME CLK=~CLK;

  environment DUT(CLK, RESET, cmdData,
  modeData, baseAddrLB, baseChannelAddrLW,
  baseAddrHB, baseChannelAddrHB, baseWordLB,
  baseChannelWordLB, baseWordHB, baseChannelWordHB, inreq);

  task configuration(logic [DATAWIDTH-1        : 0] cmdData1,
                     logic [DATAWIDTH-1        : 0] modeData1,
                     logic [REGISTERADDRESS-1  : 0] baseChannelAddrLW1,
                     logic [(ADDRESSWIDTH/2)-1 : 0] baseAddrLB1,
                     logic [REGISTERADDRESS-1  : 0] baseChannelAddrHB1,
                     logic [(ADDRESSWIDTH/2)-1 : 0] baseAddrHB1,
                     logic [REGISTERADDRESS-1  : 0] baseChannelWordLB1,
                     logic [(ADDRESSWIDTH/2)-1 : 0] baseWordLB1,
                     logic [REGISTERADDRESS-1  : 0] baseChannelWordHB1,
                     logic [(ADDRESSWIDTH/2)-1 : 0] baseWordHB1
                    );

    cmdData           = cmdData1;
    modeData          = modeData1;
    baseChannelAddrLW = baseChannelAddrLW1;
    baseAddrLB        = baseAddrLB1;
    baseChannelAddrHB = baseChannelAddrHB1;
    baseAddrHB        = baseAddrHB1;
    baseChannelWordLB = baseChannelWordLB1;
    baseWordLB        = baseWordLB1;
    baseChannelWordHB = baseChannelWordHB1;
    baseWordHB        = baseWordHB1;

  endtask

  initial
    begin
      RESET ='1;
      @(posedge CLK);
      RESET = '0;
      //intEOP = '1;
      @(posedge CLK);

      configuration(8'hC0, 8'h44, 4'h0, 8'h01, 4'h0, 8'h00, 4'h1, 8'h05, 4'h1, 8'h00);

      repeat(20) @(posedge CLK);
      inreq[0] = 1'b1;
      repeat(10) @(posedge CLK);
      inreq[0] = 1'b0;

      repeat(20) @(posedge CLK);
      inreq[1] = 1'b1;
      repeat(10) @(posedge CLK);
      inreq[1] = 1'b0;
    end

  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      #GLOBALTIME;
      $finish;
    end

endmodule
