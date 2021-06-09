module testTimingAndControl();

  bit CLK = 0;
  bit RESET;
  logic [2:0] WAITE;

  cpuInterface cpuIf(CLK, RESET);
  dmaInternalRegistersIf intRegIf(cpuIf.CLK, cpuIf.RESET);
  dmaInternalSignalsIf intSigIf(cpuIf.CLK, cpuIf.RESET);

  timingAndControl DUT(cpuIf.timingAndControl, cpuIf.priorityLogic, intRegIf.timingAndControl, intSigIf.timingAndControl);

  task setProgramCondition()

  always @(negedge CLK)
    begin
      /*if(DUT.state == 6'b100000 && intSigIf.updateCurrentWordCountReg) //TO DO - Add comment here!! CAUTION - When doing block level testing replace "intSigIf.updateCurrentWordCountReg" with "intSigIf.intEOP"
        begin
          //cpuIf.HLDA = 1'b0;
          cpuIf.DREQ = 4'b0000;
        end*/
      if(!intSigIf.assertDACK)
        cpuIf.DACK = cpuIf.DREQ;
      else
        cpuIf.DACK = 4'b0000;
      if(cpuIf.HRQ)
        cpuIf.HLDA = 1'b1;
      else
        cpuIf.HLDA = 1'b0;
      /*if(!cpuIf.HRQ)
        cpuIf.HLDA = 1'b0;*/
      if(intSigIf.decrTemporaryWordCountReg)
        begin
	  //cpuIf.HLDA = 1'b0;
          intRegIf.temporaryWordCountReg = intRegIf.temporaryWordCountReg - 1'b1;
        end
    end

  always @(posedge intSigIf.intEOP)
  begin
    cpuIf.DREQ = 4'b0000;
    //cpuIf.HLDA = 1'b0;
  end

  /*always @(posedge cpuIf.HRQ)
    begin
      repeat(WAITE) @(negedge CLK);
      cpuIf.HLDA = 1'b1;
    end*/

  /*always_comb
  begin
    if(intSigIf.intEOP) //TO DO - Add comment here!! CAUTION - When doing block level testing replace "intSigIf.updateCurrentWordCountReg" with "intSigIf.intEOP"
      begin
        cpuIf.HLDA = 1'b0;
        cpuIf.DREQ = 4'b0000;
      end
  end*/

  initial
    begin
      forever #5 CLK = ~CLK;
    end

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
      cpuIf.DREQ = 4'b0000;
      cpuIf.HLDA = 1'b0;
      cpuIf.CS_N = 1'b1;
      intRegIf.modeReg[0].transferType = 2'b00;
      intRegIf.modeReg[1].transferType = 2'b00;
      intRegIf.modeReg[2].transferType = 2'b00;
      intRegIf.modeReg[3].transferType = 2'b00;
      intRegIf.temporaryWordCountReg = 16'b00;

      @(negedge CLK);
      RESET = 1'b0;

      @(negedge CLK);
      cpuIf.CS_N = 1'b0;

      WAITE = $urandom_range(7,1);
      repeat(WAITE) @(negedge CLK);
      cpuIf.CS_N = 1'b1;

      repeat(1) @(negedge CLK);
      cpuIf.DREQ = 4'b0001;

      /*@(negedge CLK);
      if(intSigIf.intEOP)
        begin
          cpuIf.HLDA = 1'b0;
          cpuIf.DREQ = 4'b0000;
        end*/

      #200
      $stop;
    end
endmodule
