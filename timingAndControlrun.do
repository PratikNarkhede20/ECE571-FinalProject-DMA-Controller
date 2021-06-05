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
add wave -position insertpoint sim:/testTimingAndControl/*
add wave -position insertpoint  \
sim:/testTimingAndControl/cpuIf/IOR_N \
sim:/testTimingAndControl/cpuIf/IOW_N \
sim:/testTimingAndControl/cpuIf/MEMR_N \
sim:/testTimingAndControl/cpuIf/MEMW_N \
sim:/testTimingAndControl/cpuIf/READY \
sim:/testTimingAndControl/cpuIf/HLDA \
sim:/testTimingAndControl/cpuIf/ADSTB \
sim:/testTimingAndControl/cpuIf/AEN \
sim:/testTimingAndControl/cpuIf/HRQ
add wave -position insertpoint  \
sim:/testTimingAndControl/cpuIf/DREQ
add wave -position insertpoint  \
sim:/testTimingAndControl/cpuIf/EOP_N
add wave -position insertpoint  \
sim:/testTimingAndControl/intRegIf/modeReg
add wave -position insertpoint  \
sim:/testTimingAndControl/intSigIf/programCondition \
sim:/testTimingAndControl/intSigIf/loadAddr \
sim:/testTimingAndControl/intSigIf/assertDACK \
sim:/testTimingAndControl/intSigIf/deassertDACK \
sim:/testTimingAndControl/intSigIf/intEOP \
sim:/testTimingAndControl/intSigIf/updateCurrentWordCountReg \
sim:/testTimingAndControl/intSigIf/updateCurrentAddressReg
add wave -position 12  sim:/testTimingAndControl/cpuIf/CS_N
add wave -position insertpoint sim:/testTimingAndControl/DUT/*
run -all
