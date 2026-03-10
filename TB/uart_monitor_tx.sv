`ifndef UART_MONITOR_TX
  `define UART_MONITOR_TX

  typedef class uart_seq_item_mon_tx;

  class uart_monitor_tx extends uvm_monitor;

    `uvm_component_utils(uart_monitor_tx)

    virtual uart_tx_if							uart_tx_vif;
    uvm_analysis_port#(uart_seq_item_mon_tx) 	ap;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      ap = new("ap", this);

      if( ! uvm_config_db#(virtual uart_tx_if)::get(this, "", "uart_tx_vif", uart_tx_vif) ) begin
        `uvm_error( this.get_type_name(), "uart_tx_vif NOT found" )
      end    
    endfunction: build_phase

    task run_phase(uvm_phase phase);
      monitor();  
    endtask: run_phase

    extern local task monitor();

  endclass: uart_monitor_tx
      
  /**************************************************************************/    
  /***************************** IMPLEMENTATION *****************************/    
  /**************************************************************************/ 

  //monitor
  task uart_monitor_tx:: monitor();
    realtime BAUD_period;
    uart_seq_item_mon_tx item;
    item = uart_seq_item_mon_tx::type_id::create("item");
    
    //Two parallel processes (both are forever loops):
    //   The 1st process: handles normal operation (no reset)
    //   The 2nd process: handles reset

    fork 
      forever begin: first_forever_body

        forever
          @(posedge uart_tx_vif.clk)
            if(uart_tx_vif.tx_start === 1'b1) begin
              item.tx_expected = uart_tx_vif.din;				//LSB is transferred firstly
              break;
            end
        
        item.dvsr = uart_tx_vif.dvsr;
        
        BAUD_period = (16.0 * (item.dvsr+1)) / CLK_freq;
        
        @(posedge uart_tx_vif.clk); #1ps;

        START_BIT_TX_A: assert(uart_tx_vif.tx === 1'b0) else begin
          `uvm_fatal("UART_PROTOCOL_ERROR", "Error in a transmitted UART frmae (START_BIT_TX_A)")
        end 
        #BAUD_period; 		//start bit
                
        for (int i=0; i<=7; i++) begin
           item.tx_actual[i] = uart_tx_vif.tx; #BAUD_period; 				//data bits (8)
        end
        
        STOP_BIT_TX_A: assert(uart_tx_vif.tx === 1'b1) else begin
          `uvm_fatal("UART_PROTOCOL_ERROR", "Error in a transmitted UART frmae (STOP_BIT_TX_A)")
        end 
        #BAUD_period; 		//stop bit

        item.reset = uart_tx_vif.reset;
        assert(item.reset === 1'b0);        

        ap.write(item);
        `uvm_info(this.get_type_name(), item.convert2string, UVM_LOW) 
        
      end: first_forever_body
      
      forever begin: second_forever_body
        
        @(posedge uart_tx_vif.clk, posedge uart_tx_vif.reset) 
          if(uart_tx_vif.reset === 1'b1) begin
            disable first_forever_body;
			#1ps;
            
            TX_AT_RESET_A: assert(uart_tx_vif.tx === 1'b1) 	//idle
            else begin	
              `uvm_fatal("UART_PROTOCOL_ERROR", "Error in a transmitted UART frmae (TX_AT_RESET_A)")
            end		

            item.reset 			= uart_tx_vif.reset;
            item.dvsr 			= uart_tx_vif.dvsr;
            item.tx_actual[0] 	= uart_tx_vif.tx;
            item.tx_expected[0] = 1'b1;						//idle

            ap.write(item);
            `uvm_info(this.get_type_name(), item.convert2string, UVM_LOW) 
          end
        
      end: second_forever_body
    join
    
  endtask: monitor
    
`endif //UART_MONITOR_TX
