`ifndef APB_MEM_INTEGRITY_TEST
`define APB_MEM_INTEGRITY_TEST

class apb_mem_integrity_test extends apb_base_test;
  
  `uvm_component_utils(apb_mem_integrity_test);

  function new(string name="apb_mem_integrity_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    test_cfg.apb_valid_rw_txns_rand = 0;
    test_cfg.apb_err_rw_txns_rand = 0;
    super.build_phase(phase);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this, "TEST RUN PHASE STARTED");

    for(int i=0; i<test_cfg.apb_mem_integrity_txns; i++) begin
      seq_sem.get(1);
      mem_integrity_sequence = apb_mem_integrity_sequence::type_id::create("mem_integrity_sequence");
      mem_integrity_sequence.start(sqr);
      seq_sem.put(1);
    end
    phase.raise_objection(this, "TEST RUN PHASE ABOUT TO END");
  endtask: run_phase

endclass: apb_mem_integrity_test

`endif
