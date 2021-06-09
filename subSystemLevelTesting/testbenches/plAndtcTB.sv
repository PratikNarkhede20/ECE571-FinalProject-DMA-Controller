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

  dmaInternalRegistersIf intRegIf(cpuIf.CLK, cpuIf.RESET);

  dmaInternalSignalsIf intSigIf(cpuIf.CLK, cpuIf.RESET);

  dma dmaDUT (cpuIf);

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
    {intRegIf.modeReg[0].transferType, intRegIf.modeReg[1].transferType, intRegIf.modeReg[2].transferType, intRegIf.modeReg[3].transferType} = transactionType;
    intRegIf.temporaryWordCountReg = wordCount;
    intRegIf.temporaryAddressReg = addressReg;
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

      if(intSigIf.decrTemporaryWordCountReg)
        intRegIf.temporaryWordCountReg = intRegIf.temporaryWordCountReg - 1'b1;

      if(intSigIf.incrTemporaryAddressReg)
        intRegIf.temporaryAddressReg = intRegIf.temporaryAddressReg + 1'b1;
    end

  always @(posedge intSigIf.intEOP)
    begin
      cpuIf.DREQ = 4'b0000;
    end

  /*initial
    begin
      forever #5 CLK = ~CLK;
    end*/

  initial
    begin
      $dumpfile("dumps.vcd");
      $dumpvars;
    end

  initial
    begin
      @(negedge CLK);
      RESET = 1'b1;
      cpuIf.HLDA = 1'b0;
      cpuIf.CS_N = 1'b1;

      transactionRequest(4'b0000, 8'b00000000, 16'b00, 16'b00);

      @(negedge CLK);
      RESET = 1'b0;

      @(negedge CLK);
      setProgramCondition();

      repeat(1) @(negedge CLK);
      transactionRequest(4'b0001, 8'b01000000, 16'b10, 16'b11);

      repeat(6) @(negedge CLK);
      doReset();

      #200
      $stop;

    end
endmodule
