`ifndef UART_AGENT_RX_SV
  `define UART_AGENT_RX_SV

  typedef class uart_agent_config_rx;
  typedef class uart_monitor_rx;
  typedef class uart_sequencer_rx;
  typedef class uart_driver_rx; 
  typedef class uart_seq_item_mon_rx;

  class uart_agent_rx extends uvm_agent;
    `uvm_component_utils(uart_agent_rx)

    uart_agent_config_rx 						m_uart_agent_config_rx;
    uart_monitor_rx 							m_uart_monitor_rx;
    uart_sequencer_rx							m_uart_sequencer_rx;
    uart_driver_rx								m_uart_driver_rx;
    uvm_analysis_port#(uart_seq_item_mon_rx)	ap;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new 

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      m_uart_agent_config_rx = uart_agent_config_rx::type_id::create("m_uart_agent_config_rx", this);
      
      if( ! uvm_config_db#(uart_agent_config_rx)::get(this, "", "m_uart_agent_config_rx", m_uart_agent_config_rx) ) begin
        `uvm_error(this.get_type_name(), "m_uart_agent_config_rx NOT found");
      end 
      
      if ( m_uart_agent_config_rx.uart_rx_vif == null ) begin
        `uvm_error(this.get_type_name(), "m_uart_agent_config_rx.uart_rx_vif == null")
      end
      
      if ( get_is_active() == UVM_ACTIVE) begin
        m_uart_driver_rx = uart_driver_rx::type_id::create("m_uart_driver_rx", this);
        m_uart_sequencer_rx = uart_sequencer_rx::type_id::create("m_uart_sequencer_rx", this); 

        uvm_config_db#(virtual uart_rx_if)::set(this, "m_uart_driver_rx", "uart_rx_vif", m_uart_agent_config_rx.uart_rx_vif);
        m_uart_sequencer_rx.set_arbitration(m_uart_agent_config_rx.arb_mode);
      end

      m_uart_monitor_rx = uart_monitor_rx::type_id::create("m_uart_monitor_rx", this);
      uvm_config_db#(virtual uart_rx_if)::set(this, "m_uart_monitor_rx", "uart_rx_vif", m_uart_agent_config_rx.uart_rx_vif);

      ap = new("ap", this);

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
      if ( get_is_active() == UVM_ACTIVE) begin
          m_uart_driver_rx.seq_item_port.connect(m_uart_sequencer_rx.seq_item_export);
      end
      m_uart_monitor_rx.ap.connect(ap);
    endfunction: connect_phase

    function uvm_active_passive_enum get_is_active();
      return uvm_active_passive_enum'(m_uart_agent_config_rx.is_active);
    endfunction: get_is_active

  endclass: uart_agent_rx

`endif  //UART_AGENT_RX_SV
