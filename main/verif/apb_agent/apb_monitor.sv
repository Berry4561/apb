`ifndef APB_MONITOR
`define APB_MONITOR

class apb_monitor extends uvm_monitor;
  
  virtual apb_interface vif;

  `uvm_component_utils(apb_monitor)

  uvm_analysis_port#(apb_transaction) drv_ap;
  uvm_analysis_port#(apb_transaction) resp_ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv_ap = new("drv_ap", this);
    resp_ap = new("resp_ap", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual apb_interface)::get(this, "*", "vif", vif)) begin
      `uvm_error("APB_MONITOR/BUILD_PHASE", "No virtual interface specified for this monitor instance")
    end
  endfunction

  task run_phase(uvm_phase phase);
    apb_transaction drv_tr;
    apb_transaction resp_tr;
    super.run_phase(phase);
    forever begin
      
      //Protocol Violation check
      fork
        wait(vif.monitor_cb.penable == 1);
        @(vif.monitor_cb);
        if(vif.monitor_cb.psel == 0) begin
          `uvm_error("APB_MONITOR", "APB Protocol Violation penable not driven high 1 clk cycle after psel");
        end
      join_none
      
      //Monitoring driving Transaction
      wait(vif.monitor_cb.psel == 1 && vif.monitor_cb.penable == 1);
      drv_tr = apb_transaction::type_id::create("drv_tr");

      drv_tr.addr = vif.monitor_cb.paddr;
      drv_tr.p_write = vif.monitor_cb.pwrite ? apb_transaction::WRITE : apb_transaction::READ;
      if(drv_tr.p_write) begin
        drv_tr.data = vif.monitor_cb.pwdata;
      end
      drv_ap.write(drv_tr);
      
      //Monitoring response from Slave
      wait(vif.monitor_cb.pready);
      resp_tr = apb_transaction::type_id::create("resp_tr");
      if(!drv_tr.p_write) begin
        resp_tr.data = vif.monitor_cb.prdata; 
      end
      resp_tr.pslverr = vif.monitor_cb.pslverr;
      resp_ap.write(resp_tr);

    end
  endtask

endclass

`endif
