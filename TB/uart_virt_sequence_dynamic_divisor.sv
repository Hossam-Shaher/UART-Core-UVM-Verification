`ifndef UART_VIRT_SEQUENCE_DYNAMIC_DIVISOR_SV
  `define UART_VIRT_SEQUENCE_DYNAMIC_DIVISOR_SV

  typedef class uart_virt_sequence_random;    

  //Dynamic divisor:
  //	dvsr inside {11, 23, 47}
  //	reset 	 == 0  (doesn't change)
  //	tx_start == 1  (doesn't change)

  class uart_virt_sequence_dynamic_divisor extends uart_virt_sequence_random;

    `uvm_object_utils(uart_virt_sequence_dynamic_divisor)

    constraint dynamic_divisor {
      m_uart_sequence_system.item.dvsr inside {11, 23, 47};		//corresponding baud rates: 9600, 4800, and 2400 bps
      m_uart_sequence_system.item.reset == 1'b0;
      m_uart_sequence_tx.item.tx_start 	== 1'b1;
    }
    
    function new(string name = "");
      super.new(name);
    endfunction: new

  endclass: uart_virt_sequence_dynamic_divisor

`endif //UART_VIRT_SEQUENCE_DYNAMIC_DIVISOR_SV
