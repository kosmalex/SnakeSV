module test;
logic clk, rst;
logic up, down, left, right;

enum logic[1:0] {UP, DOWN, LEFT, RIGHT} direction;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

snake game(.clk(clk), .rst(~rst), .up(up), .down(down), .left(left), .right(right));

initial begin
    RESET();

    repeat(1000000) @(posedge clk);

end

task RESET();
    rst <= 1'b1;
    repeat(2) @(posedge clk);
    rst <= 1'b0;
    up <= 1'b0;
    down <= 1'b0;
    left <= 1'b0;
    right <= 1'b0;
    @(posedge clk);
endtask

task PRESS_BUTTON(logic[1:0] dir);
    @(posedge game.is_listening);

    case(dir)
        2'd0: begin
            up <= 1'b1;
            down <= 1'b0;
            left <= 1'b0;
            right <= 1'b0;
        end

        2'd1: begin
            up <= 1'b0;
            down <= 1'b1;
            left <= 1'b0;
            right <= 1'b0;
        end
        
        2'd2: begin
            up <= 1'b0;
            down <= 1'b0;
            left <= 1'b1;
            right <= 1'b0;
        end

        2'd3: begin
            up <= 1'b0;
            down <= 1'b0;
            left <= 1'b0;
            right <= 1'b1;
        end

        default: begin
            up <= 1'b0;
            down <= 1'b0;
            left <= 1'b0;
            right <= 1'b0;
        end
    endcase

    repeat(300) @(posedge clk);
endtask

endmodule
