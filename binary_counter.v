`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/24 10:48:01
// Design Name: 
// Module Name: binary_counter
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
`define CNT_BIT_WIDTH 9

module binarycounter(out, clk, rst_n);
output [`CNT_BIT_WIDTH-1:0] out;
input clk, rst_n;
reg [`CNT_BIT_WIDTH-1:0] out;
reg [`CNT_BIT_WIDTH-1:0] tmp_cnt;

always @*
    tmp_cnt = out + 1'b1;
always @(posedge clk or negedge rst_n)
    if(~rst_n)  out<=0;
    else out<=tmp_cnt;

endmodule

