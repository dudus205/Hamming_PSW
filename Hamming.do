onerror {quit -f}
vlib work
vlog -work work Hamming.vo
vlog -work work Hamming.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.Hamming_vlg_vec_tst
vcd file -direction Hamming.msim.vcd
vcd add -internal Hamming_vlg_vec_tst/*
vcd add -internal Hamming_vlg_vec_tst/i1/*
add wave /*
run -all
