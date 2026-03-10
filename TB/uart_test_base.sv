`ifndef UART_TEST_BASE_SV
  `define UART_TEST_BASE_SV

  typedef class uart_env;
  typedef class uart_env_config;

  class uart_test_base extends uvm_test;

    `uvm_component_utils(uart_test_base)

    uart_env 		m_uart_env;
    uart_env_config	m_uart_env_config;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      m_uart_env			= uart_env::type_id::create("m_uart_env", this); 
      m_uart_env_config 	= uart_env_config::type_id::create("m_uart_env_config", this);  

      if( ! uvm_config_db#(virtual uart_system_if)::get(this, "", "uart_system_vif", m_uart_env_config.m_uart_agent_config_system.uart_system_vif) ) begin
        `uvm_error(this.get_type_name(), "uart_system_vif NOT found")
      end

      if( ! uvm_config_db#(virtual uart_rx_if)::get(this, "", "uart_rx_vif", m_uart_env_config.m_uart_agent_config_rx.uart_rx_vif) ) begin
        `uvm_error(this.get_type_name(), "uart_rx_vif NOT found")
      end

      if( ! uvm_config_db#(virtual uart_tx_if)::get(this, "", "uart_tx_vif", m_uart_env_config.m_uart_agent_config_tx.uart_tx_vif) ) begin
        `uvm_error(this.get_type_name(), "uart_tx_vif NOT found")
      end

      uvm_config_db#(uart_env_config)::set(this, "m_uart_env", "m_uart_env_config", m_uart_env_config);

    endfunction: build_phase 

  endclass: uart_test_base

`endif //UART_TEST_BASE_SV