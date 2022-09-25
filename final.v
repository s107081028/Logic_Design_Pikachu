`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/22 22:50:31
// Design Name: 
// Module Name: final
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

`define back_pic  4'b0000
`define a_pic 4'b0001
`define b_pic 4'b0010
`define ball_pic 4'b0011
`define start_pic 4'b1000


module final(clk, rst, rst_n, start, pause, vgaRed, vgaGreen, vgaBlue, PS2_DATA, PS2_CLK, led, ssd_seg, ssd_ctl, hsync, vsync, audio_mclk, audio_lrck, audio_sck, audio_sdin);
input clk, rst, rst_n,  start, pause;
output hsync, vsync, audio_mclk, audio_lrck, audio_sck, audio_sdin;
output reg [3:0] vgaRed, vgaGreen, vgaBlue;
output [3:0] ssd_ctl;
output [6:0] ssd_seg;
output [15:0] led;
inout PS2_DATA, PS2_CLK;

wire clk_25MHz, clk_22, clk_21, valid, key_valid;
wire [8:0] last_change;
wire [9:0] h_cnt, v_cnt, player1_x, player1_y, player2_x, player2_y, ball_x, ball_y;
wire [11:0] data, pixel_0, pixel_a, pixel_b, pixel_ball, pixel_start;
wire [15:0] scores;
wire [21:0] pixel_addr;
wire [511:0] key_down;
wire [3:0] pic_choice;

freq_div22 fd0(.clk(clk), .out(clk_22));
freq_div21 fd1(.clk(clk), .out(clk_21));
freq_div25MHz fd2(.clk(clk), .out(clk_25MHz));

always@* begin
    if(~valid) {vgaRed, vgaGreen, vgaBlue} = 12'h0;
    else begin
        case(pic_choice)
            `a_pic : {vgaRed, vgaGreen, vgaBlue} = pixel_a;
            `b_pic : {vgaRed, vgaGreen, vgaBlue} = pixel_b;
            `ball_pic : {vgaRed, vgaGreen, vgaBlue} = pixel_ball;
            `back_pic : {vgaRed, vgaGreen, vgaBlue} = pixel_0;
            `start_pic : {vgaRed, vgaGreen, vgaBlue} = pixel_0;
            default : {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        endcase
    end
end

mem_addr_gen mem_addr_gen_inst(
    .h_cnt(h_cnt), .v_cnt(v_cnt), .pixel_addr(pixel_addr), .pic_choice(pic_choice),
    .player1_x(player1_x), .player1_y(player1_y), .player2_x(player2_x), .player2_y(player2_y),
    .ball_x(ball_x), .ball_y(ball_y),
);

play_control playctr0(
    .clk(clk_21), .rst(rst), .key_down(key_down),
    .player1_x(player1_x), .player1_y(player1_y), .player2_x(player2_x), .player2_y(player2_y),
    .ball_x(ball_x), .ball_y(ball_y), .led(led), .scores(scores), .start(start), .pause(pause),
);

blk_mem_gen_background blk_mem_gen_back(.clka(clk_25MHz), .wea(0), .addra(pixel_addr), .dina(data[11:0]), .douta(pixel_0));
blk_mem_gen_p1 blk_mem_gen_p1(.clka(clk_25MHz), .wea(0), .addra(pixel_addr), .dina(data[11:0]), .douta(pixel_a));
blk_mem_gen_p2 blk_mem_gen_p2(.clka(clk_25MHz), .wea(0), .addra(pixel_addr), .dina(data[11:0]), .douta(pixel_b));
blk_mem_gen_ball blk_mem_gen_ball(.clka(clk_25MHz), .wea(0), .addra(pixel_addr), .dina(data[11:0]), .douta(pixel_ball));

SSD seg0(.ssd_seg(ssd_seg), .ssd_ctl(ssd_ctl), .nums(scores), .rst(rst), .clk(clk));
music M0(.clk(clk), .rst_n(rst_n), .audio_mclk(audio_mclk), .audio_lrck(audio_lrck), .audio_sck(audio_sck), .audio_sdin(audio_sdin));

vga_controller vga_inst(
    .pclk(clk_25MHz),
    .reset(rst),
    .hsync(hsync),
    .vsync(vsync),
    .valid(valid),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt)
);

KeyboardDecoder key_bd(
	.key_down(key_down),
	.last_change(last_change),
	.key_valid(key_valid),
	.PS2_DATA(PS2_DATA),
	.PS2_CLK(PS2_CLK),
	.rst(rst),
	.clk(clk)
);

endmodule
