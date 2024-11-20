`ifndef APB_DUT_CHECKER
`define APB_DUT_CHECKER

class apb_dut_checker extends uvm_component;
  
  `uvm_component_utils(apb_dut_checker);
  
  `uvm_analysis_imp_decl(_drv)
  `uvm_analysis_imp_decl(_resp)
  `uvm_analysis_imp_decl(_reset)

  uvm_analysis_imp_drv#(apb_transaction, apb_dut_checker) drv_export;
  uvm_analysis_imp_resp#(apb_transaction, apb_dut_checker) resp_export;
  uvm_analysis_imp_reset#(bit, apb_dut_checker) reset_export;

  virtual apb_interface vif;

  //Ref Model
  bit [31:0] mem0[0:511];
  bit [31:0] mem1[512:767];
  bit reset = 0;

  apb_transaction txn;
  apb_transaction read_txn;

  function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv_export = new("drv_export", this);
    resp_export = new("resp_export", this);
    reset_export = new("reset_export", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual apb_interface)::get(this, "*", "vif", vif)) begin
      `uvm_error("APB_MONITOR/BUILD_PHASE", "No virtual interface specified for this monitor instance")
    end
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    //Check the Dut and reference Model

    foreach(mem0[i]) begin
      if(mem0[i] != vif.mem0[i]) begin
        `uvm_error("APB_MONITOR/EXTRACT_PHASE", $sformatf("dut.mem0[%0d]=%h and ref_model.mem0[%0d]=%h don't match", i, vif.mem0[i], i, mem0[i]));
      end
    end
    foreach(mem1[i]) begin
      if(mem1[i] != vif.mem1[i]) begin
        `uvm_error("APB_MONITOR/EXTRACT_PHASE", $sformatf("dut.mem1[%0d]=%h and ref_model.mem1[%0d]=%h don't match", i, vif.mem1[i], i, mem1[i]));
      end
    end
  endfunction

  virtual function void write_drv(apb_transaction tr);
    `uvm_info("APB_DUT_CHECKER", $sformatf("Got Drv Transaction: %s",tr.sprint), UVM_LOW)
    txn = apb_transaction::type_id::create("txn", this);
    txn.p_write = tr.p_write;
    txn.addr = tr.addr;
    txn.data = tr.data;
  endfunction

  virtual function void write_resp(apb_transaction tr);
    `uvm_info("APB_DUT_CHECKER", $sformatf("Got Resp Transaction: %s",tr.sprint), UVM_LOW)
    //Checking
    if(!reset) begin //{
      if(txn.addr > 'd767) begin //{
        if(tr.pslverr == 0) begin
          `uvm_error("APB_DUT_CHECKER", $sformatf("Transaction with invalid address:%0d sent but plsverr is not asserted byt DUT", txn.addr));
        end
      end else begin //}{
        if(tr.pslverr == 1) begin //{
          `uvm_error("APB_DUT_CHECKER", $sformatf("Transaction with valid address:%0d sent but plsverr is not asserted byt DUT", txn.addr));
        end else begin //}{
          if(txn.p_write) begin //{
            if(txn.addr < 'd511) begin
              mem0[txn.addr] = txn.data;
            end else begin
              mem1[txn.addr] = txn.data;
            end
          end else begin //}{
            if(txn.addr < 'd511) begin
              if(txn.data != mem0[txn.addr]) begin
                `uvm_error("APB_DUT_CHECKER", $sformatf("Data from read:0x%h and data from reference model:0x%h don't match for address:%0d", txn.data, mem0[txn.addr], txn.addr));
              end
            end else begin
              if(txn.data != mem1[txn.addr]) begin
                `uvm_error("APB_DUT_CHECKER", $sformatf("Data from read:0x%h and data from reference model:0x%h don't match for address:%0d", txn.data, mem1[txn.addr], txn.addr));
              end
            end
          end //}
        end //}
      end //}
    end //}
  endfunction

  virtual function void write_reset(bit reset);
    `uvm_info("APB_DUT_CHCKER", $sformatf("Got Reset: Asserted=%0d", reset), UVM_LOW);
    this.reset = reset;
    if(reset) begin
      foreach(mem0[i]) begin
        mem0[i] = 'd0;
        mem1[i] = 'd0;
      end
    end
  endfunction

endclass
`endif
