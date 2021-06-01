`include "dmaInternalRegistersIf.sv"
`include "cpuInterface.sv"
`include "dmaInternalSignalsIf.sv"
`include "priorityLogic.sv"

module priorityLogic_tb;

  bit CLK=0;
  bit RESET;
  always #5 CLK = ~CLK;
  int a,b;

  cpuInterface cpuIf(CLK, RESET);

  dmaInternalRegistersIf intRegIf(cpuIf.CLK, cpuIf.RESET);

  dmaInternalSignalsIf intSigIf(cpuIf.CLK, cpuIf.RESET);

  priorityLogic tb (cpuIf, intRegIf, intSigIf);

  initial
    begin
      @(negedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b0;
        intSigIf.assertDACK = 1'b1;
      end

      @(negedge CLK)
      cpuIf.DREQ = 4'b1111;
      $strobe("DACK = %b",cpuIf.DACK);

      @(negedge CLK)
      cpuIf.DREQ = 4'b1110;
      $strobe("DACK = %b",cpuIf.DACK);

      @(negedge CLK)
      cpuIf.DREQ = 4'b1101;
      $strobe("DACK = %b",cpuIf.DACK);

      @(negedge CLK)
      cpuIf.DREQ = 4'b1001;
      $strobe("DACK = %b",cpuIf.DACK);

      @(negedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        cpuIf.DREQ = 4'b1101;
      end
      $strobe("P DACK = %b",cpuIf.DACK);

      @(negedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        cpuIf.DREQ = 4'b1100;
      end
      $strobe("P DACK = %b",cpuIf.DACK);

      @(negedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        cpuIf.DREQ = 4'b1000;
      end
      $strobe("P DACK = %b",cpuIf.DACK);

      @(negedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        cpuIf.DREQ = 4'b0011;
      end
      $strobe("P DACK = %b",cpuIf.DACK);


      @(negedge CLK)
      a = $countones(cpuIf.DACK);
      $display("a = %d",a);

      $finish();
    end

  property singleDACK_p;
    @(posedge CLK)
    disable iff (RESET)
    cpuIf.DREQ |=> ($countones(cpuIf.DACK) ==1 );
  endproperty
  singleDACK_a : assert property(singleDACK_p);



endmodule
