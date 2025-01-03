`ifndef APB_VALID_RW_TEST
`define APB_VALID_RW_TEST

class apb_valid_rw_test extends apb_base_test;
  
  `uvm_component_utils(apb_valid_rw_test);

  function new(string name="apb_valid_rw_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    test_cfg.apb_err_rw_txns_rand = 0;
    test_cfg.apb_mem_integrity_txns_rand = 0;
    super.build_phase(phase);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this, "TEST RUN PHASE STARTED");

    for(int i=0; i<test_cfg.apb_valid_rw_txns; i++) begin
      seq_sem.get(1);
      valid_rw_sequence = apb_rw_sequence::type_id::create("valid_rw_sequence");
      valid_rw_sequence.start(sqr);
      seq_sem.put(1);
    end
    phase.raise_objection(this, "TEST RUN PHASE ABOUT TO END");
  endtask: run_phase

endclass: apb_valid_rw_test

`endif
