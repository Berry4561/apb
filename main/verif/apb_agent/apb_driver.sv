`ifndef APB_DRIVER
`define APB_DRIVER

class apb_driver extends uvm_driver#(apb_transaction);

  `uvm_component_utils(apb_driver)

  virtual apb_interface vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual apb_interface)::get(this, "*", "vif", vif)) begin
      `uvm_error("APB_DRIVER/BUILD_PHASE", "No virtual interface specified for this monitor instance")
    end
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    vif.master_cb.psel <= 0;
    vif.master_cb.penable <= 0;
    
    forever begin
      apb_transaction tr;
      phase.raise_objection(this, "Driver Busy");
      
      @(vif.master_cb);
      seq_item_port.get_next_item(tr);
      @(vif.master_cb);
      `uvm_info("APB_DRIVER",$sformatf("Transaction recieved: %s", tr.sprint()), UVM_LOW);
      case(tr.p_write) 
        apb_transaction::READ: drive_read(tr);
        apb_transaction::WRITE: drive_write(tr);
      endcase

      seq_item_port.item_done();
      phase.drop_objection(this, "Driver Idle");
    end
  endtask

  virtual protected task drive_write(apb_transaction txn);
    vif.master_cb.psel <= 1;
    vif.master_cb.pwrite <= 1;
    vif.master_cb.paddr <= txn.addr;
    vif.master_cb.pwdata <= txn.data;

    @(vif.master_cb);
    vif.master_cb.penable <= 1;

    @(vif.master_cb);
    vif.master_cb.penable <= 0;
    vif.master_cb.psel <= 0;
  endtask

  virtual protected task drive_read(apb_transaction txn);
    vif.master_cb.psel <= 1;
    vif.master_cb.pwrite <= 0;
    vif.master_cb.paddr <= txn.addr;

    @(vif.master_cb);
    vif.master_cb.penable <= 1;

    @(vif.master_cb);
    vif.master_cb.penable <= 0;
    vif.master_cb.psel <= 0;
  endtask

endclass
`endif
