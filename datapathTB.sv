module datapathTB();

  bit CLK=0;
  bit RESET;
  always #5 CLK = ~CLK;

  logic ior;
  logic iow;
  logic [7:0] db;
  logic [3:0] address;


  cpuInterfaceTesting cpuIf(CLK, RESET);

  dmaInternalRegistersIf intRegIf(cpuIf.CLK, cpuIf.RESET);

  dmaInternalSignalsIf intSigIf(cpuIf.CLK, cpuIf.RESET);

  datapath tb(cpuIf.dataPath, intRegIf.dataPath, intSigIf.dataPath);

  assign cpuIf.DB = (!cpuIf.CS_N & cpuIf.HLDA) ? db : 'z;
  assign cpuIf.IOR_N = (ior)? 1'b1 : 1'b0;
  assign cpuIf.IOW_N = (iow)? 1'b1 : 1'b0;
  assign {cpuIf.A3, cpuIf.A2, cpuIf.A1, cpuIf.A0} = (!cpuIf.CS_N & cpuIf.HLDA) ? address : 'z;

  initial
    begin

      //reset
      @(negedge CLK) RESET = 1'b1;
      @(negedge CLK)
      begin
        cpuIf.CS_N = 1'b0;
        intSigIf.loadAddr = 1'b0;
      end
      @(negedge CLK) RESET = 1'b0;

      @(negedge CLK)
      begin
        cpuIf.CS_N = 1'b0;
        cpuIf.HLDA = 1'b1;
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
        //{intSigIf.programCondition, cpuIf.CS_N, cpuIf.IOR_N, cpuIf.IOW_N, cpuIf.A3, cpuIf.A2, cpuIf.A1, cpuIf.A0} = 8'b10101100;
      end

      repeat(2)@(negedge CLK);

      //write lower byte to base address register and Current Address Register
      @(negedge CLK)
      writeRegiter(7'b0100010, 8'b11001100);

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
      $finish();
    end

  task writeRegiter(logic [6 : 0]registerCode, data);
    {cpuIf.CS_N, ior, iow, address} = registerCode;
    $display("address = %b",address );
    db = data;
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #1000
    $finish;
  end
endmodule
