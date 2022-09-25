`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/24 11:34:27
// Design Name: 
// Module Name: pikamusic
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


module music(clk, rst_n, audio_mclk, audio_lrck, audio_sck, audio_sdin);

input clk, rst_n;
output audio_mclk, audio_lrck, audio_sck, audio_sdin;
reg [21:0] note_freq;
reg [15:0] positive, negative;
wire [15:0] audio_in_left, audio_in_right;
wire [4:0] value;
wire clk_d, carry;

note_gen Ung(.clk(clk), .rst_n(rst_n), .note_div(note_freq), .audio_left(audio_in_left), .audio_right(audio_in_right), .pos(positive), .neg(negative));
speaker_control Usc(.clk(clk), .rst_n(rst_n), .audio_in_left(audio_in_left), .audio_in_right(audio_in_right), .audio_mclk(audio_mclk), .audio_lrck(audio_lrck), .audio_sck(audio_sck), .audio_sdin(audio_sdin));
freqdiv FD1(.clk(clk), .rst_n(rst_n), .out(clk_d));
upcounter U0(.value(value), .carry(carry), .clk(clk_d), .rst_n(rst_n), .increase(rst_n), .limit(5'd28));
always@* begin
    case(value)                                         //G F# G A G X
        5'd1 : begin                                    //G F# G A G X
            note_freq = 22'd127511;                     //G G  X G A X bB X B X
            positive = 16'h8fff;
            end
        5'd2 : begin
            note_freq = 22'd127511;
            positive = 16'h8fff;
            end
        5'd3 :begin
            note_freq = 22'd135139;
            positive = 16'h8fff;
            end
        5'd4 : begin
            note_freq = 22'd127511;
            positive = 16'h8fff;
            end
        5'd5 : begin
            note_freq = 22'd113636;
            positive = 16'h8fff;
            end
        5'd6 : begin
            note_freq = 22'd127511;
            positive = 16'h8fff;
            end
        5'd7 : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
        5'd8 : begin
            note_freq = 22'd127511;
            positive = 16'h8fff;
            end
        5'd9 : begin
            note_freq = 22'd135139;
            positive = 16'h8fff;
            end
        5'd10 : begin
            note_freq = 22'd127511;
            positive = 16'h8fff;
            end
        5'd11 : begin
            note_freq = 22'd113636;
            positive = 16'h8fff;
            end
        5'd12 : begin
            note_freq = 22'd127511;
            positive = 16'h8fff;
            end
        5'd13 : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
        5'd14 : begin
            note_freq = 22'd127511;
            positive = 16'h8fff;
            end
        5'd15 : begin
            note_freq = 22'd127511;
            positive = 16'h8fff;
            end
        5'd16 : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
        5'd17 : begin
            note_freq = 22'd127511;
            positive = 16'h8fff;
            end
        5'd18 : begin
            note_freq = 22'd113636;
            positive = 16'h8fff;
            end
        5'd19 : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
        5'd20 : begin
            note_freq = 22'd107259;
            positive = 16'h8fff;
            end
        5'd21 : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
        5'd22 : begin
            note_freq = 22'd101239;
            positive = 16'h8fff;
            end
        5'd23 : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
        5'd24 : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
        5'd25 : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
        5'd26 : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
        5'd27 : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
        5'd28 : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
        default : begin
            note_freq = 22'd000000;
            positive = 16'h0000;
            end
    endcase
    negative = positive * (-1);
end

endmodule
