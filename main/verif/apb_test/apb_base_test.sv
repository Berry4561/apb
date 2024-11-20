`ifndef APB_BASE_TEST
`define APB_BASE_TEST

class apb_base_test extends uvm_test;

  `uvm_component_utils(apb_base_test)

  apb_test_cfg test_cfg;
  apb_env env;
  apb_sequencer sqr;
  semaphore seq_sem;

  apb_rw_sequence valid_rw_sequence;
  apb_err_sequence err_rw_sequence;
  apb_mem_integrity_sequence mem_integrity_sequence;

  function new(string name="apb_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    test_cfg = apb_test_cfg::type_id::create("test_cfg");
    env = apb_env::type_id::create("env", this);
    seq_sem = new(1);

    if(!test_cfg.randomize()) begin
      `uvm_fatal("APB_TEST/BUILD_PHASE", "Unable to randomize test_cfg");
    end
    uvm_config_db#(apb_test_cfg)::set(null, "*", "test_cfg", test_cfg);
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sqr = env.agt.sqr;
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase
endclass: apb_base_test

`endif
