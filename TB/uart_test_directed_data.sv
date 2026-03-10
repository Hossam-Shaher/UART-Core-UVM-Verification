`ifndef UART_TEST_DIRECTED_DATA_SV
  `define UART_TEST_DIRECTED_DATA_SV

  typedef class uart_test_base;
  typedef class uart_virt_sequence_random;
     
  class uart_test_directed_data extends uart_test_normal_operation;

    `uvm_component_utils(uart_test_directed_data)
    
    //Normal operation constraints are inherited
    
    //Directed test:
    //	rx and din  == 8'h00, 8'h11, and "8'h55 or 8'hAA"
    //	and hence,
    //	tx and dout == 8'h00, 8'h11, and "8'h55 or 8'hAA"
    
    local bit [7:0] directed_data_q[$] = '{8'h00, 8'hFF, 8'h55, 8'hAA};
    
    function new(string name, uvm_component parent);
      super.new(name, parent);

      //You can manipulate nu_repetitions HERE
    endfunction: new

    task run_phase (uvm_phase phase);
      phase.raise_objection(this, "uart_test_random", 1);
      #100us;
      
      //initialize sequencers of the sub-sequences
      m_uart_virt_sequence_random.m_uart_sequencer_system 	= m_uart_env.m_uart_agent_system.m_uart_sequencer_system;
      m_uart_virt_sequence_random.m_uart_sequencer_rx 		= m_uart_env.m_uart_agent_rx.m_uart_sequencer_rx;
      m_uart_virt_sequence_random.m_uart_sequencer_tx 		= m_uart_env.m_uart_agent_tx.m_uart_sequencer_tx;
      
      directed_data_q.shuffle();
      
      for(int i=0; i<nu_repetitions; i++) begin     
        assert ( m_uart_virt_sequence_random.randomize() with {
          m_uart_sequence_rx.item.rx  == directed_data_q[i];
          m_uart_sequence_tx.item.din == directed_data_q[i];
        } );	
        m_uart_virt_sequence_random.start(null);
      end
   
      #100us;
      phase.drop_objection(this, "uart_test_random", 1);
    endtask: run_phase
    
  endclass: uart_test_directed_data

`endif //UART_TEST_DIRECTED_DATA_SV