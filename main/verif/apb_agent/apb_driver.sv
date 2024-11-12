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
    if(!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif)) begin
      `uvm_error("APB_DRIVER/BUILD_PHASE", "No virtual interface specified for this monitor instance")
    end
      
  endfunction

endclass
`endif
