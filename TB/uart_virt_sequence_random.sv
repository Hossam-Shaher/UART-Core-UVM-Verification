`ifndef UART_VIRT_SEQUENCE_RANDOM_SV
  `define UART_VIRT_SEQUENCE_RANDOM_SV

  typedef class uart_sequence_system;
  typedef class uart_sequence_rx;
  typedef class uart_sequence_tx;
  typedef class uart_sequencer_system;
  typedef class uart_sequencer_rx;
  typedef class uart_sequencer_tx;    

  class uart_virt_sequence_random extends uvm_sequence;

    `uvm_object_utils(uart_virt_sequence_random)
    
    rand uart_sequence_system	m_uart_sequence_system;
    rand uart_sequence_rx		m_uart_sequence_rx;
    rand uart_sequence_tx		m_uart_sequence_tx;
    uart_sequencer_system		m_uart_sequencer_system;	//needs to be initialized in the test
    uart_sequencer_rx			m_uart_sequencer_rx;		//needs to be initialized in the test
    uart_sequencer_tx			m_uart_sequencer_tx;		//needs to be initialized in the test

    function new(string name = "");
      super.new(name);
      m_uart_sequence_system = uart_sequence_system::type_id::create("m_uart_sequence_system"); 
      m_uart_sequence_rx 	 = uart_sequence_rx::type_id::create("m_uart_sequence_rx"); 
      m_uart_sequence_tx 	 = uart_sequence_tx::type_id::create("m_uart_sequence_tx"); 
    endfunction: new

    task body();
      m_uart_sequence_system.start(m_uart_sequencer_system, this);
      fork
        m_uart_sequence_tx.start(m_uart_sequencer_tx, this);
        m_uart_sequence_rx.start(m_uart_sequencer_rx, this);
      join   
    endtask: body

  endclass: uart_virt_sequence_random

`endif //UART_VIRT_SEQUENCE_RANDOM_SV
