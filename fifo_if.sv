interface fifo_if(input logic clk_wr, clk_rd, rst_n);
    logic write_en, read_en;
    logic [7:0] data_in, data_out;
    logic full, empty;

 modport dut (
        input clk_wr, clk_rd, rst_n,
              write_en, read_en, data_in,
        output data_out, full, empty
    );
endinterface
