class tx_driver extends uvm_driver #(tx_item);
    `uvm_component_utils(tx_driver)

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Virtual interface and agent configuration
    virtual fifo_if vif;
    agent_config agt_cfg;
    tx_item tx;
    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(agent_config)::get(this, "", "agt_cfg", agt_cfg)) begin
            `uvm_fatal("DRIVER", "FAILED TO GET INTERFACE")
        end
        vif = agt_cfg.vif;
    endfunction : build_phase

    // Run phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            tx = tx_item::type_id::create("tx");
            seq_item_port.get_next_item(tx);
            vif.write_en = tx.write_en ;
            vif.read_en = tx.read_en  ;
            vif.data_in = tx.data_in ;
            seq_item_port.item_done();
        end
    endtask : run_phase

endclass : tx_driver