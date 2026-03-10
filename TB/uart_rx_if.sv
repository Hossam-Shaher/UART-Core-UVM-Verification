`ifndef UART_RX_IF_SV
  `define UART_RX_IF_SV

  interface uart_rx_if (input logic 		clk, 
                        input logic 		reset, 
                        input logic [10:0] 	dvsr);

  	logic 		rx; 			//Serial data input from the communication link.
    logic [7:0] dout;			//8-bit received data.
    logic 		rx_done_tick;	//A status signal.
								//It is asserted for one clock cycle 
    							//after the receiving process is completed.
    
    //Assertion(s)
    
    bit checks_enable = 1;
 
    property uart_frame_rx_p;
      @(posedge clk) disable iff(reset || !checks_enable || (dvsr!==11 && dvsr!==23 && dvsr!==47) )
      rx_done_tick |-> rx && ( !$past(rx, 9*16*(11+1)) || !$past(rx, 9*16*(23+1)) || !$past(rx, 9*16*(47+1)) );
    endproperty

    UART_FRAME_RX_A: assert property(uart_frame_rx_p) else
      $error("UART_PROTOCOL_ERROR: Error in a received UART frmae (UART_FRAME_RX_A)");

    UART_FRAME_RX_C: cover property(uart_frame_rx_p);
	
  endinterface: uart_rx_if 

`endif //UART_RX_IF_SV