vlog -reportprogress 300 -work work cpuInterface.sv
vlog -reportprogress 300 -work work cpuInterfaceTesting.sv
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
vlog -reportprogress 300 -work work {/subSystemLevelTesting/modules/plAndtc.sv}
vlog -reportprogress 300 -work work {/subSystemLevelTesting/testbenches/plAndtcTB.sv}
vsim -gui -voptargs=+acc work.top
add wave -position 1 sim:/top/*
add wave -position 3 sim:/top/DUT/stateIndex
add wave -position 4 sim:/top/DUT/state
add wave -position 5 sim:/top/DUT/nextState
add wave -position 6 sim:/top/intSigIf/programCondition
add wave -position 7 sim:/top/cpuIf/DREQ
add wave -position 8 sim:/top/cpuIf/HRQ
add wave -position 9 sim:/top/cpuIf/HLDA
add wave -position 10 sim:/top/cpuIf/AEN
add wave -position 11 sim:/top/cpuIf/ADSTB
add wave -position 12 sim:/top/intSigIf/loadAddr
add wave -position 13 sim:/top/intSigIf/assertDACK
add wave -position 14 sim:/top/cpuIf/DACK
add wave -position 15 sim:/top/intSigIf/deassertDACK
add wave -position 16 sim:/top/DUT/ior
add wave -position 17 sim:/top/DUT/iow
add wave -position 18 sim:/top/DUT/memr
add wave -position 19 sim:/top/DUT/memw
add wave -position 20 sim:/top/cpuIf/IOR_N
add wave -position 21 sim:/top/cpuIf/IOW_N
add wave -position 22 sim:/top/cpuIf/MEMR_N
add wave -position 23 sim:/top/cpuIf/MEMW_N
add wave -position 24 sim:/top/cpuIf/READY
add wave -position 25 sim:/top/intSigIf/decrTemporaryWordCountReg
add wave -position 26 sim:/top/intRegIf/temporaryWordCountReg
add wave -position 27 sim:/top/intSigIf/incrTemporaryAddressReg
add wave -position 28 sim:/top/intRegIf/temporaryAddressReg
add wave -position 29 sim:/top/intSigIf/intEOP
add wave -position 30 sim:/top/cpuIf/CS_N
add wave -position 31 sim:/top/intRegIf/modeReg
add wave -position 32 sim:/top/intSigIf/updateCurrentWordCountReg
add wave -position 33 sim:/top/intSigIf/updateCurrentAddressReg
add wave -position 34 sim:/top/cpuIf/EOP_N
run -all
