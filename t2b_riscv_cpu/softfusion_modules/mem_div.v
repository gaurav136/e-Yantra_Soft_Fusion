


module mem_div #(parameter DATA_WIDTH = 32,
                 ADDR_WIDTH = 32,
                 MEM_SIZE = 128)
                (input clk,
                 input CPU_DONE,
                 input [DATA_WIDTH-1:0] wr_data,
                 output [ADDR_WIDTH-1:0] read_addr,
                 output [DATA_WIDTH-1:0] final_path_node
					  );
    
    reg [3:0] sub_mem_wr_en;
    reg [ADDR_WIDTH-1:0] sub_mem_addr, mem_div_addr;
    wire sipo_done;
    wire [DATA_WIDTH-1:0] sipo_out[0:3];
    reg [ADDR_WIDTH-1:0] rd_addr;
    reg map_full;
    wire [DATA_WIDTH-1:0] rd_sub_mem0, rd_sub_mem1, rd_sub_mem2, rd_sub_mem3;
    wire [ADDR_WIDTH-1:0] sub_mem_wr_addr;
    
    // SIPO instance
    SIPO sipo_inst (
    .clk(clk),
    .reset(CPU_DONE),
    .SI(wr_data),
    .sipo_done(sipo_done),
    .PO0(sipo_out[0]),
    .PO1(sipo_out[1]),
    .PO2(sipo_out[2]),
    .PO3(sipo_out[3])
    );

     assign read_addr = {rd_addr[29:0], 2'b00};
    
    // Reset the write enable signals and address register on power-up
    initial begin
        sub_mem_wr_en = 4'b0;
        mem_div_addr  = 32'hffff_ffff;
        rd_addr       = 32'h0;
        map_full      = 0;
    end
    
    
    always @(posedge clk) begin
        if (CPU_DONE && rd_addr < MEM_SIZE+1) begin
            rd_addr  <= rd_addr + 32'h1;
            map_full <= 1;
            end else begin
            map_full <= 0;
        end
    end
    
    always @(posedge clk) begin
        if (map_full) begin
            if (sipo_done) begin
                // Distribute data to sub-memories and update address
                mem_div_addr  <= mem_div_addr + 1;
                sub_mem_wr_en <= 4'b1111;
                end else begin
                sub_mem_wr_en <= 4'b0;
            end
            end else begin
            sub_mem_wr_en <= 4'b0;
        end
    end
    
    // Instantiate the mux2 module (ensure it's correctly implemented)
    mux2 #(32) dij_div (
    .d0(dijkstra_mem_addr),
    .d1(mem_div_addr),
    .sel(map_full),
    .y(sub_mem_wr_addr)
    );
    
  // Instantiate the Dijkstra module
    dijkstra Dijkstra (
    .clk(clk),
    .start(map_full),
    .data_to_dijkstra_1(rd_sub_mem0),
    .data_to_dijkstra_2(rd_sub_mem1),
    .data_to_dijkstra_3(rd_sub_mem2),
    .data_to_dijkstra_4(rd_sub_mem3),
    .done(done),
    .next_node_addr(dijkstra_mem_addr)
    //.final_path_node(final_path_node)
    );
    
    // Instantiate the sub memories
    sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory0 (
    .clk(clk),
    .wr_en(sub_mem_wr_en[0]),
    .wr_addr(sub_mem_wr_addr),
    .wr_data(sipo_out[0]),
    .rd_sub_mem(rd_sub_mem0)
    );
    
    sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory1 (
    .clk(clk),
    .wr_en(sub_mem_wr_en[1]),
    .wr_addr(sub_mem_wr_addr),
    .wr_data(sipo_out[1]),
    .rd_sub_mem(rd_sub_mem1)
    );
    
    sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory2 (
    .clk(clk),
    .wr_en(sub_mem_wr_en[2]),
    .wr_addr(sub_mem_wr_addr),
    .wr_data(sipo_out[2]),
    .rd_sub_mem(rd_sub_mem2)
    );
    
    sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory3 (
    .clk(clk),
    .wr_en(sub_mem_wr_en[3]),
    .wr_addr(sub_mem_wr_addr),
    .wr_data(sipo_out[3]),
    .rd_sub_mem(rd_sub_mem3)
    );
    
endmodule
    
    
    
