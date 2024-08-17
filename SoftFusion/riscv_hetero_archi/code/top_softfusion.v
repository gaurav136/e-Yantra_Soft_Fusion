//RISC-V CPU
/*
Instructions
-------------------.
This file is the top-level verilog design for RISC-V CPU Implementation

Recommended Quartus Version : 20.1

-------------------
*/

// top_riscv_cpu module declaration
module top_softfusion (
    input clk, 
    input reset,
    input Ext_MemWrite,
    input [31:0] Ext_WriteData, 
    input [31:0] Ext_DataAdr,
    output MemWrite,
    output [31:0] WriteData, 
    output [31:0] DataAdr, 
    output [31:0] ReadData,
    output [31:0] PC,
    output [31:0] Result
);

// wire lines from other modules
wire [31:0] Instr;
wire [31:0] DataAdr_rv32, WriteData_rv32;
wire [1:0] Store, Store_rv32;
wire MemWrite_rv32;
wire CPU_DONE;
wire [31:0] final_path_node;
wire [31:0] ReadAddr, ACD;


// instantiate processor and memories
riscv_cpu rvsingle (clk, reset, PC, Instr, MemWrite_rv32, DataAdr_rv32, WriteData_rv32, Store_rv32, ReadData, Result);
instr_mem imem (PC, Instr);
//data_mem dmem (clk, MemWrite, DataAdr, WriteData, Store, ReadData);
data_mem dmem (clk, MemWrite, ACD, WriteData, Store, ReadData, CPU_DONE);
mem_div mem_dijkstra(clk, CPU_DONE, ReadData, ReadAddr, final_path_node);
mux2 #(32) addr_cpu_div ( DataAdr,ReadAddr,CPU_DONE , ACD );

// output assignments
assign Store    = (Ext_MemWrite && reset) ? 2'b10 : Store_rv32;
assign MemWrite = (Ext_MemWrite && reset) ? 1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
assign DataAdr = (reset) ? Ext_DataAdr : DataAdr_rv32;
endmodule
    
