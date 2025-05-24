class transaction;
    rand bit [7:0] data_in;               // Random input data
    rand bit write_en, read_en;          // Random control signals

    // Constraint: only one of write/read can be high, or both can be low (idle)
   constraint valid_trans {
        (write_en ^ read_en == 1)
        || (write_en == 0 && read_en == 0);
    }

    // Display transaction contents
    function void display();
        $display("Transaction: data_in=%0d, write_en=%b, read_en=%b", data_in, write_en, read_en);
    endfunction
endclass

class generator;
    mailbox #(transaction) gen2drv;      // Mailbox to send transactions to driver
    event done;                          // Event to signal completion

    function new(mailbox #(transaction) gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
        repeat(10) begin
            transaction tr = new();      // Create new transaction
            tr.randomize();              // Randomize it
            gen2drv.put(tr);             // Send to driver
            tr.display();                // Display contents
            #10;
        end
        ->done;                          // Signal done after all transactions sent
    endtask
endclass

class driver;
    virtual fifo_if.tb vif;              // Virtual interface for driving DUT
    mailbox #(transaction) gen2drv;      // Mailbox to receive transactions

    function new(virtual fifo_if.tb vif, mailbox #(transaction) gen2drv);
        this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction

    task run();
        transaction tr;
        forever begin
            gen2drv.get(tr);            // Get next transaction
            vif.data_in = tr.data_in;   // Drive inputs to DUT
            vif.write_en = tr.write_en;
            vif.read_en = tr.read_en;
            #10;
        end
    endtask
endclass

class monitor;
    virtual fifo_if.mon vif;             // Virtual interface for observing DUT outputs
    mailbox mon2sb;                      // Mailbox to send observed data to scoreboard

    function new(virtual fifo_if.mon vif, mailbox mon2sb);
        this.vif = vif;
        this.mon2sb = mon2sb;
    endfunction

    task run();
        forever begin
            #10;
            mon2sb.put(vif.data_out);    // Send DUT output to scoreboard
        end
    endtask
endclass

class scoreboard;
    mailbox mon2sb;                      // Mailbox to receive monitored output
    virtual fifo_if.tb vif;             // Virtual interface to get expected values
    logic [7:0] expected_data[$];       // Queue for storing expected data
    logic [7:0] actual_data;            // Temporary for comparison

    function new(mailbox mon2sb, virtual fifo_if.tb vif);
        this.vif = vif;
        this.mon2sb = mon2sb;
    endfunction

    task run();
        logic [7:0] monitored_data;
        forever begin
            // Capture expected data on write operation
            @(posedge vif.clk_wr);
            if (vif.write_en)
                expected_data.push_back(vif.data_in);

            // On read, pop expected data and compare with actual
            @(posedge vif.clk_rd);
            if (vif.read_en) begin
                if (expected_data.size() > 0)
                    actual_data = expected_data.pop_front();
                else
                    actual_data = 8'bx;

                mon2sb.get(monitored_data);  // Get actual output from monitor

                // Compare expected vs. actual
                if (monitored_data != actual_data)
                    $fatal("Mismatch! Expected=%0d, Got=%0d", actual_data, monitored_data);
                else
                    $display("PASS: data_out=%0d", monitored_data);
            end
        end
    endtask
endclass
