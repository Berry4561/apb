`ifndef APB_SEQUENCE
`define APB_SEQUENCE

class apb_rw_sequence extends uvm_sequence#(apb_transaction);
  
  `uvm_object_utils(apb_rw_sequence)

  function new(string name="");
    super.new(name);
  endfunction

  task body();
    apb_transaction rw_txn;
    rw_txn = new();
    start_item(rw_txn);
    if(!rw_txn.randomize()) begin
      `uvm_error("APB_RW_SEQUENCE", $sformatf("Unable to randomize apb_rw_transaction"));
    end
    finish_item(rw_txn);
  endtask
endclass: apb_rw_sequence

class apb_err_sequence extends uvm_sequence#(apb_transaction);
  
  `uvm_object_utils(apb_err_sequence)

  function new(string name="");
    super.new(name);
  endfunction

  task body();
    apb_transaction err_rw_txn;
    err_rw_txn = new();
    start_item(err_rw_txn);
    if(!err_rw_txn.randomize() with {err_rw_txn.addr > 'd767;}) begin
      `uvm_error("APB_ERR_SEQUENCE", $sformatf("Unable to randomize apb_err_transaction"));
    end
    finish_item(err_rw_txn);
  endtask
endclass: apb_err_sequence

class apb_mem_integrity_sequence extends uvm_sequence#(apb_transaction);
  `uvm_object_utils(apb_mem_integrity_sequence)

  function new(string name="");
    super.new(name);
  endfunction

  task body();
    apb_transaction rw_txn;
    rw_txn = new();
    start_item(rw_txn);
    if(!rw_txn.randomize() with {rw_txn.data inside {'h55555555, 'haaaaaaaa}; rw_txn.p_write == apb_transaction::WRITE;}) begin
      `uvm_error("APB_MEM_INTEGRITY_SEQUENCE", $sformatf("Unable to randomize apb_rw_transaction"));
    end
    finish_item(rw_txn);
    
    start_item(rw_txn);
    rw_txn.p_write = apb_transaction::READ;
    finish_item(rw_txn);
  endtask
endclass: apb_mem_integrity_sequence

`endif
