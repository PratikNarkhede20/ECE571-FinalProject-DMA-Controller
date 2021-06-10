`include "dmaInternalRegistersIf.sv"
`include "cpuInterface.sv"
`include "dmaInternalSignalsIf.sv"
`include "priorityLogic.sv"

module top;

  bit CLK=0;
  bit RESET;
  always #5 CLK = ~CLK;
  logic [2:0] WAITE;

  cpuInterface cpuIf(CLK, RESET);

  //dmaInternalRegistersIf intRegIf(cpuIf.CLK, cpuIf.RESET);

  //dmaInternalSignalsIf intSigIf(cpuIf.CLK, cpuIf.RESET);

  dma DUT (cpuIf);

  task setProgramCondition();
    cpuIf.CS_N = 1'b0;

    WAITE = $urandom_range(7,1);
    repeat(WAITE) @(negedge CLK);
    cpuIf.CS_N = 1'b1;
  endtask

  task transactionRequest(
    input logic [3:0] DREQ,
    input logic [7:0] transactionType,
    input logic [15:0] wordCount,
    input logic [15:0] addressReg
  );
    cpuIf.DREQ = DREQ;
    {DUT.intRegIf.modeReg[0].transferType, DUT.intRegIf.modeReg[1].transferType, DUT.intRegIf.modeReg[2].transferType, DUT.intRegIf.modeReg[3].transferType} = transactionType;
    DUT.intRegIf.temporaryWordCountReg = wordCount;
    DUT.intRegIf.temporaryAddressReg = addressReg;
  endtask

  task doReset();
    RESET = 1'b1;

    repeat(1) @(negedge CLK);
    RESET = 1'b0;
  endtask

  always @(negedge CLK)
    begin
      /*if(intSigIf.assertDACK)
        cpuIf.DACK = cpuIf.DREQ;
      else
        cpuIf.DACK = 4'b0000;*/

      if(cpuIf.HRQ)
        cpuIf.HLDA = 1'b1;
      else
        cpuIf.HLDA = 1'b0;

      /*if(DUT.intSigIf.decrTemporaryWordCountReg)
      begin
        DUT.intRegIf.temporaryWordCountReg = DUT.intRegIf.temporaryWordCountReg - 1'b1;
      end

      if(DUT.intSigIf.incrTemporaryAddressReg)
      begin
        DUT.intRegIf.temporaryAddressReg = DUT.intRegIf.temporaryAddressReg + 1'b1;
      end*/
    end

  always @(posedge DUT.intSigIf.intEOP)
    begin
      cpuIf.DREQ = 4'b0000;
    end

  /*initial
    begin
      forever #5 CLK = ~CLK;
    end*/

  /*initial
    begin
      $dumpfile("dumps.vcd");
      $dumpvars;
    end*/

  initial
    begin
      @(negedge CLK);
      RESET = 1'b1;
      cpuIf.HLDA = 1'b0;
      cpuIf.CS_N = 1'b1;
      DUT.intRegIf.commandReg.priorityType = 1'b0;

      transactionRequest(4'b0000, 8'b00000000, 16'b00, 16'b00);

      @(negedge CLK);
      RESET = 1'b0;

      @(negedge CLK);
      setProgramCondition();

      repeat(1) @(negedge CLK);
      transactionRequest(4'b1111, 8'b01100110, 16'b01, 16'b11);

      repeat(6) @(negedge CLK);
      doReset();

      repeat(WAITE) @(negedge CLK);
      transactionRequest(4'b1110, 8'b01100110, 16'b11, 16'b1010);

      @(negedge CLK);
      setProgramCondition();

      #200
      $stop;

    end
endmodule
