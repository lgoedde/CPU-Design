onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /control_unit_tb/CLK
add wave -noupdate /control_unit_tb/nRST
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/JAL
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/RegorMem
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/WEN
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/ExtOP
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/PCSrc
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/dREN
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/dWEN
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/LUI
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/imemREN
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/BNE
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/HALT
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/ALUOP
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/Rd
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/Rs
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/Rt
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/instr
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/shamt
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/InstrType
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/RegDest
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/BType
add wave -noupdate -expand -group CU /control_unit_tb/DUT/cuif/Imm
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {430 ns} 0}
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
WaveRestoreZoom {0 ns} {11 ns}
