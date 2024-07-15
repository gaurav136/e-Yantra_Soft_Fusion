module dijkstra #(parameter node_count = 30,
                  parameter max_edges = 4)
                 (input clk,
                  input start,
                  input [31:0] data_to_dijkstra_1,
                  input [31:0] data_to_dijkstra_2,
                  input [31:0] data_to_dijkstra_3,
                  input [31:0] data_to_dijkstra_4,
                  output reg done,
                  output reg [31:0] clock_cycles,
                  output reg [10*5-1:0] final_path,
                  output reg [31:0] next_node_addr);
    
    reg [31:0] data_to_dijkstra[0:max_edges-1]; // Buffer to hold data from SIPO module
    
    
    
    integer k;
    
    reg [4:0] s_node, e_node, next_node;
    reg [4:0] i;
    reg [4:0] j;
    reg [15:0] sel;
    reg [15:0] min;
    reg [3:0] count;
    reg [4:0] min_index;
    reg [3:0] next_state;
    reg [15:0] dist [0:node_count];  // keep track of current visited nodes
    reg [5:0] visited_count;
    reg [15:0] dist_h [0:node_count]; // keeps track of history of visited nodes
    reg [10*5-1:0] final_path_reg;
    reg [14:0] adj [0:node_count-1][0:max_edges-1]; // adjacency list
    
    parameter [9:0] infinity = 10'b1111111111; // infinity
    parameter IDLE           = 0, UPDATE_VISIT           = 1, PATH_RETRACE           = 2, NODE_DIST_UPDATE           = 3, CHOOSE_NEXT_NODE           = 4, TEMP           = 5;
    
    initial begin
        // Initialize all signals to default values.
        final_path_reg = 0;
        final_path     = 0;
        clock_cycles   = 0;
        next_state     = IDLE;
        min            = 0;
        min_index      = 0;
        done           = 0;
        sel            = {1'b1, {1'b0, 1'b0, 1'b0, 1'b0, 1'b0}, {infinity}};
        visited_count  = 0;
        count          = 0;
        next_node      = 5'd30;
        s_node         = data_to_dijkstra_3[4:0];
        e_node         = data_to_dijkstra_2[4:0];
    end
    
    
    always@(*)begin
        next_node_addr <= {27'b0,next_node[4:0]};
    end
    
    
    always @(posedge clk) begin
        clock_cycles <= clock_cycles + 1;
        case(next_state)
            IDLE: begin
                if (start) begin
                    s_node = data_to_dijkstra_3[4:0];
                    e_node = data_to_dijkstra_2[4:0];
                    next_node_addr <= 32'd30;
                    done           <= 0;
                    visited_count  <= 0;
                    j              <= s_node;
                    count          <= 1;
                    i              <= 0;
                    for (k = 1; k < node_count; k = k + 1) begin
                        dist[k]   <= {1'b0, s_node, infinity};
                        dist_h[k] <= {1'b0, s_node, infinity};
                    end
                    dist[s_node]        <= {1'b1, s_node, 10'b0};
                    dist_h[s_node]      <= {1'b1, s_node, 10'b0};
                    final_path_reg[4:0] <= e_node;
                    sel                 <= {1'b1, s_node, infinity};
                    next_state          <= TEMP;
                end
            end
            TEMP: begin
                adj[j][0]   <= data_to_dijkstra_1[14:0];
                adj[j][1]   <= data_to_dijkstra_2[14:0];
                adj[j][2]   <= data_to_dijkstra_3[14:0];
                adj[j][3]   <= data_to_dijkstra_4[14:0];
                //adj[j][4] <= data_to_dijkstra_5[14:0];
                //adj[j][5] <= data_to_dijkstra_6[14:0];
                next_state  <= NODE_DIST_UPDATE;
                
            end
            NODE_DIST_UPDATE: begin
                
                // Update distances of all neighbors in parallel
                for (k = 0; k < max_edges; k = k + 1) begin
                    if (((adj[j][k][9:0] + min[9:0]) < dist_h[adj[j][k][14:10]][9:0]) && dist_h[adj[j][k][14:10]][15] ! = 1) begin
                        dist[adj[j][k][14:10]] <= {1'b0, j, {adj[j][k][9:0] + min[9:0]}};
                        end else begin
                        dist[adj[j][k][14:10]] <= dist_h[adj[j][k][14:10]];
                    end
                end
                next_state <= CHOOSE_NEXT_NODE;
                
            end
            CHOOSE_NEXT_NODE: begin
                if (i < node_count) begin
                    if (dist[i][9:0] < sel[9:0] && dist_h[i][15] ! = 1) begin
                        sel       <= {1'b0, j, dist[i][9:0]};
                        min_index <= i;
                    end
                    i <= i + 1;
                    end else begin
                        next_node  <= min_index;
                        next_state <= UPDATE_VISIT;
                    end
                end

            UPDATE_VISIT: begin
                    if (visited_count == 38) begin // Check if all nodes have been mapped
                        next_state            <= PATH_RETRACE;
                        j                     <= e_node;
                        dist_h[s_node][14:10] <= 5'b11011;
                        final_path_reg[49:5]  <= {10{5'd27}};
                        end else if (i == node_count) begin // Check if all nodes have been mapped for the current node
                            min                   <= {1'b1, sel[14:0]};
                            visited_count         <= visited_count + 1;
                            dist[min_index][15]   <= 1'b1;
                            dist_h[min_index][15] <= 1'b1;
                            for (k = 0; k < node_count; k = k + 1) begin
                                dist_h[k] <= dist[k];
                            end
                            i          <= 0;
                            j          <= min_index;
                            sel        <= {1'b1, min_index, infinity}; // This is the node to begin next iteration of mapping (having min distance)
                            next_state <= TEMP;
                            end else begin
                                next_state <= UPDATE_VISIT;
                            end
                        end
                        
            PATH_RETRACE: begin
                            if (j == 5'b11011) begin
                                done       <= 1;
                                final_path <= final_path_reg;
                                next_state <= PATH_RETRACE;
                                end else begin
                                    final_path_reg[(5 * count + 4) -: 5] <= dist_h[j][14:10];
                                    count                                <= count + 1;
                                    j                                    <= dist_h[j][14:10];
                                end
                            end
        endcase
    end
endmodule
    
    
    
