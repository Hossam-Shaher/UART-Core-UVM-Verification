`ifndef UART_SEQ_ITEM_SYSTEM_SV 
  `define UART_SEQ_ITEM_SYSTEM_SV

  class uart_seq_item_system extends uvm_sequence_item;

    `uvm_object_utils(uart_seq_item_system)
    
    //rand variables (driven)
    rand logic 			reset;
    rand logic [10:0] 	dvsr;
    
    //state variables (monitored)
	//...
    
    //soft constraints
	//...
    
    //function: convert2string
    function string convert2string;
      convert2string = $sformatf("reset=%0b, divisor=%0d", 
                                  reset, dvsr);
    endfunction: convert2string
    
    //function: do_compare
    //...

    //function: new
    function new (string name = "");
      super.new(name);
    endfunction: new

  endclass: uart_seq_item_system

`endif //UART_SEQ_ITEM_SYSTEM_SV