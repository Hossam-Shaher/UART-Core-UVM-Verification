`ifndef UART_AGENT_CONFIG_TX_SV
  `define UART_AGENT_CONFIG_TX_SV

  class uart_agent_config_tx extends uvm_object;
    `uvm_object_utils(uart_agent_config_tx)

    virtual uart_tx_if 			uart_tx_vif;
    uvm_active_passive_enum 	is_active = UVM_ACTIVE;
    uvm_sequencer_arb_mode 		arb_mode  = UVM_SEQ_ARB_FIFO;

    function new(string name="");
      super.new(name);
    endfunction: new   

  endclass: uart_agent_config_tx

`endif  //UART_AGENT_CONFIG_TX_SV
