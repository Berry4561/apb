`ifndef APB_MONITOR
`define APB_MONITOR

class apb_monitor extends uvm_monitor;
  
  uvm_analysis_port#(apb_transaction) ap;

  virtual apb_interface vif;

  `uvm_component_utils(apb_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif)) begin
      `uvm_error("APB_MONITOR/BUILD_PHASE", "No virtual interface specified for this monitor instance")
    end
  endfunction
endclass

`endif
