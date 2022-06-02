// import snakePkg::*;

// module snake
// (
//     input logic clk, rst,
//     input logic up, down, left, right, sel,
    
//     output logic hsync, vsync,
//     output logic[3:0] R, G, B,
//     output byte_t AN, C
// );

// //InputHandler
// logic is_listening;
// logic[3:0] mv_dir;

// //Update
// logic apple_bite, vis_apple, handled_col;
// pt2D[3:0] snake_pos;
// pt2D apple_pos;

// //Renderer
// logic[1:0] status;

// //IVga
// logic[3:0] r, g, b;
// logic[N_1039 - 1:0] ppc; 
// logic[N_665 - 1:0] plc;

// //Tracker
// byte_t snk_an, snk_c;
// byte_t apl_an, apl_c;

// //Assigns
// assign AN = sel ? apl_an : snk_an;
// assign C = sel ? apl_c : snk_c;

// //Combinational Blocks
// always_comb begin : ColorPicker
//     case(status)
//         2'b00: {r, g, b} = 12'h0;
//         2'b01: {r, g, b} = {4'h0, 4'hF, 4'hF};
//         2'b10: begin
//             if(vis_apple)
//                 {r, g, b} = {4'hF, 4'h0, 4'h0};
//             else
//                 {r, g, b} = 0;
//         end
//         2'b11: {r, g, b} = {4'h0, 4'hF, 4'hF};
//         default: {r, g, b} = 12'h0;
//     endcase
// end

// //Modules
// InputHandler player_input(.clk(clk), .rst(~rst), .plc(plc), .up(up), .down(down), .left(left), .right(right), .is_listening(is_listening), .dir(mv_dir));

// CollisionDetection bite_detect(.clk(clk), .rst(~rst), .is_listening(is_listening), .hCol(handled_col), .status(status), .collided(apple_bite));

// Update animator(.clk(clk), .rst(~rst), .is_listening(is_listening), .apple_bite(apple_bite), .hCol(handled_col), .mv_dir(mv_dir), .snake_pos(snake_pos), 
//                 .apple_pos(apple_pos), .vis_apple(vis_apple)); // out: done_updating

// Renderer draw_entities(.clk(clk), .rst(~rst), .ppc(ppc), .plc(plc), .snake_pos(snake_pos), .apple_pos(apple_pos), .status(status));

// IVga screen(.clk(clk), .rst(~rst), .r(r), .g(g), .b(b), .ppc(ppc), .plc(plc), .R(R), .G(G), .B(B), .hsync(hsync), .vsync(vsync));

// endmodule


import snakePkg::*;

module snake
(
    input logic clk, rst,
    input logic up, down, left, right, sel,
    
    output logic hsync, vsync,
    output logic[3:0] R, G, B,
    output byte_t AN, C
);

//InputHandler
logic is_listening;
logic[3:0] mv_dir;

//Update
logic apple_bite, vis_apple, handled_col;
logic[4:0] points;
pt2D[3:0] snake_pos;
pt2D apple_pos;

//Renderer
logic[1:0] status;

//IVga
logic[3:0] r, g, b;
logic[N_1039 - 1:0] ppc; 
logic[N_665 - 1:0] plc;

//Tracker
byte_t snk_an, snk_c;
byte_t apl_an, apl_c;

//Assigns
assign AN = sel ? apl_an : snk_an;
assign C = sel ? apl_c : snk_c;

//Combinational Blocks
always_comb begin : ColorPicker
    case(status)
        2'b00: {r, g, b} = 12'h0;
        2'b01: {r, g, b} = {4'h0, 4'hF, 4'hF};
        2'b10: begin
            if(vis_apple)
                {r, g, b} = {4'hF, 4'h0, 4'h0};
            else
                {r, g, b} = 0;
        end
        2'b11: {r, g, b} = {4'h0, 4'hF, 4'hF};
        default: {r, g, b} = 12'h0;
    endcase
end

//Modules
InputHandler player_input(.clk(clk), .rst(~rst), .plc(plc), .up(up), .down(down), .left(left), .right(right), .is_listening(is_listening), .dir(mv_dir));

CollisionDetection bite_detect(.clk(clk), .rst(~rst), .is_listening(is_listening), .hCol(handled_col), .status(status), .collided(apple_bite));

Update animator(.clk(clk), .rst(~rst), .is_listening(is_listening), .apple_bite(apple_bite), .hCol(handled_col), .mv_dir(mv_dir), .snake_pos(snake_pos), 
                .apple_pos(apple_pos), .vis_apple(vis_apple), .points(points)); // out: done_updating

//Builder snk_body(.clk(clk), .rst(~rst), .snake_head_pos(snake_head_pos), .points(points), .update(done_updating), snake_pos(snake_pos), .mask(draw_mask));
//mask: sel the ffs from snake_body to display.
//points decide the length

Renderer draw_entities(.clk(clk), .rst(~rst), .ppc(ppc), .plc(plc), .snake_pos(snake_pos), .apple_pos(apple_pos), .status(status));

IVga screen(.clk(clk), .rst(~rst), .r(r), .g(g), .b(b), .ppc(ppc), .plc(plc), .R(R), .G(G), .B(B), .hsync(hsync), .vsync(vsync));

endmodule