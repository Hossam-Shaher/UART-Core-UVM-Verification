`ifndef UART_COVERAGE_COLLECTOR_SYSTEM_SV
  `define UART_COVERAGE_COLLECTOR_SYSTEM_SV

  typedef class uart_seq_item_system;
    
  class uart_coverage_collector_system extends uvm_subscriber#(uart_seq_item_system);
    `uvm_component_utils(uart_coverage_collector_system)

    uart_seq_item_system 	item;

    covergroup cover_group_system;
      option.per_instance = 1;

      reset : coverpoint item.reset {
        option.comment = "reset";
      }
      
      dvsr : coverpoint item.dvsr {
        option.comment = "divisor";
        bins common_baud_rates[3] = {11, 23, 47};	//corresponding baud rates: 9600, 4800, and 2400 bps
      }
    endgroup: cover_group_system

    function new(string name, uvm_component parent);
      super.new(name, parent);
      cover_group_system = new();
    endfunction: new  

    function void write(uart_seq_item_system t);
      item = t;
      cover_group_system.sample();
    endfunction: write

    function string coverage2string();
      coverage2string  = {
        $sformatf("\n  cover_group_system:		%.2f%%", cover_group_system.get_inst_coverage()),
        $sformatf("\n       dvsr:				%.2f%%", cover_group_system.dvsr.get_inst_coverage()),
        $sformatf("\n       reset:				%.2f%%", cover_group_system.reset.get_inst_coverage()),
        $sformatf("\n  ======================================"),
        $sformatf("\n  OVERALL Coverage:        %.2f%%", $get_coverage())
      };    
    endfunction: coverage2string

    function void report_phase(uvm_phase phase);
      `uvm_info("COVERAGE", coverage2string(), UVM_NONE)
    endfunction: report_phase

  endclass: uart_coverage_collector_system

`endif //UART_COVERAGE_COLLECTOR_SYSTEM_SV