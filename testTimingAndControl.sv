module testTimingAndControl();
  CPUinterface.timingAndControl TCcpuIf;
  CPUinterface.priorityLogic PLcpuIf;
  dmaInternalRegistersIf.timingControl intRegIf;
  dmaInternalSignalsIf.timingControl intSigIf;

  parameter TRUE   = 1'b1;
  parameter FALSE  = 1'b0;
  parameter CLOCK_CYCLE  = 10;
  parameter CLOCK_WIDTH  = CLOCK_CYCLE/2;
  parameter RESET_CLOCKS = 2;

  timingAndControl TC(CPUinterface.timingAndControl TCcpuIf, CPUinterface.priorityLogic PLcpuIf, dmaInternalRegistersIf.timingControl intRegIf, dmaInternalSignalsIf.timingControl intSigIf);

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
