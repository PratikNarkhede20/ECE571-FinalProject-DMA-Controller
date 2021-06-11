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
vsim -gui -voptargs=+acc work.top
add wave -position end  sim:/top/CLK
add wave -position end  sim:/top/RESET
add wave -position end  sim:/top/cmdData
add wave -position end  sim:/top/modeData
add wave -position end  sim:/top/baseAddrLB
add wave -position end  sim:/top/baseChannelAddrLW
add wave -position end  sim:/top/baseAddrHB
add wave -position end  sim:/top/baseChannelAddrHB
add wave -position end  sim:/top/baseWordLB
add wave -position end  sim:/top/baseChannelWordLB
add wave -position end  sim:/top/baseWordHB
add wave -position end  sim:/top/baseChannelWordHB
add wave -position end  sim:/top/inreq
add wave -position end  sim:/top/DUT/genblk1[1]/p1/ID
add wave -position end  sim:/top/DUT/genblk1[1]/p1/intEOP
add wave -position end  sim:/top/DUT/genblk1[1]/p1/dataOut
add wave -position end  sim:/top/DUT/genblk1[1]/p1/address
add wave -position end  sim:/top/DUT/genblk1[1]/p1/mem
add wave -position end  sim:/top/DUT/genblk1[1]/p1/temp
add wave -position end  sim:/top/DUT/genblk1[0]/p1/ID
add wave -position end  sim:/top/DUT/genblk1[0]/p1/intEOP
add wave -position end  sim:/top/DUT/genblk1[0]/p1/dataOut
add wave -position end  sim:/top/DUT/genblk1[0]/p1/address
add wave -position end  sim:/top/DUT/genblk1[0]/p1/mem
add wave -position end  sim:/top/DUT/genblk1[0]/p1/temp
add wave -position end  sim:/top/DUT/busIf/IOR_N
add wave -position end  sim:/top/DUT/busIf/IOW_N
add wave -position end  sim:/top/DUT/busIf/MEMR_N
add wave -position end  sim:/top/DUT/busIf/MEMW_N
add wave -position end  sim:/top/DUT/busIf/HLDA
add wave -position end  sim:/top/DUT/busIf/ADSTB
add wave -position end  sim:/top/DUT/busIf/AEN
add wave -position end  sim:/top/DUT/busIf/HRQ
add wave -position end  sim:/top/DUT/busIf/CS_N
add wave -position end  sim:/top/DUT/busIf/DACK
add wave -position end  sim:/top/DUT/busIf/DREQ
add wave -position end  sim:/top/DUT/busIf/EOP_N
add wave -position end  sim:/top/DUT/busIf/A0
add wave -position end  sim:/top/DUT/busIf/A1
add wave -position end  sim:/top/DUT/busIf/A2
add wave -position end  sim:/top/DUT/busIf/A3
add wave -position end  sim:/top/DUT/busIf/A4
add wave -position end  sim:/top/DUT/busIf/A5
add wave -position end  sim:/top/DUT/busIf/A6
add wave -position end  sim:/top/DUT/busIf/A7
add wave -position end  sim:/top/DUT/busIf/DB
add wave -position 54  sim:/top/DUT/DMA/d/baseAddressReg
add wave -position 55  sim:/top/DUT/DMA/d/baseWordCountReg
add wave -position 56  sim:/top/DUT/DMA/d/currentAddressReg
add wave -position 57  sim:/top/DUT/DMA/d/currentWordCountReg
add wave -position 58  sim:/top/DUT/DMA/d/temporaryReg
add wave -position 59  sim:/top/DUT/DMA/d/writeBuffer
add wave -position 60  sim:/top/DUT/DMA/d/readBuffer
add wave -position 61  sim:/top/DUT/DMA/d/ioDataBuffer
add wave -position 62  sim:/top/DUT/DMA/d/ioAddressBuffer
add wave -position 63  sim:/top/DUT/DMA/d/outputAddressBuffer
add wave -position 64  sim:/top/DUT/DMA/d/internalFF
add wave -position 65  sim:/top/DUT/DMA/d/ldBaseAddressReg
add wave -position 66  sim:/top/DUT/DMA/d/rdCurrentAddressReg
add wave -position 67  sim:/top/DUT/DMA/d/ldBaseWordCountReg
add wave -position 68  sim:/top/DUT/DMA/d/rdCurrentWordCountReg
add wave -position 69  sim:/top/DUT/DMA/d/ldCommandReg
add wave -position 70  sim:/top/DUT/DMA/d/ldModeReg
add wave -position 71  sim:/top/DUT/DMA/d/rdStatusReg
add wave -position 72  sim:/top/DUT/DMA/d/clearInternalFF
add wave -position 73  sim:/top/DUT/DMA/d/enUpperAddress
add wave -position end  sim:/top/DUT/DMA/intSigIf/programCondition
add wave -position end  sim:/top/DUT/DMA/intSigIf/loadAddr
add wave -position end  sim:/top/DUT/DMA/intSigIf/assertDACK
add wave -position end  sim:/top/DUT/DMA/intSigIf/deassertDACK
add wave -position end  sim:/top/DUT/DMA/intSigIf/intEOP
add wave -position end  sim:/top/DUT/DMA/intSigIf/updateCurrentWordCountReg
add wave -position end  sim:/top/DUT/DMA/intSigIf/updateCurrentAddressReg
add wave -position end  sim:/top/DUT/DMA/intSigIf/decrTemporaryWordCountReg
add wave -position end  sim:/top/DUT/DMA/intSigIf/incrTemporaryAddressReg
add wave -position 2  sim:/top/DUT/DMA/tC/stateIndex
add wave -position 3  sim:/top/DUT/DMA/tC/state
add wave -position 4  sim:/top/DUT/DMA/tC/nextState
add wave -position 28  sim:/top/DUT/DMA/tC/ior
add wave -position 29  sim:/top/DUT/DMA/tC/iow
add wave -position 30  sim:/top/DUT/DMA/tC/memr
add wave -position 31  sim:/top/DUT/DMA/tC/memw
add wave -position 40  sim:/top/DUT/DMA/tC/configured
add wave -position end  sim:/top/DUT/mem/addressHB
add wave -position end  sim:/top/DUT/mem/dataOut
add wave -position end  sim:/top/DUT/mem/dataIn
add wave -position end  sim:/top/DUT/mem/address
add wave -position end  sim:/top/DUT/mem/mem
run -all
