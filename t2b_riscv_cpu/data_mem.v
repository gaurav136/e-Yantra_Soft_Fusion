module data_mem #(parameter DATA_WIDTH = 32,
                  ADDR_WIDTH = 32,
                  MEM_SIZE = 128)
                 (input clk,
                  input wr_en,
                  input [ADDR_WIDTH-1:0] wr_addr,
                  input [DATA_WIDTH-1:0] wr_data,
                  input [1:0] store_sel, // 00: sb, 01: sh, 10: sw
                  output reg [DATA_WIDTH-1:0] rd_data_mem, // Changed to reg to allow sequential reads
                  output reg CPU_DONE
                  );
    
    // Memory array of 128 32-bit words
    reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];
    
    // Word-aligned memory access
    wire [ADDR_WIDTH-3:0] word_addr = wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE;
    reg [31:0] data;
    
    // Read logic (sequential)
    integer i = 4;
    
    always @(posedge clk) begin
        if (CPU_DONE && i < 124) begin
            rd_data_mem <= data_ram[i]; // Sequentially read data from memory
            i = i + 1;
        end
    end
    
    // CPU_DONE signal generation
    always @(*) begin
        CPU_DONE = (data_ram[3] == 32'hFFFFFFFF) ? 1 : 0; // Check for 0xFFFFFFFF
    end
    
    // Data selection logic
    always @* begin
        case (store_sel)
            2'b00: data = {{24{wr_data[7]}}, wr_data[7:0]}; // sb
            2'b01: data = {{16{wr_data[15]}}, wr_data[15:0]}; // sh
            2'b10: data = wr_data; // sw
            default: data = wr_data;
        endcase
    end
    
    // Synchronous write logic with byte masking
    always @(posedge clk) begin
        if (wr_en) begin
            case (store_sel)
                2'b00: begin // Store byte (sb)
                    case (wr_addr[1:0])
                        2'b00: data_ram[word_addr][7:0]   <= data[7:0];
                        2'b01: data_ram[word_addr][15:8]  <= data[7:0];
                        2'b10: data_ram[word_addr][23:16] <= data[7:0];
                        2'b11: data_ram[word_addr][31:24] <= data[7:0];
                    endcase
                end
                2'b01: begin // Store half-word (sh)
                    case (wr_addr[1])
                        1'b0: data_ram[word_addr][15:0]  <= data[15:0];
                        1'b1: data_ram[word_addr][31:16] <= data[15:0];
                    endcase
                end
                2'b10: begin // Store word (sw)
                    data_ram[word_addr] <= data;
                end
            endcase
        end
    end
    
endmodule
