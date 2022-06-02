import snakePkg::*;

module InputHandler
(
    input logic clk, rst,
    input logic up, down, left, right,
    input logic[N_665 - 1:0] plc,
    
    output logic is_listening,
    output logic[3:0] dir
);

logic[3:0] temp_buffer;
PosEdge UP(.clk(clk), .rst(rst), .signal(up), .pedge(temp_buffer[0]));
PosEdge DOWN(.clk(clk), .rst(rst), .signal(down), .pedge(temp_buffer[1]));
PosEdge LEFT(.clk(clk), .rst(rst), .signal(left), .pedge(temp_buffer[2]));
PosEdge RIGHT(.clk(clk), .rst(rst), .signal(right), .pedge(temp_buffer[3]));

logic listen_en;
assign is_listening = listen_en;
always_ff @(posedge clk) begin : enable_input_detection
    if (rst)
        listen_en <= 1'b1;
    else if(plc > 660)
        listen_en <= 1'b0;
    else
        listen_en <= 1'b1;
end

enum logic {LISTEN, HOLD} state;
always_ff @(posedge clk) begin
    if(rst) begin
        state <= LISTEN;
        dir <= 4'b0001;
    end
    else begin
        case(state)
            LISTEN: begin
                if(|temp_buffer & listen_en) begin
                    case(temp_buffer)
                        4'b0001: if(dir ^ 4'b0010) dir <= temp_buffer;
                        4'b0010: if(dir ^ 4'b0001) dir <= temp_buffer;
                        4'b0100: if(dir ^ 4'b1000) dir <= temp_buffer;
                        4'b1000: if(dir ^ 4'b0100) dir <= temp_buffer;
                    endcase
                    
                    state <= HOLD;
                end
            end

            HOLD: if(~listen_en) state <= LISTEN;

            default: state <= LISTEN;
        endcase
    end
end

endmodule
