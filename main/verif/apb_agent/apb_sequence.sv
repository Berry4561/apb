`ifndef APB_SEQUENCE
`define APB_SEQUENCE

class apb_sequence extends uvm_sequence#(apb_transaction);
  
  `uvm_object_utils(apb_sequence)

  function new(string name="");
    super.new(name);
  endfunction

  task body();
    apb_transaction rw_txn;
    repeat(80) begin
      rw_txn = new();
      start_item(rw_txn);
      assert(rw_txn.randomize());
      finish_item(rw_txn);
    end
  endtask
endclass

`endif
