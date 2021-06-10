`include "dmaInternalRegistersIf.sv"
`include "busInterface.sv"
`include "dmaInternalSignalsIf.sv"
`include "priorityLogic.sv"

module priorityLogic_tb;

  bit CLK=0;
  bit RESET;
  always #5 CLK = ~CLK;

  busInterface busIf(CLK, RESET);

  dmaInternalRegistersIf intRegIf(busIf.CLK, busIf.RESET);

  dmaInternalSignalsIf intSigIf(busIf.CLK, busIf.RESET);

  priorityLogic tb (busIf, intRegIf, intSigIf);

  initial
    begin
      @(negedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b0;
        intSigIf.assertDACK = 1'b1;
      end

      @(negedge CLK)
      busIf.DREQ = 4'b1111;
      $strobe("DACK = %b",busIf.DACK);

      @(negedge CLK)
      busIf.DREQ = 4'b1110;
      $strobe("DACK = %b",busIf.DACK);

      @(negedge CLK)
      busIf.DREQ = 4'b1101;
      $strobe("DACK = %b",busIf.DACK);

      @(negedge CLK)
      busIf.DREQ = 4'b1001;
      $strobe("DACK = %b",busIf.DACK);

      @(negedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        busIf.DREQ = 4'b1101;
      end
      $strobe("P DACK = %b",busIf.DACK);

      @(negedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        busIf.DREQ = 4'b1100;
      end
      $strobe("P DACK = %b",busIf.DACK);

      @(negedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        busIf.DREQ = 4'b1000;
      end
      $strobe("P DACK = %b",busIf.DACK);

      @(negedge CLK)
      begin
        intRegIf.commandReg.priorityType = 1'b1;
        busIf.DREQ = 4'b0011;
      end
      $strobe("P DACK = %b",busIf.DACK);

      $finish();
    end

  property singleDACK_p;
    @(posedge CLK)
    disable iff (RESET)
    busIf.DREQ |=> ($countones(busIf.DACK) ==1 );
  endproperty
  singleDACK_a : assert property(singleDACK_p);

endmodule
