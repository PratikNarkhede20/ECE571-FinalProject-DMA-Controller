module datapathTB();

  bit CLK=0;
  bit RESET;
  always #5 CLK = ~CLK;

  logic ior;
  logic iow;
  logic [7:0] db;
  logic [3:0] address;


  busInterface busIf(CLK, RESET);

  dmaInternalRegistersIf intRegIf(busIf.CLK, busIf.RESET);

  dmaInternalSignalsIf intSigIf(busIf.CLK, busIf.RESET);

  datapath tb(busIf.dataPath, intRegIf.dataPath, intSigIf.dataPath);

  assign busIf.DB = (!busIf.CS_N & busIf.HLDA) ? db : 'z;
  assign busIf.IOR_N = (ior)? 1'b1 : 1'b0;
  assign busIf.IOW_N = (iow)? 1'b1 : 1'b0;
  assign {busIf.A3, busIf.A2, busIf.A1, busIf.A0} = (!busIf.CS_N & busIf.HLDA) ? address : 'z;

  initial
    begin

      //reset
      @(negedge CLK) RESET = 1'b1;
      @(negedge CLK)
      begin
        busIf.CS_N = 1'b0;
        intSigIf.loadAddr = 1'b0;
      end
      @(negedge CLK) RESET = 1'b0;

      @(negedge CLK)
      begin
        busIf.CS_N = 1'b0;
        busIf.HLDA = 1'b1;
        intSigIf.programCondition = 1'b1;
      end

      //command register
      @(negedge CLK)
      writeRegiter(7'b0101000, 8'b10101010);

      repeat(2)@(negedge CLK);

      //mode register
      @(negedge CLK)
      writeRegiter(7'b0101011, 8'b11101110);


      //clear internal flipflop
      @(negedge CLK)
      begin
        //{intSigIf.programCondition, busIf.CS_N, busIf.IOR_N, busIf.IOW_N, busIf.A3, busIf.A2, busIf.A1, busIf.A0} = 8'b10101100;
        {busIf.CS_N, ior, iow, address} = 7'b0101100;
      end

      repeat(2)@(negedge CLK);

      //write lower byte to base address register and Current Address Register
      @(negedge CLK)
      writeRegiter(7'b0100010, 8'b00010001);

      repeat(2)@(negedge CLK);

      //write upper byte to base address register and Current Address Register
      @(negedge CLK)
      writeRegiter(7'b0100010, 8'b10001000);

      repeat(2)@(negedge CLK);

      //write lower byte to base word register and Current word Register
      @(negedge CLK)
      writeRegiter(7'b0100101, 8'b11110101);

      repeat(2)@(negedge CLK);

      //write upper byte to base word register and Current word Register
      @(negedge CLK)
      writeRegiter(7'b0100101, 8'b10110010);

      repeat(2)@(negedge CLK);

      //read lower byte of Current Address Register
      @(negedge CLK)
      readRegiter(7'b0010010);

      repeat(2)@(negedge CLK);

      //read upper byte of Current Address Register
      @(negedge CLK)
      readRegiter(7'b0010010);

      repeat(2)@(negedge CLK);

      $finish();
    end

  task writeRegiter(logic [6 : 0]registerCode, logic [7 : 0]data);
    {busIf.CS_N, ior, iow, address} = registerCode;
    db = data;
  endtask

  task readRegiter(logic [6 : 0]registerCode);
    {busIf.CS_N, ior, iow, address} = registerCode;
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #1000
    $finish;
  end
endmodule
