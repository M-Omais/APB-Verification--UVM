vlog -sv fifo_if.sv fifo.sv tx_pkg.sv top.sv
vsim -classdebug -uvmcontrol=all work.top +UVM_VERBOSITY=UVM_HIGH 
add wave -position insertpoint  \
sim:/top/fifoi/clk_rd \
sim:/top/fifoi/clk_wr \
sim:/top/fifoi/data_in \
sim:/top/fifoi/data_out \
sim:/top/fifoi/empty \
sim:/top/fifoi/full \
sim:/top/fifoi/read_en \
sim:/top/fifoi/rst_n \
sim:/top/fifoi/write_en
run
