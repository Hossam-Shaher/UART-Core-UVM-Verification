# UVM Testbench

This is a categorized list of SV files used to build this testbench.

**Top module**
* testbench.sv

**UART package**
* uart_pkg.sv

**Interfaces**
* uart_system_if.sv
* uart_rx_if.sv
* uart_tx_if.sv


**Globals (parameters, data types, ...)**
* uart_globals.sv

**System**

*Sequence item*
* uart_seq_item_system.sv

*Monitor, sequencer, driver*
* uart_monitor_system.sv
* uart_sequencer_system.sv
* uart_driver_system.sv

*Agent, agent configuration object*
* uart_agent_config_system.sv
* uart_agent_system.sv

*Coverage collector*
* uart_coverage_collector_system.sv

**Rx**

*Sequence items*
* uart_seq_item_drv_rx.sv
* uart_seq_item_mon_rx.sv

*Monitor, sequencer, driver*
* uart_monitor_rx.sv
* uart_sequencer_rx.sv
* uart_driver_rx.sv

*Agent, agent configuration object*
* uart_agent_config_rx.sv
* uart_agent_rx.sv

*Coverage collector*
* uart_coverage_collector_rx.sv

**Tx**

*Sequence items*
* uart_seq_item_drv_tx.sv
* uart_seq_item_mon_tx.sv

*Monitor, sequencer, driver*
* uart_monitor_tx.sv
* uart_sequencer_tx.sv
* uart_driver_tx.sv

*Agent, agent configuration object*
* uart_agent_config_tx.sv
* uart_agent_tx.sv

*Coverage collector*
* uart_coverage_collector_tx.sv

**Scoreboard**
* uart_scoreboard.sv

**Environment, environment configuration object**
* uart_env_config.sv
* uart_env.sv

**Sequences**
* uart_sequence_system.sv
* uart_sequence_rx.sv
* uart_sequence_tx.sv
* uart_virt_sequence_random.sv
* uart_virt_sequence_normal_operation.sv
* uart_virt_sequence_dynamic_divisor.sv
* uart_virt_sequence_reset.sv

**Tests**
* uart_test_base.sv
* uart_test_random.sv
* uart_test_normal_operation.sv
* uart_test_dynamic_divisor.sv
* uart_test_directed_data.sv
* uart_test_reset.sv
