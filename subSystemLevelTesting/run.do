vlog -reportprogress 300 -work work busInterface.sv
vlog -reportprogress 300 -work work datapath.sv
vlog -reportprogress 300 -work work datapathTB.sv
vlog -reportprogress 300 -work work dmaInternalRegistersIf.sv
vlog -reportprogress 300 -work work dmaInternalRegistersPkg.sv
vlog -reportprogress 300 -work work dmaInternalSignalsIf.sv
vlog -reportprogress 300 -work work dmaRegConfigPkg.sv
vlog -reportprogress 300 -work work priorityLogic.sv
vlog -reportprogress 300 -work work priorityLogicTB.sv
vlog -reportprogress 300 -work work timingAndControl.sv
vlog -reportprogress 300 -work work timingAndControlTB.sv
vlog -reportprogress 300 -work work {subSystemLevelTesting/modules/plAndtc.sv}
vlog -reportprogress 300 -work work {subSystemLevelTesting/testbenches/plAndtcTB.sv}
vlog -reportprogress 300 -work work {subSystemLevelTesting/modules/dma.sv}
vlog -reportprogress 300 -work work {subSystemLevelTesting/testbenches/dmaTB.sv}
vsim -gui -voptargs=+acc work.top
add wave -position 1 sim:/top/*
add wave -position 3 sim:/top/DUT/tC/stateIndex
add wave -position 4 sim:/top/DUT/tC/state
add wave -position 5 sim:/top/DUT/tC/nextState
add wave -position 6 sim:/top/DUT/tC/intSigIf/programCondition
add wave -position 7 sim:/top/cpuIf/DREQ
add wave -position 8 sim:/top/cpuIf/HRQ
add wave -position 9 sim:/top/cpuIf/HLDA
add wave -position 10 sim:/top/cpuIf/AEN
add wave -position 11 sim:/top/cpuIf/ADSTB
add wave -position 12 sim:/top/DUT/intSigIf/loadAddr
add wave -position 13 sim:/top/DUT/intSigIf/assertDACK
add wave -position 14 sim:/top/cpuIf/DACK
add wave -position 15 sim:/top/DUT/tC/ior
add wave -position 16 sim:/top/DUT/tC/iow
add wave -position 17 sim:/top/DUT/tC/memr
add wave -position 18 sim:/top/DUT/tC/memw
add wave -position 19 sim:/top/DUT/cpuIf/IOR_N
add wave -position 20 sim:/top/DUT/cpuIf/IOW_N
add wave -position 21 sim:/top/DUT/cpuIf/MEMR_N
add wave -position 22 sim:/top/DUT/cpuIf/MEMW_N
add wave -position 23 sim:/top/DUT/intSigIf/decrTemporaryWordCountReg
add wave -position 24 sim:/top/DUT/intRegIf/temporaryWordCountReg
add wave -position 25 sim:/top/DUT/intSigIf/incrTemporaryAddressReg
add wave -position 26 sim:/top/DUT/intRegIf/temporaryAddressReg
add wave -position 27 sim:/top/DUT/intRegIf/commandReg
add wave -position 28 sim:/top/DUT/intSigIf/intEOP
add wave -position 29 sim:/top/DUT/tC/configured
add wave -position 30 sim:/top/cpuIf/CS_N
add wave -position 31 sim:/top/DUT/intRegIf/modeReg
add wave -position 32 sim:/top/DUT/intSigIf/updateCurrentWordCountReg
add wave -position 33 sim:/top/DUT/intSigIf/updateCurrentAddressReg
add wave -position 34 sim:/top/cpuIf/EOP_N
run -all
