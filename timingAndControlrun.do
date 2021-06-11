vlib work
vlog -reportprogress 300 -work work busInterface.sv
vlog -reportprogress 300 -work work datapath.sv
vlog -reportprogress 300 -work work dmaInternalRegistersIf.sv
vlog -reportprogress 300 -work work dmaInternalRegistersPkg.sv
vlog -reportprogress 300 -work work dmaInternalSignalsIf.sv
vlog -reportprogress 300 -work work dmaRegConfigPkg.sv
vlog -reportprogress 300 -work work priorityLogic.sv
vlog -reportprogress 300 -work work priorityLogicTB.sv
vlog -reportprogress 300 -work work TimingAndControlTB.sv
vlog -reportprogress 300 -work work TimingAndControl.sv
vsim -gui -voptargs=+acc work.timingAndControlTB
add wave -position 1 sim:/timingAndControlTB/*
add wave -position 3 sim:/timingAndControlTB/DUT/stateIndex
add wave -position 4 sim:/timingAndControlTB/DUT/state
add wave -position 5 sim:/timingAndControlTB/DUT/nextState
add wave -position 6 sim:/timingAndControlTB/intSigIf/programCondition
add wave -position 7 sim:/timingAndControlTB/busIf/DREQ
add wave -position 8 sim:/timingAndControlTB/busIf/HRQ
add wave -position 9 sim:/timingAndControlTB/busIf/HLDA
add wave -position 10 sim:/timingAndControlTB/busIf/AEN
add wave -position 11 sim:/timingAndControlTB/busIf/ADSTB
add wave -position 12 sim:/timingAndControlTB/intSigIf/loadAddr
add wave -position 13 sim:/timingAndControlTB/intSigIf/assertDACK
add wave -position 14 sim:/timingAndControlTB/busIf/DACK
add wave -position 15 sim:/timingAndControlTB/intSigIf/deassertDACK
add wave -position 16 sim:/timingAndControlTB/DUT/ior
add wave -position 17 sim:/timingAndControlTB/DUT/iow
add wave -position 18 sim:/timingAndControlTB/DUT/memr
add wave -position 19 sim:/timingAndControlTB/DUT/memw
add wave -position 20 sim:/timingAndControlTB/busIf/IOR_N
add wave -position 21 sim:/timingAndControlTB/busIf/IOW_N
add wave -position 22 sim:/timingAndControlTB/busIf/MEMR_N
add wave -position 23 sim:/timingAndControlTB/busIf/MEMW_N
add wave -position 24 sim:/timingAndControlTB/busIf/READY
add wave -position 25 sim:/timingAndControlTB/intSigIf/decrTemporaryWordCountReg
add wave -position 26 sim:/timingAndControlTB/intRegIf/temporaryWordCountReg
add wave -position 27 sim:/timingAndControlTB/intSigIf/incrTemporaryAddressReg
add wave -position 28 sim:/timingAndControlTB/intRegIf/temporaryAddressReg
add wave -position 29 sim:/timingAndControlTB/intSigIf/intEOP
add wave -position 30 sim:/timingAndControlTB/busIf/CS_N
add wave -position 31 sim:/timingAndControlTB/intRegIf/modeReg
add wave -position 32 sim:/timingAndControlTB/intSigIf/updateCurrentWordCountReg
add wave -position 33 sim:/timingAndControlTB/intSigIf/updateCurrentAddressReg
add wave -position 34 sim:/timingAndControlTB/busIf/EOP_N
run -all
