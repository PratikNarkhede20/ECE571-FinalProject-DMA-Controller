module testTimingAndControl();
  cpuInterface.timingAndControl TCcpuIf;
  cpuInterface.priorityLogic PLcpuIf;
  dmaInternalRegistersIf.timingControl intRegIf;
  dmaInternalSignalsIf.timingControl intSigIf;

  bit CLK = 0;
  bit RESET;
  always #5 CLK = ~CLK;

  timingAndControl DUT(cpuInterface.timingAndControl TCcpuIf, cpuInterface.priorityLogic PLcpuIf, dmaInternalRegistersIf.timingControl intRegIf, dmaInternalSignalsIf.timingControl intSigIf);

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
