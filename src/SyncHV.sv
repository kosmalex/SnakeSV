import snakePkg::*;

module SyncHV
(
    input logic[N_1039-1:0] ppc,
    input logic[N_665-1:0] plc,
    output logic hsync, vsync
);

logic[1:0] h, v;

Compare #(.N(11), .suc_val(1'b1), .comp_t(LT)) lt_976(.comp(ppc), .to(10'd976), .res(h[0]));
Compare #(.N(11), .suc_val(1'b1), .comp_t(GT)) gt_856(.comp(ppc), .to(10'd856), .res(h[1]));

Compare #(.N(10), .suc_val(1'b1), .comp_t(LT)) lt_643(.comp(plc), .to(10'd643), .res(v[0]));
Compare #(.N(10), .suc_val(1'b1), .comp_t(GT)) gt_637(.comp(plc), .to(10'd637), .res(v[1]));

assign hsync = ~(&h);
assign vsync = ~(&v);

endmodule
