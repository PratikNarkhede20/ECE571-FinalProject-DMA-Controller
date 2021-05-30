module timingAndControl(CPUinterface.timingAndControl TCcpuIf, CPUinterface.priorityLogic PLcpuIf, dmaInternalRegistersIf.timingControl intRegIf, dmaInternalSignalsIf.timingControl intSigIf);

  enum {SIIndex = 0,
        SOIndex = 1,
        S1Index = 2,
        S2Index = 3,
        S3Index = 4,
        S4Index = 5} stateIndex;

  enum logic [5:0] {SI = 6'b000001 << SIIndex,
                    SO = 6'b000001 << SOIndex,
                    S1 = 6'b000001 << S1Index,
                    S2 = 6'b000001 << S2Index,
                    S3 = 6'b000001 << S3Index,
                    S4 = 6'b000001 << S4Index} state, nextState;

  //Reset Condition
  always_ff @(posedge CLK)
    begin
      if (RESET)
        state <= SI;
      else
        state <= nextState;
    end

  //Next state Logic
  always_comb
    begin
      nextState = state;
      unique case (1'b1)
        state[SIIndex]:	if (PLcpuIf.DREQ0 || PLcpuIf.DREQ1 || PLcpuIf.DREQ2 || PLcpuIf.DREQ3)
          nextState = SO;
        state[SOIndex]:	if (PLcpuIf.HLDA)
          nextState <= S1;
        else if (!extEOP)
          Next state <= SI;
        else
          nextState <= S0;
        state[S1Index]:	if (!extEOP)
          nextState <= SI;
        else
          nextState <= S2;
        state[S2Index]:	if (!extEOP)
          nextState <= SI;
        else
          nextState <= S4;
        state[S4Index]:
          nextState <= SI;
      endcase
    end

  always_comb
    begin
      {cpuIf.AEN, cpuIf.ADSTB, PLcpuIf.HRQ} = 3'b0;
      {cpuIf.MEMR_N, cpuIf.MEMW_N, cpuIf.IOR_N, cpuIf.IOW_N} = 4'bz;
      cpuIf.EOP_N = 1'b1;
      intSigIf.intEOP = 1'b0; intSigIf.loadAddr = 1'b0; intSigIf.assertDACK = 1'b0, intSigIf.deassertDACK = 1'b0;

      unique case (1'b1)

        state[SIIndex]:
          begin
            if(!cpuIf.CS_N && !PLcpuIf.HLDA)
              intSigIf.programCondition = 1'b1;
            {cpuIf.AEN, cpuIf.ADSTB, PLcpuIf.HRQ} = 3'b0;
            {cpuIf.MEMR_N, cpuIf.MEMW_N, cpuIf.IOR_N, cpuIf.IOW_N} = 4'bz;
            cpuIf.EOP_N = 1'b1;
            intSigIf.intEOP = 1'b0; intSigIf.loadAddr = 1'b0; intSigIf.assertDACK = 1'b0, intSigIf.deassertDACK = 1'b0;
          end

        state[SOIndex]:
        begin
          PLcpuIf.HRQ = 1'b1;
        end

        state[S1Index]:
        begin
          intSigIf.programCondition = 1'b0;
          {cpuIf.AEN, cpuIf.ADSTB, intSigIf.loadAddr, intSigIf.assertDACK} = 4'b1;
        end

        state[S2Index]:
        begin
          unique case (1'b1)

            PLcpuIf.DACK0:
            begin
              cpuIf.IOR_N = (intRegIf.modeReg[0].transferType == 2'b01)? 1'b0 : 1'bz;
              cpuIf.MEMW_N = (intRegIf.modeReg[0].transferType == 2'b01)? 1'b0 : 1'bz;
              cpuIf.IOW_N = (intRegIf.modeReg[0].transferType == 2'b10)? 1'b0 : 1'bz;
              cpuIf.MEMR_N = (intRegIf.modeReg[0].transferType == 2'b10)? 1'b0 : 1'bz;
            end

            PLcpuIf.DACK1:
            begin
              cpuIf.IOR_N = (intRegIf.modeReg[1].transferType == 2'b01)? 1'b0 : 1'bz;
              cpuIf.MEMW_N = (intRegIf.modeReg[1].transferType == 2'b01)? 1'b0 : 1'bz;
              cpuIf.IOW_N = (intRegIf.modeReg[1].transferType == 2'b10)? 1'b0 : 1'bz;
              cpuIf.MEMR_N = (intRegIf.modeReg[1].transferType == 2'b10)? 1'b0 : 1'bz;
            end

            PLcpuIf.DACK2:
            begin
              cpuIf.IOR_N = (intRegIf.modeReg[2].transferType == 2'b01)? 1'b0 : 1'bz;
              cpuIf.MEMW_N = (intRegIf.modeReg[2].transferType == 2'b01)? 1'b0 : 1'bz;
              cpuIf.IOW_N = (intRegIf.modeReg[2].transferType == 2'b10)? 1'b0 : 1'bz;
              cpuIf.MEMR_N = (intRegIf.modeReg[2].transferType == 2'b10)? 1'b0 : 1'bz;
            end

            PLcpuIf.DACK3:
            begin
              cpuIf.IOR_N = (intRegIf.modeReg[3].transferType == 2'b01)? 1'b0 : 1'bz;
              cpuIf.MEMW_N = (intRegIf.modeReg[3].transferType == 2'b01)? 1'b0 : 1'bz;
              cpuIf.IOW_N = (intRegIf.modeReg[3].transferType == 2'b10)? 1'b0 : 1'bz;
              cpuIf.MEMR_N = (intRegIf.modeReg[3].transferType == 2'b10)? 1'b0 : 1'bz;
            end

          endcase

        end

        state[S4Index]:
        begin
          cpuIf.IOR_N = (IOR_N == 1'b0)? 1'b1 : 1'bz;
          cpuIf.MEMW_N = (MEMW_N == 1'b0)? 1'b1 : 1'bz;
          cpuIf.IOW_N = (IOW_N == 1'b0)? 1'b1 : 1'bz;
          cpuIf.MEMR_N = (MEMR_N == 1'b0)? 1'b1 : 1'bz;

          intRegIf.temporaryWordCountReg = intRegIf.temporaryWordCountReg - 1'b1;
          intSigIf.updatecurrentWordCountReg = 1'b1;
          if (intRegIf.temporaryWordCountReg == 0)
            intSigIf.intEOP = 1'b1;

        end
      endcase
    end
endmodule
