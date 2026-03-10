`ifndef UART_SEQ_ITEM_MON_RX_SV 
  `define UART_SEQ_ITEM_MON_RX_SV

  class uart_seq_item_mon_rx extends uvm_sequence_item;

    `uvm_object_utils(uart_seq_item_mon_rx)
    
    //state variables (Monitored/ actual)
    logic 			reset;    
    logic [10:0] 	dvsr;		
    logic [7:0] 	dout_actual;
    
    //state variables (Expected)
    logic [7:0] 	dout_expected;

    //function: convert2string
    function string convert2string;
      convert2string = $sformatf("reset=%0b, dvsr=%0d, dout_actual=%0b, dout_expected=%0b", 
                                  reset, dvsr, dout_actual, dout_expected);
    endfunction: convert2string
    
    //function: do_compare
    //...

    //function: new
    function new (string name = "");
      super.new(name);
    endfunction: new

  endclass: uart_seq_item_mon_rx

`endif //UART_SEQ_ITEM_MON_RX_SV