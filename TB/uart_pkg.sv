`ifndef UART_PKG_SV
  `define UART_PKG_SV

  //Timescale
  `timescale 1s/1ps

  //Interfaces
  `include "uart_system_if.sv"
  `include "uart_rx_if.sv"
  `include "uart_tx_if.sv"

  package uart_pkg;

    //UVM
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    //Globals (parameters, data types, ...)
    `include "uart_globals.sv"
	
	//System
      
      //Sequence item
        `include "uart_seq_item_system.sv"

      //Monitor, sequencer, driver
        `include "uart_monitor_system.sv"
        `include "uart_sequencer_system.sv"
        `include "uart_driver_system.sv"

      //Agent, agent configuration object
        `include "uart_agent_config_system.sv"
        `include "uart_agent_system.sv"

      //Coverage collector
        `include "uart_coverage_collector_system.sv"

	//Rx
      
      //Sequence items
        `include "uart_seq_item_drv_rx.sv"
        `include "uart_seq_item_mon_rx.sv"

      //Monitor, sequencer, driver
        `include "uart_monitor_rx.sv"
        `include "uart_sequencer_rx.sv"
        `include "uart_driver_rx.sv"

      //Agent, agent configuration object
        `include "uart_agent_config_rx.sv"
        `include "uart_agent_rx.sv"

      //Coverage collector
        `include "uart_coverage_collector_rx.sv"

	//Tx
      
      //Sequence item
        `include "uart_seq_item_drv_tx.sv"
        `include "uart_seq_item_mon_tx.sv"

      //Monitor, sequencer, driver
        `include "uart_monitor_tx.sv"
        `include "uart_sequencer_tx.sv"
        `include "uart_driver_tx.sv"

      //Agent, agent configuration object
        `include "uart_agent_config_tx.sv"
        `include "uart_agent_tx.sv"

      //Coverage collector
        `include "uart_coverage_collector_tx.sv"

    //Scoreboard
    `include "uart_scoreboard.sv"

    //Environment, environment configuration object
    `include "uart_env_config.sv"
    `include "uart_env.sv"

    //Sequences
    `include "uart_sequence_system.sv"
    `include "uart_sequence_rx.sv"
    `include "uart_sequence_tx.sv"
    `include "uart_virt_sequence_random.sv"
    `include "uart_virt_sequence_normal_operation.sv"
    `include "uart_virt_sequence_dynamic_divisor.sv"
    `include "uart_virt_sequence_reset.sv"

    //Tests
    `include "uart_test_base.sv"
    `include "uart_test_random.sv"
    `include "uart_test_normal_operation.sv"
    `include "uart_test_dynamic_divisor.sv"
	`include "uart_test_directed_data.sv"
	`include "uart_test_reset.sv"

  endpackage: uart_pkg 

`endif //UART_PKG_SV