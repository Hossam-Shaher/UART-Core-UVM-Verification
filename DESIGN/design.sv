`include "baud_gen.sv"
`include "uart_rx.sv"
`include "uart_tx.sv"

module uart
  #(
    parameter DBIT = 8,      // # data bits
              SB_TICK = 16   // # 16 ticks for 1 stop bit
  )
  (
    //system
    input  logic 		clk, 
                        reset,
    input  logic [10:0] dvsr,

    //Rx
    input  logic 		rx,
    output logic [7:0] 	dout,
    output logic 		rx_done_tick,

    //Tx
    input  logic [7:0] 	din,
    input  logic 		tx_start, 
    output logic 		tx,
    output logic 		tx_done_tick
  );
    
  wire logic tick;

  baud_gen baud_gen_unit (.*);

  uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit 
  (.*, .s_tick(tick));

  uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit
  (.*, .s_tick(tick));

endmodule: uart