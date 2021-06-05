module testTimingAndControl();

  bit CLK = 0;
  bit RESET;
  //always #5 CLK = ~CLK;

  cpuInterface cpuIf(CLK, RESET);
  dmaInternalRegistersIf intRegIf(cpuIf.CLK, cpuIf.RESET);
  dmaInternalSignalsIf intSigIf(cpuIf.CLK, cpuIf.RESET);

  /*cpuInterface.timingAndControl TCcpuIf;//(CLK, RESET);
  cpuInterface.priorityLogic PLcpuIf;//(CLK, RESET);
  dmaInternalRegistersIf.timingAndControl intRegIf;//(cpuIf.CLK, cpuIf.RESET);
  dmaInternalSignalsIf.timingAndControl intSigIf;//(cpuIf.CLK, cpuIf.RESET);*/

  timingAndControl DUT(cpuIf.timingAndControl, cpuIf.priorityLogic, intRegIf.timingAndControl, intSigIf.timingAndControl);

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
      cpuIf.DREQ = 4'b0001;
      cpuIf.HLDA = 1'b0;
      cpuIf.CS_N = 1'b0;
      //cpuIf.EOP_N = 1'b0;
      intRegIf.modeReg[0].transferType = 2'b00;
      intRegIf.modeReg[1].transferType = 2'b00;
      intRegIf.modeReg[2].transferType = 2'b00;
      intRegIf.modeReg[3].transferType = 2'b01;

      $stop;
    end
endmodule
