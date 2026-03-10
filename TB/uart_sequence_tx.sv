`ifndef UART_SEQUENCE_TX_SV
  `define UART_SEQUENCE_TX_SV

  typedef class uart_seq_item_drv_tx;

  class uart_sequence_tx extends uvm_sequence#(uart_seq_item_drv_tx);

    `uvm_object_utils(uart_sequence_tx)

    rand uart_seq_item_drv_tx item;

    function new(string name = "");
      super.new(name);
      item = uart_seq_item_drv_tx::type_id::create("item"); 
      //Do NOT insert a 2nd actual argument "this", bcz "this" shall be a component
    endfunction: new

    task body();
      start_item(item);
      finish_item(item);    
    endtask: body

  endclass: uart_sequence_tx

`endif //UART_SEQUENCE_TX_SV
