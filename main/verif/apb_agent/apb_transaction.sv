`ifndef APB_TRANSCATION
`define APB_TRANSCTION

class apb_transaction extends uvm_sequence_item;
  typedef enum {READ, WRITE} rd_wr_e; 
 
  `uvm_object_utils(apb_transaction)

  rand bit [31:0] addr;
  rand bit [31:0] data;
  rand rd_wr_e p_write;
  //Monitor signals
  bit pslverr;

  constraint addr_c{
    soft addr[31:0] >= 32'd0;
    soft addr[31:0] <= 32'd767;
  }

  constraint data_c{
    data[31:0] >= 'h0;
    data[31:0] <= 'hffffffff;
  }

  function new(string name="");
  endfunction

  function string sprint();
    return $sformatf("pwrite=%0s, addr=%0h, data=%0h ", p_write, addr, data);
  endfunction

endclass:apb_transaction

`endif
