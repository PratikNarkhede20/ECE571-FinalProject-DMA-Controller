module testTimingAndControl();

  bit CLK = 0;
  bit RESET;
  always #5 CLK = ~CLK;

  cpuInterface.timingAndControl TCcpuIf(CLK, RESET);
  cpuInterface.priorityLogic PLcpuIf(CLK, RESET);
  dmaInternalRegistersIf.timingAndControl intRegIf(cpuIf.CLK, cpuIf.RESET);
  dmaInternalSignalsIf.timingAndControl intSigIf(cpuIf.CLK, cpuIf.RESET);

  timingAndControl DUT(TCcpuIf, PLcpuIf, intRegIf, intSigIf);

  initial
    begin
      @(negedge TCcpuIf.CLK);
      TCcpuIf.RESET = 1'b1;
      PLcpuIf.DREQ = 4'b0001;
      PLcpuIf.HLDA = 1'b0;
      TCcpuIf.EOP_N = 1'b0;
      intRegIf.modeReg[0].transferType = 2'b00;
      intRegIf.modeReg[1].transferType = 2'b00;
      intRegIf.modeReg[2].transferType = 2'b00;
      intRegIf.modeReg[3].transferType = 2'b01;

      $stop;
    end
endmodule
