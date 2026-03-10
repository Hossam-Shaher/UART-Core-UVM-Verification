`ifndef UART_AGENT_SYSTEM_SV
  `define UART_AGENT_SYSTEM_SV

  typedef class uart_agent_config_system;
  typedef class uart_monitor_system;
  typedef class uart_sequencer_system;
  typedef class uart_driver_system; 
  typedef class uart_seq_item_system;

  class uart_agent_system extends uvm_agent;
    `uvm_component_utils(uart_agent_system)

    uart_agent_config_system 					m_uart_agent_config_system;
    uart_monitor_system 						m_uart_monitor_system;
    uart_sequencer_system						m_uart_sequencer_system;
    uart_driver_system							m_uart_driver_system;
    uvm_analysis_port#(uart_seq_item_system)	ap;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new 

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      m_uart_agent_config_system = uart_agent_config_system::type_id::create("m_uart_agent_config_system", this);
      
      if( ! uvm_config_db#(uart_agent_config_system)::get(this, "", "m_uart_agent_config_system", m_uart_agent_config_system) ) begin
        `uvm_error(this.get_type_name(), "m_uart_agent_config_system NOT found");
      end 
      
      if ( m_uart_agent_config_system.uart_system_vif == null ) begin
        `uvm_error(this.get_type_name(), "m_uart_agent_config_system.uart_system_vif == null")
      end
      
      if ( get_is_active() == UVM_ACTIVE) begin
        m_uart_driver_system = uart_driver_system::type_id::create("m_uart_driver_system", this);
        m_uart_sequencer_system = uart_sequencer_system::type_id::create("m_uart_sequencer_system", this); 

        uvm_config_db#(virtual uart_system_if)::set(this, "m_uart_driver_system", "uart_system_vif", m_uart_agent_config_system.uart_system_vif);
        m_uart_sequencer_system.set_arbitration(m_uart_agent_config_system.arb_mode);
      end

      m_uart_monitor_system = uart_monitor_system::type_id::create("m_uart_monitor_system", this);
      uvm_config_db#(virtual uart_system_if)::set(this, "m_uart_monitor_system", "uart_system_vif", m_uart_agent_config_system.uart_system_vif);

      ap = new("ap", this);

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
      if ( get_is_active() == UVM_ACTIVE) begin
          m_uart_driver_system.seq_item_port.connect(m_uart_sequencer_system.seq_item_export);
      end
      m_uart_monitor_system.ap.connect(ap);
    endfunction: connect_phase

    function uvm_active_passive_enum get_is_active();
      return uvm_active_passive_enum'(m_uart_agent_config_system.is_active);
    endfunction: get_is_active

  endclass: uart_agent_system

`endif  //UART_AGENT_SYSTEM_SV