// import snakePkg::*;

// module Update
// (
//     input logic clk, rst,
//     input logic is_listening, apple_bite,
//     input logic[3:0] mv_dir,

//     output logic vis_apple, hCol,
//     output pt2D[3:0] snake_pos,
//     output pt2D apple_pos
// );

// logic plisten;
// PosEdge peListen(.clk(clk), .rst(rst), .signal(is_listening), .pedge(plisten));

// localparam ceil = 143;
// logic[7:0] frame_ctr;
// always_ff @(posedge clk) begin : count_frames_passed
//     if(rst)
//         frame_ctr <= 0;
//     else if(plisten) begin
//         if(frame_ctr == ceil - 1) frame_ctr <= 0;
//         else frame_ctr <= frame_ctr + 1;
//     end 
// end

// logic pAppleBite;
// PosEdge peAppleBite(.clk(clk), .rst(rst), .signal(apple_bite), .pedge(pAppleBite));

// always_ff @(posedge clk) begin
//     if(rst) begin
//        hCol <= 1'b1; 
//     end else begin
//         if(pAppleBite) hCol <= 1'b0;
//         if(state == HANDLED_COL) hCol <= 1'b1;
//     end
// end

// logic[7:0] cur_frame, speed;
// logic[2:0] lvl;
// enum logic[2:0] {IDLE, MOV, COL, SELF_BITE, APPLE_BITE, HANDLED_COL} state;
// always_ff @(posedge clk) begin : UpdateFSM
//     if(rst) begin
//         snake_pos <= {10'd300, 10'd463, 10'd300, 10'd442, 10'd300, 10'd421, 10'd300, 10'd400};
//         apple_pos <= {10'd300, 10'd200};
//         cur_frame <= 0;
//         lvl <= 0;
//         speed <= 32;

//         state <= IDLE;
//     end
//     else begin
//         case(state)
//             IDLE: begin
//                 if(
//                     (cur_frame != frame_ctr) && ((frame_ctr & (speed - 1)) == 0)
//                 ) begin
//                     cur_frame <= frame_ctr;

//                     state <= MOV;
//                 end
//             end

//             MOV: begin
//                 case(mv_dir)
//                     4'b0001: begin
//                         if(snake_pos[0].y > 20)
//                             snake_pos[0].y <= snake_pos[0].y - 21;
//                         else 
//                             snake_pos[0].y <= 600;
//                     end
                    
//                     4'b0010: begin
//                         if(snake_pos[0].y < 580)
//                             snake_pos[0].y <= snake_pos[0].y + 21;
//                         else 
//                             snake_pos[0].y <= 0;
//                     end
                    
//                     4'b0100: begin
//                         if(snake_pos[0].x > 20)
//                             snake_pos[0].x <= snake_pos[0].x - 21;
//                         else 
//                             snake_pos[0].x <= 800;
//                     end
                    
//                     4'b1000: begin
//                         if(snake_pos[0].x < 780)
//                             snake_pos[0].x <= snake_pos[0].x + 21;
//                         else 
//                             snake_pos[0].x <= 0;
//                     end
//                 endcase
                
//                 snake_pos[1] <= snake_pos[0];
//                 snake_pos[2] <= snake_pos[1];
//                 snake_pos[3] <= snake_pos[2];
                
//                 state <= COL;
//             end
    
//             COL: begin
//                 if(snake_pos[0] == snake_pos[1])
//                     state <= SELF_BITE;
//                 else if(snake_pos[0] == snake_pos[2])
//                     state <= SELF_BITE;
//                 else if(snake_pos[0] == snake_pos[3])
//                     state <= SELF_BITE;
//                 else if(apple_bite)
//                     state <= APPLE_BITE;
//                 else
//                     state <= IDLE;
//             end
    
//             SELF_BITE: begin
//                 snake_pos <= {10'd300, 10'd463, 10'd300, 10'd442, 10'd300, 10'd421, 10'd300, 10'd400};
//                 apple_pos <= {10'd300, 10'd200};
//                 speed <= 32;
//                 lvl <= 0;

//                 state <= IDLE;
//             end
    
//             APPLE_BITE: begin
//                 apple_pos <= appos[index];

//                 if((lvl == 3'd5) && (speed != 8'd2)) begin
//                     lvl <= 0;
//                     speed <= speed >> 1;
//                 end else
//                     lvl <= lvl + 1;
                
//                 state <= HANDLED_COL;
//             end

//             HANDLED_COL: state <= IDLE;
    
//             default: state <= IDLE;
//         endcase
//     end
// end

// logic[7:0][19:0] appos;
// assign appos = {10'd400, 10'd300, 10'd100, 10'd150, 10'd275, 10'd500, 10'd670, 10'd300, 10'd10, 10'd10, 10'd750, 10'd550, 10'd150, 10'd200, 10'd450, 10'd5};

// logic[7:0][2:0] seeds;
// assign seeds = {3'd1, 3'd3, 3'd5, 3'd6, 3'd7, 3'd2, 3'd4, 3'd0};

// logic[2:0] index;
// logic[1:0] i;
// always_ff @(posedge clk) begin
//     if(rst) begin
//         index <= 1'b1;
//         i <= 1'b0;
//     end else if(state == APPLE_BITE) begin
//         index[2:1] <= index[1:0];
//         index[0] <= index[2] ^ index[1];
//         i <= i + 1;

