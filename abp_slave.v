module apb_slave #(
    parameter MEM_SIZE = 128    // Memory size, default to 128 bytes (since address is 7 bits)
) (
    input wire clk,               // Clock signal
    input wire rst,               // Reset signal
    input wire [6:0] apb_paddr,   // 7-bit address from APB master
    input wire apb_pwrite,        // Write enable from APB master
    input wire apb_pread,         // Read enable from APB master
    input wire apb_penable,       // Enable signal from APB master
    input wire [7:0] apb_pwdata,  // Data to write to memory
    output reg [7:0] apb_prdata,  // Data to read from memory
    input wire apb_pslverr,       // Error signal from APB master
    output reg apb_pready,        // Ready signal to APB master
    output reg apb_pslverr_out    // Error signal output to APB master
);

    // Memory array, parameterized size
    reg [7:0] memory [0:MEM_SIZE-1]; // Memory size based on MEM_SIZE parameter

    // APB slave logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            apb_pready <= 0;
            apb_pslverr_out <= 0;
            apb_prdata <= 8'h00;
        end else begin
            if (apb_penable) begin
                if (apb_paddr > MEM_SIZE) begin  // Invalid address check
                    apb_pslverr_out <= 1;  // Set error flag
                    apb_pready <= 0;       // Not ready
                end else if (apb_pwrite) begin
                    
                    memory[apb_paddr] <= apb_pwdata; // Store data
                    memory[apb_paddr][7] <= 0;
                    apb_pready <= 1;
                    apb_pslverr_out <= 0;
                end else if (apb_pread) begin
                    apb_prdata <= memory[apb_paddr]; // Read data
                    apb_pready <= 1;
                    apb_pslverr_out <= 0;
                end
            end else begin
                apb_pready <= 0;
            end
        end
    end

endmodule