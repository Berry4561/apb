`ifndef APB_ENV
`define APB_ENV

class apb_env extends uvm_env;

  `uvm_component_utils(apb_env)

  apb_agent agt;
  apb_dut_checker checker;

  function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = apb_agent::type_id::create("agt", this);
    checker = apb_dut_checker::type_id::create("checker", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //Make analysis port connection here;
    agt.mon.drv_ap.connect(checker.drv_export);
    agt.mon.resp_ap.connect(checker.resp_export);
    agt.reset_mon.reset_ap.connect(checker.reset_export);
  endfunction
endclass

`endif
