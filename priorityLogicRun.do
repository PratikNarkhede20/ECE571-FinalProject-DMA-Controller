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
vsim -gui -voptargs=+acc work.priorityLogicTB
add wave -position insertpoint  \
sim:/priorityLogicTB/CLK \
sim:/priorityLogicTB/RESET
add wave -position insertpoint  \
sim:/priorityLogicTB/busIf/DACK \
sim:/priorityLogicTB/busIf/DREQ
add wave -position insertpoint  \
sim:/priorityLogicTB/intRegIf/commandReg
add wave -position insertpoint  \
sim:/priorityLogicTB/intSigIf/assertDACK
add wave -position insertpoint  \
sim:/priorityLogicTB/tb/priorityOrder
run -all
