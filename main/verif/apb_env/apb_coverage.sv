`ifndef APB_COVERAGE
`define APB_COVERAGE
  
  covergroup valid_rw_txns_cg;
    PADDR: coverpoint paddr{
        bins addr[768] = {[0:767]};
      }
    PWRITE: coverpoint pwrite{
        bins read = {0};
        bins write = {1};
      }
    RESET: coverpoint reset{
        bins not_reset = {0};
        bins in_reset = {1};
      }
    PADDRxPWRITE : cross PADDR, PWRITE;
    PADDRxPWRITExRESET : cross PADDR, PWRITE, RESET;
  endgroup: valid_rw_txns_cg

  covergroup mem_integrity_txns_cg;
    PADDR: coverpoint paddr{
        bins addr[768] = {[0:767]};
      }
    PREAD: coverpoint pwrite{
        bins read = {0};
        ignore_bins write = {1};
      }
    PWRITE: coverpoint pwrite{
        bins write = {1};
        ignore_bins read = {0};
      } 
    PWDATA: coverpoint pwdata{
        bins inverted = {'h55555555};
        bins non_inverted = {'haaaaaaaa};
      }
    PRDATA: coverpoint prdata{
        bins inverted = {'h55555555};
        bins non_inverted = {'haaaaaaaa};
      }
    RESET: coverpoint reset{
        bins not_reset = {0};
        ignore_bins in_reset = {1};
      }
    MEM_INTEGRITY_WRITES: cross PADDR, PWRITE, PWDATA, RESET;
    MEM_INTEGRITY_READS: cross PADDR, PREAD, PRDATA, RESET;

  endgroup: mem_integrity_txns_cg

  covergroup err_txns_cg;
    PSLVERR: coverpoint pslverr{
        bins slverr = {1};
        ignore_bins not_slverr = {0};
      }
    PWRITE: coverpoint pwrite{
        bins read = {0};
        bins write = {1};
      }
    PADDR: coverpoint paddr{
        bins err_addr = {[768:$]};
        ignore_bins valid_addr = {[0:767]};
      }
    PLSVERRxPWRITE: cross PSLVERR, PWRITE;
    PADDRxPWRITE: cross PADDR, PWRITE;
  endgroup: err_txns_cg

`endif
