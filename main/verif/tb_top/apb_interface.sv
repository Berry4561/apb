`ifndef APB_INTERFACE
`define APB_INTERFACE

interface apb_interface;
    logic           pclk;
    logic           preset_n;
    logic           psel;
    logic [31:0]    paddr;
    logic           penable;
    logic           pwrite; //Write/Read_BAR
    logic [31:0]    pwdata;
    logic           pready;
    logic [31:0]    prdata;
    logic           pslverr;
    bit             err_trans;

    //Reg bank0 //Connect it to dut
    logic [31:0] mem0[0:511];
    //Reg bank1 //Connect it to dut
    logic [31:0] mem1[512:767];
    
    clocking slave_cb @(posedge pclk); // For Use of Driver
      default input #1ns output #1ns;
      output paddr, psel, penable, pwrite, pwdata;
      input  prdata, pready, pslverr;
    endclocking

    clocking master_cb @(posedge pclk); // FOr use of any slave bf,
      default input #1ns output #1ns;
      output  paddr, psel, penable, pwrite, pwdata;
      input prdata, pready, pslverr;
    endclocking

    clocking monitor_cb @(posedge pclk);// For use of monitoring components
      default input #1ns output #1ns;
      input paddr, psel, penable, pwrite, pwdata, prdata, pready, pslverr;
    endclocking

    modport master(clocking master_cb);
    modport slave(clocking slave_cb);
    modport passive(clocking monitor_cb);
    
    property psel_enable_relation ;
      @(posedge pclk) disable iff (!preset_n)
        $rose(psel) |=> penable;
    endproperty
    
    property psleverr_one_cycle ;
      @(posedge pclk) disable iff(!preset_n)
        $rose(pslverr) |=> $fell(pslverr);
    endproperty

    initial begin
      assert property(psel_enable_relation);
      assert property(psleverr_one_cycle);
    end
    
endinterface
`endif
