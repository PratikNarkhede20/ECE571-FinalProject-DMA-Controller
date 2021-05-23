package InternalRegisters;

logic [15 : 0] BaseAddress        [3 : 0];
logic [15 : 0] BaseWordCount      [3 : 0];
logic [15 : 0] CurrentAddress     [3 : 0];
logic [15 : 0] CurrentWordCount   [3 : 0];
logic [15 : 0] TemporaryAddress          ;
logic [15 : 0] TemporaryWordCount        ;
logic [7  : 0] Temporary                 ;

struct packed{logic C0ReachedTC; //1 - Channel 0 has reached Terminal Count
              logic C1ReachedTC; //1 - Channel 1 has reached Terminal Count
              logic C2ReachedTC; //1 - Channel 2 has reached Terminal Count
              logic C3ReachedTC; //1 - Channel 3 has reached Terminal Count
              logic C0Request  ; //1 - Channel 0 Request
              logic C1Request  ; //1 - Channel 1 Request
              logic C2Request  ; //1 - Channel 2 Request
              logic C3Request  ; //1 - Channel 3 Request
             }Status;

struct packed{logic MemToMem      ; //0 - Memory to Memory disable, 1 - Memory to Memory enable
              logic C0AddressHold ; //0-Channel 0 address hold disabled,  1-Channel 0 address hold enable, X-if MemToMem=0
              logic Controller    ; //0-Controller Enable, 1-Controller Disable
              logic Timing        ; //0-Normal Timing, 1-Compressed Timing
              logic Priority      ; //0-Fixed Priority, 1-Rotating Priority
              logic WriteSelection; //0-Late Write Selection, 1-Extended Write Selection, X-if CompressedTiming=1
              logic DREQSense     ; //0-DREQ sense active high, 1-DREQ sense active low
              logic DACKSense     ; //0-DACK sense active low, 1-DACK sense active high
             } Command;

struct packed{logic [1 : 0] ChannelSelect     ; //00-Channel0, 01-Channel1, 10-Channel2, 11-Channel3
              logic [1 : 0] TransferType      ; //00-Verify transfer, 01-Write Transfer, 10-Read Transfer, 11-illegal, XX-if ModeSelect=11
              logic         Autoinitialization; //0-Autoinitialization Disable, 1-Autoinitialization Enable
              logic         AddressSelect     ; //0-Address Increment select, 1-Address Drecement select
              logic [1 : 0] ModeSelect        ; //00-Demand Mode , 01-Single Mode, 10-Block Mode, 11-Cascade Mode
             } Mode;

struct packed{logic C0Mask; //0-Clear Channel 0 mask bit, 1-Set Channel 0 mask bit
              logic C1Mask; //0-Clear Channel 0 mask bit, 1-Set Channel 0 mask bit
              logic C2Mask; //0-Clear Channel 0 mask bit, 1-Set Channel 0 mask bit
              logic C3Mask; //0-Clear Channel 0 mask bit, 1-Set Channel 0 mask bit
             } Mask;

struct packed{logic [1 : 0] ChannelSelect; //00-Selecr Channel0, 01-Select Channel1, 10-Select Channel2, 11-Select Channel3
              logic RequestBit           ; //0-Reset Request bit, 1-Set Request bit
             } Request;
endpackage
