`ifndef UART_MONITOR_RX
  `define UART_MONITOR_RX

  typedef class uart_seq_item_mon_rx;

  class uart_monitor_rx extends uvm_monitor;

    `uvm_component_utils(uart_monitor_rx)

    virtual uart_rx_if							uart_rx_vif;
    uvm_analysis_port#(uart_seq_item_mon_rx) 	ap;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      ap = new("ap", this);

      if( ! uvm_config_db#(virtual uart_rx_if)::get(this, "", "uart_rx_vif", uart_rx_vif) ) begin
        `uvm_error( this.get_type_name(), "uart_rx_vif NOT found" )
      end    
    endfunction: build_phase

    task run_phase(uvm_phase phase);
      monitor();  
    endtask: run_phase

    extern local task monitor();

  endclass: uart_monitor_rx
      
  /**************************************************************************/    
  /***************************** IMPLEMENTATION *****************************/    
  /**************************************************************************/ 

  //monitor
  task uart_monitor_rx:: monitor();
    realtime BAUD_period;
    uart_seq_item_mon_rx item;
    item = uart_seq_item_mon_rx::type_id::create("item");
    
    //Two parallel peocesses (both are forever loops):
    //   The 1st process: handles normal operation (no reset)
    //   The 2nd process: handles reset

    fork 
      forever begin: first_forever_body

        forever
          @(posedge uart_rx_vif.clk)
            if(uart_rx_vif.rx === 1'b0) 								//start bit
              break;

        item.dvsr = uart_rx_vif.dvsr;
        
        BAUD_period = (16.0 * (item.dvsr+1)) / CLK_freq;
        
        #BAUD_period;
        
        for (int i=0; i<=7; i++) begin
          item.dout_expected[i] = uart_rx_vif.rx; #BAUD_period;			//data bits (8)
        end
        
        STOP_BIT_RX_A: assert(uart_rx_vif.rx === 1'b1) else begin
          `uvm_fatal("UART_PROTOCOL_ERROR", "Error in a received UART frmae (STOP_BIT_RX_A)")
        end
        #BAUD_period;	//stop bit
        
        item.dout_actual = uart_rx_vif.dout;
        
        item.reset = uart_rx_vif.reset;
        assert(uart_rx_vif.reset === 1'b0);
        
        ap.write(item);
        
        `uvm_info(this.get_type_name(), item.convert2string, UVM_LOW) 
        
      end: first_forever_body
      
      forever begin: second_forever_body
        
        @(posedge uart_rx_vif.clk, posedge uart_rx_vif.reset)
          if(uart_rx_vif.reset === 1'b1) begin          
            disable first_forever_body;
			#1ps;
            
            DOUT_AT_RESET_A: assert(uart_rx_vif.dout === '0) else begin
              `uvm_fatal("UART_PROTOCOL_ERROR", "Error in a received UART frmae (DOUT_AT_RESET_A)")
            end

            item.reset 		 	= uart_rx_vif.reset;
            item.dvsr = uart_rx_vif.dvsr;
            item.dout_actual 	= uart_rx_vif.dout;
            item.dout_expected 	= '0;

            ap.write(item);
            `uvm_info(this.get_type_name(), item.convert2string, UVM_LOW) 
          end
        
      end: second_forever_body
    join
  endtask: monitor
    
`endif //UART_MONITOR_RX
