module testTimingAndControl();
  cpuInterface.timingAndControl TCcpuIf;
  cpuInterface.priorityLogic PLcpuIf;
  dmaInternalRegistersIf.timingControl intRegIf;
  dmaInternalSignalsIf.timingControl intSigIf;

  parameter TRUE   = 1'b1;
  parameter FALSE  = 1'b0;
  parameter CLOCK_CYCLE  = 10;
  parameter CLOCK_WIDTH  = CLOCK_CYCLE/2;
  parameter RESET_CLOCKS = 2;

  timingAndControl TC(cpuInterface.timingAndControl TCcpuIf, cpuInterface.priorityLogic PLcpuIf, dmaInternalRegistersIf.timingControl intRegIf, dmaInternalSignalsIf.timingControl intSigIf);

  initial
    begin
      Clock = FALSE;
      forever #CLOCK_WIDTH Clock = ~Clock;
    end

  initial
    begin
      Reset = TRUE;
      repeat (RESET_CLOCKS) @(negedge Clock);
      Reset = FALSE;
    end

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
