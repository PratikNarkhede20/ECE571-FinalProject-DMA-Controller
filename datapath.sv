`include "dmaRegConfigPkg.sv"
module datapath(cpuInterface cpuIf, dmaInternalRegistersIf intRegIf, dmaInternalSignalsIf intSigIf);

  import dmaRegConfigPkg :: *; //wildcard import

  //internal register of DMA
  logic [ADDRESSWIDTH-1 : 0] baseAddressReg      [CHANNELS-1 : 0];
  logic [ADDRESSWIDTH-1 : 0] baseWordCountReg    [CHANNELS-1 : 0];
  logic [ADDRESSWIDTH-1 : 0] currentAddressReg   [CHANNELS-1 : 0];
  logic [ADDRESSWIDTH-1 : 0] currentWordCountReg [CHANNELS-1 : 0];
  //logic [ADDRESSWIDTH-1 : 0] temporaryAddressReg;
  //logic [ADDRESSWIDTH-1 : 0] temporaryWordCountReg;
  logic [DATAWIDTH-1    : 0] temporaryReg;

  //read and write buffer inside DMA
  logic [DATAWIDTH-1    : 0] writeBuffer;
  logic [DATAWIDTH-1    : 0] readBuffer ;

  //address and data buffers of DMA
  logic [DATAWIDTH-1 : 0]        ioDataBuffer       ;
  logic [(ADDRESSWIDTH/4)-1 : 0] ioAddressBuffer    ;
  logic [(ADDRESSWIDTH/4)-1 : 0] outputAddressBuffer;

  //internal flipflop
  logic internalFF;

  //internals signals used for design logic of DMA
  logic ldBaseAddressReg;
  logic rdCurrentAddressReg;
  logic ldBaseWordCountReg;
  logic rdCurrentWordCountReg;
  logic ldCommandReg;
  logic ldModeReg;
  logic rdStatusReg;
  logic clearInternalFF;
  bit enUpperAddress;


  //Data Buffer
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        ioDataBuffer <= '0;
      else if(!cpuIf.CS_N & !cpuIf.IOW_N)
        ioDataBuffer <= cpuIf.DB;
      else
        ioDataBuffer <= ioDataBuffer;
    end

  assign cpuIf.DB = (!cpuIf.CS_N & !cpuIf.IOR_N) ? ioDataBuffer : 'z;  //UNCOMMENT LATER

  //Address Buffer
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        ioAddressBuffer <= '0;
      else if(!cpuIf.CS_N & cpuIf.HLDA & intSigIf.loadAddr)
        ioAddressBuffer <= {cpuIf.A3, cpuIf.A2, cpuIf.A1, cpuIf.A0};
      else
        ioAddressBuffer <= ioAddressBuffer;
    end

  assign {cpuIf.A3, cpuIf.A2, cpuIf.A1, cpuIf.A0} = (!cpuIf.CS_N & cpuIf.HLDA & intSigIf.loadAddr) ? ioAddressBuffer : 4'bz;
  assign {cpuIf.A7, cpuIf.A6, cpuIf.A5, cpuIf.A4} = (!cpuIf.CS_N & cpuIf.HLDA & intSigIf.loadAddr) ? outputAddressBuffer : 4'bz;


  //register selection for configuration
  always_comb
    begin
      //Register Code for writing Base Address Register is CS_N=0, IOR_N=1, IOW_N=0, A3=0, A0=0. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      ldBaseAddressReg = (intSigIf.programCondition & !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & !cpuIf.A3 & !cpuIf.A0 & {cpuIf.A2, cpuIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for reading Current Address Register is CS_N=0, IOR_N=0, IOW_N=1, A3=0, A0=0. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      rdCurrentAddressReg = (intSigIf.programCondition & !cpuIf.CS_N & !cpuIf.IOR_N & cpuIf.IOW_N & !cpuIf.A3 & !cpuIf.A0 & {cpuIf.A2, cpuIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for writing Base Word Count Register is CS_N=0, IOR_N=1, IOW_N=0, A3=0, A0=1. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      ldBaseWordCountReg = (intSigIf.programCondition & !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & !cpuIf.A3 & cpuIf.A0 & {cpuIf.A2, cpuIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for reading Current Word Count Register is CS_N=0, IOR_N=0, IOW_N=1, A3=0, A0=1. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      rdCurrentWordCountReg = (intSigIf.programCondition & !cpuIf.CS_N & !cpuIf.IOR_N & cpuIf.IOW_N & !cpuIf.A3 & cpuIf.A0 & {cpuIf.A2, cpuIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for writing Command Register is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A2=0 , A1=0 , A0=0.
      ldCommandReg = (intSigIf.programCondition & !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & cpuIf.A3 & !cpuIf.A2 & !cpuIf.A1 & !cpuIf.A0) ? 1'b1 : 1'b0;

      //Register Code for writing Mode Register is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A2=0 , A1=1 , A0=1.
      ldModeReg = (intSigIf.programCondition & !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & cpuIf.A3 & !cpuIf.A2 & cpuIf.A1 & cpuIf.A0) ? 1'b1 : 1'b0;

      //Register Code for reading Status Register is CS_N=0, IOR_N=0, IOW_N=1, A3=1, A2=0 , A1=0 , A0=0.
      rdStatusReg = (intSigIf.programCondition & !cpuIf.CS_N & !cpuIf.IOR_N & cpuIf.IOW_N & cpuIf.A3 & !cpuIf.A2 & !cpuIf.A1 & !cpuIf.A0) ? 1'b1 : 1'b0;

      //Register Code for clearing Internal Flip Flop is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A2=1 , A1=0 , A0=0
      clearInternalFF = (intSigIf.programCondition & !cpuIf.CS_N & cpuIf.IOR_N & !cpuIf.IOW_N & cpuIf.A3 & cpuIf.A2 & !cpuIf.A1 & !cpuIf.A0) ? 1'b1 : 1'b0;


      singleRegisterConfig_a : assert ($onehot({ldBaseAddressReg, rdCurrentAddressReg, ldBaseWordCountReg, rdCurrentWordCountReg, ldCommandReg, ldModeReg, rdStatusReg, clearInternalFF}));
    end

  //Command Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        intRegIf.commandReg <= '0;

      //write Command Register
      else if( ldCommandReg )
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
      else if( ldModeReg )
        intRegIf.modeReg[ioDataBuffer[1 : 0]] <= ioDataBuffer[DATAWIDTH-1 : 2];

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
      else if( rdStatusReg )
        begin
          ioDataBuffer <= intRegIf.statusReg;

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

      else if(intSigIf.loadAddr) //update the condition to capture higher address bits
        begin
          ioDataBuffer <= intRegIf.temporaryAddressReg[ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ];
          {outputAddressBuffer, ioAddressBuffer} <= intRegIf.temporaryAddressReg[ ((ADDRESSWIDTH/2)-1) : 0 ];
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
            begin
              baseAddressReg[i] <= '0;
            end
        end

      //write Base Address Register
      else if( ldBaseAddressReg )
        begin
          if(internalFF)
            begin
              baseAddressReg[{cpuIf.A2, cpuIf.A1}][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ] <= writeBuffer;
              enUpperAddress <= '0;
            end
          else
            begin
              baseAddressReg[{cpuIf.A2, cpuIf.A1}][ ((ADDRESSWIDTH/2)-1) : 0 ] <= writeBuffer;
              enUpperAddress <= '1;
            end
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
      else if( ldBaseAddressReg )
        begin
          if(internalFF)
            begin
              currentAddressReg[{cpuIf.A2, cpuIf.A1}][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ] <= writeBuffer;
              enUpperAddress <= '0;
            end
          else
            begin
              currentAddressReg[{cpuIf.A2, cpuIf.A1}][ ((ADDRESSWIDTH/2)-1) : 0 ] <= writeBuffer;
              enUpperAddress <= '1;
            end
        end

      //read Current Address Register
      else if( rdCurrentAddressReg )
        begin
          if(internalFF)
            begin
              readBuffer <= currentAddressReg[{cpuIf.A2, cpuIf.A1}][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ];
              enUpperAddress <= '0;
            end
          else
            begin
              readBuffer <= currentAddressReg[{cpuIf.A2, cpuIf.A1}][ ((ADDRESSWIDTH/2)-1) : 0 ];
              enUpperAddress <= '1;
            end
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
      else if( ldBaseWordCountReg )
        begin
          if(internalFF)
            begin
              baseWordCountReg[{cpuIf.A2, cpuIf.A1}][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ] <= writeBuffer;
              enUpperAddress <= '0;
            end
          else
            begin
              baseWordCountReg[{cpuIf.A2, cpuIf.A1}][ ((ADDRESSWIDTH/2)-1) : 0 ] <= writeBuffer;
              enUpperAddress <= '1;
            end
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
      else if( ldBaseWordCountReg )
        begin
          if(internalFF)
            begin
              currentWordCountReg[{cpuIf.A2, cpuIf.A1}][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ] <= writeBuffer;
              enUpperAddress <= '0;
            end
          else
            begin
              currentWordCountReg[{cpuIf.A2, cpuIf.A1}][ ((ADDRESSWIDTH/2)-1) : 0 ] <= writeBuffer;
              enUpperAddress <= '1;
            end
        end

      //read Current Word Count Register
      else if( rdCurrentWordCountReg )
        begin
          if(internalFF)
            begin
              readBuffer <= currentWordCountReg[0][ (ADDRESSWIDTH-1) : (ADDRESSWIDTH/2) ];
              enUpperAddress <= '0;
            end
          else
            begin
              readBuffer <= currentWordCountReg[0][ ((ADDRESSWIDTH/2)-1) : 0 ];
              enUpperAddress <= '1;
            end
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

  //temporary address register
  always_ff @(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        intRegIf.temporaryAddressReg <= '0;

      else if(intSigIf.incrTemporaryAddressReg)
        intRegIf.temporaryAddressReg <= intRegIf.temporaryAddressReg + 1'b1;

      else
        intRegIf.temporaryAddressReg <= intRegIf.temporaryAddressReg;
    end

  //temporary word count
  always_ff @(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        intRegIf.temporaryWordCountReg <= '0;

      else if(intSigIf.decrTemporaryWordCountReg)
        intRegIf.temporaryWordCountReg <= intRegIf.temporaryWordCountReg - 1'b1;

      else
        intRegIf.temporaryWordCountReg <= intRegIf.temporaryWordCountReg;
    end

  //internal flip flop
  always_ff@(posedge cpuIf.CLK)
    begin
      if( cpuIf.RESET || clearInternalFF || !enUpperAddress)
        internalFF <= 1'b0;
      else if(enUpperAddress)
        internalFF <= 1'b1;
      else
        internalFF <= internalFF;
    end

  //Write Buffer
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        writeBuffer <= '0;
      else if( ldBaseAddressReg | ldBaseWordCountReg | ldCommandReg | ldModeReg )
        begin
          writeBuffer <= ioDataBuffer;
        end
      else
        writeBuffer <= writeBuffer;
    end

  //Read Buffer
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        readBuffer <= '0;
      else if( rdCurrentAddressReg | rdCurrentWordCountReg | rdStatusReg )
        begin
          ioDataBuffer <= readBuffer;
        end
      else
        readBuffer <= readBuffer;
    end

  //Output Address buffer
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        outputAddressBuffer <= '0;
      else
        outputAddressBuffer <= outputAddressBuffer;
    end

  final
  begin
    $display("baseAddressReg = %p", baseAddressReg);
    $display("baseWordCountReg = %p", baseWordCountReg);
    $display("currentAddressReg = %p", currentAddressReg);
    $display("currentWordCountReg = %p", currentWordCountReg);
    $display("temporaryReg = %p", temporaryReg);
    $display("writeBuffer = %p", writeBuffer);
    $display("readBuffer = %p", readBuffer);
  end

  //assertion to check if Command Register holds valid data
  property writeCommandRegister_p;
    @(posedge cpuIf.CLK)
    disable iff (cpuIf.RESET)
    (ldCommandReg) |=> (intRegIf.commandReg == $past(ioDataBuffer));
  endproperty

  writeCommandRegister_a : assert property (writeCommandRegister_p);


  //assertion to check if Command Register is zeroed on Reset
  property commandRegZeroOnReset_p;
    @(posedge cpuIf.CLK)
    (cpuIf.RESET) |=> (intRegIf.commandReg == '0);
  endproperty

  commandRegZeroOnReset_a : assert property (commandRegZeroOnReset_p);


    //assertion to check if Mode Register is zeroed on Reset
   property modeRegZeroOnReset_p;
    @(posedge cpuIf.CLK)
     (cpuIf.RESET) |=> (intRegIf.modeReg[0] == '0 and intRegIf.modeReg[1] == '0 and intRegIf.modeReg[2] == '0 and intRegIf.modeReg[3] == '0);
  endproperty

  modeRegZeroOnReset_a : assert property (modeRegZeroOnReset_p);


    //assertion to check if Base Address Register is zeroed on Reset
    property baseAddressRegZeroOnReset_p;
    @(posedge cpuIf.CLK)
     (cpuIf.RESET) |=> (baseAddressReg[0] == '0 and baseAddressReg[1] == '0 and baseAddressReg[2] == '0 and baseAddressReg[3] == '0);
  endproperty

  baseAddressRegZeroOnReset_a : assert property (baseAddressRegZeroOnReset_p);


    //assertion to check if Base Word Count Register is zeroed on Reset
    property baseWordCountRegZeroOnReset_p;
    @(posedge cpuIf.CLK)
      (cpuIf.RESET) |=> (baseWordCountReg[0] == '0 and baseWordCountReg[1] == '0 and baseWordCountReg[2] == '0 and baseWordCountReg[3] == '0);
  endproperty

  baseWordCountRegZeroOnReset_a : assert property (baseWordCountRegZeroOnReset_p);


    //assertion to check if Current Address Register is zeroed on Reset
    property currentAddressRegZeroOnReset_p;
    @(posedge cpuIf.CLK)
      (cpuIf.RESET) |=> (currentAddressReg[0] == '0 and currentAddressReg[1] == '0 and currentAddressReg[2] == '0 and currentAddressReg[3] == '0);
  endproperty

  currentAddressRegZeroOnReset_a : assert property (currentAddressRegZeroOnReset_p);


    //assertion to check if Current Word Count Register is zeroed on Reset
    property currentWordCountRegZeroOnReset_p;
    @(posedge cpuIf.CLK)
      (cpuIf.RESET) |=> (currentWordCountReg[0] == '0 and currentWordCountReg[1] == '0 and currentWordCountReg[2] == '0 and currentWordCountReg[3] == '0);
  endproperty

  currentWordCountRegZeroOnReset_a : assert property (currentWordCountRegZeroOnReset_p);


    //assertion to check if ioDataBuffer is zeroed on Reset
     property ioDataBufferZeroOnReset_p;
    @(posedge cpuIf.CLK)
       (cpuIf.RESET) |=> (ioDataBuffer == '0);
  endproperty

  ioDataBufferZeroOnReset_a : assert property (ioDataBufferZeroOnReset_p);


    //assertion to check if ioAddressBuffer is zeroed on Reset
    property ioAddressBufferZeroOnReset_p;
    @(posedge cpuIf.CLK)
       (cpuIf.RESET) |=> (ioAddressBuffer == '0);
  endproperty

  ioAddressBufferZeroOnReset_a : assert property (ioAddressBufferZeroOnReset_p);


    //assertion to check if outputAddressBuffer is zeroed on Reset
   property outputAddressBufferZeroOnReset_p;
    @(posedge cpuIf.CLK)
       (cpuIf.RESET) |=> (outputAddressBuffer == '0);
  endproperty

  outputAddressBufferZeroOnReset_a : assert property (outputAddressBufferZeroOnReset_p);


    endmodule
