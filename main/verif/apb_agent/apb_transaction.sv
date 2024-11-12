`ifndef  APB_TRANSCATION
`define APB_TRANSCTION

class apb_transaction extends uvm_sequence_item;
  
  `uvm_object_utils(apb_transaction)

  typedef enum {READ, WRITE} rd_wr_e;
  rand bit [31:0] addr;
  rand bit [31:0] data;
  rand rd_wr_e p_write;

  constraint addr_c{
    addr[31:0] >= 32'd0;
    addr[31:0] < 32'd256;
  }

  constraint data_c{
    data[31:0] >= 32'd0;
    data[31:0] < 32'd256;
  }

  function new(string name="");
  endfunction

  function string sprint();
    return $sformatf("pwrite=%0s padd=%0h data=%0h", p_write, addr, data);
  endfunction
endclass:apb_transaction
`endif
