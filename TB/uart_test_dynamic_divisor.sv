`ifndef UART_TEST_DYNAMIC_DIVISOR_SV
  `define UART_TEST_DYNAMIC_DIVISOR_SV

  typedef class uart_test_random;
  typedef class uart_virt_sequence_random;
  typedef class uart_virt_sequence_dynamic_divisor;
  
  class uart_test_dynamic_divisor extends uart_test_random;

    `uvm_component_utils(uart_test_dynamic_divisor)
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
      //You can manipulate nu_repetitions HERE
            
      uart_virt_sequence_random::type_id::set_type_override( uart_virt_sequence_dynamic_divisor::get_type() );
    endfunction: new
    
  endclass: uart_test_dynamic_divisor

`endif //UART_TEST_DYNAMIC_DIVISOR_SV