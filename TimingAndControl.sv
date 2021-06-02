`include "dmaInternalRegistersIf.sv"
`include "cpuInterface.sv"
`include "dmaInternalSignalsIf.sv"
`include "dmaInternalRegistersPkg.sv"
module timingAndControl(cpuInterface.timingAndControl TCcpuIf, cpuInterface.priorityLogic PLcpuIf, dmaInternalRegistersIf.timingAndControl intRegIf, dmaInternalSignalsIf.timingAndControl intSigIf);

//Flags
  logic ior;
  logic iow;
  logic memr;
  logic memw;

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
  always_ff @(posedge TCcpuIf.CLK)
    begin
      if (TCcpuIf.RESET)
        state <= SI;
      else
        state <= nextState;
    end

    assign cpuIf.IOR_N = (ior)? 1'b0 : 1'bz;
    assign cpuIf.MEMW_N = (memw)? 1'b0 : 1'bz;
    assign cpuIf.IOW_N = (iow)? 1'b0 : 1'bz;
    assign cpuIf.MEMR_N = (memr)? 1'b0 : 1'bz;

  //Next state Logic
  always_comb
    begin
      nextState = state;
      unique case (1'b1)
        state[SIIndex]:	if (|PLcpuIf.DREQ)
          nextState = SO;
        state[SOIndex]:	if (PLcpuIf.HLDA)
          nextState = S1;
        state[S1Index]:
          nextState = S2;
        state[S2Index]:
          nextState = S4;
        state[S4Index]:
          nextState = SI;
      endcase
    end

  always_comb
    begin
      {cpuIf.AEN, cpuIf.ADSTB, PLcpuIf.HRQ} = 3'b0;
      //{cpuIf.MEMR_N, cpuIf.MEMW_N, cpuIf.IOR_N, cpuIf.IOW_N} = 4'bz;
      //cpuIf.EOP_N = 1'b1;
      intSigIf.intEOP = 1'b0;
      intSigIf.loadAddr = 1'b0;
      intSigIf.assertDACK = 1'b0;
      //intSigIf.deassertDACK = 1'b0;
      intSigIf.updateCurrentWordCountReg = 1'b0;
      intSigIf.updateCurrentAddressReg = 1'b0;

      unique case (1'b1)

        state[SIIndex]:
          begin
            if(!cpuIf.CS_N && !PLcpuIf.HLDA)
              intSigIf.programCondition = 1'b1;
            {cpuIf.AEN, cpuIf.ADSTB, PLcpuIf.HRQ} = 3'b0;
            {ior,memw,iow,memr} = 4'b0000;
            intSigIf.intEOP = 1'b0; intSigIf.loadAddr = 1'b0; intSigIf.assertDACK = 1'b0; //intSigIf.deassertDACK = 1'b0;
            intSigIf.updateCurrentWordCountReg = 1'b0;
            intSigIf.updateCurrentAddressReg = 1'b0;
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

              PLcpuIf.DACK[0]:
                begin
                  {ior,memw,iow,memr} = 4'b0000;
                  unique case (intRegIf.modeReg[0].transferType)
                    2'b01: begin ior = 1'b1; memw = 1'b1; end
                    2'b10: begin iow = 1'b1; memr = 1'b1; end
                  endcase
                end

              PLcpuIf.DACK[1]:
                begin
                  {ior,memw,iow,memr} = 4'b0000;
                  unique case (intRegIf.modeReg[1].transferType)
                    2'b01: begin ior = 1'b1; memw = 1'b1; end
                    2'b10: begin iow = 1'b1; memr = 1'b1; end
                  endcase
                end

              PLcpuIf.DACK[2]:
                begin
                  {ior,memw,iow,memr} = 4'b0000;
                  unique case (intRegIf.modeReg[2].transferType)
                    2'b01: begin ior = 1'b1; memw = 1'b1; end
                    2'b10: begin iow = 1'b1; memr = 1'b1; end
                  endcase
                end

              PLcpuIf.DACK[3]:
                begin
                  {ior,memw,iow,memr} = 4'b0000;
                  unique case (intRegIf.modeReg[3].transferType)
                    2'b01: begin ior = 1'b1; memw = 1'b1; end
                    2'b10: begin iow = 1'b1; memr = 1'b1; end
                  endcase
                end

            endcase

          end

        state[S4Index]:
          begin
            {ior,memw,iow,memr} = 4'b0000;
            
            intRegIf.temporaryWordCountReg = intRegIf.temporaryWordCountReg - 1'b1;
            intSigIf.updateCurrentWordCountReg = 1'b1;
            if (intRegIf.temporaryWordCountReg == 0)
              intSigIf.intEOP = 1'b1;

            intRegIf.temporaryAddressReg = intRegIf.temporaryAddressReg + 1'b1;
            intSigIf.updateCurrentAddressReg = 1'b1;

          end
      endcase
    end
endmodule
