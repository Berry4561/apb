# Variables
FILE_LIST = filelist.f
VCS = /home/tools/vcs/2023.12-SP2/bin/vcs
SIMV = simv

# Build target for a specific source file
build2: verif/tb_top/top.sv
	$(VCS) -sverilog verif/tb_top/top.sv

# Main build target
build: $(FILE_LIST)
	$(VCS) -full64 -sverilog -f $(FILE_LIST) +uvm

# Clean target
clean:
	rm -rf $(SIMV) csrc* *.daidir *.vpd *.log vc_hdrs.h

run_test:
	./simv +UVM_TESTNAME=apb_rand_test
