import snakePkg::*;

module Tracker
(
    input logic clk, rst,
    input pt2D target,

    output byte_t AN, C
);

logic[7:0][3:0] buffer; // needs to be converted to bcd
assign buffer = traget;

byte_t an;
assign AN = an;
SegmentRefresh arbiter(.clk(clk), .rst(rst), .AN(an));

logic[2:0] i;
always_comb begin : AN_ENCODER
    i[0] = ~(an[1] & an[3] & an[5] & an[7]);
    i[1] = ~(an[2] & an[3] & an[6] & an[7]);
    i[2] = ~(an[4] & an[5] & an[6] & an[7]);
end

ISegmentDisplay segment_display(.val(buffer[i]), .C(C));

endmodule
