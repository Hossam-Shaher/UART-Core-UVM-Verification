`ifndef UART_SCOREBOARD_SV
  `define UART_SCOREBOARD_SV

  typedef class uart_seq_item_mon_rx;
  typedef class uart_seq_item_mon_tx;

  `uvm_analysis_imp_decl(_in_rx) 	// Class: uvm_analysis_imp_in_rx	Method: write_in_rx
  `uvm_analysis_imp_decl(_in_tx)	// Class: uvm_analysis_imp_in_tx	Method: write_in_tx
    
  class uart_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(uart_scoreboard)
    
    //Analysis implementation ports
    uvm_analysis_imp_in_rx#(uart_seq_item_mon_rx, uart_scoreboard) imp_in_rx;	//for receiving information from RX side
    uvm_analysis_imp_in_tx#(uart_seq_item_mon_tx, uart_scoreboard) imp_in_tx;	//for receiving information from TX side
    
    //Counters(s) used in report_phase
    local int unsigned mismatch_count = 0;
        
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction: new
    
    extern function void build_phase (uvm_phase phase);
      
    extern function void write_in_rx(uart_seq_item_mon_rx item);    //port_in_rx

    extern function void write_in_tx(uart_seq_item_mon_tx item);    //port_in_tx

    extern function void report_phase (uvm_phase phase);
    
  endclass: uart_scoreboard

  /**************************************************************************/    
  /***************************** IMPLEMENTATION *****************************/    
  /**************************************************************************/ 
      
      
  //build_phase
  //-----------
      
  function void uart_scoreboard:: build_phase (uvm_phase phase);
    super.build_phase(phase);

    imp_in_rx   = new("imp_in_rx", this);
    imp_in_tx   = new("imp_in_tx", this);

  endfunction: build_phase
      
  //write_in_rx
  //-----------
      
  function void uart_scoreboard:: write_in_rx(uart_seq_item_mon_rx item);
       
    if(item.reset == 1'b0) 
      assert(item.dout_actual === item.dout_expected) else begin	
        `uvm_error( this.get_type_name(), $sformatf( "MISMATCH:: item: %s", item.convert2string() ) )  
        mismatch_count++;
      end
         
    else if (item.reset == 1'b1)
      assert(item.dout_actual === item.dout_expected) else begin	
        `uvm_error( this.get_type_name(), $sformatf( "MISMATCH:: item: %s", item.convert2string() ) )  
        mismatch_count++;
      end

  endfunction: write_in_rx
      
  //write_in_tx
  //-----------
      
  function void uart_scoreboard:: write_in_tx(uart_seq_item_mon_tx item);

    if(item.reset == 1'b0) 
      assert(item.tx_actual === item.tx_expected) else begin	
        `uvm_error( this.get_type_name(), $sformatf( "MISMATCH:: item: %s", item.convert2string() ) )  
        mismatch_count++;
      end
        
    else if (item.reset == 1'b1) 
      assert(item.tx_actual[0] === item.tx_expected[0]) else begin	
        `uvm_error( this.get_type_name(), $sformatf( "MISMATCH:: item: %s", item.convert2string() ) )  
        mismatch_count++; 
      end
    
  endfunction: write_in_tx
      
  //report_phase
  //------------
      
  function void uart_scoreboard:: report_phase (uvm_phase phase);
    
    if( mismatch_count == 0) begin 
      `uvm_info("SCOREBOARD RESULTS", $sformatf("Mismatches:: PASS; no mismatches") , UVM_NONE)
    end
    else begin
      `uvm_error("SCOREBOARD RESULTS", $sformatf("Mismatches:: ERROR; number of mismatches: %0d", mismatch_count))
    end

  endfunction: report_phase

`endif //UART_SCOREBOARD_SV