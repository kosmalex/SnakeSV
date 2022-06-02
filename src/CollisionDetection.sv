module CollisionDetection
(
    input logic clk, rst,
    input logic is_listening, hCol,
    input logic[1:0] status,

    output logic collided
);

logic phCol;
PosEdge pehCol(.clk(clk), .rst(rst), .signal(hCol), .pedge(phCol));

enum logic {MOVING, COLLIDED} state;
always_ff @(posedge clk) begin
    if(rst) begin
        collided <= 1'b0;
        state <= MOVING;
    end else begin
        case(state)
            MOVING: begin
                if(&status & is_listening) begin
                    collided <= 1'b1;

                    state <= COLLIDED;
                end
            end

            COLLIDED: begin
                if(phCol) begin 
                    collided <= 1'b0;
                    
                    state <= MOVING;
                end
            end 

            default: state <= MOVING;
        endcase
    end
end
endmodule
