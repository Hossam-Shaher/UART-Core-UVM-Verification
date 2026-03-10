`ifndef UART_SYSTEM_IF_SV
  `define UART_SYSTEM_IF_SV

  interface uart_system_if (input logic clk);

  	logic 			reset; 	//Asynchronous active high reset.
    logic [10:0] 	dvsr; 	//Run-time configurable divisor. 
    						//This signal controls the baud rate.
    
  endinterface: uart_system_if 

`endif //UART_SYSTEM_IF_SV