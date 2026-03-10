`include "uart_pkg.sv"

module tb;
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import uart_pkg::*;
  
  //Clock generator
  logic clk = 0;
  always #CLK_half_cycle clk = ~clk;

  //Interfaces
  uart_system_if	uart_system_if_inst( .clk(clk) );
  uart_rx_if		uart_rx_if_inst( .clk(clk), .reset(uart_system_if_inst.reset), .dvsr(uart_system_if_inst.dvsr) );
  uart_tx_if		uart_tx_if_inst( .clk(clk), .reset(uart_system_if_inst.reset), .dvsr(uart_system_if_inst.dvsr) );
  
  //DUT (for parameters, use default values)
  uart #() dut (
    .clk			( clk ),		
    .reset			( uart_system_if_inst.reset 	),			
    .dvsr			( uart_system_if_inst.dvsr 		),
    .rx				( uart_rx_if_inst.rx 			),	
    .dout			( uart_rx_if_inst.dout 			),	
    .rx_done_tick 	( uart_rx_if_inst.rx_done_tick 	),	
    .din			( uart_tx_if_inst.din			),		
    .tx_start		( uart_tx_if_inst.tx_start 		),		
    .tx				( uart_tx_if_inst.tx 			),
    .tx_done_tick	( uart_tx_if_inst.tx_done_tick	)
  );
  
  //Initial reset generator
  initial begin
    uart_system_if_inst.reset 	= 1'b0;
    uart_system_if_inst.dvsr 	= 11;
    uart_rx_if_inst.rx 			= 1'b1;	//idle
    uart_tx_if_inst.din 		=  '0;
    uart_tx_if_inst.tx_start 	= 1'b0;

    #(CLK_half_cycle/2.0)	uart_system_if_inst.reset <= 1'b1;
    #(CLK_half_cycle/2.0) 	uart_system_if_inst.reset <= 1'b0;    
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    uvm_config_db#(virtual uart_system_if):: set(null, "uvm_test_top", "uart_system_vif", uart_system_if_inst);
    uvm_config_db#(virtual uart_rx_if):: 	 set(null, "uvm_test_top", "uart_rx_vif", uart_rx_if_inst);
    uvm_config_db#(virtual uart_tx_if):: 	 set(null, "uvm_test_top", "uart_tx_vif", uart_tx_if_inst);
    
    run_test("uart_test_base"); 
    //Default test is "uart_test_base" 
    //Use +UVM_TESTNAME=<class name> to choose another test
  end
  
endmodule: tb