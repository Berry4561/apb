//THis file is the top module of the Testbench
module top;
  
  import uvm_pkg::*;
 
  `include "uvm_macros.svh"
  
  logic pclk;
  logic preset_n;

  apb_interface apb_if();
  
  apb_top dut1(.pclk(pclk),
               .preset_n(preset_n),
               .psel(apb_if.psel),
               .penable(apb_if.penable),
               .pready(apb_if.pready),
               .paddr(apb_if.paddr),
               .pwrite(apb_if.pwrite),
               .pwdata(apb_if.pwdata),
               .prdata(apb_if.prdata),
               .pslverr(apb_if.pslverr)
                );

  assign apb_if.pclk = pclk;
  assign apb_if.preset_n = preset_n;

  assign apb_if.mem0 = dut1.mem0;
  assign apb_if.mem1 = dut1.mem1;

  //CLock GEN Block;
  initial begin
    pclk=0;
  end
  
  always begin
    #10 pclk = ~pclk;
  end

  //RESET DEASSERTION
  initial begin
    preset_n=0;
    repeat (1) @(posedge pclk);
    preset_n=1;
  end

  initial begin
    uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top", "vif", apb_if);
    run_test();
  end

  
endmodule
