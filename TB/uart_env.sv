`ifndef UART_ENV_SV
  `define UART_ENV_SV

  typedef class uart_env_config;
  typedef class uart_agent_system;
  typedef class uart_agent_rx;
  typedef class uart_agent_tx;
  typedef class uart_agent_config_system;
  typedef class uart_agent_config_rx;
  typedef class uart_agent_config_tx;
  typedef class uart_coverage_collector_system;
  typedef class uart_coverage_collector_rx;
  typedef class uart_coverage_collector_tx;
  typedef class uart_scoreboard;

  class uart_env extends uvm_env;

    `uvm_component_utils(uart_env)

    uart_env_config 				m_uart_env_config;
    uart_agent_system 				m_uart_agent_system;
    uart_agent_rx 					m_uart_agent_rx;
    uart_agent_tx 					m_uart_agent_tx;
    uart_coverage_collector_system 	m_uart_coverage_collector_system;
    uart_coverage_collector_rx 		m_uart_coverage_collector_rx;
    uart_coverage_collector_tx 		m_uart_coverage_collector_tx;
    uart_scoreboard					m_uart_scoreboard;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new

    extern function void build_phase(uvm_phase phase);

    extern function void connect_phase(uvm_phase phase);

  endclass: uart_env
      
  /**************************************************************************/    
  /***************************** IMPLEMENTATION *****************************/    
  /**************************************************************************/    

  //build_phase
  //-----------

  function void uart_env:: build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //Environment configuration object
    m_uart_env_config = uart_env_config::type_id::create("m_uart_env_config", this);
    if( ! uvm_config_db#(uart_env_config)::get(this, "", "m_uart_env_config", m_uart_env_config) ) begin
      `uvm_error(this.get_type_name(), "m_uart_env_config NOT found")
    end    
    //manipulate properties of m_uart_env_config HERE

    //Agents (system, rx, tx)
    m_uart_agent_system = uart_agent_system::type_id::create("m_uart_agent_system", this);
    m_uart_agent_rx 	= uart_agent_rx::type_id::create("m_uart_agent_rx", this);
    m_uart_agent_tx 	= uart_agent_tx::type_id::create("m_uart_agent_tx", this);

    //Agents configuration objects (system, rx, tx)
    uvm_config_db#(uart_agent_config_system)::set(this, "m_uart_agent_system", "m_uart_agent_config_system", m_uart_env_config.m_uart_agent_config_system);
    uvm_config_db#(uart_agent_config_rx)::set(this, "m_uart_agent_rx", "m_uart_agent_config_rx", m_uart_env_config.m_uart_agent_config_rx);
    uvm_config_db#(uart_agent_config_tx)::set(this, "m_uart_agent_tx", "m_uart_agent_config_tx", m_uart_env_config.m_uart_agent_config_tx);

    //Coverage collectors (system, rx, tx)
    if( m_uart_env_config.coverage_enable_system == 1 )
        m_uart_coverage_collector_system = uart_coverage_collector_system::type_id::create("m_uart_coverage_collector_system", this);
    if( m_uart_env_config.coverage_enable_rx == 1 )
        m_uart_coverage_collector_rx = uart_coverage_collector_rx::type_id::create("m_uart_coverage_collector_rx", this);
    if( m_uart_env_config.coverage_enable_tx == 1 )
        m_uart_coverage_collector_tx = uart_coverage_collector_tx::type_id::create("m_uart_coverage_collector_tx", this);
    
    //Scoreboard
    m_uart_scoreboard = uart_scoreboard::type_id::create("m_uart_scoreboard", this);
    
  endfunction: build_phase 

  //connect_phase
  //-------------

  function void uart_env:: connect_phase(uvm_phase phase);
    
    //Agent --> Coverage collector
    if( m_uart_env_config.coverage_enable_system == 1 )
        m_uart_agent_system.ap.connect(m_uart_coverage_collector_system.analysis_export);
    if( m_uart_env_config.coverage_enable_rx == 1 )
        m_uart_agent_rx.ap.connect(m_uart_coverage_collector_rx.analysis_export);    
    if( m_uart_env_config.coverage_enable_tx == 1 )
        m_uart_agent_tx.ap.connect(m_uart_coverage_collector_tx.analysis_export);
  
    //Agent --> Scoreboard
    m_uart_agent_rx.ap.connect(m_uart_scoreboard.imp_in_rx);
    m_uart_agent_tx.ap.connect(m_uart_scoreboard.imp_in_tx);
    
  endfunction: connect_phase 
    
`endif //UART_ENV_SV