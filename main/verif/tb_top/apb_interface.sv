`ifndef APB_INTERFACE_SV
`define APB_INTERFACE_SV

interface apb_interface(input pclk);
    logic preset_n;
    logic [31:0]    paddr;
    logic [2:0]     pprot;
    logic           pselx;
    logic           penable;
    logic           pwrite; //Write/Read_BAR
    logic [31:0]    pwdata;
    logic [3:0]     pstrb;
    logic           pready;
    logic           prdata;
    logic           pslverr;
    logic           pwakeup;
    logic           pauser;
    
    
    
endinterface
`endif