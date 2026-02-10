module grayscale(
    clk,
    r,
    g,
    b,
    gray
);

input wire clk;
input wire [11:0] r;
input wire [11:0] g;
input wire [11:0] b;
output wire [11:0] gray;    //width may have to be changed

reg [11:0]add_gb;
reg [11:0]add_rgb;

// assign output
assign gray = add_rgb;

// rough averaging - r/4 + g/2 + b/4 (but it's pipelined :3)
always_ff @(posedge clk) begin
    add_gb <= r[11:2] + b[11:2];
    add_rgb <= add_gb + g[11:1];
end


endmodule