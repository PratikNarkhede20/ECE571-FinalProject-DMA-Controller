module TimingAndControl(CPUinterface.TimingControl cpuIf, dmaInternalRegistersIf.TimingControl intRegIf);

  logic ProgramCondition = 1'b0; //INTERNAL SIGNAL
  logic HLDA; //INTERNAL SIGNAL
  logic HRQ; //INTERNAL SIGNAL
  logic LoadAddr; //INTERNAL SIGNAL
  logic LoadDACK; //INTERNAL SIGNAL
  logic DREQ0, DREQ1, DREQ2, DREQ3; //INTERNAL SIGNAL
  logic intEOP; //INTERNAL SIGNAL

  enum {SIIndex = 0,
        SOIndex = 1,
        S1Index = 2,
        S2Index = 3,
        S3Index = 4,
        S4Index = 5} StateIndex;

  enum logic [5:0] {SI = 6'b000001 << SIIndex,
                    SO = 6'b000001 << SOIndex,
                    S1 = 6'b000001 << S1Index,
                    S2 = 6'b000001 << S2Index,
                    S3 = 6'b000001 << S3Index,
                    S4 = 6'b000001 << S4Index} State, NextState;

  //Reset Condition
  always_ff @(posedge CLK)
    begin
      if (Reset)
        State <= SI;
      else
        State <= NextState;
    end

  //Next State Logic
  always_comb
    begin
      NextState = State;
      unique case (1'b1)
        State[SIIndex]:	if (DREQ0 || DREQ1 || DREQ2 || DREQ3)
          NextState = SO;
        State[SOIndex]:	if (HLDA)
          NextState <= S1;
        else if (!extEOP)
          Next State <= SI;
        else
          NextState <= S0;
        State[S1Index]:	if (!extEOP)
          NextState <= SI;
        else
          NextState <= S2;
        State[S2Index]:	if (!extEOP)
          NextState <= SI;
        else
          NextState <= S4;
        State[S4Index]:
          NextState <= SI;
      endcase
    end

  always_comb
    begin
      {/*Insert FSM outputs*/} = 4'b0;
      unique case (1'b1)

        State[SIIndex]:
          begin
            if(!cpuIf.CS_N && !HLDA)
              ProgramCondition = 1'b1;
            {cpuIf.AEN, cpuIf.ADSTB, cpuIf.HRQ} = 3'b0;
            {cpuIf.MEMR_N, cpuIf.MEMW_N, cpuIf.IOR_N, cpuIf.IOW_N} = 4'bz;
            cpuIf.EOP_N = 1'b1;
            {cpuIf.DACK0, cpuIf.DACK1, cpuIf.DACK2, cpuIf.DACK3} = 4'b0;
          end

        State[SOIndex]:
        begin
          HRQ = 1'b1;
        end

        State[S1Index]:
        begin
          ProgramCondition = 1'b0;
          {cpuIf.AEN, cpuIf.ADSTB, LoadAddr, LoadDACK} = 4'b1;
        end

        State[S2Index]:
        begin
          unique case (1'b1)

            DACK0:
            begin
              cpuIf.IOR_N = (intRegIf.mode[0].transferType == 2'b01)? 1'b0 : 1'bz;
              assign cpuIf.MEMW_N = (intRegIf.mode[0].transferType == 2'b01)? 1'b0 : 1'bz;
              assign cpuIf.IOW_N = (intRegIf.mode[0].transferType == 2'b10)? 1'b0 : 1'bz;
              assign cpuIf.MEMR_N = (intRegIf.mode[0].transferType == 2'b10)? 1'b0 : 1'bz;
            end

            DACK1:
            begin
              assign cpuIf.IOR_N = (intRegIf.mode[1].transferType == 2'b01)? 1'b0 : 1'bz;
              assign cpuIf.MEMW_N = (intRegIf.mode[1].transferType == 2'b01)? 1'b0 : 1'bz;
              assign cpuIf.IOW_N = (intRegIf.mode[1].transferType == 2'b10)? 1'b0 : 1'bz;
              assign cpuIf.MEMR_N = (intRegIf.mode[1].transferType == 2'b10)? 1'b0 : 1'bz;
            end

            DACK2:
            begin
              assign cpuIf.IOR_N = (intRegIf.mode[2].transferType == 2'b01)? 1'b0 : 1'bz;
              assign cpuIf.MEMW_N = (intRegIf.mode[2].transferType == 2'b01)? 1'b0 : 1'bz;
              assign cpuIf.IOW_N = (intRegIf.mode[2].transferType == 2'b10)? 1'b0 : 1'bz;
              assign cpuIf.MEMR_N = (intRegIf.mode[2].transferType == 2'b10)? 1'b0 : 1'bz;
            end

            DACK3:
            begin
              assign cpuIf.IOR_N = (intRegIf.mode[3].transferType == 2'b01)? 1'b0 : 1'bz;
              assign cpuIf.MEMW_N = (intRegIf.mode[3].transferType == 2'b01)? 1'b0 : 1'bz;
              assign cpuIf.IOW_N = (intRegIf.mode[3].transferType == 2'b10)? 1'b0 : 1'bz;
              assign cpuIf.MEMR_N = (intRegIf.mode[3].transferType == 2'b10)? 1'b0 : 1'bz;
            end

          endcase

        end

        State[S4Index]:
        begin
          assign cpuIf.IOR_N = (IOR_N == 1'b0)? 1'b1 : 1'bz;
          assign cpuIf.MEMW_N = (MEMW_N == 1'b0)? 1'b1 : 1'bz;
          assign cpuIf.IOW_N = (IOW_N == 1'b0)? 1'b1 : 1'bz;
          assign cpuIf.MEMR_N = (MEMR_N == 1'b0)? 1'b1 : 1'bz;

          intRegIf.temporaryWordCount = intRegIf.temporaryWordCount - 1'b1;
          if (intRegIf.temporaryWordCount == 0)
            intEOP = 1'b1;

        end
      endcase
    end
endmodule