//         if(i == 4) begin
//             index <= seeds[index];
//             i <= 0;
//         end
//     end
// end

// localparam blink_rate = 72; //If it decreases blink speed increases
// logic draw_apple;
// assign vis_apple = draw_apple;
// logic blinked;
// always_ff @(posedge clk) begin
//     if(rst) begin
//         draw_apple <= 1'b1;
//         blinked <= 1'b0;
//     end
//     else if(frame_ctr % blink_rate == 0 && ~blinked) begin
//         draw_apple <= ~draw_apple;
//         blinked <= 1'b1;
//     end else if(frame_ctr % blink_rate != 0)
//         blinked <= 1'b0;
// end

// endmodule

import snakePkg::*;

module Update
(
    input logic clk, rst,
    input logic is_listening, apple_bite,
    input logic[3:0] mv_dir,

    output logic vis_apple, hCol,
    output logic[3:0] points,
    output pt2D snake_head,
    output pt2D apple_pos
);

logic plisten;
PosEdge peListen(.clk(clk), .rst(rst), .signal(is_listening), .pedge(plisten));

localparam ceil = 143;
logic[7:0] frame_ctr;
always_ff @(posedge clk) begin : count_frames_passed
    if(rst)
        frame_ctr <= 0;
    else if(plisten) begin
        if(frame_ctr == ceil - 1) frame_ctr <= 0;
        else frame_ctr <= frame_ctr + 1;
    end 
end

logic pAppleBite;
PosEdge peAppleBite(.clk(clk), .rst(rst), .signal(apple_bite), .pedge(pAppleBite));

always_ff @(posedge clk) begin
    if(rst) begin
       hCol <= 1'b1; 
    end else begin
        if(pAppleBite) hCol <= 1'b0;
        if(state == HANDLED_COL) hCol <= 1'b1;
    end
end

logic[7:0] cur_frame, speed;
logic[2:0] lvl;
enum logic[2:0] {IDLE, MOV, COL, SELF_BITE, APPLE_BITE, HANDLED_COL} state;
always_ff @(posedge clk) begin : UpdateFSM
    if(rst) begin
        snake_head <= {10'd300, 10'd400};
        apple_pos <= {10'd300, 10'd200};
        cur_frame <= 0;
        lvl <= 0;
        speed <= 16;

        state <= IDLE;
    end
    else begin
        case(state)
            IDLE: begin
                if(
                    (cur_frame != frame_ctr) && ((frame_ctr & (speed - 1)) == 0)
                ) begin
                    cur_frame <= frame_ctr;

                    state <= MOV;
                end
            end

            MOV: begin
                case(mv_dir)
                    4'b0001: begin
                        if(snake_head.y > 20)
                            snake_head.y <= snake_head.y - 21;
                        else 
                            snake_head.y <= 600;
                    end
                    
                    4'b0010: begin
                        if(snake_head.y < 580)
                            snake_head.y <= snake_head.y + 21;
                        else 
                            snake_head.y <= 0;
                    end
                    
                    4'b0100: begin
                        if(snake_head.x > 20)
                            snake_head.x <= snake_head.x - 21;
                        else 
                            snake_head.x <= 800;
                    end
                    
                    4'b1000: begin
                        if(snake_head.x < 780)
                            snake_head.x <= snake_head.x + 21;
                        else 
                            snake_head.x <= 0;
                    end
                endcase
                
                state <= COL;
            end
    
            COL: begin
                if(apple_bite) state <= APPLE_BITE;
                else state <= IDLE;
            end
    
            APPLE_BITE: begin
                apple_pos <= appos[index];
                if(points < 4'd31) points <= points + 1'b1;
                
                if((lvl == 3'd5) && (speed != 8'd2)) begin
                    lvl <= 0;
                    speed <= speed >> 1;
                end else
                    lvl <= lvl + 1;
                
                state <= HANDLED_COL;
            end

            HANDLED_COL: state <= IDLE;
    
            default: state <= IDLE;
        endcase
    end
end

logic[7:0][19:0] appos;
assign appos = {10'd400, 10'd300, 10'd100, 10'd150, 10'd275, 10'd500, 10'd670, 10'd300, 10'd10, 10'd10, 10'd750, 10'd550, 10'd150, 10'd200, 10'd450, 10'd5};

logic[7:0][2:0] seeds;
assign seeds = {3'd1, 3'd3, 3'd5, 3'd6, 3'd7, 3'd2, 3'd4, 3'd0};

logic[2:0] index;
logic[1:0] i;
always_ff @(posedge clk) begin
    if(rst) begin
        index <= 1'b1;
        i <= 1'b0;
    end else if(state == APPLE_BITE) begin
        index[2:1] <= index[1:0];
        index[0] <= index[2] ^ index[1];
        i <= i + 1;

        if(i == 4) begin
            index <= seeds[index];
            i <= 0;
        end
    end
end

localparam blink_rate = 72; //If it decreases blink speed increases
logic draw_apple;
assign vis_apple = draw_apple;
logic blinked;
always_ff @(posedge clk) begin
    if(rst) begin
        draw_apple <= 1'b1;
        blinked <= 1'b0;
    end
    else if(frame_ctr % blink_rate == 0 && ~blinked) begin
        draw_apple <= ~draw_apple;
        blinked <= 1'b1;
    end else if(frame_ctr % blink_rate != 0)
        blinked <= 1'b0;
end

endmodule
