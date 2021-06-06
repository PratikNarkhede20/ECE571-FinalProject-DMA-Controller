module testTimingAndControl();

  bit CLK = 0;
  bit RESET;
  logic [2:0] WAITE;
  //always #5 CLK = ~CLK;

  cpuInterface cpuIf(CLK, RESET);
  dmaInternalRegistersIf intRegIf(cpuIf.CLK, cpuIf.RESET);
  dmaInternalSignalsIf intSigIf(cpuIf.CLK, cpuIf.RESET);

  /*cpuInterface.timingAndControl TCcpuIf;//(CLK, RESET);
  cpuInterface.priorityLogic PLcpuIf;//(CLK, RESET);
  dmaInternalRegistersIf.timingAndControl intRegIf;//(cpuIf.CLK, cpuIf.RESET);
  dmaInternalSignalsIf.timingAndControl intSigIf;//(cpuIf.CLK, cpuIf.RESET);*/

  timingAndControl DUT(cpuIf.timingAndControl, cpuIf.priorityLogic, intRegIf.timingAndControl, intSigIf.timingAndControl);

  always @(negedge CLK)
    begin
      if(DUT.state == 6'b100000 && intSigIf.updateCurrentWordCountReg) //TO DO - Add comment here!! CAUTION - When doing block level testing replace "intSigIf.updateCurrentWordCountReg" with "intSigIf.intEOP"
        begin
          cpuIf.HLDA = 1'b0;
          cpuIf.DREQ = 4'b0000;
        end
      if(!intSigIf.assertDACK)
        cpuIf.DACK = 4'b0000;
      else
        cpuIf.DACK = 4'b0001;
      if(intSigIf.decrTemporaryWordCountReg)
        begin
          intRegIf.temporaryWordCountReg = intRegIf.temporaryWordCountReg - 1'b1;
        end
    end

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
      //cpuIf.EOP_N = 1'b0;
      intRegIf.modeReg[0].transferType = 2'b01;
      intRegIf.modeReg[1].transferType = 2'b00;
      intRegIf.modeReg[2].transferType = 2'b00;
      intRegIf.modeReg[3].transferType = 2'b00;
      intRegIf.temporaryWordCountReg = 16'b10;

      @(negedge CLK);
      RESET = 1'b0;

      @(negedge CLK);
      cpuIf.CS_N = 1'b0;

      WAITE = $urandom_range(7,0);
      repeat(WAITE) @(negedge CLK);
      cpuIf.CS_N = 1'b1;

      repeat(1) @(negedge CLK);
      cpuIf.DREQ = 4'b0001;

      repeat(WAITE) @(negedge CLK);
      cpuIf.HLDA = 1'b1;

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
