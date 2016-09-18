onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate -divider DPCache
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/dcif/halt
add wave -noupdate /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate /system_tb/DUT/CPU/dcif/datomic
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/dcif/flushed
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -expand -group Memory /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -expand -group Memory /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -expand -group Memory /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -expand -group Memory /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -expand -group Memory /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -expand -group Memory /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -expand -group Memory /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -expand -group Memory /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -expand -group Memory /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -expand -group Memory /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate -divider ALU
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluif/NEG
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluif/OVER
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluif/ZERO
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluif/alu_op
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluif/port_a
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluif/port_b
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluif/out
add wave -noupdate -divider Request
add wave -noupdate /system_tb/DUT/CPU/DP/REQ/rqif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP/REQ/rqif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/REQ/rqif/dren
add wave -noupdate /system_tb/DUT/CPU/DP/REQ/rqif/dwen
add wave -noupdate /system_tb/DUT/CPU/DP/REQ/rqif/dmemren
add wave -noupdate /system_tb/DUT/CPU/DP/REQ/rqif/dmemwen
add wave -noupdate /system_tb/DUT/CPU/DP/REQ/rqif/pcen
add wave -noupdate -divider {Register File}
add wave -noupdate /system_tb/DUT/CPU/DP/REGF/rfif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/REGF/rfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/REGF/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/REGF/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/REGF/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/REGF/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/REGF/rfif/rdat2
add wave -noupdate /system_tb/DUT/CPU/DP/REGF/register
add wave -noupdate -divider PC
add wave -noupdate /system_tb/DUT/CPU/DP/PCOUNT/pcif/pcen
add wave -noupdate /system_tb/DUT/CPU/DP/PCOUNT/pcif/pc_next
add wave -noupdate /system_tb/DUT/CPU/DP/PCOUNT/pcif/pc_out
add wave -noupdate /system_tb/DUT/CPU/DP/CU/CLK
add wave -noupdate /system_tb/DUT/CPU/DP/CU/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/CU/opcode
add wave -noupdate /system_tb/DUT/CPU/DP/CU/func
add wave -noupdate -divider {Control Unit}
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/HALT
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/JAL
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/RegorMem
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/ExtOP
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/PCSrc
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/dREN
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/dWEN
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/LUI
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/imemREN
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/BNE
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/ALUOP
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/Rd
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/Rs
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/Rt
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/instr
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/shamt
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/InstrType
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/RegDest
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/BType
add wave -noupdate /system_tb/DUT/CPU/DP/CU/cuif/Imm
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {220000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {87235 ps} {352766 ps}
