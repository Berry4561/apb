`ifndef APB_TOP
`define APB_TOP
  //  logic           pclk;
  //  logic           preset_n;
  //  logic           psel;
  //  logic [31:0]    paddr;
  //  logic           penable;
  //  logic           pwrite; //Write/Read_BAR
  //  logic [31:0]    pwdata;
  //  logic           pready;
  //  logic           prdata;
  //  logic           pslverr;
module apb_top( pclk,
                preset_n,
                psel,
                penable,
                pready,
                paddr,
                pwrite,
                pwdata,
                prdata,
                pslverr
            );

  //Input Ports
  input pclk;
  input preset_n;
  input psel;
  input penable;
  input pwrite;
  input [31:0] paddr;
  input [31:0] pwdata;
  
  //Output Ports
  output reg pready;
  output reg [31:0] prdata;
  output reg pslverr;

  //This slave contains 2 Register banks from adress 0:511 and 512:767, 
  //Anything outside of this adress space access will result in SlaveErr Response

  //Reg bank0
  reg [31:0] mem0[0:511];
  //Reg bank1
  reg [31:0] mem1[512:767];

  reg [31:0] wdata;
  reg [31:0] waddr;
  reg write_ongoing;

  //state declaration communication
  parameter [1:0] idle=2'b00;
  parameter [1:0] setup=2'b01;
  parameter [1:0] access=2'b10;
  
  //FSM present state and next state
  reg [1:0] ps, ns;

  //present state to next state assignment
  always @(posedge pclk) begin
    if(!preset_n) begin
      ps <= idle;
      for(int i=0; i< 512; i++) begin
        mem0[i] <= 'h0; //memory reset
      end
      for(int i=512; i< 767; i++) begin
        mem0[i] <= 'h0; //memory reset
      end
    end else begin
      ps <= ns;
      if(pready & write_ongoing) begin
        if(waddr <= 511)begin
          mem0[waddr] = wdata;
        end else if(waddr >511 & waddr <=767) begin
          mem0[waddr] = wdata;
        end
      end
    end
  end

  //FSM ns assignment combinational block
  always_comb begin //{
    case(ps)
      idle: begin
        write_ongoing = 0;
        if(psel & !penable) begin
          ns = setup;
        end else begin
          ns = idle;
        end
      end

      setup: begin
        if(!penable | !psel ) begin //{
          ns = idle;
        end else begin //}{
          
          ns = access;
          if(paddr > 'd767) begin
            pslverr = 1;
            pready = 1;
          end
          if(pwrite) begin //{ Write Logic
            waddr = paddr;
            wdata = pwdata;
            write_ongoing = 1;
            pready = 1;
            pslverr = 0;
          end else begin//}{ Read Logic
            if(paddr <= 'd511) begin
              prdata = mem0[paddr];
              pready = 1;
              pslverr = 0;
            end else begin
              prdata = mem1[paddr];
              pready = 1;
              pslverr = 0;
            end
          end //}
        end //}
      end

      access: begin
        if(!penable | !psel) begin
          ns = idle;
          pready = 0;
          write_ongoing = 1;
        end
      end

      default: begin
        ns = idle;
      end
    endcase
  end //}



endmodule
`endif
