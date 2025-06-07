transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/PC_Logic.sv}
vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/Main_Decoder.sv}
vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/Condition_Check.sv}
vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/Alu_Deco.sv}
vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/Register_File.sv}
vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/Register.sv}
vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/Mux.sv}
vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/Extender.sv}
vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/CPU.sv}
vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/ALU.sv}
vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/Adder.sv}
vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/Control_Unit.sv}

vlog -sv -work work +incdir+C:/Users/josee/CE3201_PF {C:/Users/josee/CE3201_PF/CPU_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  CPU_tb

add wave *
view structure
view signals
run -all
