`ifndef UART_ENV_CONFIG_SV
  `define UART_ENV_CONFIG_SV

  typedef class uart_agent_config_system;
  typedef class uart_agent_config_rx;
  typedef class uart_agent_config_tx;
    
  class uart_env_config extends uvm_object;
    `uvm_object_utils(uart_env_config)

    uart_agent_config_system	m_uart_agent_config_system;
    uart_agent_config_rx		m_uart_agent_config_rx;
    uart_agent_config_tx		m_uart_agent_config_tx;
    
    bit coverage_enable_system 	= 1'b1;
    bit coverage_enable_rx 		= 1'b1;
    bit coverage_enable_tx 		= 1'b1;

    function new(string name="");
      super.new(name);

      m_uart_agent_config_system = uart_agent_config_system::type_id::create("m_uart_agent_config_system");
      m_uart_agent_config_rx 	 = uart_agent_config_rx::type_id::create("m_uart_agent_config_rx");
      m_uart_agent_config_tx 	 = uart_agent_config_tx::type_id::create("m_uart_agent_config_tx");

    endfunction: new   

  endclass: uart_env_config

`endif  //UART_ENV_CONFIG_SV