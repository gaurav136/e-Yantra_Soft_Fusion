//module mem_div #(parameter DATA_WIDTH = 32,
//                 ADDR_WIDTH = 32,
//                 MEM_SIZE = 128)
//                (input clk,
//                 input CPU_DONE,
//                 input [DATA_WIDTH-1:0] wr_data,
//                 output [ADDR_WIDTH-1:0] read_addr,
//                 output [DATA_WIDTH-1:0] rd_sub_mem0,
//                 output [DATA_WIDTH-1:0] rd_sub_mem1,
//                 output [DATA_WIDTH-1:0] rd_sub_mem2,
//                 output [DATA_WIDTH-1:0] rd_sub_mem3);
//    
//    reg [3:0] sub_mem_wr_en;
//    reg [ADDR_WIDTH-1:0] sub_mem_wr_addr;
//    wire sipo_done;
//    wire [DATA_WIDTH-1:0] sipo_out[0:3];
//    reg [ADDR_WIDTH-3:0] rd_addr;
//    
//    // SIPO instance
//    SIPO sipo_inst (
//    .clk(clk),
//    .reset(CPU_DONE),
//    .SI(wr_data),
//    .sipo_done(sipo_done),
//    .PO0(sipo_out[0]),
//    .PO1(sipo_out[1]),
//    .PO2(sipo_out[2]),
//    .PO3(sipo_out[3])
//    );
//    
//    // Reset the write enable signals and address register on power-up
//    initial begin
//        sub_mem_wr_en   = 4'b0;
//        sub_mem_wr_addr = 32'b0;
//        rd_addr         = 32'd4;
//		  read_addr 		= 32'b0;
//    end
//    
//    assign read_addr = {rd_addr, 2'b00};
//
//    always @(posedge clk) begin
//        if (CPU_DONE && rd_addr < 30'd124) begin
//            rd_addr <= rd_addr + 30'd1;
//        end
//        else begin
//            rd_addr <= 32'bx;
//        end
//    end
//    
//    
//    always @(posedge clk) begin
//        if (sipo_done) begin
//            // Distribute data to sub-memories and update address
//            sub_mem_wr_addr <= sub_mem_wr_addr + 1;
//            sub_mem_wr_en   <= 4'b1111;
//            end else begin
//            sub_mem_wr_en <= 4'b0;
//        end
//    end
//    
//    // Instantiate the sub memories
//    sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory0 (
//    .clk(clk),
//    .wr_en(sub_mem_wr_en[0]),
//    .wr_addr(sub_mem_wr_addr),
//    .wr_data(sipo_out[0]),
//    .rd_sub_mem(rd_sub_mem0)
//    );
//    
//    sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory1 (
//    .clk(clk),
//    .wr_en(sub_mem_wr_en[1]),
//    .wr_addr(sub_mem_wr_addr),
//    .wr_data(sipo_out[1]),
//    .rd_sub_mem(rd_sub_mem1)
//    );
//    
//    sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory2 (
//    .clk(clk),
//    .wr_en(sub_mem_wr_en[2]),
//    .wr_addr(sub_mem_wr_addr),
//    .wr_data(sipo_out[2]),
//    .rd_sub_mem(rd_sub_mem2)
//    );
//    
//    sub_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MEM_SIZE(32)) sub_memory3 (
//    .clk(clk),
//    .wr_en(sub_mem_wr_en[3]),
//    .wr_addr(sub_mem_wr_addr),
//    .wr_data(sipo_out[3]),
//    .rd_sub_mem(rd_sub_mem3)
//    );
//    
//endmodule


module mem_div #(parameter DATA_WIDTH = 32,
                 ADDR_WIDTH = 32,
                 MEM_SIZE = 128)
                (input clk,
                 input CPU_DONE,
                 input [DATA_WIDTH-1:0] wr_data,
                 output [ADDR_WIDTH-1:0] read_addr,
                 output [DATA_WIDTH-1:0] rd_sub_mem0,
                 output [DATA_WIDTH-1:0] rd_sub_mem1,
                 output [DATA_WIDTH-1:0] rd_sub_mem2,
                 output [DATA_WIDTH-1:0] rd_sub_mem3);
    
    reg [3:0] sub_mem_wr_en;
    reg [ADDR_WIDTH-1:0] sub_mem_wr_addr;
    wire sipo_done;
    wire [DATA_WIDTH-1:0] sipo_out[0:3];
    reg [ADDR_WIDTH-3:0] rd_addr;
    
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
    
    // Reset the write enable signals and address register on power-up
    initial begin
        sub_mem_wr_en = 4'b0;
        sub_mem_wr_addr = 32'b0;
        rd_addr = 29'd0;
    end
    
    assign read_addr = {rd_addr, 2'b00};

    always @(posedge clk) begin
        if (CPU_DONE && rd_addr < 124) begin
            rd_addr <= rd_addr + 29'd1;
        end else begin
            rd_addr <= 0; // Or some other default value
        end
    end
    
    always @(posedge clk) begin
        if (sipo_done) begin
            // Distribute data to sub-memories and update address
            sub_mem_wr_addr <= sub_mem_wr_addr + 1;
            sub_mem_wr_en <= 4'b1111;
        end else begin
            sub_mem_wr_en <= 4'b0;
        end
    end
    
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

