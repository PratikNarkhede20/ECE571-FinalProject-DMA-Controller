module memoryTB();
  parameter ADDRESSWIDTH=16;
  parameter DATAWIDTH=8;
  bit CLK;
  logic MEMR_N;
  logic MEMW_N;
  logic A0, A1, A2, A3, A4, A5, A6, A7;
  logic [(ADDRESSWIDTH/2)-1:0] addressHB;
  logic ADSTB;
  wire [DATAWIDTH-1:0] DB;
  logic [DATAWIDTH-1:0] dataIn;
  logic [DATAWIDTH-1:0] dataOut;

    always #5 CLK = ~CLK;


  memory memory(CLK,MEMR_N, MEMW_N , ADSTB, A0, A1, A2, A3, A4, A5, A6, A7, DB, addressHB );
  assign DB = (!MEMW_N) ? dataIn : 'bz;
//assign DB = dataIn;


  initial
    begin
      @(posedge CLK);
      MEMW_N='0;
      MEMR_N='1;
      ADSTB='1;
      {addressHB,A7,A6,A5,A4,A3,A2,A1,A0} = 16'h0005;
      dataIn= 8'h80;
      repeat(2)@(posedge CLK);
      MEMW_N='1;
      ADSTB='0;
      $display("%h",memory.mem[5]);
    end

  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      #100;
      $finish;
    end

endmodule
