module datapathTB();

  bit CLK=0;
  bit RESET;
  always #5 CLK = ~CLK;

  cpuInterface cpuIf(CLK, RESET);

  dmaInternalRegistersIf intRegIf(cpuIf.CLK, cpuIf.RESET);

  dmaInternalSignalsIf intSigIf(cpuIf.CLK, cpuIf.RESET);

  datapath tb(cpuIf.dataPath, intRegIf.dataPath, intSigIf.dataPath);

  initial
    begin
      @(negedge CLK) RESET = 1'b1;
      @(negedge CLK)
      begin
        cpuIf.CS_N = 1'b0;
        intSigIf.loadAddr = 1'b0;
        $display("commandReg = %b, modeReg0 = %b, maskReg = %b, statusReg = %b", intRegIf.commandReg, intRegIf.modeReg[0], intRegIf.maskReg, intRegIf.statusReg);
      end

      @(negedge CLK) RESET = 1'b0;

      @(negedge CLK)
      begin
        intSigIf.loadAddr = 1'b1;
        cpuIf.CS_N = 1'b0;
        {intSigIf.programCondition, cpuIf.CS_N, cpuIf.IOR_N, cpuIf.IOW_N, cpuIf.A3, cpuIf.A2, cpuIf.A1, cpuIf.A0} = 8'b10101000;
        cpuIf.DB = 8'b10101010;
      end

      @(negedge CLK)
      $display("AFTER CONFIG commandReg = %b, modeReg0 = %b, maskReg = %b, statusReg = %b", intRegIf.commandReg, intRegIf.modeReg[0], intRegIf.maskReg, intRegIf.statusReg);

      $finish();
    end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #1000
    $finish;
  end
endmodule
