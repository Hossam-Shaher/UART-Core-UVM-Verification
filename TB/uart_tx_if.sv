`ifndef UART_TX_IF_SV
  `define UART_TX_IF_SV

  interface uart_tx_if (input logic 		clk, 
                        input logic 		reset, 
                        input logic [10:0] 	dvsr);

    logic [7:0] din;			//8-bit data to be transmitted.
    logic 		tx_start;		//A control signal.
								//It is asserted for one clock cycle
    							//to latch din and initiate transmission.
    logic 		tx;				//Serial data output to the communication link.
    logic 		tx_done_tick;	//A status signal.
								//It is asserted for one clock cycle
    							//after the transmission process is completed.
    
    //Assertion(s)
    
    bit checks_enable = 1;

    property uart_frame_tx_p;
      @(posedge clk) disable iff(reset || !checks_enable || (dvsr!==11 && dvsr!==23 && dvsr!==47))
      tx_done_tick |-> tx && ( !$past(tx, 9*16*(11+1)) || !$past(tx, 9*16*(23+1)) || !$past(tx, 9*16*(47+1)) );	
    endproperty

    UART_FRAME_TX_A: assert property(uart_frame_tx_p) else
      $error("UART_PROTOCOL_ERROR: Error in a transmitted UART frmae (UART_FRAME_TX_A)");

    UART_FRAME_TX_C: cover property(uart_frame_tx_p);
    
  endinterface: uart_tx_if 

`endif //UART_TX_IF_SV