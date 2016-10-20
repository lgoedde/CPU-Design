onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /icache_tb/CLK
add wave -noupdate /icache_tb/nRST
add wave -noupdate /icache_tb/DUT/i_table
add wave -noupdate /icache_tb/DUT/new_imemaddr
add wave -noupdate /icache_tb/DUT/curr_entry
add wave -noupdate -expand -group dcif /icache_tb/DUT/dcif/ihit
add wave -noupdate -expand -group dcif /icache_tb/DUT/dcif/imemREN
add wave -noupdate -expand -group dcif /icache_tb/DUT/dcif/imemload
add wave -noupdate -expand -group dcif /icache_tb/DUT/dcif/imemaddr
add wave -noupdate -expand -group cif /icache_tb/DUT/cif/iwait
add wave -noupdate -expand -group cif /icache_tb/DUT/cif/iREN
add wave -noupdate -expand -group cif /icache_tb/DUT/cif/iload
add wave -noupdate -expand -group cif /icache_tb/DUT/cif/iaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11 ns} 0}
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
WaveRestoreZoom {0 ns} {32 ns}
