`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/22 23:11:49
// Design Name: 
// Module Name: player_control
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

module play_control(
    input clk,
    input rst,
    input [511:0] key_down,
    input start,
    input pause,
    output player1_x,
    output player1_y,
    output player2_x,
    output player2_y,
    output ball_x,
    output ball_y,
    output reg [15:0] led,
    output reg [15:0] scores,
);

parameter [8:0] key_1_up = 9'h1D;
parameter [8:0] key_1_down = 9'h1B;
parameter [8:0] key_1_left = 9'h1C;
parameter [8:0] key_1_right = 9'h23;
parameter [8:0] key_1_kill = 9'h29;
parameter [8:0] key_2_up = 9'h73;
parameter [8:0] key_2_down = 9'h72;
parameter [8:0] key_2_left = 9'h69;
parameter [8:0] key_2_right = 9'h7A;
parameter [8:0] key_2_kill = 9'h5A;
parameter [6:0] gravity = 6'd1;
parameter [6:0] x_move = 6'd3;

reg signed [9:0] player1_x, player2_x, player1_y, player2_y, ball_x, ball_y;
reg signed [9:0] next_player1_x, next_player2_x, next_player1_y, next_player2_y, next_ball_x, next_ball_y;
reg [3:0] next_state, state;
reg win, next_win;
reg signed [9:0] player1_y_velocity, player2_y_velocity, ball_x_velocity, ball_y_velocity, next_player1_y_velocity, next_player2_y_velocity, next_ball_x_velocity, next_ball_y_velocity;
reg [30:0] timer, next_timer;
reg [15:0] next_scores;

always@ (posedge clk, posedge rst) begin
    if(rst)begin
        player1_y_velocity <= 0; player2_y_velocity <= 0; player1_x <= 10'd30; player1_y <= 10'd220; player2_x <= 10'd264; player2_y <= 10'd220;
        ball_x_velocity <= 0; ball_y_velocity <= 0; ball_x <= 10'd38; ball_y <= 10'd55; state <= 0; win <= 0; timer <= 0; scores <= 0;
    end
    else begin
        player1_y_velocity <= next_player1_y_velocity; player2_y_velocity <= next_player2_y_velocity;
        player1_x <= next_player1_x; player1_y <= next_player1_y; player2_x <= next_player2_x; player2_y <= next_player2_y;
        ball_x_velocity <= next_ball_x_velocity; ball_y_velocity <= next_ball_y_velocity; ball_x <= next_ball_x; ball_y <= next_ball_y;
        state <= next_state; win <= next_win; timer <= next_timer; scores <= next_scores;
    end
end

always@(*)begin
    led = 16'd0;
    next_ball_x_velocity = ball_x_velocity; next_ball_y_velocity = ball_y_velocity; next_ball_x = ball_x; next_ball_y = ball_y;
    next_player1_y_velocity = player1_y_velocity; next_player2_y_velocity = player2_y_velocity;
    next_player1_x = player1_x; next_player1_y = player1_y; next_player2_x = player2_x; next_player2_y = player2_y;
    next_state = state; next_win = win; next_timer = timer; next_scores = scores;

    if(rst) begin
        next_state = 0;
        end
    else if(state == 0) begin                                 //main menu
        next_ball_y = 10'd55;
        next_player1_x = 10'd30; next_player1_y = 10'd220;
        next_player2_x = 10'd264; next_player2_y = 10'd220;
        next_scores = 0;
        if(start) begin
            next_state = 4'd1;
            next_ball_x = 10'd38;
            end
        else begin
            next_ball_x = 10'd145;
            end
        end
    else if(state == 1) begin
        if(~pause) begin
            if(timer[6] == 0) begin                           // Hold on a moment before Game Starts
                next_timer = timer + 1;
                next_ball_y = 10'd55; next_ball_x_velocity = 10'd0; next_ball_y_velocity = 10'd0;
                next_player1_x = 10'd30; next_player1_y = 10'd220; next_player1_y_velocity = 10'd0;
                next_player2_x = 10'd264; next_player2_y = 10'd220; next_player2_y_velocity = 10'd0;
                end
            else if(timer[6] == 1) begin                                                                                 //Game Starts
                next_timer = timer;
                //--------------------------------------------------------------------------------------------------------Player_x move by Key pressed
                    if (key_down[key_1_left]) begin
                        if ((key_down[key_1_kill]) && (player1_y == 220) && (~key_down[key_1_up])) begin      // Dash (Dive ball)
                            if (player1_x <= 60) begin
                                next_player1_x = 8;
                                end
                            else begin
                                next_player1_x = player1_x - 52;
                                end
                            end
                        else if (player1_x - x_move>8) begin
                            next_player1_x = player1_x - x_move;
                            end
                        else begin
                            next_player1_x = 10'd8;
                            end
                        end
                    else if (key_down[key_1_right]) begin
                        if ((key_down[key_1_kill]) && (player1_y == 220) && (~key_down[key_1_up])) begin      // Dash (Dive ball)
                            if (player1_x >= 98 - 26) begin
                                next_player1_x = 155 - 26;
                                end
                            else begin
                                next_player1_x = player1_x + 52;
                                end
                            end
                        else if (player1_x + x_move + 26 < 155) begin
                            next_player1_x = player1_x + x_move;
                            end
                        else begin
                            next_player1_x = 10'd155 - 26;
                            end
                        end

                    if ((key_down[key_1_up]) && (player1_y_velocity == 0)) begin            // Free Fall
                            next_player1_y_velocity = -10'd16;
                        end


                    if (key_down[key_2_left]) begin
                        if ((key_down[key_2_kill]) && (player2_y == 220) && (~key_down[key_2_up])) begin      // Dash (Dive ball)
                            if (player2_x <= 164 + 52) begin
                                next_player2_x = 163;
                                end
                            else begin
                                next_player2_x = player2_x - 52;
                                end
                            end
                        else if (player2_x - x_move > 163) begin
                            next_player2_x = player2_x - x_move;
                            end
                        else begin
                            next_player2_x = 10'd163;
                            end
                        end
                    if (key_down[key_2_right]) begin
                        if ((key_down[key_2_kill]) && (player2_y == 220) && (~key_down[key_2_up])) begin      // Dash (Dive ball)
                            if (player2_x >= 316 - 52 - 26) begin
                                next_player2_x = 317 - 26;
                                end
                            else begin
                                next_player2_x = player2_x + 52;
                                end
                            end
                        else if (player2_x + x_move + 26 < 317) begin
                            next_player2_x = player2_x + x_move;
                            end
                        else begin
                            next_player2_x = 10'd317 - 26;
                            end
                        end

                    if ((key_down[key_2_up]) && (player2_y_velocity == 0)) begin            // Free Fall
                            next_player2_y_velocity = -10'd16;
                        end

                //------------------------------------------------------------------------------------------------------------ball lands
                    if(ball_y >= 220)begin
                        next_state = 4'd2;
                        next_timer = 0;
                        if(ball_x <= 160)begin
                            next_win = 1;
                            if (scores[7:0] == 8'b00010100) begin
                                next_state = 4'd3;
                                next_scores[3:0] = next_scores[3:0] + 1;      // p2 = 15 end game
                                end
                            else if (scores[3:0] + 1 <= 4'b1001) begin        // < 10
                                next_scores[3:0] = next_scores[3:0] + 1;
                                end
                            else begin                                        //become 10
                                next_scores[7:4] = next_scores[7:4] + 1;
                                next_scores[3:0] = 4'b0000;
                                end
                            end
                        else begin
                            next_win = 0;
                            if (scores[15:8]==8'b00010100) begin
                                next_state = 4'd3;
                                next_scores[11:8] = next_scores[11:8] + 1;      // p1 = 15 end game
                                end
                            else if (scores[11:8] + 1 <= 4'b1001) begin        // < 10
                                next_scores[11:8] = next_scores[11:8] + 1;
                                end
                            else begin                                         //become 10
                                next_scores[15:12] = next_scores[15:12] + 1;
                                next_scores[11:8] = 4'b0000;
                                end
                            end
                        end

                //----------------------------------------------------------------------------------------------------------------ball elastically collision (ball x)
                    else begin
                        if (ball_x + ball_x_velocity <= 5) begin
                            next_ball_x = 5;
                            next_ball_x_velocity = 0 - ball_x_velocity;                                                 // rebounce from left wall
                            end
                        else if (ball_x + ball_x_velocity >= 285) begin
                            next_ball_x = 285;
                            next_ball_x_velocity = 0 - ball_x_velocity;                                                 // rebounce from right wall
                            end
                        else if((ball_x + ball_x_velocity + 30 >= 155) && (ball_x + 30 < 155) && (ball_y >= 145)) begin // hit left net
                            next_ball_x = 155 - 27;
                            next_ball_x_velocity = 0 - ball_x_velocity;
                            end
                        else if((ball_x + ball_x_velocity <= 165) && (ball_x > 165) && (ball_y >= 145)) begin           // hit right net
                            next_ball_x = 165;
                            next_ball_x_velocity = 0 - ball_x_velocity;
                            end

                    //-----------------------------------------------------------------------------------------------------------------ball elastically collide player1_x
                        else if ((ball_x + ball_x_velocity >= player1_x - 30) && (ball_x + ball_x_velocity <= player1_x + 26)
                        && (ball_y + ball_y_velocity >= player1_y - 30) && (ball_y + ball_y_velocity - 40 <= player1_y) 
                        && ((ball_x > player1_x - 30) || (ball_x > player1_x + 26)
                        || (ball_y < player1_y - 40) || (ball_y - 30 > player1_y))) begin
                        
                            if (key_down[key_1_kill]) begin
                                if (key_down[key_1_right]) begin                                             // kill right
                                    next_ball_x_velocity = 10'd12;
                                    next_ball_x = ball_x + 12;
                                    end
                                else begin
                                    next_ball_x_velocity = 10'd9;                                            // normal kill
                                    next_ball_x = ball_x + 9;
                                    end
                                end
                            else begin
                                if (ball_x + 15 <= player1_x + 4) begin                                      // bounce left
                                    next_ball_x_velocity = -10'd6;
                                    next_ball_x = ball_x - 6;
                                    end
                                else if ((ball_x + 15 > player1_x + 4) && (ball_x + 15 <= player1_x + 9)) begin          // bounce up left  
                                    next_ball_x_velocity = -10'd4;
                                    next_ball_x = ball_x - 4;
                                    end
                                else if ((ball_x + 15 > player1_x + 9) && (ball_x + 15 <= player1_x + 17)) begin         //bounce up
                                    next_ball_x_velocity = 10'd0;
                                    end
                                else if ((ball_x + 15 > player1_x + 17) && (ball_x + 15 <= player1_x + 22)) begin        // bounce up right
                                    next_ball_x_velocity = 10'd4;
                                    next_ball_x = ball_x + 4;
                                    end
                                else if (ball_x + 15 > player1_x + 22) begin                                             // bounce right
                                    next_ball_x_velocity = 10'd6;
                                    next_ball_x = ball_x + 6;
                                    end
                                end
                            end
                    //-------------------------------------------------------------------------------------------------------------ball elastically collide player2_x
                        else if ((ball_x + ball_x_velocity >= player2_x - 30) && (ball_x + ball_x_velocity <= player2_x + 26)
                        && (ball_y + ball_y_velocity >= player2_y - 30) && (ball_y + ball_y_velocity - 40 <= player2_y) 
                        && ((ball_x > player2_x - 30) || (ball_x > player2_x + 26)
                        || (ball_y < player2_y - 40) || (ball_y - 30 > player2_y))) begin
                                    
                            if (key_down[key_2_kill]) begin                                                   // kill left
                                if (key_down[key_2_left]) begin
                                    next_ball_x_velocity = -10'd12;
                                    next_ball_x = ball_x - 12;
                                    end
                                else begin
                                    next_ball_x_velocity = -10'd9;                                            // normal kill
                                    next_ball_x = ball_x - 9;
                                    end
                                end
                            else begin
                                if (ball_x + 15 <= player2_x + 4) begin                                      // bounce left
                                    next_ball_x_velocity = -10'd6;
                                    next_ball_x = ball_x - 6;
                                    end
                                else if ((ball_x + 15 > player2_x + 4) && (ball_x + 15 <= player2_x + 9)) begin         //bounce up left
                                    next_ball_x_velocity = -10'd4;
                                    next_ball_x = ball_x - 4;
                                    end
                                else if ((ball_x + 15 > player2_x + 9) && (ball_x + 15 <= player2_x + 17)) begin        //bounce up
                                    next_ball_x_velocity = 10'd0;
                                    end
                                else if ((ball_x + 15 > player2_x + 17) && (ball_x + 15 <= player2_x + 22)) begin       //bounce up right
                                    next_ball_x_velocity = 10'd4;
                                    next_ball_x = ball_x + 4;
                                    end
                                else if (ball_x + 15 > player2_x + 22) begin                                            //bounce right
                                    next_ball_x_velocity = 10'd6;
                                    next_ball_x = ball_x + 6;
                                    end
                                end
                            end
                        else begin
                            next_ball_x = ball_x + ball_x_velocity;                                                  // continue flying with velocity
                            end

                //-------------------------------------------------------------------------------------------------------------ball elastically collision of y
                        if((ball_y + ball_y_velocity -20 >= 145) && (ball_x >= 155) && (ball_x <= 165)) begin            // hit top of net
                            next_ball_y = 145;
                            next_ball_y_velocity = 0 - ball_y_velocity;
                            end
                        else if (ball_y + ball_y_velocity < 35) begin                                                // hit ceiling
                            next_ball_y = 35;
                            next_ball_y_velocity = 0 - ball_y_velocity;
                            end
                    //----------------------------------------------------------------------------------------------------------ball collide player1_y
                        else if ((ball_x + ball_x_velocity >= player1_x - 30) && (ball_x + ball_x_velocity <= player1_x + 26)
                        && (ball_y + ball_y_velocity >= player1_y - 30) && (ball_y + ball_y_velocity - 40 <= player1_y) 
                        && ((ball_x > player1_x - 30) || (ball_x > player1_x + 26)
                        || (ball_y < player1_y - 40) || (ball_y - 30 > player1_y))) begin
                                         
                            if (key_down[key_1_kill]) begin
                                if (key_down[key_1_up]) begin                                                        // kill up
                                    next_ball_y_velocity = -10'd11;
                                    next_ball_y = ball_y - 11;
                                    end
                                else if (key_down[key_1_down]) begin                                                 // kill down
                                    next_ball_y_velocity = 10'd11;
                                    next_ball_y = ball_y + 11;
                                    end
                                else begin
                                    next_ball_y_velocity = 10'd0;                                                    // normal kill
                                    end
                                end
                            else begin
                                if (player1_y_velocity < 0) begin                                                    // When jumping
                                    next_ball_y_velocity = - 10'd5 + player1_y_velocity;
                                    next_ball_y = ball_y - 5 + player1_y_velocity;
                                    end
                                else begin                                                                           // Normal bounce up
                                    next_ball_y_velocity = -10'd14;
                                    next_ball_y = ball_y - 14;
                                    end
                                end
                            end
                            
                    //----------------------------------------------------------------------------------------------------------ball collide player2_y
                        else if ((ball_x + ball_x_velocity >= player2_x - 30) && (ball_x + ball_x_velocity <= player2_x + 26)
                        && (ball_y + ball_y_velocity >= player2_y - 40) && (ball_y + ball_y_velocity - 30 <= player2_y) 
                        && ((ball_x > player2_x - 30) || (ball_x > player2_x + 26)
                        || (ball_y < player2_y - 40) || (ball_y - 30 > player2_y))) begin
                        
                            if (key_down[key_2_kill]) begin
                                if (key_down[key_2_up]) begin                                                        // kill up
                                    next_ball_y_velocity = -10'd11;
                                    next_ball_y = ball_y - 11;
                                    end
                                else if (key_down[key_2_down]) begin                                                 // kill down
                                    next_ball_y_velocity = 10'd11;
                                    next_ball_y = ball_y + 11;
                                    end
                                else begin
                                    next_ball_y_velocity = 10'd0;                                                    // normal kill
                                    end
                                end
                            else begin
                                if (player2_y_velocity < 0) begin                                                    // When jumping
                                    next_ball_y_velocity = -10'd5 + player2_y_velocity;
                                    next_ball_y = ball_y - 5 + player2_y_velocity;
                                    end
                                else begin                                                                           // Normal bounce up
                                    next_ball_y_velocity = -10'd14;
                                    next_ball_y = ball_y - 14;
                                    end
                                end
                            end
                        else begin                                                                          // Free falling with velocity
                            next_ball_y = ball_y + ball_y_velocity;
                            next_ball_y_velocity = ball_y_velocity + gravity;
                            end
                        end

                //---------------------------------------------------------------------------------------------------------------player move by velocity and gravity
                if (player1_y_velocity + player1_y > 220) begin
                    next_player1_y = 10'd220;                                                          // Land
                    next_player1_y_velocity = 0;
                    end
                else begin
                        next_player1_y = player1_y + player1_y_velocity;                               // Free fall
                        if(player1_y < 220) begin
                            next_player1_y_velocity = player1_y_velocity + gravity;
                            end
                    end

                if (player2_y_velocity + player2_y > 220) begin
                    next_player2_y = 10'd220;                                                          // Land
                    next_player2_y_velocity = 0;
                    end
                else begin
                        next_player2_y = player2_y + player2_y_velocity;                               // Free fall
                        if(player2_y < 220) begin
                            next_player2_y_velocity = player2_y_velocity + gravity;
                            end    
                    end
                end
            end
        end

    else if(state == 2) begin
        if(~win) begin                                                                                 // goal
            led[15:8] = 8'b10000000;
            end
        else begin
            led[7:0] = 8'b00000001;
            end
        next_ball_y = 10'd55;
        next_ball_x_velocity = 10'd0;
        next_ball_y_velocity = 10'd0;
        next_player1_x = 10'd30;
        next_player1_y = 10'd220;
        next_player1_y_velocity = 10'd0;
        next_player2_x = 10'd264;
        next_player2_y = 10'd220;
        next_player2_y_velocity = 10'd0;

        if (timer[7]) begin                                                                           // pause a while
            next_timer = 0;
            next_state = 4'd1;
            if(~win) begin
                next_ball_x = 10'd38;
                end
            else begin
                next_ball_x = 10'd252;
                end
            end
        else begin
            next_timer = timer + 1;
            end
        end
    //-----------------------------------------------------------------------------------------------------------GAME OVER
    else if(state == 3) begin                                     
        if(~win) begin                                                                           // P2 WIN
            led[15:8] = 8'b11111111;
            next_player1_x = 10'd146;
            next_player1_y = 10'd130;
            next_player2_x = 10'd264;
            next_player2_y = 10'd220;
            end
        else begin                                                                              // P1 WIN
            led[7:0] = 8'b11111111;
            next_player1_x = 10'd30;
            next_player1_y = 10'd220;
            next_player2_x = 10'd146;
            next_player2_y = 10'd130;
            end
        next_ball_x = 10'd145;
        next_ball_y = 10'd55;
        next_ball_x_velocity = 10'd0;
        next_ball_y_velocity = 10'd0;
        next_player1_y_velocity = 10'd0;
        next_player2_y_velocity = 10'd0;
        if (timer[7]) begin                                                                           // pause a while
            next_scores = 0;
            next_timer = 0;
            next_state = 4'd0;                                                                        // back to menu
            end
        else begin
            next_timer = timer + 1;
            end
        end
    end

endmodule