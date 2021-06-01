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
      @(posedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b0;
        intSigIf.assertDACK = 1'b1;
      end

      @(posedge CLK)
      cpuIf.DREQ = 4'b1111;
      $display("DACK = %b",cpuIf.DACK);

      @(posedge CLK)
      cpuIf.DREQ = 4'b1110;
      $display("DACK = %b",cpuIf.DACK);

      @(posedge CLK)
      cpuIf.DREQ = 4'b1100;
      $display("DACK = %b",cpuIf.DACK);

      @(posedge CLK)
      cpuIf.DREQ = 4'b1101;
      $display("DACK = %b",cpuIf.DACK);

      @(posedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        cpuIf.DREQ = 4'b1101;
      end
      $display("P DACK = %b",cpuIf.DACK);

      @(posedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        cpuIf.DREQ = 4'b1110;
      end
      $display("P DACK = %b",cpuIf.DACK);

      @(posedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        cpuIf.DREQ = 4'b1001;
      end
      $display("P DACK = %b",cpuIf.DACK);

      @(posedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        cpuIf.DREQ = 4'b1001;
      end
      $display("P DACK = %b",cpuIf.DACK);


      @(posedge CLK)
      a = $countones(cpuIf.DACK);
      $display("a = %d",a);

      $finish();
    end

  property singleDACK_p;
    @(posedge CLK)
    disable iff (RESET)
    cpuIf.DREQ |=> ($countones(cpuIf.DACK)==1);
  endproperty
  singleDACK_a : assert property(singleDACK_p)

endmodule
