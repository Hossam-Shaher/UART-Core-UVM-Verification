`ifndef UART_TEST_NORMAL_OPERATION_SV
  `define UART_TEST_NORMAL_OPERATION_SV

  typedef class uart_test_random;
  typedef class uart_virt_sequence_random;
  typedef class uart_virt_sequence_normal_operation;
  
  class uart_test_normal_operation extends uart_test_random;

    `uvm_component_utils(uart_test_normal_operation)
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
      //You can manipulate nu_repetitions HERE
            
      uart_virt_sequence_random::type_id::set_type_override( uart_virt_sequence_normal_operation::get_type() );
    endfunction: new
    
  endclass: uart_test_normal_operation

`endif //UART_TEST_NORMAL_OPERATION_SV