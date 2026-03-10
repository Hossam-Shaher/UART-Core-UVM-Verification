`ifndef UART_AGENT_TX_SV
  `define UART_AGENT_TX_SV

  typedef class uart_agent_config_tx;
  typedef class uart_monitor_tx;
  typedef class uart_sequencer_tx;
  typedef class uart_driver_tx; 
  typedef class uart_seq_item_mon_tx;

  class uart_agent_tx extends uvm_agent;
    `uvm_component_utils(uart_agent_tx)

    uart_agent_config_tx 						m_uart_agent_config_tx;
    uart_monitor_tx 							m_uart_monitor_tx;
    uart_sequencer_tx							m_uart_sequencer_tx;
    uart_driver_tx								m_uart_driver_tx;
    uvm_analysis_port#(uart_seq_item_mon_tx)	ap;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new 

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      m_uart_agent_config_tx = uart_agent_config_tx::type_id::create("m_uart_agent_config_tx", this);
      
      if( ! uvm_config_db#(uart_agent_config_tx)::get(this, "", "m_uart_agent_config_tx", m_uart_agent_config_tx) ) begin
        `uvm_error(this.get_type_name(), "m_uart_agent_config_tx NOT found");
      end 
      
      if ( m_uart_agent_config_tx.uart_tx_vif == null ) begin
        `uvm_error(this.get_type_name(), "m_uart_agent_config_tx.uart_tx_vif == null")
      end
      
      if ( get_is_active() == UVM_ACTIVE) begin
        m_uart_driver_tx = uart_driver_tx::type_id::create("m_uart_driver_tx", this);
        m_uart_sequencer_tx = uart_sequencer_tx::type_id::create("m_uart_sequencer_tx", this); 

        uvm_config_db#(virtual uart_tx_if)::set(this, "m_uart_driver_tx", "uart_tx_vif", m_uart_agent_config_tx.uart_tx_vif);
        m_uart_sequencer_tx.set_arbitration(m_uart_agent_config_tx.arb_mode);
      end

      m_uart_monitor_tx = uart_monitor_tx::type_id::create("m_uart_monitor_tx", this);
      uvm_config_db#(virtual uart_tx_if)::set(this, "m_uart_monitor_tx", "uart_tx_vif", m_uart_agent_config_tx.uart_tx_vif);

      ap = new("ap", this);

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
      if ( get_is_active() == UVM_ACTIVE) begin
          m_uart_driver_tx.seq_item_port.connect(m_uart_sequencer_tx.seq_item_export);
      end
      m_uart_monitor_tx.ap.connect(ap);
    endfunction: connect_phase

    function uvm_active_passive_enum get_is_active();
      return uvm_active_passive_enum'(m_uart_agent_config_tx.is_active);
    endfunction: get_is_active

  endclass: uart_agent_tx

`endif  //UART_AGENT_TX_SV