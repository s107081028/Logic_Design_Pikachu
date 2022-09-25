//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/22 22:58:23
// Design Name: 
// Module Name: freq_div
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define FREQ_DIV_WIDTH 27

module freq_div22(clk, out);
    input clk;   
    output out;   
    reg [21:0] num;
    wire [21:0] next;

    always@(posedge clk)begin
    	num <= next;
        end
    assign next = num +1;
    assign out = num[21];
    
endmodule

module freq_div21(clk, out);
    input clk;   
    output out;
    reg [20:0] num;
    wire [20:0] next;
    
    always@(posedge clk)begin
    	num<=next;
        end
    
    assign next = num +1;
    assign out = num[20];
    
endmodule

module freq_div25MHz(clk, out);   
    parameter n = 2;  
    input clk;   
    output out;   
    
    reg [n-1:0] num;
    wire [n-1:0] next;
    
    always@(posedge clk)begin
    	num<=next;
        end
    
    assign next = num +1;
    assign out = num[n-1];
    
endmodule

module freqdiv(
    input clk,
    input rst_n,
    output reg out);
reg [`FREQ_DIV_WIDTH-1:0] q;
reg [`FREQ_DIV_WIDTH-1:0] q_tmp;
reg smallclk;
always @*
    q_tmp = q + 1'b1;
always @(posedge clk or negedge rst_n)
    if (~rst_n || smallclk == 1) q <= `FREQ_DIV_WIDTH'd0;
    else q <= q_tmp;
      
always @*
    if(q_tmp == 12500000) smallclk = 1;
    else smallclk = 0;
    
always @(posedge clk or negedge rst_n)
    if (~rst_n) out <= 0;
    else begin
        if(smallclk == 1) out <= ~out;
    end
    
endmodule