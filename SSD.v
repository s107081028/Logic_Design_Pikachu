`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/23 04:04:15
// Design Name: 
// Module Name: SSD
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

module SSD(
	output reg [6:0] ssd_seg,
	output reg [3:0] ssd_ctl,
	input wire [15:0] nums,
	input wire rst,
	input wire clk
    );
    
    reg [15:0] ssd_clk;
    reg [3:0] display_num;
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		ssd_clk <= 15'b0;
    	end else begin
    		ssd_clk <= ssd_clk + 15'b1;
    	end
    end
    
    always @ (posedge ssd_clk[15], posedge rst) begin
    	if (rst) begin
    		display_num <= 4'b0000;
    		ssd_ctl <= 4'b1111;
    	end else begin
    		case (ssd_ctl)
    			4'b1110 : begin
    					display_num <= nums[7:4];
    					ssd_ctl <= 4'b1101;
    				end
    			4'b1101 : begin
						display_num <= nums[11:8];
						ssd_ctl <= 4'b1011;
					end
    			4'b1011 : begin
						display_num <= nums[15:12];
						ssd_ctl <= 4'b0111;
					end
    			4'b0111 : begin
						display_num <= nums[3:0];
						ssd_ctl <= 4'b1110;
					end
    			default : begin
						display_num <= nums[3:0];
						ssd_ctl <= 4'b1110;
					end				
    		endcase
    	end
    end
    
    always @ (*) begin
    	case (display_num)
    		0 : ssd_seg = 7'b1000000;	//0000
			1 : ssd_seg = 7'b1111001;   //0001                                                
			2 : ssd_seg = 7'b0100100;   //0010                                                
			3 : ssd_seg = 7'b0110000;   //0011                                             
			4 : ssd_seg = 7'b0011001;   //0100                                               
			5 : ssd_seg = 7'b0010010;   //0101                                               
			6 : ssd_seg = 7'b0000010;   //0110
			7 : ssd_seg = 7'b1111000;   //0111
			8 : ssd_seg = 7'b0000000;   //1000
			9 : ssd_seg = 7'b0010000;	//1001
			default : ssd_seg = 7'b0111111;
    	endcase
    end
    
endmodule