`ifndef UART_TEST_RANDOM_SV
  `define UART_TEST_RANDOM_SV

  typedef class uart_test_base;
  typedef class uart_virt_sequence_random;
     
  class uart_test_random extends uart_test_base;

    `uvm_component_utils(uart_test_random)
    
    uart_virt_sequence_random 	m_uart_virt_sequence_random;
    int unsigned 				nu_repetitions = 4;				//number of repetitions (used in a repeat loop in run_phase)
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      //manipulate properties of m_uart_env_config HERE

      m_uart_virt_sequence_random = uart_virt_sequence_random::type_id::create("m_uart_virt_sequence_random", this);

    endfunction: build_phase 

    task run_phase (uvm_phase phase);
      phase.raise_objection(this, "uart_test_random", 1);
      #100us;
      
      //initialize sequencers of the sub-sequences
      m_uart_virt_sequence_random.m_uart_sequencer_system 	= m_uart_env.m_uart_agent_system.m_uart_sequencer_system;
      m_uart_virt_sequence_random.m_uart_sequencer_rx 		= m_uart_env.m_uart_agent_rx.m_uart_sequencer_rx;
      m_uart_virt_sequence_random.m_uart_sequencer_tx 		= m_uart_env.m_uart_agent_tx.m_uart_sequencer_tx;
      
      repeat (nu_repetitions) begin
        assert ( m_uart_virt_sequence_random.randomize() );	
        m_uart_virt_sequence_random.start(null);
      end
   
      #100us;
      phase.drop_objection(this, "uart_test_random", 1);
    endtask: run_phase
    
  endclass: uart_test_random

`endif //UART_TEST_RANDOM_SV