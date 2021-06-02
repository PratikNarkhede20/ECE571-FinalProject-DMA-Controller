module priorityLogic(cpuInterface.dataPath cpuIf, dmaInternalRegistersIf.dataPath intRegIf, dmaInternalSignalsIf intSigIf);

  logic [3:0][1:0] priorityOrder = 8'b11_10_01_00;

  always_comb
    begin

      //commandReg.priorityType=0 is Fixed Priority. commandReg.priorityType=1 is Rotating Priority

      //Fixed Priority
      if(!intRegIf.commandReg.priorityType && intSigIf.assertDACK)
        begin
          priority case(1'b1)
            cpuIf.DREQ[0] : cpuIf.DACK = 4'b0001 << 0;
            cpuIf.DREQ[1] : cpuIf.DACK = 4'b0001 << 1;
            cpuIf.DREQ[2] : cpuIf.DACK = 4'b0001 << 2;
            cpuIf.DREQ[3] : cpuIf.DACK = 4'b0001 << 3;
          endcase
        end

      //Rotating Priority
      else if(intRegIf.commandReg.priorityType && intSigIf.assertDACK)
        begin
          priority case(1'b1)

            cpuIf.DREQ[priorityOrder[0]]:
              begin
                cpuIf.DACK = 4'b0001 << priorityOrder[0];
                priorityOrder = {priorityOrder[0], priorityOrder[3:1]};
              end

            cpuIf.DREQ[priorityOrder[1]]:
              begin
                cpuIf.DACK = 4'b0001 << priorityOrder[1];
                priorityOrder = {priorityOrder[1:0], priorityOrder[3:2]};
              end

            cpuIf.DREQ[priorityOrder[2]]:
              begin
                cpuIf.DACK = 4'b0001 << priorityOrder[2];
                priorityOrder =  {priorityOrder[2:0], priorityOrder[3]};
              end

            cpuIf.DREQ[priorityOrder[3]]:
              begin
                cpuIf.DACK = 4'b0001 << priorityOrder[3];
                priorityOrder = priorityOrder;
              end

            default: cpuIf.DACK = 4'b0000;

          endcase
        end

      else
        cpuIf.DACK = 4'b0000;
    end
endmodule
