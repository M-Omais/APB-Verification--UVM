class tx_monitor extends uvm_monitor;
    `uvm_component_utils(tx_monitor)
    function new(string name , uvm_component parent);
        super.new(name,parent);
    endfunction //new()
    virtual fifo_if vif;
    agent_config agt_cfg;
    uvm_analysis_port #(tx_item) dut_in_tx_port;   
    uvm_analysis_port #(tx_item) dut_out_tx_port;
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        dut_in_tx_port = new("dut_in_tx_port",this);
        dut_out_tx_port = new("dut_out_tx_port",this);
        if (!uvm_config_db #(agent_config)::get(this,"","agt_cfg",agt_cfg)) begin
            `uvm_fatal("MONITOR","UNABLE TO GET VIRTUAL INTERFACE")
        end
        vif = agt_cfg.vif;
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        fork
            get_inputs();
            get_outputs();
        join
    endtask //   
    
    virtual task get_inputs();
        tx_item tx_in;
        forever begin
            tx_in = tx_item::type_id::create("tx_in");

                tx_in.write_en = vif.write_en ;
                tx_in.data_in = vif.data_in ;
                `uvm_info("TX_OUT",tx_in.convert2string(),UVM_DEBUG);
            @(posedge vif.clk_wr)begin
                dut_in_tx_port.write(tx_in);
            end
        end
    endtask 
    
    virtual task get_outputs();
        tx_item tx_out;
        forever begin
            tx_out = tx_item::type_id::create("tx_out");
            // vif.get_an_output(tx_out);
                tx_out.data_out = vif.data_out;
                tx_out.full = vif.full;
                tx_out.empty = vif.empty;
                tx_out.read_en = vif.read_en  ;
                // `uvm_info("TX_OUT",tx_out.convert2string(),UVM_LOW);
            @(posedge vif.clk_rd)begin
                dut_out_tx_port.write(tx_out);
            end
        end
    endtask //
endclass //tx_monitor extends uvm_monitor