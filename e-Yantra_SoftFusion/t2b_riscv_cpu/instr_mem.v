
// instr_mem.v - instruction memory for single-cycle RISC-V CPU

module instr_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 512) (
    input       [ADDR_WIDTH-1:0] instr_addr,
    output      [DATA_WIDTH-1:0] instr
);

// array of 64 32-bit words or instructions
reg [DATA_WIDTH-1:0] instr_ram [0:MEM_SIZE-1];

initial begin
    $readmemh("program_dump.hex", instr_ram);
end

// word-aligned memory access
// combinational read logic
assign instr = instr_ram[instr_addr[31:2]];

endmodule



//// instr_mem.v - instruction memory for single-cycle RISC-V CPU
//
//module instr_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 512) (
//    input       [ADDR_WIDTH-1:0] instr_addr,
//    output      [DATA_WIDTH-1:0] instr
//);
//
//// array of 512 32-bit words (instructions)
//reg [DATA_WIDTH-1:0] instr_ram [0:MEM_SIZE-1];
//
//initial begin
//    $readmemh("program_dump.hex", instr_ram);
//end
//
//// Word-aligned memory access
//// Combinational read logic
//assign instr = instr_ram[instr_addr[ADDR_WIDTH-1:2] % MEM_SIZE];
//
//endmodule
