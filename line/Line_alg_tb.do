vlib work
vmap work

vcom line_PC.vhd
vcom line_PO.vhd
vcom Line_alg.vhd
vcom Line_alg_tb.vhd

vsim Line_alg_tb

add wave Line_alg_tb/clock
add wave Line_alg_tb/start
add wave Line_alg_tb/addr
add wave Line_alg_tb/wren
add wave -radix unsigned Line_alg_tb/estado

view wave
run 10000 ns
wave zoom full