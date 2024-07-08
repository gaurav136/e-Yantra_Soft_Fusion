
module SIPO (input wire clk,         // Clock input
             input wire reset,       // Reset input
             input wire [31:0] SI,   // Serial input (32-bit wide)
             output reg sipo_done,   // SIPO done signal
             output reg [31:0] PO0,  // Parallel output 0 (32-bit wide)
             output reg [31:0] PO1,  // Parallel output 1 (32-bit wide)
             output reg [31:0] PO2,  // Parallel output 2 (32-bit wide)
             output reg [31:0] PO3); // Parallel output 3 (32-bit wide)
    
    reg [31:0] shift_register [0:3]; // 32-bit wide, 4-deep shift register
    reg [1:0] shift_count;           // Count the number of shifts
    
    integer i;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 3; i > 0; i = i - 1) begin
                shift_register[i] <= shift_register[i-1]; // Shift data down
            end
            shift_register[0] <= SI; // Load new data into first stage
            
            // Increment shift count
            shift_count <= shift_count + 1;
            
            // If 4 shifts have been completed, assert sipo_done
            if (shift_count == 3) begin
                sipo_done   <= 1;
                shift_count <= 0; // Reset the shift count
                end else begin
                sipo_done <= 0;
            end
            end else begin
            
            for (i = 0; i < 4; i = i + 1) begin
                shift_register[i] <= 0; // Reset all stages to 0
            end
            shift_count <= 0;
            sipo_done   <= 0;
        end
    end
    
    always @(posedge sipo_done) begin
        PO0 = shift_register[0];
        PO1 = shift_register[1];
        PO2 = shift_register[2];
        PO3 = shift_register[3];
    end
    
endmodule
