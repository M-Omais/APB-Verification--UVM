module fifo(
    input  logic        clk_wr,
    input  logic        clk_rd,
    input  logic        rst_n,
    input  logic        write_en,
    input  logic        read_en,
    input  logic [7:0]  data_in,
    output logic [7:0]  data_out,
    output logic        full,
    output logic        empty);

    parameter DEPTH = 16;  // FIFO depth

    // FIFO memory
    logic [7:0] mem [0:DEPTH-1] = '{default:0}; // Data storage initialized to 0

    // Write and read pointers
    logic [$clog2(DEPTH)-1:0] wr_ptr = 0, rd_ptr = 0;

    // Counter to track number of elements
    logic [$clog2(DEPTH+1)-1:0] count;

    // Write process (triggered on write clock or reset)
    always_ff @(posedge clk_wr or negedge rst_n) begin
        if (!rst_n)begin
            wr_ptr <= 0; // Reset write pointer
        end
        else if (write_en && !full) begin
            mem[wr_ptr] <= data_in; // Write data to memory
            wr_ptr <= wr_ptr + 1;        // Increment write pointer
        end
    end

    // Read process (triggered on read clock or reset)
    always_ff @(posedge clk_rd or negedge rst_n) begin
        if (!rst_n)begin
            rd_ptr <= 0; // Reset write pointer
        end
        else if (read_en) begin
            data_out <= mem[rd_ptr]; // Read data from memory
            rd_ptr <= rd_ptr + 1;         // Increment read pointer
        end
    end

    // Counter logic to track number of valid entries
    always_ff @(posedge clk_wr or posedge clk_rd or negedge rst_n) begin
        if (!rst_n)
            count <= 0; // Reset count
        else begin
            // Increment count for valid write without simultaneous read
            if (write_en && !full && !(read_en && !empty))
                count <= count + 1;
            // Decrement count for valid read without simultaneous write
            else if (read_en && !empty && !(write_en && !full))
                count <= count - 1;
        end
    end

    // Status flags
    assign full = (count == DEPTH); // FIFO is full
    assign empty = (count == 0);    // FIFO is empty

endmodule
