module dma(cpuInterface cpuIf);

  import dmaRegConfigPkg :: *; //wildcard parameter package import;

  dmaInternalRegistersIf intRegIf (cpuIf.CLK, cpuIf.RESET);

  dmaInternalSignalsIf intSigIf (cpuIf.CLK, cpuIf.RESET);

  priorityLogic pL ( cpuIf.priorityLogic, intRegIf.priorityLogic, intSigIf.priorityLogic );

  timingAndControl tC ( cpuIf.timingAndControl, cpuIf.priorityLogic, intRegIf.timingAndControl, intSigIf.timingAndControl );

  datapath d ( cpuIf, intRegIf, intSigIf );


endmodule
