import snakePkg::*;

module IVga
(
    input logic rst, clk,

    input logic[3:0] r, g, b,
    
    output logic hsync, vsync,
    output logic[3:0] R, G, B,
    output logic[N_1039 - 1:0] ppc,
    output logic[N_665 - 1:0] plc
);

//Send_Black
logic snd_blck;
logic[1:0] blck;

//Assigns
assign snd_blck = |blck;

//Blocks
logic pxlClk;
always_ff @(posedge clk) begin : pixelClock
    if(rst)
        pxlClk <= 1'b1;
    else
        pxlClk <= ~pxlClk;
end

always_ff @(posedge clk) begin : perPxlCounter
    if (rst)
        ppc <= 0;
    else if(pxlClk) begin
        if(ppc != 1039)
            ppc <= ppc + 1;
        else
            ppc <= 0;
    end
end

always_ff @(posedge clk) begin : perLineCounter
    if (rst)
        plc <= 0;
    else if(pxlClk) begin
        if (ppc == 1039) begin
            if(plc != 665)
                plc <= plc + 1;
            else
                plc <= 0;
        end
    end
end

always_ff @(posedge clk) begin : Final_Color
    if(rst) {R, G, B} <= 0;
    else if(snd_blck) {R, G, B} <= 0;
    else {R, G, B} <= {r, g, b};
end

//Modules
SyncHV sync_sig(.ppc(ppc), .plc(plc), .hsync(hsync), .vsync(vsync));

Compare #(.N(11), .comp_t(GT), .suc_val(1'b1)) gt_800(.comp(ppc), .to(10'd800), .res(blck[0]));
Compare #(.N(10), .comp_t(GT), .suc_val(1'b1)) gt_600(.comp(plc), .to(10'd600), .res(blck[1]));

endmodule
