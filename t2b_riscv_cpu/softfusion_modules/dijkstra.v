
//Path Planner design
//Parameters : node_count : for total no. of nodes + 1 (consider an imaginary node, refer discuss forum),
//					max_edges : no. of max edges for every node.


//Inputs  	 : clk : 50 MHz clock, 
//				   start : start signal to initiate the path planning,
//				   s_node : start node,
//				   e_node : destination node.
//
//Output     : done : Path planning completed signal,
//             final_path : the final path from start to end node.



//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////

module dijkstra
#(parameter node_count = 27, parameter max_edges = 4)
(
	input clk,
	input start,
    input [31:0] data_to_dijkstra_1,
    input [31:0] data_to_dijkstra_2,
    input [31:0] data_to_dijkstra_3,
    input [31:0] data_to_dijkstra_4,
	 output reg done,
    output reg [31:0] node_addr,	
	//output reg [10*5-1:0] final_path
    output reg [31:0]final_path_node

);

////////////////////////WRITE YOUR CODE FROM HERE///////////////////
initial begin 
done =0;
node_addr =0;
final_path_node =0;
end


////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule 