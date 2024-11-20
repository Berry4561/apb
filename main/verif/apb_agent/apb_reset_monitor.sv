`ifndef APB_RESET_MONITOR
`define APB_RESET_MONITOR
 
class apb_reset_monitor extends uvm_monitor;
  
  `uvm_component_utils(apb_reset_monitor);
  uvm_analysis_port#(bit) reset_ap;

  virtual apb_interface vif;
  bit reset = 0;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    reset_ap = new("reset_ap", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual apb_interface)::get(this, "*", "vif", vif)) begin
      `uvm_error("APB_MONITOR/BUILD_PHASE", "No virtual interface specified for this monitor instance")
    end
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(vif.preset_n);
      if(vif.preset_n == 1) begin
        reset = 0;
      end else begin
        reset = 1;
      end
      reset_ap.write(reset);
    end
  endtask
endclass
`endif
