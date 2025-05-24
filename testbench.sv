`include "classes.sv"
`include "fifo_if.sv"

module top;
    logic clk_wr = 0, clk_rd = 0, rst_n=1;
    fifo_if fifoi(clk_wr, clk_rd, rst_n);
    mailbox #(transaction) gen2drv;
    mailbox mon2sb;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard sb;

    // Instantiate FIFO
    fifo dut(fifoi);

    always #5 clk_wr = ~clk_wr;
    always #5 clk_rd = ~clk_rd;

    initial begin
        rst_n = 0; #20; rst_n = 1;
    end

    initial begin
        $stop;
        gen2drv = new(); mon2sb = new();
        gen = new(gen2drv);
        drv = new(fifoi, gen2drv);
        mon = new(fifoi, mon2sb);
        sb = new(mon2sb,fifoi);

        fork
            gen.run();
            drv.run();
            mon.run();
            sb.run();
        join_any
        #1000;
        $stop;
    end
endmodule
