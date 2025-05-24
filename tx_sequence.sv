class tx_sequence extends uvm_sequence #(tx_item);
    `uvm_object_utils(tx_sequence)

    // Constructor
    function new(string name = "tx_sequence");
        super.new(name);        
    endfunction // new()

    // Sequence body
    virtual task body();
        tx_item tx;
        int i=0;
        // Loop for 10 iterations
        repeat(10) begin
            // Create a new transaction item
            tx = tx_item::type_id::create("tx");
            
            // Determine write_en or read_en based on cycle number
            if (i < 3) begin
                // For the first 5 iterations, enable write
                tx.write_en = 1;
                tx.read_en = 0;
            end else begin
                // For the next 5 iterations, enable read
                tx.write_en = 0;
                tx.read_en = 1;
            end
            
            // Start the transaction item
            start_item(tx);
            
            // Randomize the transaction fields (excluding the control signals)
            if (!tx.randomize()) begin
                `uvm_fatal(get_type_name, "CANT RANDOMIZE");
            end
            
            // Finish the transaction item
            finish_item(tx);
            
            // Delay for 10 time units (adjust as per your needs)
            #10;
            
            // Increment the cycle count (i++)
            i = i + 1;
        end
    endtask // body()

endclass // tx_sequence extends uvm_sequence #(tx_item)
