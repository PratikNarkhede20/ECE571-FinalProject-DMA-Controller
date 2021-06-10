module cpuTB();
  parameter CYCLETIME=10;
  parameter ONTIME =CYCLETIME/2;
  parameter GLOBALTIME=300;
  parameter REGISTERADDRESS =4;
  parameter DATAWIDTH =8;
  parameter ADDRESSWIDTH=16;
  bit CLK;
  logic RESET;
  logic HRQ;
  logic HLDA;
  logic CS_N;
  logic IOR_N;
  logic IOW_N;
  logic[REGISTERADDRESS-1:0] regAddress;
  logic A3;
  logic A2;
  logic A1;
  logic A0;
  logic [DATAWIDTH-1:0] DB;
  logic intEOP;


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

  cpu processor(CLK, RESET, cmdData, modeData, baseAddrLB, baseChannelAddrLW, baseAddrHB, baseChannelAddrHB, baseWordLB, baseChannelWordLB, baseWordHB, baseChannelWordHB, intEOP, HRQ, HLDA, CS_N, IOR_N, IOW_N, A3, A2, A1, A0, DB);

  always #ONTIME CLK=~CLK;


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
      intEOP = '1;
      @(posedge CLK);

      configuration(8'hC0, 8'h44, 4'h0, 8'h01, 4'h0, 4'h00, 4'h1, 8'h05, 4'h1, 8'h00);

      @(posedge CLK);
      intEOP = '0;
      @(posedge CLK);
    end

  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      #GLOBALTIME;
      $finish;
    end
endmodule
