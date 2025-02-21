`timescale 1ns / 1ps

module tb_apb_slave;

    // Parameters
    parameter MEM_SIZE = 128; // Memory size (matches 7-bit address)

    // Inputs
    reg clk;
    reg rst;
    reg [6:0] apb_paddr;   // 7-bit address
    reg apb_pwrite;
    reg apb_pread;
    reg apb_penable;
    reg [7:0] apb_pwdata;  // Write data
    reg apb_pslverr;       // Slave error input (not used in this testbench)

    // Outputs
    wire [7:0] apb_prdata; // Read data
    wire apb_pready;       // Ready signal
    wire apb_pslverr_out;  // Slave error output

    // Instantiate the APB slave module
    apb_slave #(
        .MEM_SIZE(MEM_SIZE)
    ) uut (
        .clk(clk),
        .rst(rst),
        .apb_paddr(apb_paddr),
        .apb_pwrite(apb_pwrite),
        .apb_pread(apb_pread),
        .apb_penable(apb_penable),
        .apb_pwdata(apb_pwdata),
        .apb_prdata(apb_prdata),
        .apb_pslverr(apb_pslverr),
        .apb_pready(apb_pready),
        .apb_pslverr_out(apb_pslverr_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        rst = 1;
        apb_paddr = 0;
        apb_pwrite = 0;
        apb_pread = 0;
        apb_penable = 0;
        apb_pwdata = 0;
        apb_pslverr = 0;

        // Apply reset
        #20;
        rst = 0; // De-assert reset
        #10;

        // Test 1: Write to a valid address
        $display("Test 1: Write to valid address");
        apb_paddr = 7'd50;       // Address 50
        apb_pwdata = 8'hAA;      // Data to write
        apb_pwrite = 1;          // Write operation
        apb_penable = 1;         // Enable the transaction
        #10;
        apb_pwrite = 0;          // Clear write signal
        apb_penable = 0;         // Disable the transaction
        #10;

        
        
        $display("Test 11: Write to valid address");
        apb_paddr = 7'd51;       // Address 50
        apb_pwdata = 8'hAB;      // Data to write
        apb_pwrite = 1;          // Write operation
        apb_penable = 1;         // Enable the transaction
        #10;
        apb_pwrite = 0;          // Clear write signal
        apb_penable = 0;         // Disable the transaction
        #10;

        // Test 2: Read from a valid address
        

        // Test 3: Write to an invalid address
        $display("Test 3: Write to invalid address");
        apb_paddr = 7'd130;      // Address 130 (out of range)
        apb_pwdata = 8'hBB;      // Data to write
        apb_pwrite = 1;          // Write operation
        apb_penable = 1;         // Enable the transaction
        #10;
        if (apb_pslverr_out)
            $display("Error detected: Address out of range");
        else
            $display("Error not detected: Test failed");
        apb_pwrite = 0;          // Clear write signal
        apb_penable = 0;         // Disable the transaction
        #10;

        // Test 4: Read from an invalid address
        $display("Test 4: Read from invalid address");
        apb_paddr = 7'd130;      // Address 130 (out of range)
        apb_pread = 1;           // Read operation
        apb_penable = 1;         // Enable the transaction
        #10;
        if (apb_pslverr_out)
            $display("Error detected: Address out of range");
        else
            $display("Error not detected: Test failed");
        apb_pread = 0;           // Clear read signal
        apb_penable = 0;         // Disable the transaction
        #10;

        // Test 5: Read from a different valid address
        $display("Test 5: Read from a different valid address");
        apb_paddr = 7'd100;      // Address 100
        apb_pread = 1;           // Read operation
        apb_penable = 1;         // Enable the transaction
        #10;
        if (apb_prdata == 8'h00) // Default memory value is 0x00
            $display("Read data matches: 0x00");
        else
            $display("Read data mismatch: Expected 0x00, Got %h", apb_prdata);
        apb_pread = 0;           // Clear read signal
        apb_penable = 0;         // Disable the transaction
        #10;
        
        
        // Test 2: Read from a valid address
        $display("Test 2: Read from valid address");
        apb_paddr = 7'd50;       // Address 50
        apb_pread = 1;           // Read operation
        apb_penable = 1;         // Enable the transaction
        #10;
        if (apb_prdata == 8'hAA)
            $display("Read data matches: 0xAA");
        else
            $display("Read data mismatch: Expected 0xAA, Got %h", apb_prdata);
        apb_pread = 0;           // Clear read signal
        apb_penable = 0;         // Disable the transaction
        #10;
        
        $display("Test 22: Read from valid address");
        apb_paddr = 7'd51;       // Address 50
        apb_pread = 1;           // Read operation
        apb_penable = 1;         // Enable the transaction
        #10;
        if (apb_prdata == 8'hAB)
            $display("Read data matches: 0xAB");
        else
            $display("Read data mismatch: Expected 0xAA, Got %h", apb_prdata);
        apb_pread = 0;           // Clear read signal
        apb_penable = 0;         // Disable the transaction
        #10;
        // End simulation
        $display("Simulation complete");
        $finish;
    end

endmodule