import dmaRegConfigPkg :: *; //wildcard import
module cpu(busInterface.cpu cpu,
  input logic [DATAWIDTH-1:0] cmdData,
  input logic [DATAWIDTH-1:0] modeData,
  input logic [(ADDRESSWIDTH/2)-1:0] baseAddrLB,
  input logic [REGISTERADDRESS-1:0] baseChannelAddrLW,
  input logic [(ADDRESSWIDTH/2)-1:0] baseAddrHB,
  input logic [REGISTERADDRESS-1:0] baseChannelAddrHB,
  input logic [(ADDRESSWIDTH/2)-1:0]baseWordLB,
  input logic [REGISTERADDRESS-1:0] baseChannelWordLB,
  input logic [(ADDRESSWIDTH/2)-1:0] baseWordHB,
  input logic [REGISTERADDRESS-1:0] baseChannelWordHB,
  input logic intEOP);

  import dmaRegConfigPkg :: *; //wildcard import
  logic A3,A2,A1,A0;
  logic IOR_N;
  logic IOW_N;
  logic DB;
  //input logic CLK;
  //input logic RESET;
  //input logic HRQ;
  /*input logic intEOP;

  input logic [DATAWIDTH-1:0] cmdData;
  input logic [DATAWIDTH-1:0] modeData;
  input logic [(ADDRESSWIDTH/2)-1:0] baseAddrLB;
  input logic [REGISTERADDRESS-1:0] baseChannelAddrLW;
  input logic [(ADDRESSWIDTH/2)-1:0] baseAddrHB;
  input logic [REGISTERADDRESS-1:0] baseChannelAddrHB;
  input logic [(ADDRESSWIDTH/2)-1:0]baseWordLB;
  input logic [REGISTERADDRESS-1:0] baseChannelWordLB;
  input logic [(ADDRESSWIDTH/2)-1:0] baseWordHB;
  input logic [REGISTERADDRESS-1:0] baseChannelWordHB;*/


  //register configuration
  //output logic CS_N;
  //output logic IOR_N;
  //output logic IOW_N;
  //output logic A3;
  //output logic A2;
  //output logic A1;
  //output logic A0;
  //output logic HLDA;
  //output logic [DATAWIDTH-1:0] DB;
  logic[REGISTERADDRESS-1:0] regAddress;
  int waitState,count;

  logic handShake;
  logic [2:0] regCount;

  assign cpu.A3 = (!cpu.CS_N) ? A3 : 'bz;
  assign cpu.A2 = (!cpu.CS_N) ? A2 : 'bz;
  assign cpu.A1 = (!cpu.CS_N) ? A1 : 'bz;
  assign cpu.A0 = (!cpu.CS_N) ? A0 : 'bz;
  assign cpu.IOR_N = (!cpu.CS_N) ? IOR_N : 'bz;
  assign cpu.IOW_N = (!cpu.CS_N) ? IOW_N : 'bz;
  assign cpu.DB = (!cpu.CS_N) ? DB : 'bz;

  task ldCommandReg(logic [DATAWIDTH-1:0] cmdData);
    //command register
    cpu.CS_N ='0;
    {A3, A2, A1, A1} = 4'h8;
    IOR_N = '1;
    IOW_N ='0;
    DB = cmdData;
  endtask

  task ldModeReg(logic [DATAWIDTH-1:0] modeData);
    //mode register
    cpu.CS_N ='0;
    IOR_N = '1;
    IOW_N ='0;
    {A3, A2, A1, A1} = 4'hB;
    DB = modeData; //single transfer channel 0 write mode
    //DB<= 8'h48; //single transfer channel 0 read mode
  endtask


  task ldBaAddrLB(logic [REGISTERADDRESS-1:0] channelAddr, logic [(ADDRESSWIDTH/2)-1:0] lowerByte);
    //write base address & current address lower byte
    cpu.CS_N  = '0;
    IOR_N ='1;
    IOW_N ='0;
    {A3, A2, A1, A1} = channelAddr; //channel 0
    //{A3, A2, A1, A0} <= 4'h2; //channel 1
    DB =lowerByte;
  endtask

  task ldBaAddreHB(logic [REGISTERADDRESS-1:0] channelAddr,logic [(ADDRESSWIDTH/2)-1:0] higherByte);
    //write base address & current address higher byte
    cpu.CS_N = '0;
    IOR_N ='1;
    IOW_N ='0;
    {A3, A2, A1, A1} = channelAddr; //channel 0
    //{A3, A2, A1, A0} <= 4'h2; //channel 1
    DB<=higherByte;
  endtask

  task ldBaWordLB(logic [REGISTERADDRESS-1:0] channelAddr, logic [(ADDRESSWIDTH/2)-1:0] lowerByte);
    //base and current word lower byte
    cpu.CS_N = '0;
    IOR_N ='1;
    IOW_N ='0;
    {A3, A2, A1, A1} = channelAddr; //channel 0
    //{A3, A2, A1, A0} <= 4'h2; //channel 1
    DB <= lowerByte;
  endtask

  task ldBaWordHB(logic [REGISTERADDRESS-1:0] channelAddr,logic [(ADDRESSWIDTH/2)-1:0] higherByte);
    //base and current word higher byte

    cpu.CS_N = '0;
    IOR_N ='1;
    IOW_N ='0;
    {A3, A2, A1, A1} = channelAddr; //channel 0
    //{A3, A2, A1, A0} <= 4'h2; //channel 1
    DB = higherByte;
  endtask

  always_ff@(posedge cpu.CLK)
    begin
      if(cpu.RESET)
        begin
          cpu.HLDA<='0;
          count <='0;
        end
      else if(cpu.HRQ)
        count<=count+1;
      else
        count<=count;

      if( cpu.HRQ && count ==waitState)
        begin
          cpu.HLDA<='1;
          count <='0;
        end
      else if(cpu.HRQ && handShake=='1)
        begin
          cpu.HLDA<='1;
        end
      else
        cpu.HLDA = '0;
    end

  always_ff@(posedge cpu.CLK)
    begin
      if(cpu.RESET|| intEOP)
        regCount <= '0;
      else if(regCount!='1)
        regCount <= regCount+1'b1;
      else
        regCount <= regCount;

    end

  always_comb
    begin
      if(cpu.RESET)
        cpu.CS_N = '0;
      else
        begin
          unique case(regCount)
            1:ldCommandReg(cmdData);
            2:ldModeReg(modeData); //44 : channel 0 write;  48 : channel 0 read;
            3:ldBaAddrLB(baseChannelAddrLW, baseAddrLB);
            4:ldBaAddreHB(baseChannelAddrHB, baseAddrHB);
            5:ldBaWordLB(baseChannelWordLB, baseWordLB);
            6:ldBaWordHB(baseChannelWordHB, baseWordHB);
            7:cpu.CS_N = '1;
            default: cpu.CS_N = '1;
          endcase
        end
    end

  always_comb
    begin
      if(cpu.HRQ)
        begin
          waitState=$urandom_range(1,10);
          $display("%d",waitState);
        end
      else
        waitState ='0;
      if(cpu.HRQ && cpu.HLDA)
        handShake='1;
      else
        handShake ='0;
    end


endmodule
