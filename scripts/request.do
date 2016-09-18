onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /request_tb/CLK
add wave -noupdate /request_tb/nRST
add wave -noupdate /request_tb/DUT/rqif/ihit
add wave -noupdate /request_tb/DUT/rqif/dhit
add wave -noupdate /request_tb/DUT/rqif/dren
add wave -noupdate /request_tb/DUT/rqif/dwen
add wave -noupdate /request_tb/DUT/rqif/dmemren
add wave -noupdate /request_tb/DUT/rqif/dmemwen
add wave -noupdate /request_tb/DUT/rqif/pcen
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {257 ns} 0}
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
