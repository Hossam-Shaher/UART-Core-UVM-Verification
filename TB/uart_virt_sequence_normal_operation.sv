`ifndef UART_VIRT_SEQUENCE_NORMAL_OPERATION_SV
  `define UART_VIRT_SEQUENCE_NORMAL_OPERATION_SV

  typedef class uart_virt_sequence_random;    

  //Normal operation: 
  //	dvsr  	 == 11 (doesn't change)
  //	reset 	 == 0  (doesn't change)
  //	tx_start == 1  (doesn't change)

  class uart_virt_sequence_normal_operation extends uart_virt_sequence_random;

    `uvm_object_utils(uart_virt_sequence_normal_operation)

    constraint normal_operation {
      m_uart_sequence_system.item.dvsr 	== 11;
      m_uart_sequence_system.item.reset == 1'b0;
      m_uart_sequence_tx.item.tx_start 	== 1'b1;
    }
    
    function new(string name = "");
      super.new(name);
    endfunction: new

  endclass: uart_virt_sequence_normal_operation

`endif //UART_VIRT_SEQUENCE_NORMAL_OPERATION_SV
