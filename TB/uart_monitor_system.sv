`ifndef UART_MONITOR_SYSTEM
  `define UART_MONITOR_SYSTEM

  typedef class uart_seq_item_system;

  class uart_monitor_system extends uvm_monitor;

    `uvm_component_utils(uart_monitor_system)

    virtual uart_system_if						uart_system_vif;
    uvm_analysis_port#(uart_seq_item_system) 	ap;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      ap = new("ap", this);

      if( ! uvm_config_db#(virtual uart_system_if)::get(this, "", "uart_system_vif", uart_system_vif) ) begin
        `uvm_error( this.get_type_name(), "uart_system_vif NOT found" )
      end    
    endfunction: build_phase

    task run_phase(uvm_phase phase);
      forever begin
          monitor();  
      end
    endtask: run_phase

    extern local task monitor();

  endclass: uart_monitor_system
      
  /**************************************************************************/    
  /***************************** IMPLEMENTATION *****************************/    
  /**************************************************************************/ 

  //monitor
  task uart_monitor_system:: monitor();
    uart_seq_item_system item;
    item = uart_seq_item_system::type_id::create("item");
    
    @(posedge uart_system_vif.clk);
    
    item.reset 		= uart_system_vif.reset;
    item.dvsr 		= uart_system_vif.dvsr;

    ap.write(item);

    /* `uvm_info(this.get_type_name(), item.convert2string, UVM_LOW) */
  endtask: monitor
    
`endif //UART_MONITOR_SYSTEM