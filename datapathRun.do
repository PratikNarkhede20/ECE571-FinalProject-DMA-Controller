vlib work
vlog -reportprogress 300 -work work dmaRegConfigPkg.sv
vlog -reportprogress 300 -work work dmaInternalRegistersPkg.sv
vlog -reportprogress 300 -work work dmaInternalRegistersIf.sv
vlog -reportprogress 300 -work work dmaInternalSignalsIf.sv
vlog -reportprogress 300 -work work environment.sv
vlog -reportprogress 300 -work work busInterface.sv
vlog -reportprogress 300 -work work cpu.sv
vlog -reportprogress 300 -work work dma.sv
vlog -reportprogress 300 -work work memory.sv
vlog -reportprogress 300 -work work datapath.sv
vlog -reportprogress 300 -work work peripheral.sv
vlog -reportprogress 300 -work work priorityLogic.sv
vlog -reportprogress 300 -work work timingAndControl.sv
vlog -reportprogress 300 -work work {subSystemLevel/modules/plAndtc.sv}
vlog -reportprogress 300 -work work environmentTB.sv
vlog -reportprogress 300 -work work dma.sv
vlog -reportprogress 300 -work work cpuTB.sv
vlog -reportprogress 300 -work work dmaTB.sv
vlog -reportprogress 300 -work work memoryTB.sv
vlog -reportprogress 300 -work work datapathTB.sv
vlog -reportprogress 300 -work work peripheralTB.sv
vlog -reportprogress 300 -work work priorityLogicTB.sv
vlog -reportprogress 300 -work work timingAndControlTB.sv
vlog -reportprogress 300 -work work {subSystemLevel/testbenches/plAndtcTB.sv}
vsim -gui -voptargs=+acc work.datapathTB
add wave -position insertpoint  \
sim:/datapathTB/busIf/A0 \
sim:/datapathTB/busIf/A1 \
sim:/datapathTB/busIf/A2 \
sim:/datapathTB/busIf/A3
add wave -position insertpoint  \
sim:/datapathTB/intRegIf/statusReg \
sim:/datapathTB/intRegIf/commandReg \
sim:/datapathTB/intRegIf/modeReg
add wave -position insertpoint  \
sim:/datapathTB/intRegIf/temporaryAddressReg \
sim:/datapathTB/intRegIf/temporaryWordCountReg
add wave -position insertpoint  \
sim:/datapathTB/tb/baseAddressReg \
sim:/datapathTB/tb/baseWordCountReg \
sim:/datapathTB/tb/currentAddressReg \
sim:/datapathTB/tb/currentWordCountReg
add wave -position insertpoint  \
sim:/datapathTB/tb/writeBuffer \
sim:/datapathTB/tb/readBuffer \
sim:/datapathTB/tb/ioDataBuffer \
sim:/datapathTB/tb/ioAddressBuffer \
sim:/datapathTB/tb/outputAddressBuffer \
sim:/datapathTB/tb/internalFF \
sim:/datapathTB/tb/ldBaseAddressReg \
sim:/datapathTB/tb/rdCurrentAddressReg \
sim:/datapathTB/tb/ldBaseWordCountReg \
sim:/datapathTB/tb/rdCurrentWordCountReg \
sim:/datapathTB/tb/ldCommandReg \
sim:/datapathTB/tb/ldModeReg \
sim:/datapathTB/tb/rdStatusReg \
sim:/datapathTB/tb/clearInternalFF \
sim:/datapathTB/tb/enUpperAddress
run -all
