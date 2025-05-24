class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)

    fifo_env env;

    function new(string name = "fifo_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        tx_sequence fifo_seq;
        fifo_seq = tx_sequence::type_id::create("fifo_seq");
        phase.raise_objection( this, "Starting  main phase" );
        $display("%t Starting sequence fifo_seq run_phase",$time);
        fifo_seq.start(env.agent.sqr);
        phase.drop_objection( this , "Finished fifo_seq in main phase" );
    endtask
endclass
