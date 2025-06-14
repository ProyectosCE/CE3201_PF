transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -sv -work work +incdir+. {Gambling_Tec.svo}

vlog -sv -work work +incdir+C:/Users/joseb/Documents/GitHub/CE3201_PF {C:/Users/joseb/Documents/GitHub/CE3201_PF/tb_Gambling_Tec.sv}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L cyclonev_ver -L lpm_ver -L sgate_ver -L cyclonev_hssi_ver -L altera_mf_ver -L cyclonev_pcie_hip_ver -L gate_work -L work -voptargs="+acc"  tb_Gambling_Tec

add wave *
view structure
view signals
run -all
