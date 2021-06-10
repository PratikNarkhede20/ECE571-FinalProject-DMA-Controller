vlog -reportprogress 300 -work work {N:/MS in USA/Spring 2021/Intro to SV/Project/cpuInterface.sv}
vlog -reportprogress 300 -work work {N:/MS in USA/Spring 2021/Intro to SV/Project/datapath.sv}
vlog -reportprogress 300 -work work {N:/MS in USA/Spring 2021/Intro to SV/Project/dmaInternalRegistersIf.sv}
vlog -reportprogress 300 -work work {N:/MS in USA/Spring 2021/Intro to SV/Project/dmaInternalRegistersPkg.sv}
vlog -reportprogress 300 -work work {N:/MS in USA/Spring 2021/Intro to SV/Project/dmaInternalSignalsIf.sv}
vlog -reportprogress 300 -work work {N:/MS in USA/Spring 2021/Intro to SV/Project/dmaRegConfigPkg.sv}
vlog -reportprogress 300 -work work {N:/MS in USA/Spring 2021/Intro to SV/Project/priorityLogic.sv}
vlog -reportprogress 300 -work work {N:/MS in USA/Spring 2021/Intro to SV/Project/priorityLogicTB.sv}
vlog -reportprogress 300 -work work {N:/MS in USA/Spring 2021/Intro to SV/Project/testTimingAndControl.sv}
vlog -reportprogress 300 -work work {N:/MS in USA/Spring 2021/Intro to SV/Project/TimingAndControl.sv}
vsim -gui -voptargs=+acc work.testTimingAndControl
add wave -position 1 sim:/testTimingAndControl/*
add wave -position 3 sim:/testTimingAndControl/DUT/stateIndex
add wave -position 4 sim:/testTimingAndControl/DUT/state
add wave -position 5 sim:/testTimingAndControl/DUT/nextState
add wave -position 6 sim:/testTimingAndControl/intSigIf/programCondition
add wave -position 7 sim:/testTimingAndControl/busIf/DREQ
add wave -position 8 sim:/testTimingAndControl/busIf/HRQ
add wave -position 9 sim:/testTimingAndControl/busIf/HLDA
add wave -position 10 sim:/testTimingAndControl/busIf/AEN
add wave -position 11 sim:/testTimingAndControl/busIf/ADSTB
add wave -position 12 sim:/testTimingAndControl/intSigIf/loadAddr
add wave -position 13 sim:/testTimingAndControl/intSigIf/assertDACK
add wave -position 14 sim:/testTimingAndControl/busIf/DACK
add wave -position 15 sim:/testTimingAndControl/intSigIf/deassertDACK
add wave -position 16 sim:/testTimingAndControl/DUT/ior
add wave -position 17 sim:/testTimingAndControl/DUT/iow
add wave -position 18 sim:/testTimingAndControl/DUT/memr
add wave -position 19 sim:/testTimingAndControl/DUT/memw
add wave -position 20 sim:/testTimingAndControl/busIf/IOR_N
add wave -position 21 sim:/testTimingAndControl/busIf/IOW_N
add wave -position 22 sim:/testTimingAndControl/busIf/MEMR_N
add wave -position 23 sim:/testTimingAndControl/busIf/MEMW_N
add wave -position 24 sim:/testTimingAndControl/busIf/READY
add wave -position 25 sim:/testTimingAndControl/intSigIf/decrTemporaryWordCountReg
add wave -position 26 sim:/testTimingAndControl/intRegIf/temporaryWordCountReg
add wave -position 27 sim:/testTimingAndControl/intSigIf/incrTemporaryAddressReg
add wave -position 28 sim:/testTimingAndControl/intRegIf/temporaryAddressReg
add wave -position 29 sim:/testTimingAndControl/intSigIf/intEOP
add wave -position 30 sim:/testTimingAndControl/busIf/CS_N
add wave -position 31 sim:/testTimingAndControl/intRegIf/modeReg
add wave -position 32 sim:/testTimingAndControl/intSigIf/updateCurrentWordCountReg
add wave -position 33 sim:/testTimingAndControl/intSigIf/updateCurrentAddressReg
add wave -position 34 sim:/testTimingAndControl/busIf/EOP_N
run -all
