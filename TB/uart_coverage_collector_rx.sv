`ifndef UART_COVERAGE_COLLECTOR_RX_SV
  `define UART_COVERAGE_COLLECTOR_RX_SV

  typedef class uart_seq_item_mon_rx;
    
  class uart_coverage_collector_rx extends uvm_subscriber#(uart_seq_item_mon_rx);
    `uvm_component_utils(uart_coverage_collector_rx)

    uart_seq_item_mon_rx 	item;

    covergroup cover_group_rx;
      option.per_instance = 1;

      dout : coverpoint item.dout_actual {
        option.comment = "dout";
        bins all_zeros 		  = {8'h00};
        bins all_ones 		  = {8'hFF};
        bins alternating_bits = {8'h55, 8'hAA};		//8'b0101_0101, 8'b1010_1010
      }
      
      dvsr : coverpoint item.dvsr {
        option.comment = "divisor";
        bins common_baud_rates[3] = {11, 23, 47};	//corresponding baud rates: 9600, 4800, and 2400 bps
      }      
      
      reset : coverpoint item.reset {
        option.comment = "reset";
      }
    endgroup: cover_group_rx

    function new(string name, uvm_component parent);
      super.new(name, parent);
      cover_group_rx = new();
    endfunction: new  

    function void write(uart_seq_item_mon_rx t);
      item = t;
      cover_group_rx.sample();
    endfunction: write

    function string coverage2string();
      coverage2string  = {
        $sformatf("\n  cover_group_rx:			%.2f%%", cover_group_rx.get_inst_coverage()),
        $sformatf("\n       dout:				%.2f%%", cover_group_rx.dout.get_inst_coverage()),
        $sformatf("\n       dvsr:				%.2f%%", cover_group_rx.dvsr.get_inst_coverage()),
        $sformatf("\n       reset:				%.2f%%", cover_group_rx.reset.get_inst_coverage()),
        $sformatf("\n  ======================================"),
        $sformatf("\n  OVERALL Coverage:        %.2f%%", $get_coverage())
      };    
    endfunction: coverage2string

    function void report_phase(uvm_phase phase);
      `uvm_info("COVERAGE", coverage2string(), UVM_NONE)
    endfunction: report_phase

  endclass: uart_coverage_collector_rx

`endif //UART_COVERAGE_COLLECTOR_RX_SV