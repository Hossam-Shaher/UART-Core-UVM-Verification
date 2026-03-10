`ifndef UART_GLOBALS_SV
  `define UART_GLOBALS_SV

  //Parameters
  localparam realtime 	CLK_freq 		= 1.8432e6;				//unit: Hz
  localparam realtime 	CLK_half_cycle 	= 1 / (2*CLK_freq); 	//unit: s

`endif	//UART_GLOBALS_SV