interface dmaInternalRegistersIf(input logic CLK, RESET);

  struct packed{logic c0ReachedTC; //1 - Channel 0 has reached Terminal Count
                logic c1ReachedTC; //1 - Channel 1 has reached Terminal Count
                logic c2ReachedTC; //1 - Channel 2 has reached Terminal Count
                logic c3ReachedTC; //1 - Channel 3 has reached Terminal Count
                logic c0Request  ; //1 - Channel 0 Request
                logic c1Request  ; //1 - Channel 1 Request
                logic c2Request  ; //1 - Channel 2 Request
                logic c3Request  ; //1 - Channel 3 Request
               } statusReg;

  struct packed{logic memToMem      ; //0 - Memory to Memory disable, 1 - Memory to Memory enable
                logic c0AddressHold ; //0-Channel 0 address hold disabled,  1-Channel 0 address hold enable, X-if MemToMem=0
                logic controller    ; //0-Controller Enable, 1-Controller Disable
                logic timing        ; //0-Normal Timing, 1-Compressed Timing
                logic priorityType      ; //0-Fixed Priority, 1-Rotating Priority
                logic writeSelection; //0-Late Write Selection, 1-Extended Write Selection, X-if CompressedTiming=1
                logic dreqSense     ; //0-DREQ sense active high, 1-DREQ sense active low
                logic dackSense     ; //0-DACK sense active low, 1-DACK sense active high
               } commandReg;

  struct packed{logic [1 : 0] channelSelect     ; //00-Channel0, 01-Channel1, 10-Channel2, 11-Channel3
                logic [1 : 0] transferType      ; //00-Verify transfer, 01-Write Transfer, 10-Read Transfer, 11-illegal, XX-if ModeSelect=11
                logic         autoinitialization; //0-Autoinitialization Disable, 1-Autoinitialization Enable
                logic         addressSelect     ; //0-Address Increment select, 1-Address Drecement select
                logic [1 : 0] modeSelect        ; //00-Demand Mode , 01-Single Mode, 10-Block Mode, 11-Cascade Mode
               } modeReg [3 : 0];

  struct packed{logic c0Mask; //0-Clear Channel 0 mask bit, 1-Set Channel 0 mask bit
                logic c1Mask; //0-Clear Channel 0 mask bit, 1-Set Channel 0 mask bit
                logic c2Mask; //0-Clear Channel 0 mask bit, 1-Set Channel 0 mask bit
                logic c3Mask; //0-Clear Channel 0 mask bit, 1-Set Channel 0 mask bit
               } maskReg;

  struct packed{logic [1 : 0] channelSelect; //00-Select Channel0, 01-Select Channel1, 10-Select Channel2, 11-Select Channel3
                logic requestBit           ; //0-Reset Request bit, 1-Set Request bit
               } requestReg;

  modport PriorityLogic(
    input CLK,
    input RESET,
    input commandReg,
    input maskReg,
    input requestReg
  );

  modport TimingControl(
    input CLK,
    input RESET,
    input modeReg,
    input statusReg
  );

  modport DataPath(
    input CLK,
    input RESET,
    input commandReg,
    input modeReg,
    input requestReg);

endinterface
