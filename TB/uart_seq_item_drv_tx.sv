`ifndef UART_SEQ_ITEM_DRV_TX_SV 
  `define UART_SEQ_ITEM_DRV_TX_SV

  class uart_seq_item_drv_tx extends uvm_sequence_item;

    `uvm_object_utils(uart_seq_item_drv_tx)
    
    //rand variables (driven)
    rand logic [7:0] 	din;
    rand logic 			tx_start;
    
    //soft constraints
	//...

    //function: convert2string
    function string convert2string;
      convert2string = $sformatf("din=%0b, tx_start=%0b", 
                                  din, tx_start);
    endfunction: convert2string
    
    //function: do_compare
    //...

    //function: new
    function new (string name = "");
      super.new(name);
    endfunction: new

  endclass: uart_seq_item_drv_tx

`endif //UART_SEQ_ITEM_DRV_TX_SV