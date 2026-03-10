`ifndef UART_DRIVER_TX
  `define UART_DRIVER_TX

  typedef class uart_seq_item_drv_tx;

  class uart_driver_tx extends uvm_driver#(uart_seq_item_drv_tx);

    `uvm_component_utils(uart_driver_tx)

    virtual uart_tx_if uart_tx_vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if( ! uvm_config_db#(virtual uart_tx_if)::get(this, "", "uart_tx_vif", uart_tx_vif) ) begin
        `uvm_error( this.get_type_name(), "uart_tx_vif NOT found" )
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

    extern local task drive(uart_seq_item_drv_tx req);

  endclass: uart_driver_tx
      
  /**************************************************************************/    
  /***************************** IMPLEMENTATION *****************************/    
  /**************************************************************************/ 
      
  //initialize
  //----------
  task uart_driver_tx:: initialize();
    uart_tx_vif.tx_start	<= 1'b0;
    uart_tx_vif.din			<= '0;
  endtask

  //drive
  //-----
  task uart_driver_tx:: drive(uart_seq_item_drv_tx req);
    realtime BAUD_period;

    //Two parallel processes:
    //   The 1st process: handles normal operation (no reset)
    //   The 2nd process: handles reset
    
    fork
      begin: first_process
        
        @(posedge uart_tx_vif.clk);
        uart_tx_vif.tx_start <= req.tx_start;
        uart_tx_vif.din 	 <= req.din;		//LSB is transferred firstly

        fork
          @(posedge uart_tx_vif.clk) begin
            uart_tx_vif.tx_start <= 1'b0;
            uart_tx_vif.din 	 <= '0;
          end
        join_none

        BAUD_period = (16.0 * (uart_tx_vif.dvsr+1)) / CLK_freq;

        if(req.tx_start === 1'b1)
          #(10*BAUD_period);					//1 start bit + 8 data bit + 1 stop bit
        
        disable second_process;

        `uvm_info(this.get_type_name(), req.convert2string, UVM_LOW)
        
      end: first_process
      
      begin: second_process
        
        @(posedge uart_tx_vif.clk, posedge uart_tx_vif.reset)
          if(uart_tx_vif.reset === 1'b1) begin
            disable first_process;
            uart_tx_vif.tx_start <= 1'b0;
          end
        
      end: second_process
    join        
     
  endtask: drive
    
`endif //UART_DRIVER_TX
