`ifndef APB_RAND_TEST
`define APB_RAND_TEST

class apb_rand_test extends apb_base_test;

  `uvm_component_utils(apb_rand_test)

  apb_test_cfg test_cfg;
  apb_env env;
  apb_sequencer sqr;
  semaphore seq_sem;

  apb_rw_sequence valid_rw_sequence;
  apb_err_sequence err_rw_sequence;
  apb_mem_integrity_sequence mem_integrity_sequence;

  function new(string name="apb_rand_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    super.run_phase(phase);
    phase.raise_objection(this, "TEST RUN PHASE STARTED");

    fork
      begin
        for(int i=0; i<test_cfg.apb_valid_rw_txns; i++) begin
          seq_sem.get(1);
          valid_rw_sequence = apb_rw_sequence::type_id::create("valid_rw_sequence");
          valid_rw_sequence.start(sqr);
          seq_sem.put(1);
        end
      end

      begin
        for(int i=0; i<test_cfg.apb_err_rw_txns; i++) begin
          seq_sem.get(1);
          err_rw_sequence = apb_err_sequence::type_id::create("err_rw_sequence");
          err_rw_sequence.start(sqr);
          seq_sem.put(1);
        end
      end

      begin
        for(int i=0; i<test_cfg.apb_mem_integrity_txns; i++) begin
          seq_sem.get(1);
          mem_integrity_sequence = apb_mem_integrity_sequence::type_id::create("mem_integrity_sequence");
          mem_integrity_sequence.start(sqr);
          seq_sem.put(1);
        end
      end

    join
    phase.raise_objection(this, "TEST RUN PHASE ABOUT TO END");
  endtask: run_phase

endclass: apb_rand_test

`endif
