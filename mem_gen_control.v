`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/23 02:14:47
// Design Name: 
// Module Name: mem_addr_gen
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

module mem_addr_gen(
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output reg [16:0] pixel_addr,
   output reg [3:0] pic_choice,
   input [9:0] player1_x,
   input [9:0] player1_y,
   input [9:0] player2_x,
   input [9:0] player2_y,
   input [9:0] ball_x,
   input [9:0] ball_y,
);

   parameter back_pic = 4'b0000;
   parameter p1_pic = 4'b0001;
   parameter p2_pic = 4'b0010;
   parameter ball_pic = 4'b0011;
   wire [9:0] hscan, vscan;
   assign hscan = h_cnt>>1;
   assign vscan = v_cnt>>1;
   always@(*)begin
         if ((hscan > ball_x) && (hscan <= ball_x + 30) && (vscan <= ball_y) && (vscan >= ball_y - 30)) begin
            pic_choice = ball_pic;
            pixel_addr = ((hscan - ball_x) % 30 + 30 * (30 + vscan - ball_y)) % 900;
            end
         else if ((hscan > player1_x) && (hscan <= player1_x + 26) && (vscan <= player1_y) && (vscan >= player1_y - 40)) begin
            pic_choice = p1_pic;
            pixel_addr = ((hscan - player1_x) % 26 + 26 * (40 + vscan - player1_y)) % 1040;
            end 
         else if ((hscan > player2_x) && (hscan <= player2_x + 26) && (vscan <= player2_y) && (vscan >= player2_y - 40)) begin
            pic_choice = p2_pic;
            pixel_addr = ((hscan - player2_x) % 26 + 26 * (40 + vscan - player2_y)) % 1040;
            end 
         else begin
            pic_choice = back_pic;
            pixel_addr = (hscan + 320 * (vscan)) % 76800;
            end
      end
endmodule