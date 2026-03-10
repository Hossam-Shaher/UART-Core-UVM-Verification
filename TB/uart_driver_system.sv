`ifndef UART_DRIVER_SYSTEM
  `define UART_DRIVER_SYSTEM

  typedef class uart_seq_item_system;

  class uart_driver_system extends uvm_driver#(uart_seq_item_system);

    `uvm_component_utils(uart_driver_system)

    virtual uart_system_if uart_system_vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if( ! uvm_config_db#(virtual uart_system_if)::get(this, "", "uart_system_vif", uart_system_vif) ) begin
        `uvm_error( this.get_type_name(), "uart_system_vif NOT found" )
      end    
    endfunction: build_phase

    task run_phase(uvm_phase phase);
      initialize();

      forever begin
        seq_item_port.get_next_item(req);
          drive(req);            
        seq_item_port.item_done();
      end
    endtask: run_phase

    extern local task initialize();

    extern local task drive(uart_seq_item_system req);

  endclass: uart_driver_system
      
  /**************************************************************************/    
  /***************************** IMPLEMENTATION *****************************/    
  /**************************************************************************/ 
      
  //initialize
  //----------
  task uart_driver_system:: initialize();
    uart_system_vif.reset	<= 1'b0;
    uart_system_vif.dvsr	<= 11;
  endtask

  //drive
  //-----
  task uart_driver_system:: drive(uart_seq_item_system req);
    @(posedge uart_system_vif.clk);
    
    uart_system_vif.reset 	<= req.reset;
    uart_system_vif.dvsr	<= req.dvsr;
    
    `uvm_info(this.get_type_name(), req.convert2string, UVM_LOW) 
  endtask: drive
    
`endif //UART_DRIVER_SYSTEM