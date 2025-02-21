module i2c_master (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [6:0] addr,   // 7-bit slave address
    input wire rw,           // Read (1) / Write (0)
    input wire [7:0] data_in, // Data to be written (if write operation)
    
    output reg [7:0] data_out, // Data received from slave (if read operation)
    output reg ready,         // Ready when idle
    output reg i2c_scl,
    inout wire i2c_sda,
    input wire ack_received,   // Input from slave to know when the address is acknowledged
    input wire read_data_received,
    output reg addr_send
);

    reg [3:0] state;
    reg [8:0] shift_reg;  // Holds 8-bit data + 1 bit for address R/W
    reg sda_dir;
    reg sda_out;
    reg scl_enable;
    reg [3:0] bit_counter;

    
    assign i2c_sda = sda_dir ? sda_out : 1'bz;  // SDA line is driven by sda_out when sda_dir = 1
    wire shift_done = (shift_reg == 0);  // Done shifting when all bits are sent

    localparam IDLE = 0, START = 1, SEND_ADDR = 2, READ_ACK = 3,
               WRITE_DATA = 4, READ_DATA = 5, STOP = 6;
    // Generate the I2C clock
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            i2c_scl <= 1; // Default HIGH
        end else if (scl_enable) begin
            i2c_scl <= ~i2c_scl; // Toggle SCL
        end
    end
    
    // Main state machine
    always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        scl_enable <= 0;
        i2c_scl <= 1;
        sda_dir <= 1;  // Set SDA as input (high impedance by default)
        sda_out <= 1;  // Set SDA to high (idle state)
        data_out <= 8'd0;
        addr_send <= 0;
        bit_counter <= 0;
        ready <= 1;  // Set ready on reset
    end else begin
        case (state)
            IDLE: begin
                ready <= 1;  // Ready when idle
                sda_dir <= 1;  
                if (enable) begin
                    state <= START;
                    shift_reg <= {addr, rw};  
                    scl_enable <= 1;  
                    ready <= 0;  
                end
            end 

            START: begin
                if (i2c_scl) begin  
                    sda_out <= 0;    
                    state <= SEND_ADDR;
                    $display("MASTER: Start Condition Set");
                end
            end

            SEND_ADDR: begin
                if (~i2c_scl) begin
                    addr_send <= 1;
                    sda_out <= shift_reg[8]; // Send MSB first
                    shift_reg <= shift_reg << 1; 
                    if (shift_reg == 0) begin
                        state <= READ_ACK;
                        addr_send <= 0;
                    end
                end
            end

            READ_ACK: begin
                if (ack_received) begin 
                    if (rw == 0) begin  
//                        $display("MASTER: rw == 0 .");
                        shift_reg <= {data_in, 1'b0}; 
                        state <= WRITE_DATA;
                    end else begin  
//                        $display("MASTER: rw == 1 .");
                        bit_counter <= 0;  // Reset bit counter 
                        state <= READ_DATA;
                    end
                end
            end

            WRITE_DATA: begin
                if (~i2c_scl) begin
                    sda_out <= shift_reg[8]; //  MSB first
                    shift_reg <= shift_reg << 1; 
                    if (shift_reg == 0) begin
                        state <= STOP;
                    end
                end
            end

            READ_DATA: begin
                sda_dir <= 0;  // Release SDA to read from slave
                if (read_data_received) begin
                    if (~i2c_scl) begin
                        shift_reg <= {shift_reg[6:0], i2c_sda};  
//                        $display("shift_reg=%0b", shift_reg);
                        bit_counter <= bit_counter + 1;
                        if (bit_counter == 7) begin                 // Last bit received
                            data_out <= {shift_reg[6:0], i2c_sda}; // Store data
                            sda_dir <= 1;  
                            sda_out <= 0;  // ACK (Pull SDA LOW)
                            state <= STOP;
                        end
                    end
                end
            end

            STOP: begin
                if (i2c_scl) begin  
                    sda_out <= 1;    
                    scl_enable <= 0;  
                    sda_dir <= 1;  
                    ready <= 1;  
                    state <= IDLE;  
//                    $display("MASTER: Stop Condition Set");
                end
            end 
        endcase
    end
end

endmodule
