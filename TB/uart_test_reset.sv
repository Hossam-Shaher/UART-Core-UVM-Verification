`ifndef UART_TEST_RESET_SV
  `define UART_TEST_RESET_SV

  typedef class uart_test_random;
  typedef class uart_virt_sequence_random;
  typedef class uart_virt_sequence_reset;
  
  //In this test, a reset may occur during transmission/ receiving (normal operation constraints are applied)
    
  class uart_test_reset extends uart_test_random;

    `uvm_component_utils(uart_test_reset)
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
      //You can manipulate nu_repetitions HERE
            
      uart_virt_sequence_random::type_id::set_type_override( uart_virt_sequence_reset::get_type() );
    endfunction: new
    
  endclass: uart_test_reset

`endif //UART_TEST_RESET_SV