`ifndef UART_SEQUENCE_SYSTEM_SV
  `define UART_SEQUENCE_SYSTEM_SV

  typedef class uart_seq_item_system;

  class uart_sequence_system extends uvm_sequence#(uart_seq_item_system);

    `uvm_object_utils(uart_sequence_system)

    rand uart_seq_item_system item;

    function new(string name = "");
      super.new(name);
      item = uart_seq_item_system::type_id::create("item"); 
      //Do NOT insert a 2nd actual argument "this", bcz "this" shall be a component
    endfunction: new

    task body();
      start_item(item);
      finish_item(item);    
    endtask: body

  endclass: uart_sequence_system

`endif //UART_SEQUENCE_SYSTEM_SV