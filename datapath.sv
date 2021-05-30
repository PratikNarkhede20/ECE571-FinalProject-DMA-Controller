`include "dmaInternalRegistersIf.sv";
`include "cpuInterface.sv";
`include "dmaInternalSignalsIf.sv";
module datapath(cpuInterface.dataPath cpuIf, dmaInternalRegistersIf.dataPath intRegIf, dmaInternalSignalsIf intSigIf);

  logic [15 : 0] baseAddressReg        [3 : 0];
  logic [15 : 0] baseWordCountReg      [3 : 0];
  logic [15 : 0] currentAddressReg     [3 : 0];
  logic [15 : 0] currentWordCountReg   [3 : 0];
  logic [15 : 0] temporaryAddressReg          ;
  //logic [15 : 0] temporaryWordCountReg        ;
  logic [7  : 0] temporaryReg                 ;

  logic [7 : 0] writeBuffer;
  logic [7 : 0] readBuffer ;

  logic [3 : 0] ioDataBuffer	   ;
  logic [3 : 0] ioAddressBuffer	   ;
  logic [3 : 0] outputAddressBuffer;

  logic internalFF;

  //Command Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        intRegIf.commandReg <= '0;

      //write Command Register
      //Register Code for writing Command Register is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A2=0 , A1=0 , A0=0.
      else if( !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & cpuIf.A3 & !cpuIf.A2 & !cpuIf.A1 & !cpuIf.A0 )
        intRegIf.commandReg <= ioDataBuffer;

      else
        intRegIf.commandReg <= intRegIf.commandReg;
    end

  //Mode Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        begin
          for(int i=0; i<=3; i=i+1)
            intRegIf.modeReg[i] <= '0;
        end

      //write Mode Register
      //Register Code for writing Mode Register is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A2=0 , A1=1 , A0=1.
      else if( !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & cpuIf.A3 & !cpuIf.A2 & cpuIf.A1 & cpuIf.A0 )
        intRegIf.modeReg[ioDataBuffer[1:0]] <= ioDataBuffer[7:2];

      else
        begin
          for(int i=0; i<=3; i=i+1)
            intRegIf.modeReg[i] <= intRegIf.modeReg[i];
        end
    end



  //Status Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        intRegIf.statusReg <= '0;

      //read Mode Register
      //Register Code for reading Mode Register is CS_N=0, IOR_N=0, IOW_N=1, A3=1, A2=0 , A1=0 , A0=0.
      else if( !cpuIf.CS_N & !cpuIf.IOR_N & cpuIf.IOW_N & cpuIf.A3 & !cpuIf.A2 & !cpuIf.A1 & !cpuIf.A0 )
        begin
          ioDataBuffer <= intRegIf.statusReg;

          //clear status reg after each read
          intRegIf.statusReg <= '0;
        end

      //update Status Register
      else if(intSigIf.intEOP)
        begin
          intRegIf.statusReg.c3Request <= cpuIf.DREQ3;
          intRegIf.statusReg.c2Request <= cpuIf.DREQ2;
          intRegIf.statusReg.c1Request <= cpuIf.DREQ1;
          intRegIf.statusReg.c0Request <= cpuIf.DREQ0;
        end

      else
        intRegIf.statusReg <= intRegIf.statusReg;
    end



  //Base Address Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        begin
          for(int i=0; i<=3; i=i+1)
            baseAddressReg[i] <= '0;
        end

      //write Base Address Register
      //Register Code for writing Base Address Register is CS_N=0, IOR_N=1, IOW_N=0, A3=0, A0=0. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      else if( !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & !cpuIf.A3 & !cpuIf.A0 )
        begin
          if(internalFF)
            baseAddressReg[{cpuIf.A2, cpuIf.A1}][15:8] <= writeBuffer;
          else
            baseAddressReg[{cpuIf.A2, cpuIf.A1}][7:0] <= writeBuffer;
        end

      else
        begin
          for(int i=0; i<=3; i=i+1)
            baseAddressReg[i] <= baseAddressReg[i];
        end
    end

  //Current Address Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        begin
          for(int i=0; i<=3; i=i+1)
            currentAddressReg[i] <= '0;
        end

      //write Current Address Register
      //Register Code for writing Current Address Register is CS_N=0, IOR_N=1, IOW_N=0, A3=0, A0=0. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      else if( !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & !cpuIf.A3 & !cpuIf.A0 )
        begin
          if(internalFF)
            currentAddressReg[0][15:8] <= writeBuffer;
          else
            currentAddressReg[0][7:0] <= writeBuffer;
        end

      //read Current Address Register
      //Register Code for reading Current Address Register is CS_N=0, IOR_N=0, IOW_N=1, A3=0, A0=1. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      else if( !cpuIf.CS_N & !cpuIf.IOR_N & cpuIf.IOW_N & !cpuIf.A3 & cpuIf.A0 )
        begin
          if(internalFF)
            readBuffer <= currentAddressReg[0][15:8];
          else
            readBuffer <= currentAddressReg[0][7:0];
        end

      else
        begin
          for(int i=0; i<=3; i=i+1)
            currentAddressReg[i] <= currentAddressReg[i];
        end

    end


  //Base Word Count Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        begin
          for(int i=0; i<=3; i=i+1)
            baseWordCountReg[i] <= '0;
        end

      //write Base Word Count Register
      //Register Code for writing Base Word Count Register is CS_N=0, IOR_N=1, IOW_N=0, A3=0, A0=1. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      else if( !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & !cpuIf.A3 & cpuIf.A0 )
        begin
          if(internalFF)
            baseWordCountReg[0][15:8] <= writeBuffer;
          else
            baseWordCountReg[0][7:0] <= writeBuffer;
        end

      else
        begin
          for(int i=0; i<=3; i=i+1)
            baseWordCountReg[i] <= baseWordCountReg[i];
        end
    end

  //Current Word Count Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        begin
          for(int i=0; i<=3; i=i+1)
            currentWordCountReg[i] <= '0;
        end

      //write Current Word Count Register
      //Register Code for writing Current Word Count Register is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A0=0. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      else if( !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & cpuIf.A3 & !cpuIf.A0 )
        begin
          if(internalFF)
            currentWordCountReg[0][15:8] <= writeBuffer;
          else
            currentWordCountReg[0][7:0] <= writeBuffer;
        end

      //read Current Word Count Register
      //Register Code for reading Current Word Count Register is CS_N=0, IOR_N=0, IOW_N=1, A3=0, A0=1. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      else if( !cpuIf.CS_N & !cpuIf.IOR_N & cpuIf.IOW_N & !cpuIf.A3 & cpuIf.A0 )
        begin
          if(internalFF)
            readBuffer <= currentWordCountReg[0][15:8];
          else
            readBuffer <= currentWordCountReg[0][7:0];
        end

      else
        begin
          if(intSigIf.updateCurrentWordCountReg && cpuIf.DACK0)
            currentWordCountReg[0] <= intRegIf.temporaryWordCountReg;

          else if(intSigIf.updateCurrentWordCountReg && cpuIf.DACK1)
            currentWordCountReg[1] <= intRegIf.temporaryWordCountReg;

          else if(intSigIf.updateCurrentWordCountReg && cpuIf.DACK2)
            currentWordCountReg[2] <= intRegIf.temporaryWordCountReg;

          else if(intSigIf.updateCurrentWordCountReg && cpuIf.DACK3)
            currentWordCountReg[3] <= intRegIf.temporaryWordCountReg;

          else
            begin
              for(int i=0; i<=3; i=i+1)
                currentWordCountReg[i] <= currentWordCountReg[i];
            end

        end
    end

endmodule
