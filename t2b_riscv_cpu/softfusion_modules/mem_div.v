module mem_div #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 128) (
    input                     clk,
    input                     CPU_DONE,
    input  [DATA_WIDTH-1:0]   wr_data,
    output [DATA_WIDTH-1:0]   rd_sub_mem0,
    output [DATA_WIDTH-1:0]   rd_sub_mem1,
    output [DATA_WIDTH-1:0]   rd_sub_mem2,
    output [DATA_WIDTH-1:0]   rd_sub_mem3
);

reg [3:0] sub_mem_wr_en;
reg [ADDR_WIDTH-1:0] sub_mem_wr_addr [0:3];
reg [DATA_WIDTH-1:0] sub_mem_wr_data [0:3];
reg [1:0] sub_mem_index;
reg [ADDR_WIDTH-1:0] wr_addr;

// Reset the write enable signals and address register on power-up
initial begin
    sub_mem_wr_en = 4'b0;
    wr_addr = 32'b0;
    sub_mem_index = 2'b0;
end

always @(posedge clk) begin
    if (CPU_DONE) begin
        // Enable write for the selected sub-memory
        sub_mem_wr_en[sub_mem_index] <= 1;
        sub_mem_wr_addr[sub_mem_index] <= wr_addr;
        sub_mem_wr_data[sub_mem_index] <= wr_data;

        // Move to the next sub-memory
        sub_mem_index <= sub_mem_index + 1;

        // Increment the write address after every 4 writes
        if (sub_mem_index == 3) begin
            wr_addr <= wr_addr + 1;
        end
    end else begin
        // Reset write enable signals when CPU_DONE is not asserted
        sub_mem_wr_en <= 4'b0;
    end
end

// Instantiate the sub memories
sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory0 (
    .clk(clk),
    .wr_en(sub_mem_wr_en[0]),
    .wr_addr(sub_mem_wr_addr[0]),
    .wr_data(sub_mem_wr_data[0]),
    .rd_sub_mem(rd_sub_mem0)
);

sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory1 (
    .clk(clk),
    .wr_en(sub_mem_wr_en[1]),
    .wr_addr(sub_mem_wr_addr[1]),
    .wr_data(sub_mem_wr_data[1]),
    .rd_sub_mem(rd_sub_mem1)
);

sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory2 (
    .clk(clk),
    .wr_en(sub_mem_wr_en[2]),
    .wr_addr(sub_mem_wr_addr[2]),
    .wr_data(sub_mem_wr_data[2]),
    .rd_sub_mem(rd_sub_mem2)
);

sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory3 (
    .clk(clk),
    .wr_en(sub_mem_wr_en[3]),
    .wr_addr(sub_mem_wr_addr[3]),
    .wr_data(sub_mem_wr_data[3]),
    .rd_sub_mem(rd_sub_mem3)
);

endmodule
