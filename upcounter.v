`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/24 10:47:36
// Design Name: 
// Module Name: upcounter
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


module upcounter(value, carry, clk, rst_n, increase, limit);
input clk, rst_n, increase;
input [4:0] limit;
output carry;
output [4:0] value;
reg [4:0] value_tmp;
reg [4:0] value;
reg carry;

always @*
if (value == limit && increase)
begin
value_tmp = 5'b0001;
carry = 1;
end
else if (value != limit && increase)
begin
value_tmp = value + 1;
carry = 0;
end
else
begin
value_tmp = value;
carry = 0;
end

always @(posedge clk or negedge rst_n)
if (~rst_n) 
value <=  5'b0001;
else 
value <= value_tmp;
endmodule