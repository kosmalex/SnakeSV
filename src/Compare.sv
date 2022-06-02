module Compare
#(
    parameter N = 4,
    parameter comp_t = 0,
    parameter logic suc_val = 1'b1
)
(
    input logic[N - 1:0] comp, to,
    output logic res
);

always_comb begin
    case(comp_t)
        3'd0: res = comp == to ? suc_val : !suc_val;
        3'd1: res = comp > to ? suc_val : !suc_val;
        3'd2: res = comp < to ? suc_val : !suc_val;
        3'd3: res = comp >= to ? suc_val : !suc_val;
        3'd4: res = comp <= to ? suc_val : !suc_val;
        default: res = suc_val;
    endcase
end
endmodule
