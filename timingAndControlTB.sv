module testTimingAndControl();

  bit CLK = 0;
  bit RESET;
  always #5 CLK = ~CLK;
  logic [2:0] WAITE;

  busInterface busIf(CLK, RESET);
  dmaInternalRegistersIf intRegIf(busIf.CLK, busIf.RESET);
  dmaInternalSignalsIf intSigIf(busIf.CLK, busIf.RESET);

  timingAndControl DUT(busIf.timingAndControl, busIf.priorityLogic, intRegIf.timingAndControl, intSigIf.timingAndControl);

  task setProgramCondition();
    busIf.CS_N = 1'b0;

    WAITE = $urandom_range(7,1);
    repeat(WAITE) @(negedge CLK);
    busIf.CS_N = 1'b1;
  endtask

  task transactionRequest(
    input logic [3:0] DREQ,
    input logic [7:0] transactionType,
    input logic [15:0] wordCount,
    input logic [15:0] addressReg
    );
    busIf.DREQ = DREQ;
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
      /*if(DUT.state == 6'b100000 && intSigIf.updateCurrentWordCountReg) //TO DO - Add comment here!! CAUTION - When doing block level testing replace "intSigIf.updateCurrentWordCountReg" with "intSigIf.intEOP"
        begin
          //busIf.HLDA = 1'b0;
          busIf.DREQ = 4'b0000;
        end*/
      if(intSigIf.assertDACK)
        busIf.DACK = busIf.DREQ;
      else
        busIf.DACK = 4'b0000;

      if(busIf.HRQ)
        busIf.HLDA = 1'b1;
      else
        busIf.HLDA = 1'b0;

      /*if(!busIf.HRQ)
        busIf.HLDA = 1'b0;*/
      if(intSigIf.decrTemporaryWordCountReg)
        intRegIf.temporaryWordCountReg = intRegIf.temporaryWordCountReg - 1'b1;

      if(intSigIf.incrTemporaryAddressReg)
        intRegIf.temporaryAddressReg = intRegIf.temporaryAddressReg + 1'b1;
    end

  always @(posedge intSigIf.intEOP)
  begin
    busIf.DREQ = 4'b0000;
    //busIf.HLDA = 1'b0;
  end

  /*always @(posedge busIf.HRQ)
    begin
      repeat(WAITE) @(negedge CLK);
      busIf.HLDA = 1'b1;
    end*/

  /*always_comb
  begin
    if(intSigIf.intEOP) //TO DO - Add comment here!! CAUTION - When doing block level testing replace "intSigIf.updateCurrentWordCountReg" with "intSigIf.intEOP"
      begin
        busIf.HLDA = 1'b0;
        busIf.DREQ = 4'b0000;
      end
  end*/

  /*initial
    begin
      forever #5 CLK = ~CLK;
    end*/

  initial
    begin
      $dumpfile("dumps.vcd");
      //$dumpvars(0,edge_detect);
      $dumpvars;
    end

  initial
    begin
      @(negedge CLK);
      RESET = 1'b1;
      busIf.HLDA = 1'b0;
      busIf.CS_N = 1'b1;

      transactionRequest(4'b0000, 8'b00000000, 16'b00, 16'b00);
      /*intRegIf.modeReg[0].transferType = 2'b01;
      intRegIf.modeReg[1].transferType = 2'b00;
      intRegIf.modeReg[2].transferType = 2'b00;
      intRegIf.modeReg[3].transferType = 2'b00;
      intRegIf.temporaryWordCountReg = 16'b01;*/

      @(negedge CLK);
      RESET = 1'b0;

      @(negedge CLK);
      setProgramCondition();
      /*busIf.CS_N = 1'b0;

      WAITE = $urandom_range(7,1);
      repeat(WAITE) @(negedge CLK);
      busIf.CS_N = 1'b1;*/

      repeat(1) @(negedge CLK);
      transactionRequest(4'b0001, 8'b01000000, 16'b10, 16'b11);
      //busIf.DREQ = 4'b0001;

      repeat(6) @(negedge CLK);
      doReset();

      /*@(negedge CLK);
      if(intSigIf.intEOP)
        begin
          busIf.HLDA = 1'b0;
          busIf.DREQ = 4'b0000;
        end*/

      #200
      $stop;
    end
endmodule
