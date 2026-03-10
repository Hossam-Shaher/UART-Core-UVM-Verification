`ifndef UART_DRIVER_RX
  `define UART_DRIVER_RX

  typedef class uart_seq_item_drv_rx;

  class uart_driver_rx extends uvm_driver#(uart_seq_item_drv_rx);

    `uvm_component_utils(uart_driver_rx)

    virtual uart_rx_if uart_rx_vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if( ! uvm_config_db#(virtual uart_rx_if)::get(this, "", "uart_rx_vif", uart_rx_vif) ) begin
        `uvm_error( this.get_type_name(), "uart_rx_vif NOT found" )
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

    extern local task drive(uart_seq_item_drv_rx req);

  endclass: uart_driver_rx
      
  /**************************************************************************/    
  /***************************** IMPLEMENTATION *****************************/    
  /**************************************************************************/ 
      
  //initialize
  //----------
  task uart_driver_rx:: initialize();
    uart_rx_vif.rx <= 1'b1;		//idle
  endtask

  //drive
  //-----
  task uart_driver_rx:: drive(uart_seq_item_drv_rx req);
    realtime BAUD_period;

    //Two parallel processes:
    //   The 1st process: handles normal operation (no reset)
    //   The 2nd process: handles reset
    
    fork
      begin: first_process
        
        @(posedge uart_rx_vif.clk);						//idle

        BAUD_period = (16.0 * (uart_rx_vif.dvsr+1)) / CLK_freq;
        
        uart_rx_vif.rx <= 1'b0; #BAUD_period;			//start bit
        
        for (int i=0; i<=7; i++) begin
          uart_rx_vif.rx <= req.rx[i]; #BAUD_period;	//data bits (8)
        end

        uart_rx_vif.rx <= 1'b1; #BAUD_period;			//stop bit

        disable second_process;

        `uvm_info(this.get_type_name(), req.convert2string, UVM_LOW) 
      
      end: first_process
      
      begin: second_process
        
        @(posedge uart_rx_vif.clk, posedge uart_rx_vif.reset) 
          if(uart_rx_vif.reset === 1'b1) begin          
            disable first_process;
            uart_rx_vif.rx <= 1'b1;            			//idle
          end
        
      end: second_process
    join
    
  endtask: drive
    
`endif //UART_DRIVER_RX