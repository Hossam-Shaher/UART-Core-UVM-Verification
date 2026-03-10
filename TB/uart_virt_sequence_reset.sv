`ifndef UART_VIRT_SEQUENCE_RESET_SV
  `define UART_VIRT_SEQUENCE_RESET_SV

  typedef class uart_virt_sequence_random;    

  //In this sequence, a reset may occur during transmission/ receiving (normal operation constraints are applied)

  class uart_virt_sequence_reset extends uart_virt_sequence_random;

    `uvm_object_utils(uart_virt_sequence_reset)
    
    rand uart_sequence_system	m_uart_sequence_system_1;
   
    constraint reset_during_normal_operation {
      m_uart_sequence_system.item.dvsr 	 == 11;
      m_uart_sequence_system.item.reset  == 1'b0;
      m_uart_sequence_system_1.item.dvsr == 11;
      m_uart_sequence_tx.item.tx_start	 == 1'b1;
    }
    
    function new(string name = "");
      super.new(name);
      
      m_uart_sequence_system_1 = uart_sequence_system::type_id::create("m_uart_sequence_system_1");
    endfunction: new

    task body();
      m_uart_sequence_system.start(m_uart_sequencer_system, this);
      fork
        m_uart_sequence_tx.start(m_uart_sequencer_tx, this);
        m_uart_sequence_rx.start(m_uart_sequencer_rx, this);
        #1ms m_uart_sequence_system_1.start(m_uart_sequencer_system, this);		//NEW!
      join   
    endtask: body

  endclass: uart_virt_sequence_reset

`endif //UART_VIRT_SEQUENCE_RESET_SV