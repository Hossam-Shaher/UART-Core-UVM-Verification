`ifndef UART_SEQ_ITEM_MON_TX_SV 
  `define UART_SEQ_ITEM_MON_TX_SV

  class uart_seq_item_mon_tx extends uvm_sequence_item;

    `uvm_object_utils(uart_seq_item_mon_tx)
  
    //state variables (Monitored/ actual)
    logic 			reset;    
    logic [10:0] 	dvsr;
    logic [7:0]		tx_actual;
    
    //state variables (Expected)
    logic [7:0] 	tx_expected;
    
    //function: convert2string
    function string convert2string;
      convert2string = $sformatf("reset=%0b, dvsr=%0d, tx_actual=%0b, tx_expected=%0b", 
                                  reset, dvsr, tx_actual, tx_expected);
    endfunction: convert2string
    
    //function: do_compare
    //...

    //function: new
    function new (string name = "");
      super.new(name);
    endfunction: new

  endclass: uart_seq_item_mon_tx

`endif //UART_SEQ_ITEM_MON_TX_SV