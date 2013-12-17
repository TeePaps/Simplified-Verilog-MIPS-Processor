vlib work
vmap work work

vlog -lint -work work ../alu/*.v
vlog -lint -work work ../common/*.v
vlog -lint -work work ../control_unit/*.v
vlog -lint -work work ../cpu/*.v
vlog -lint -work work ../data_memory/*.v
vlog -lint -work work ../instruction_memory/*.v
vlog -lint -work work ../program_counter/*.v
vlog -lint -work work ../register_file/*.v
vlog -lint -work work tb_cpu.v

vsim -novopt -lib work -t ps work.tb_cpu

