all:
	ghdl -i Line_PC.vhd
	ghdl -i Line_PO.vhd
	ghdl -i Line_alg.vhd
	ghdl -i Line_alg_tb.vhd
	ghdl -m Line_alg_tb
	./line_alg_tb --stop-time=10us --wave=ondas.ghw

top:
	ghdl -i *.vhd
	ghdl -m top_module_tb
	./top_module_tb --stop-time=10us --waves-top.ghw
