`ifndef UART_SEQUENCE_RX_SV
  `define UART_SEQUENCE_RX_SV

  typedef class uart_seq_item_drv_rx;

  class uart_sequence_rx extends uvm_sequence#(uart_seq_item_drv_rx);

    `uvm_object_utils(uart_sequence_rx)

    rand uart_seq_item_drv_rx item;

    function new(string name = "");
      super.new(name);
      item = uart_seq_item_drv_rx::type_id::create("item"); 
      //Do NOT insert a 2nd actual argument "this", bcz "this" shall be a component
    endfunction: new

    task body();
      start_item(item);
      finish_item(item);    
    endtask: body

  endclass: uart_sequence_rx

`endif //UART_SEQUENCE_RX_SV
