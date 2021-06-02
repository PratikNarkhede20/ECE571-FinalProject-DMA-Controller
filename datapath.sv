`include "dmaRegConfigPkg.sv"
module datapath(cpuInterface.dataPath cpuIf, dmaInternalRegistersIf.dataPath intRegIf, dmaInternalSignalsIf intSigIf);

  import dmaRegConfigPkg :: *; //wildcard import

  logic [ADDRESSWIDTH-1 : 0] baseAddressReg        [CHANNELS-1 : 0];
  logic [ADDRESSWIDTH-1 : 0] baseWordCountReg      [CHANNELS-1 : 0];
  logic [ADDRESSWIDTH-1 : 0] currentAddressReg     [CHANNELS-1 : 0];
  logic [ADDRESSWIDTH-1 : 0] currentWordCountReg   [CHANNELS-1 : 0];
  //logic [ADDRESSWIDTH-1 : 0] temporaryAddressReg          ;
  //logic [ADDRESSWIDTH-1 : 0] temporaryWordCountReg        ;
  logic [DATAWIDTH-1    : 0] temporaryReg;

  logic [DATAWIDTH-1    : 0] writeBuffer;
  logic [DATAWIDTH-1    : 0] readBuffer ;

  //logic [7 : 0] ioDataBuffer	   ;
  //logic [3 : 0] ioAddressBuffer	   ;
  //logic [3 : 0] outputAddressBuffer;

  logic internalFF;
  logic ld_baseAddressReg;
  logic rd_currentAddressReg;
  logic ld_baseWordCountReg;
  logic rd_currentWordCountReg;
  logic ld_commandReg;
  logic ld_modeReg;
  logic rd_statusReg;
  logic clear_internalFF;

  //always_comb
    //begin
      //Register Code for writing Base Address Register is CS_N=0, IOR_N=1, IOW_N=0, A3=0, A0=0. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      assign ld_baseAddressReg = (intSigIf.programCondition & !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & !cpuIf.A3 & !cpuIf.A0 & {cpuIf.A2, cpuIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for reading Current Address Register is CS_N=0, IOR_N=0, IOW_N=1, A3=0, A0=1. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      assign rd_currentAddressReg = (intSigIf.programCondition & !cpuIf.CS_N & !cpuIf.IOR_N & cpuIf.IOW_N & !cpuIf.A3 & cpuIf.A0 & {cpuIf.A2, cpuIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for writing Base Word Count Register is CS_N=0, IOR_N=1, IOW_N=0, A3=0, A0=1. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      assign ld_baseWordCountReg = (intSigIf.programCondition & !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & !cpuIf.A3 & cpuIf.A0 & {cpuIf.A2, cpuIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for reading Current Word Count Register is CS_N=0, IOR_N=0, IOW_N=1, A3=0, A0=1. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      assign rd_currentWordCountReg = (intSigIf.programCondition & !cpuIf.CS_N & !cpuIf.IOR_N & cpuIf.IOW_N & !cpuIf.A3 & cpuIf.A0 & {cpuIf.A2, cpuIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for writing Command Register is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A2=0 , A1=0 , A0=0.
      assign ld_commandReg = (intSigIf.programCondition & !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & cpuIf.A3 & !cpuIf.A2 & !cpuIf.A1 & !cpuIf.A0) ? 1'b1 : 1'b0;

      //Register Code for writing Mode Register is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A2=0 , A1=1 , A0=1.
      assign ld_modeReg = (intSigIf.programCondition & !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & cpuIf.A3 & !cpuIf.A2 & cpuIf.A1 & cpuIf.A0) ? 1'b1 : 1'b0;

      //Register Code for reading Status Register is CS_N=0, IOR_N=0, IOW_N=1, A3=1, A2=0 , A1=0 , A0=0.
      assign rd_statusReg = (intSigIf.programCondition & !cpuIf.CS_N & !cpuIf.IOR_N & cpuIf.IOW_N & cpuIf.A3 & !cpuIf.A2 & !cpuIf.A1 & !cpuIf.A0) ? 1'b1 : 1'b0;

      //Register Code for clearing Internal Flip Flop is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A2=1 , A1=0 , A0=0
      assign clear_internalFF = (intSigIf.programCondition & !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & cpuIf.A3 & cpuIf.A2 & !cpuIf.A1 & !cpuIf.A0) ? 1'b1 : 1'b0;

      //TO DO : IMMEDIATE Assertions
    //end

  //Command Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        intRegIf.commandReg <= '0;

      //write Command Register
      else if( ld_commandReg )
        intRegIf.commandReg <= cpuIf.DB;

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
      else if( ld_modeReg )
        intRegIf.modeReg[cpuIf.DB[1:0]] <= cpuIf.DB[7:2];

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

      //read Status Register
      else if( rd_statusReg )
        begin
          cpuIf.DB <= intRegIf.statusReg;

          //clear status reg after each read
          intRegIf.statusReg <= '0;
        end

      //update Status Register
      else if(intSigIf.intEOP) //TO DO : update condition
        begin
          intRegIf.statusReg.c3Request 	 <= cpuIf.DREQ[3];
          intRegIf.statusReg.c2Request 	 <= cpuIf.DREQ[2];
          intRegIf.statusReg.c1Request 	 <= cpuIf.DREQ[1];
          intRegIf.statusReg.c0Request 	 <= cpuIf.DREQ[0];
          intRegIf.statusReg.c3ReachedTC <= (!(|(currentWordCountReg[3]))) ? 1'b1 : 1'b0; //TO DO : Updated Current Word Count Reg
          intRegIf.statusReg.c2ReachedTC <= (!(|(currentWordCountReg[2]))) ? 1'b1 : 1'b0;
          intRegIf.statusReg.c1ReachedTC <= (!(|(currentWordCountReg[1]))) ? 1'b1 : 1'b0;
          intRegIf.statusReg.c0ReachedTC <= (!(|(currentWordCountReg[0]))) ? 1'b1 : 1'b0;
        end

      else
        intRegIf.statusReg <= intRegIf.statusReg;
    end

  //Temporary Address Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        intRegIf.temporaryAddressReg <= '0;

      else if(intSigIf.loadAddr)
        begin
          cpuIf.DB <= intRegIf.temporaryAddressReg[ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ];
          { cpuIf.A7, cpuIf.A6, cpuIf.A5, cpuIf.A4, cpuIf.A3, cpuIf.A2, cpuIf.A1, cpuIf.A0 } <= intRegIf.temporaryAddressReg[ ((ADDRESSWIDTH/2)-1) : 0 ];
        end

      else
        begin
          if(cpuIf.DACK[0])
            intRegIf.temporaryAddressReg <= currentAddressReg[0];

          else if(cpuIf.DACK[1])
            intRegIf.temporaryAddressReg <= currentAddressReg[1];

          else if(cpuIf.DACK[2])
            intRegIf.temporaryAddressReg <= currentAddressReg[2];

          else if(cpuIf.DACK[3])
            intRegIf.temporaryAddressReg <= currentAddressReg[3];

          else
            intRegIf.temporaryAddressReg <= intRegIf.temporaryAddressReg;
        end

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
      else if( ld_baseAddressReg )
        begin
          if(internalFF)
            baseAddressReg[{cpuIf.A2, cpuIf.A1}][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ] <= writeBuffer;
          else
            baseAddressReg[{cpuIf.A2, cpuIf.A1}][ ((ADDRESSWIDTH/2)-1) : 0 ] <= writeBuffer;
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
      else if( ld_baseAddressReg )
        begin
          if(internalFF)
            currentAddressReg[{cpuIf.A2, cpuIf.A1}][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ] <= writeBuffer;
          else
            currentAddressReg[{cpuIf.A2, cpuIf.A1}][ ((ADDRESSWIDTH/2)-1) : 0 ] <= writeBuffer;
        end

      //read Current Address Register

      else if( rd_currentAddressReg )
        begin
          if(internalFF)
            readBuffer <= currentAddressReg[{cpuIf.A2, cpuIf.A1}][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ];
          else
            readBuffer <= currentAddressReg[{cpuIf.A2, cpuIf.A1}][ ((ADDRESSWIDTH/2)-1) : 0 ];
        end

      else
        begin
          if(intSigIf.updateCurrentAddressReg && cpuIf.DACK[0])
            currentAddressReg[0] <= intRegIf.temporaryAddressReg;

          else if(intSigIf.updateCurrentAddressReg && cpuIf.DACK[1])
            currentAddressReg[1] <= intRegIf.temporaryAddressReg;

          else if(intSigIf.updateCurrentAddressReg && cpuIf.DACK[2])
            currentAddressReg[2] <= intRegIf.temporaryAddressReg;

          else if(intSigIf.updateCurrentAddressReg && cpuIf.DACK[3])
            currentAddressReg[3] <= intRegIf.temporaryAddressReg;

          else
            begin
              for(int i=0; i<=3; i=i+1)
                currentAddressReg[i] <= currentAddressReg[i];
            end

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
      else if( ld_baseWordCountReg )
        begin
          if(internalFF)
            baseWordCountReg[{cpuIf.A2, cpuIf.A1}][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ] <= writeBuffer;
          else
            baseWordCountReg[{cpuIf.A2, cpuIf.A1}][ ((ADDRESSWIDTH/2)-1) : 0 ] <= writeBuffer;
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
      else if( ld_baseWordCountReg )
        begin
          if(internalFF)
            currentWordCountReg[{cpuIf.A2, cpuIf.A1}][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ] <= writeBuffer;
          else
            currentWordCountReg[{cpuIf.A2, cpuIf.A1}][ ((ADDRESSWIDTH/2)-1) : 0 ] <= writeBuffer;
        end

      //read Current Word Count Register
      else if( rd_currentWordCountReg )
        begin
          if(internalFF)
            readBuffer <= currentWordCountReg[0][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ];
          else
            readBuffer <= currentWordCountReg[0][ ((ADDRESSWIDTH/2)-1) : 0 ];
        end

      else
        begin
          if(intSigIf.updateCurrentWordCountReg && cpuIf.DACK[0])
            currentWordCountReg[0] <= intRegIf.temporaryWordCountReg;

          else if(intSigIf.updateCurrentWordCountReg && cpuIf.DACK[1])
            currentWordCountReg[1] <= intRegIf.temporaryWordCountReg;

          else if(intSigIf.updateCurrentWordCountReg && cpuIf.DACK[2])
            currentWordCountReg[2] <= intRegIf.temporaryWordCountReg;

          else if(intSigIf.updateCurrentWordCountReg && cpuIf.DACK[3])
            currentWordCountReg[3] <= intRegIf.temporaryWordCountReg;

          else
            begin
              for(int i=0; i<=3; i=i+1)
                currentWordCountReg[i] <= currentWordCountReg[i];
            end

        end
    end

  //internal flip flop
  always_ff@(posedge cpuIf.CLK)
    begin
      if( clear_internalFF )
        internalFF <= 1'b0;
      else
        internalFF <= 1'b1;
    end

  //Write Buffer
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        writeBuffer <= '0;
      else if( ld_baseAddressReg | ld_baseWordCountReg | ld_commandReg | ld_modeReg )
        writeBuffer <= cpuIf.DB;
      else
        writeBuffer <= writeBuffer;
    end

  //read Buffer
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        readBuffer <= '0;
      else if( rd_currentAddressReg | rd_currentWordCountReg | rd_statusReg )
        cpuIf.DB <= readBuffer;
      else
        readBuffer <= readBuffer;
    end

endmodule
