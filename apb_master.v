module apb_master (
    input wire clk,                // Clock signal
    input wire rst,                // Reset signal
    input wire [6:0] apb_addr,     // Address from I2C slave
    input wire [7:0] apb_wdata,    // Data from I2C slave
    input wire apb_write,          // Write enable from I2C slave
    input wire apb_read,           // Read enable from I2C slave
    input wire apb_enable,         // APB enable signal from I2C slave
    input wire data_send,
    input wire apb_ready,          // APB slave ready signal
    input wire apb_pslverr,        // APB slave error
    input wire [7:0] apb_prdata,   // Read data from APB slave
    
    output reg apb_penable,        // APB enable signal
    output reg apb_pwrite,         // APB write signal
    output reg apb_pread,          // APB read signal 
    output reg [7:0] apb_pwdata,   // APB write data
    output reg [6:0] apb_paddr,    // APB address
    output reg apb_master_ready,   // Master ready signal for I2C slave
    output reg [7:0] i2c_out, // Read data directly sent to I2C slave
    output reg waiting_for_data    // Indicates when data is ready
);

    // State encoding
    localparam IDLE           = 2'b00;
    localparam WRITE_TRANSFER = 2'b01;
    localparam READ_TRANSFER  = 2'b10;
    localparam ERROR          = 2'b11;

    reg [1:0] state; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all outputs
            state <= IDLE;
            apb_penable <= 0;
            apb_pwrite <= 0;
            apb_pread <= 0;
            apb_pwdata <= 0;
            apb_paddr <= 0;
            apb_master_ready <= 0;
            i2c_out <= 0;
            waiting_for_data <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Reset control signals
                    apb_penable <= 0;
                    apb_pwrite <= 0;
                    apb_pread <= 0;
                    apb_master_ready <= 0;
                    waiting_for_data <= 0;
                        

                        if (apb_enable && apb_write && data_send) begin
                            apb_paddr <= apb_addr;
                            apb_pwdata <= apb_wdata;
                            apb_pwrite <= 1;
                            apb_penable <= 1;
                            state <= WRITE_TRANSFER;
                        end else if (apb_enable && apb_read) begin
                            apb_paddr <= apb_addr;
                            apb_pread <= 1;
                            apb_penable <= 1;
                            state <= READ_TRANSFER;
                        end
                    end

                WRITE_TRANSFER: begin
                    if (apb_ready) begin
                    $display("inside WRITE_TRANSFER");
                        if (apb_pslverr) begin
                            state <= ERROR;
                        end else begin
                            apb_penable <= 0;
                            apb_master_ready <= 1; // Signal transaction completion
                            state <= IDLE;
                        end
                    end
                end

                READ_TRANSFER: begin
                    if (apb_ready) begin
                    $display("inside READ_TRANSFER");
                        if (apb_pslverr) begin
                            state <= ERROR;
                        end else begin
                            i2c_out <= apb_prdata; // Directly send read data
                            
                            apb_penable <= 0;
                            waiting_for_data <= 1;  // Indicate that data is available
                            apb_master_ready <= 1;  // Indicate read completion
                            state <= IDLE;
                        end
                    end
                end

                ERROR: begin
                    apb_penable <= 0;
                    apb_master_ready <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule