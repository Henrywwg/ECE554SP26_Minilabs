module receiver(
    input clk,
    input rst,
    input [1:0] IOADDR,
    input enable,
    input RxD,
    output RDA,
    output [7:0] dout
);

typedef enum logic [1:0] {
    IDLE = 2'b00,
    START_BIT = 2'b01,
    DATA_BITS = 2'b10,
    STOP_BIT = 2'b11
} state_t;

state_t state, next_state;

logic [3:0] div_16_counter; // Counter for 16x baud rate
logic [2:0] metastable_data; // Shift register for metastability
logic [7:0] data_buffer; // Buffer to hold received data
logic en_b_cntr; 

// actual baud counter                      !NOTE NEED TO FIX
always_ff @(posedge clk or negedge rst) begin
    if (!rst)
        div_16_counter <= '0;
    else if (en_b_cntr)
        div_16_counter <= div_16_counter + 1'b1;
    else
        div_16_counter <= '0;
end


// Sample on edge of enable. Our bad rate is actually based on 
always_ff @(posedge clk or  negedge rst) begin
    if(!rst)
        metastable_data <= '0;
    else if (enable)
        metastable_data <= {metastable_data[1:0], RxD};
    
end



// State machine reset and trans
always_ff @(posedge clk or negedge rst) 
    if (!rst) 
        state <= IDLE;
    else 
        state <= next_state;

// State machine combinational logic

always_comb begin
    next_state = state; // Default to hold state
    en_b_cntr = 0;      // Enable for the baud decimator


    case (state)
        IDLE: begin
            if (enable && RxD == 0) // Start bit detected
                next_state = START_BIT;
        end
        START_BIT: begin
            if (enable) 
                next_state = DATA_BITS;
        end
        DATA_BITS: begin
            if (enable) 
                next_state = STOP_BIT;
        end
        STOP_BIT: begin
            if (enable) 
                next_state = IDLE;
        end
    endcase

end




endmodule