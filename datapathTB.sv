`include "dmaInternalRegistersIf.sv"
`include "cpuInterface.sv"
`include "dmaInternalSignalsIf.sv"
//`include "datapath.sv"
//`include "dmaRegConfigPkg.sv"

module datapathTB();

  bit CLK=0;
  bit RESET;
  always #5 CLK = ~CLK;

  cpuInterface cpuIf(CLK, RESET);

  dmaInternalRegistersIf intRegIf(cpuIf.CLK, cpuIf.RESET);

  dmaInternalSignalsIf intSigIf(cpuIf.CLK, cpuIf.RESET);

  datapath tb(cpuIf, intRegIf, intSigIf);

  initial
    begin
      @(negedge CLK) RESET = 1'b1;
      @(negedge CLK)
      $display("commandReg = %b, modeReg0 = %b, maskReg = %b, statusReg = %b", intRegIf.commandReg, intRegIf.modeReg[0], intRegIf.maskReg, intRegIf.statusReg);
      $finish();
    end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #1000
    $finish;
  end




endmodule
