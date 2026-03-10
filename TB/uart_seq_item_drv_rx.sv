`ifndef UART_SEQ_ITEM_DRV_RX_SV 
  `define UART_SEQ_ITEM_DRV_RX_SV

  class uart_seq_item_drv_rx extends uvm_sequence_item;

    `uvm_object_utils(uart_seq_item_drv_rx)
    
    //rand variable (driven)
    rand logic [7:0] 	rx;

    //soft constraints
	//...
    
    //function: convert2string
    function string convert2string;
      convert2string = $sformatf("rx=%0b",
                                  rx);
    endfunction: convert2string

    //function: new
    function new (string name = "");
      super.new(name);
    endfunction: new

  endclass: uart_seq_item_drv_rx

`endif //UART_SEQ_ITEM_DRV_RX_SV