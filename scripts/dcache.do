onerror {resume}
quietly virtual function -install /system_tb/DUT/CPU/DP/dpif -env /system_tb/DUT/CPU/DP/dpif { &{/system_tb/DUT/CPU/DP/dpif/halt, /system_tb/DUT/CPU/DP/dpif/ihit, /system_tb/DUT/CPU/DP/dpif/imemREN, /system_tb/DUT/CPU/DP/dpif/imemload, /system_tb/DUT/CPU/DP/dpif/imemaddr, /system_tb/DUT/CPU/DP/dpif/dhit, /system_tb/DUT/CPU/DP/dpif/datomic, /system_tb/DUT/CPU/DP/dpif/dmemREN, /system_tb/DUT/CPU/DP/dpif/dmemWEN, /system_tb/DUT/CPU/DP/dpif/flushed, /system_tb/DUT/CPU/DP/dpif/dmemload, /system_tb/DUT/CPU/DP/dpif/dmemstore, /system_tb/DUT/CPU/DP/dpif/dmemaddr }} DPIF
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CLK
add wave -noupdate /system_tb/DUT/nRST
add wave -noupdate /system_tb/DUT/halt
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/forwarded
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/jump_address
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/branch_address
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/branchMux
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -group DPIF /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -group ALUIF /system_tb/DUT/CPU/DP/aluif/NEG
add wave -noupdate -group ALUIF /system_tb/DUT/CPU/DP/aluif/OVER
add wave -noupdate -group ALUIF /system_tb/DUT/CPU/DP/aluif/ZERO
add wave -noupdate -group ALUIF /system_tb/DUT/CPU/DP/aluif/alu_op
add wave -noupdate -group ALUIF /system_tb/DUT/CPU/DP/aluif/port_a
add wave -noupdate -group ALUIF /system_tb/DUT/CPU/DP/aluif/port_b
add wave -noupdate -group ALUIF /system_tb/DUT/CPU/DP/aluif/out
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/instr
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/dREN
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/dWEN
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/PCSel
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/branch
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/branchSel
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/memtoReg
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/aluSrc
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/ALUop
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/rsel1
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/rsel2
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/wsel
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/immediate
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/regWrite
add wave -noupdate -group CUIF /system_tb/DUT/CPU/DP/cuif/wdataSrc
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/m_wsel
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/m_wen
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/w_wsel
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/w_wen
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/forward1
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/forward2
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/ex_rt
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/ex_lw
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/id_opcode
add wave -noupdate -group PCIF /system_tb/DUT/CPU/DP/pcif/pcen
add wave -noupdate -group PCIF /system_tb/DUT/CPU/DP/pcif/pc_next
add wave -noupdate -group PCIF /system_tb/DUT/CPU/DP/pcif/pc_out
add wave -noupdate -group RFIF /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -group RFIF /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -group RFIF /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -group RFIF /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -group RFIF /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -group RFIF /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -group RFIF /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -group IFID /system_tb/DUT/CPU/DP/ifid/instr
add wave -noupdate -group IFID /system_tb/DUT/CPU/DP/ifid/pcp4_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/opcode_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/funct_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/dREN_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/dWEN_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/branchSel_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/branch_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/PCSel_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/ALUop_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/regWrite_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/wDataSrc_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/aluSrc_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/MemtoReg_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/Imm_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/wsel_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/JumpAddr_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/pcp4_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/rdat1_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/rdat2_out
add wave -noupdate -group IDEX /system_tb/DUT/CPU/DP/idex/HALT_out
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/opcode_out
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/funct_out
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/dREN_out
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/dWEN_out
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/dmemStore
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/MemtoReg_out
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/portO_out
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/WSel_out
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/WEN_out
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/wdatasrc_out
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/pcp4_out
add wave -noupdate -group EXM /system_tb/DUT/CPU/DP/exm/HALT_out
add wave -noupdate -group MWB /system_tb/DUT/CPU/DP/mwb/opcode_out
add wave -noupdate -group MWB /system_tb/DUT/CPU/DP/mwb/funct_out
add wave -noupdate -group MWB /system_tb/DUT/CPU/DP/mwb/dmemLoad_out
add wave -noupdate -group MWB /system_tb/DUT/CPU/DP/mwb/wdatasrc_out
add wave -noupdate -group MWB /system_tb/DUT/CPU/DP/mwb/MemtoReg_out
add wave -noupdate -group MWB /system_tb/DUT/CPU/DP/mwb/portO_out
add wave -noupdate -group MWB /system_tb/DUT/CPU/DP/mwb/Wsel_out
add wave -noupdate -group MWB /system_tb/DUT/CPU/DP/mwb/RegWEN_out
add wave -noupdate -group MWB /system_tb/DUT/CPU/DP/mwb/pcp4_out
add wave -noupdate -group MWB /system_tb/DUT/CPU/DP/mwb/HALT_out
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate /system_tb/DUT/CPU/DP/REGF/register
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/halt
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/ihit
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/imemREN
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/imemload
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/imemaddr
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/dhit
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/datomic
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/dmemREN
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/dmemWEN
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/flushed
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/dmemload
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/dmemstore
add wave -noupdate -group DCIF /system_tb/DUT/CPU/CM/dcif/dmemaddr
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/iwait
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/dwait
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/iREN
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/dREN
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/dWEN
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/iload
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/dload
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/dstore
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/iaddr
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/daddr
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/ccwait
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/ccinv
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/ccwrite
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/cctrans
add wave -noupdate -group CIF /system_tb/DUT/CPU/CM/cif/ccsnoopaddr
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/CLK
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/nRST
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/i_table
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/new_imemaddr
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/curr_entry
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/CLK
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/nRST
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/d_table
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/state
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_state
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_v
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_dirty
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_lru
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/cache_write
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_data1
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_data2
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_tag
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/newdmem
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/curr_set
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/match0
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/match1
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/d_counter
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/next_d_counter
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/hit_count
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/miss_count
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/write_loc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14645978 ps} 0}
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
WaveRestoreZoom {14614082 ps} {15358786 ps}