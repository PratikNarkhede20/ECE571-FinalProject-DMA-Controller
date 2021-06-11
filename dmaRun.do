vlog -reportprogress 300 -work work dmaRegConfigPkg.sv
vlog -reportprogress 300 -work work dmaInternalRegistersPkg.sv
vlog -reportprogress 300 -work work dmaInternalRegistersIf.sv
vlog -reportprogress 300 -work work dmaInternalSignalsIf.sv
vlog -reportprogress 300 -work work busInterface.sv
vlog -reportprogress 300 -work work datapath.sv
vlog -reportprogress 300 -work work priorityLogic.sv
vlog -reportprogress 300 -work work timingAndControl.sv
vlog -reportprogress 300 -work work {subSystemLevelTesting/modules/plAndtc.sv}
vlog -reportprogress 300 -work work dma.sv
vlog -reportprogress 300 -work work datapathTB.sv
vlog -reportprogress 300 -work work priorityLogicTB.sv
vlog -reportprogress 300 -work work timingAndControlTB.sv
vlog -reportprogress 300 -work work {subSystemLevelTesting/testbenches/plAndtcTB.sv}
vlog -reportprogress 300 -work work dmaTB.sv
vsim -gui -voptargs=+acc work.dmaTB
add wave -position 1 sim:/dmaTB/*
add wave -position 3 sim:/dmaTB/DUT/tC/stateIndex
add wave -position 4 sim:/dmaTB/DUT/tC/state
add wave -position 5 sim:/dmaTB/DUT/tC/nextState
add wave -position 6 sim:/dmaTB/DUT/tC/intSigIf/programCondition
add wave -position 7 sim:/dmaTB/busIf/DREQ
add wave -position 8 sim:/dmaTB/busIf/HRQ
add wave -position 9 sim:/dmaTB/busIf/HLDA
add wave -position 10 sim:/dmaTB/busIf/AEN
add wave -position 11 sim:/dmaTB/busIf/ADSTB
add wave -position 12 sim:/dmaTB/DUT/intSigIf/loadAddr
add wave -position 13 sim:/dmaTB/DUT/intSigIf/assertDACK
add wave -position 14 sim:/dmaTB/busIf/DACK
add wave -position 15 sim:/dmaTB/DUT/tC/ior
add wave -position 16 sim:/dmaTB/DUT/tC/iow
add wave -position 17 sim:/dmaTB/DUT/tC/memr
add wave -position 18 sim:/dmaTB/DUT/tC/memw
add wave -position 19 sim:/dmaTB/DUT/busIf/IOR_N
add wave -position 20 sim:/dmaTB/DUT/busIf/IOW_N
add wave -position 21 sim:/dmaTB/DUT/busIf/MEMR_N
add wave -position 22 sim:/dmaTB/DUT/busIf/MEMW_N
add wave -position 23 sim:/dmaTB/DUT/intSigIf/decrTemporaryWordCountReg
add wave -position 24 sim:/dmaTB/DUT/intRegIf/temporaryWordCountReg
add wave -position 25 sim:/dmaTB/DUT/intSigIf/incrTemporaryAddressReg
add wave -position 26 sim:/dmaTB/DUT/intRegIf/temporaryAddressReg
add wave -position 27 sim:/dmaTB/DUT/intRegIf/commandReg
add wave -position 28 sim:/dmaTB/DUT/intSigIf/intEOP
add wave -position 29 sim:/dmaTB/DUT/tC/configured
add wave -position 30 sim:/dmaTB/busIf/CS_N
add wave -position 31 sim:/dmaTB/DUT/intRegIf/modeReg
add wave -position 32 sim:/dmaTB/DUT/intSigIf/updateCurrentWordCountReg
add wave -position 33 sim:/dmaTB/DUT/intSigIf/updateCurrentAddressReg
add wave -position 34 sim:/dmaTB/busIf/EOP_N
run -all
