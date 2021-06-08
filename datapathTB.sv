`include "dmaInternalRegistersIf.sv"
`include "cpuInterfaceTesting.sv"
`include "dmaInternalSignalsIf.sv"
//`include "datapath.sv"
//`include "dmaRegConfigPkg.sv"

module datapathTB();

  bit CLK=0;
  bit RESET;
  always #5 CLK = ~CLK;

  //virtual cpuInterface cpuIf;


  cpuInterfaceTesting cpuIf(CLK, RESET);

  dmaInternalRegistersIf intRegIf(cpuIf.CLK, cpuIf.RESET);

  dmaInternalSignalsIf intSigIf(cpuIf.CLK, cpuIf.RESET);

  datapath tb(cpuIf.dataPath, intRegIf, intSigIf);

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
        cpuIf.HLDA = 1'b1;
      end

      //command register
      @(negedge CLK)
      begin
        {intSigIf.programCondition, cpuIf.CS_N, cpuIf.IOR_N, cpuIf.IOW_N, cpuIf.A3, cpuIf.A2, cpuIf.A1, cpuIf.A0} = 8'b10101000;
        cpuIf.DB = 8'b10101010;
      end

      repeat(2)@(negedge CLK);

      //mode register
      @(negedge CLK)
      begin
        {intSigIf.programCondition, cpuIf.CS_N, cpuIf.IOR_N, cpuIf.IOW_N, cpuIf.A3, cpuIf.A2, cpuIf.A1, cpuIf.A0} = 8'b10101011;
        cpuIf.DB = 8'b11101110;
      end

      repeat(2)@(negedge CLK);
      $display("mode reg[2] = %b", intRegIf.modeReg[2]);

       //write upper Address base address register and Current Address Register
      @(negedge CLK)
      begin
        {intSigIf.programCondition, cpuIf.CS_N, cpuIf.IOR_N, cpuIf.IOW_N, cpuIf.A3, cpuIf.A2, cpuIf.A1, cpuIf.A0} = 8'b10100010;
        cpuIf.DB = 8'b11001100;
      end

      repeat(2)@(negedge CLK);
        $finish();
    end



  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #1000
    $finish;
  end
endmodule
