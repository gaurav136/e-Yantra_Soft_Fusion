
// sub_mem.v 

module sub_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 32) (
    input       clk, wr_en,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
    output      [DATA_WIDTH-1:0] rd_sub_mem
);

// array of 64 32-bit words or data
reg [DATA_WIDTH-1:0] sub_ram [0:MEM_SIZE-1];

// combinational read logic
// word-aligned memory access
assign rd_sub_mem = sub_ram[wr_addr[DATA_WIDTH-1:2] % MEM_SIZE];

// synchronous write logic
always @(posedge clk) begin
    if (wr_en) sub_ram[wr_addr[DATA_WIDTH-1:2] % MEM_SIZE] <= wr_data;
end

endmodule
