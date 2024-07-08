
// t2b_riscv_cpu module declaration
module t2b_riscv_cpu (input clk,
                      input reset,
                      input Ext_MemWrite,
                      input [31:0] Ext_WriteData,
                      input [31:0] Ext_DataAdr,
                      output MemWrite,
                      output [31:0] WriteData,
                      output [31:0] DataAdr,
                      output [31:0] ReadData);
    
    // wire lines from other modules
    wire [31:0] PC, Instr;
    wire MemWrite_rv32;
    wire [31:0] DataAdr_rv32, WriteData_rv32;
    wire [1:0] Store;
    wire CPU_DONE;
    wire [31:0] rd_sub_mem0, rd_sub_mem1, rd_sub_mem2, rd_sub_mem3;
    wire [31:0] ReadAddr, ACD;
    // instantiate processor and memories
    riscv_cpu rvsingle (clk, reset, PC, Instr, MemWrite_rv32, DataAdr_rv32, WriteData_rv32, Store, ReadData);
    instr_mem imem (PC, Instr);
    data_mem dmem (clk, MemWrite, ACD, WriteData, Store, ReadData, CPU_DONE);
    mem_div mem_dijkstra(clk, CPU_DONE, ReadData, ReadAddr,rd_sub_mem0, rd_sub_mem1, rd_sub_mem2, rd_sub_mem3);
    mux2 #(32) addr_cpu_div ( DataAdr,ReadAddr,CPU_DONE , ACD );
    
    // output assignments
    assign MemWrite  = (Ext_MemWrite && reset) ? 1 : MemWrite_rv32;
    assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
    assign DataAdr   = (reset) ? Ext_DataAdr : DataAdr_rv32;
    
endmodule
    
