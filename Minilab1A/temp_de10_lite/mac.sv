module MAC #
(
parameter DATA_WIDTH = 8
)
(
input clk,
input rst_n,
input En,
input Clr,
input [DATA_WIDTH-1:0] Ain,
input [DATA_WIDTH-1:0] Bin,
output [DATA_WIDTH*3-1:0] Cout
);  

//Register declarations
reg [DATA_WIDTH*3-1:0] cum_register;

//Wire decs
wire [DATA_WIDTH*3-1:0] intermed_product;


//Intermediate product (not pipelined... yikes)
assign intermed_product = Ain * Bin;

//Output is just reading the cumulative_register
assign Cout = cum_register;

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin 
        cum_register <= {DATA_WIDTH*3{1'b0}};
    end
    else begin 
        if(Clr) begin
            cum_register <= {DATA_WIDTH*3{1'b0}};
        end 
        else if (En) begin
            cum_register <= intermed_product + cum_register;
        end
    end
end




endmodule