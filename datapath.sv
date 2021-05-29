module datapath(cpuInterface cpuIf, dmaInternalRegistersIf intRegIf);

  import dmaInternalRegistersPkg :: baseAddress,
    dmaInternalRegistersPkg :: baseWordCount,
    dmaInternalRegistersPkg :: currentAddress,
    dmaInternalRegistersPkg :: currentWordCount,
    dmaInternalRegistersPkg :: temporaryAddress,
    dmaInternalRegistersPkg :: temporaryWordCount,
    dmaInternalRegistersPkg :: temporary;

  logic [7 : 0] writeBuffer;
  logic [7 : 0] readBuffer;

  logic [3 : 0] ioDataBuffer;
  logic [3 : 0] ioAddressBuffer;
  logic [3 : 0] outputAddressBuffer;

  logic internalFF;

  //write Command Register
  always_ff@(posedge cpuIF.CLK)
    begin
      if(cpuIF.RESET)
        intRegIf.command <= '0;
      else if()
        intRegIf.command <= ioDataBuffer;
      else
        intRegIf.command <= intRegIf.command;
    end

  //write Mode Register



  //write Request Register



  //write Status Register




  //write Base Address Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        begin
          baseAddress[0] <= '0;
          baseAddress[1] <= '0;
          baseAddress[2] <= '0;
          baseAddress[3] <= '0;
        end

      //write Base Address for Channel0
      else if()
        begin
          if(internalFF)
            baseAddress[0][15:8] <= writeBuffer;
          else
            baseAddress[0][7:0] <= writeBuffer;
        end

      //write Base Address for Channel1
      else if()
        begin
          if(internalFF)
            baseAddress[1][15:8] <= writeBuffer;
          else
            baseAddress[1][7:0] <= writeBuffer;
        end

      //write Base Address for Channel2
      else if()
        begin
          if(internalFF)
            baseAddress[2][15:8] <= writeBuffer;
          else
            baseAddress[2][7:0] <= writeBuffer;
        end

      //write Base Address for Channel3
      else if()
        begin
          if(internalFF)
            baseAddress[3][15:8] <= writeBuffer;
          else
            baseAddress[3][7:0] <= writeBuffer;
        end

      else
        begin
        end
    end

  //write Current Address Register
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        begin
          currentAddress[0] <= '0;
          currentAddress[1] <= '0;
          currentAddress[2] <= '0;
          currentAddress[3] <= '0;
        end

      //write Current Address for Channel0
      else if()
        begin
          if(internalFF)
            currentAddress[0][15:8] <= writeBuffer;
          else
            currentAddress[0][7:0] <= writeBuffer;
        end

      //write Current Address for Channel1
      else if()
        begin
          if(internalFF)
            currentAddress[1][15:8] <= writeBuffer;
          else
            currentAddress[1][7:0] <= writeBuffer;
        end

      //write Current Address for Channel2
      else if()
        begin
          if(internalFF)
            currentAddress[2][15:8] <= writeBuffer;
          else
            currentAddress[2][7:0] <= writeBuffer;
        end

      //write Current Address for Channel3
      else if()
        begin
          if(internalFF)
            currentAddress[3][15:8] <= writeBuffer;
          else
            currentAddress[3][7:0] <= writeBuffer;
        end

      else
        begin
        end
    end


  //read Current Address Register
  always_ff@(posedge cpuIf.CLK)
    begin
      //read Current Address for Channel0
      if()
        begin
          if(internalFF)
            readBuffer <= currentAddress[0][15:8];
          else
            readBuffer <= currentAddress[0][7:0];
        end

      //read Current Address for Channel1
      else if()
        begin
          if(internalFF)
            readBuffer <= currentAddress[1][15:8];
          else
            readBuffer <= currentAddress[1][7:0];
        end

      //read Current Address for Channel2
      else if()
        begin
          if(internalFF)
            readBuffer <= currentAddress[2][15:8];
          else
            readBuffer <= currentAddress[2][7:0];
        end

      //read Current Address for Channel3
      else if()
        begin
          if(internalFF)
            readBuffer <= currentAddress[3][15:8];
          else
            readBuffer <= currentAddress[3][7:0];
        end

      else
        begin
        end
    end

  //write Base Word Count
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        begin
          baseWordCount[0] <= '0;
          baseWordCount[1] <= '0;
          baseWordCount[2] <= '0;
          baseWordCount[3] <= '0;
        end

      //write Base Word Count for Channel0
      else if()
        begin
          if(internalFF)
            baseWordCount[0][15:8] <= writeBuffer;
          else
            baseWordCount[0][7:0] <= writeBuffer;
        end

      //write Base Word Count for Channel1
      else if()
        begin
          if(internalFF)
            baseWordCount[1][15:8] <= writeBuffer;
          else
            baseWordCount[1][7:0] <= writeBuffer;
        end

      //write Base Word Count for Channel2
      else if()
        begin
          if(internalFF)
            baseWordCount[2][15:8] <= writeBuffer;
          else
            baseWordCount[2][7:0] <= writeBuffer;
        end

      //write Base Word Count for Channel3
      else if()
        begin
          if(internalFF)
            baseWordCount[3][15:8] <= writeBuffer;
          else
            baseWordCount[3][7:0] <= writeBuffer;
        end

      else
        begin
        end
    end

  //write Current Word Count
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        begin
          currentWordCount[0] <= '0;
          currentWordCount[1] <= '0;
          currentWordCount[2] <= '0;
          currentWordCount[3] <= '0;
        end

      //write Current Word Count for Channel0
      else if()
        begin
          if(internalFF)
            currentWordCount[0][15:8] <= writeBuffer;
          else
            currentWordCount[0][7:0] <= writeBuffer;
        end

      //write Current Word Count for Channel1
      else if()
        begin
          if(internalFF)
            currentWordCount[1][15:8] <= writeBuffer;
          else
            currentWordCount[1][7:0] <= writeBuffer;
        end

      //write Current Word Count for Channel2
      else if()
        begin
          if(internalFF)
            currentWordCount[2][15:8] <= writeBuffer;
          else
            currentWordCount[2][7:0] <= writeBuffer;
        end

      //write Current Word Count for Channel3
      else if()
        begin
          if(internalFF)
            currentWordCount[3][15:8] <= writeBuffer;
          else
            currentWordCount[3][7:0] <= writeBuffer;
        end

      else
        begin
        end
    end

  //read Current Word Count
  always_ff@(posedge cpuIf.CLK)
    begin
      if(cpuIf.RESET)
        begin
          currentWordCount[0] <= '0;
          currentWordCount[1] <= '0;
          currentWordCount[2] <= '0;
          currentWordCount[3] <= '0;
        end

      //read Current Word Count for Channel0
      else if()
        begin
          if(internalFF)
            readBuffer <= currentWordCount[0][15:8];
          else
            readBuffer <= currentWordCount[0][7:0];
        end

      //read Current Word Count for Channel1
      else if()
        begin
          if(internalFF)
            readBuffer <= currentWordCount[1][15:8];
          else
            readBuffer <= currentWordCount[1][7:0];
        end

      //read Current Word Count for Channel2
      else if()
        begin
          if(internalFF)
            readBuffer <= currentWordCount[2][15:8];
          else
            readBuffer <= currentWordCount[2][7:0];
        end

      //read Current Word Count for Channel3
      else if()
        begin
          if(internalFF)
            readBuffer <= currentWordCount[3][15:8];
          else
            readBuffer <= currentWordCount[3][7:0];
        end

      else
        begin
        end
    end


endmodule
