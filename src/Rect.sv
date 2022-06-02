import snakePkg::*;

module Rect
#(
    parameter width = 10'd5,
    parameter height = 10'd5
)
(
    input logic[9:0] ppc,
    input logic[9:0] plc,
    input pt2D origin,
    output logic draw
);
    logic[3:0] shouldDraw;
    logic[9:0] p2X;
    logic[9:0] p2Y;

    assign p2X = origin.x + width;
    assign p2Y = origin.y + height;

    Compare #(.N(10), .comp_t(GT)) gt_originX(.comp(ppc), .to(origin.x), .res(shouldDraw[0]));
    Compare #(.N(10), .comp_t(LT)) lt_p2X(.comp(ppc), .to(p2X),  .res(shouldDraw[1]));
    
    Compare #(.N(10), .comp_t(GT)) gt_originY(.comp(plc), .to(origin.y), .res(shouldDraw[2]));
    Compare #(.N(10), .comp_t(LT)) lt_p2Y(.comp(plc), .to(p2Y), .res(shouldDraw[3]));

    assign draw = &shouldDraw;
endmodule