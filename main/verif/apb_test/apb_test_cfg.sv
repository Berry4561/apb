`ifndef APB_TEST_CFG
`define APB_TEST_CFG
 
class apb_test_cfg extends uvm_object;

  rand int apb_valid_rw_txns;
  bit apb_valid_rw_txns_rand=1;
  rand int apb_err_rw_txns;
  bit apb_err_rw_txns_rand=1;
  rand int apb_mem_integrity_txns;
  bit apb_mem_integrity_txns_rand=1;

  constraint apb_valid_rw_txns_c{
    apb_valid_rw_txns inside {[0:100]};
  }

  constraint apb_err_rw_txns_c{
    apb_err_rw_txns inside {[0:6]};
  }

  constraint apb_mem_integrity_txns_c{
    apb_mem_integrity_txns inside {[0:200]};
  }
  
  `uvm_object_utils_begin(apb_test_cfg)
    `uvm_field_int(apb_valid_rw_txns,             UVM_DEFAULT)
    `uvm_field_int(apb_err_rw_txns,               UVM_DEFAULT)
    `uvm_field_int(apb_mem_integrity_txns,        UVM_DEFAULT)
     `uvm_field_int(apb_valid_rw_txns_rand,       UVM_DEFAULT)
    `uvm_field_int(apb_err_rw_txns_rand,          UVM_DEFAULT)
    `uvm_field_int(apb_mem_integrity_txns_rand,   UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name="");
    super.new(name);
  endfunction

  function void pre_randomize(); 
    apb_valid_rw_txns.rand_mode(apb_valid_rw_txns_rand);
    apb_err_rw_txns.rand_mode(apb_err_rw_txns_rand);
    apb_mem_integrity_txns_rand.rand_mode(apb_mem_integrity_txns_rand);
  endfunction
endclass: apb_test_cfg

`endif
