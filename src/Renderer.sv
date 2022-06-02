// import snakePkg::*;

// module Renderer
// (
//     input logic clk, rst,
//     input logic[10:0] ppc,
//     input logic[9:0] plc,
//     input pt2D[3:0] snake_pos,
//     input pt2D apple_pos,

//     output logic[1:0] status
// );

// logic[3:0] tempS;
// assign status[0] = |tempS;

// generate
//     genvar i;
//     for(i = 0; i < 4; i++) begin : SnakeParts
//         Rect #(.width(9'd18), .height(9'd18)) snk_b(.ppc(ppc[N_800-1:0]), .plc(plc[N_600-1:0]), .origin(snake_pos[i]), .draw(tempS[i]));
//     end
// endgenerate

// Rect #(.width(9'd10), .height(9'd10)) apple(.ppc(ppc[N_800-1:0]), .plc(plc[N_600-1:0]), .origin(apple_pos), .draw(status[1]));

// endmodule


import snakePkg::*;

module Renderer
#(
    parameter snake_size = 32
)
(
    input logic clk, rst,
    input logic[10:0] ppc,
    input logic[9:0] plc,
    input pt2D[snake_size - 1:0] snake_pos,
    input pt2D apple_pos,
//  input logic[snake_size - 1:0] mask,
  
    output logic[1:0] status
);

logic[3:0] tempS;
assign status[0] = |tempS;

generate
    genvar i;
    for(i = 0; i < snake_size; i++) begin : SnakeParts
        Rect #(.width(9'd18), .height(9'd18)) snk_b(.ppc(ppc[N_800-1:0]), .plc(plc[N_600-1:0]), .origin(snake_pos[i]), .draw(tempS[i]));
    end
endgenerate

Rect #(.width(9'd10), .height(9'd10)) apple(.ppc(ppc[N_800-1:0]), .plc(plc[N_600-1:0]), .origin(apple_pos), .draw(status[1]));

endmodule
