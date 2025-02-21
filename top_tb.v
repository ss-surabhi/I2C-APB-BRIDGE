`timescale 1ns/1ps

module top_tb;

    // Testbench signals
    reg         clk;
    reg         rst;
    reg         enable;
    reg  [6:0]  i2c_addr;
    reg         i2c_rw;       // 0 for write, 1 for read
    reg  [7:0]  i2c_data_in;  // Data to be written
    wire [7:0]  i2c_data_out; // Data received from slave
    wire        i2c_ready;
    wire        i2c_scl;
    wire        i2c_sda;

    
    top uut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .i2c_addr(i2c_addr),
        .i2c_rw(i2c_rw),
        .i2c_data_in(i2c_data_in),
        .i2c_data_out(i2c_data_out),
        .i2c_ready(i2c_ready),
        .i2c_scl(i2c_scl),
        .i2c_sda(i2c_sda)
    );

    // Clock generation (50MHz)
    always #10 clk = ~clk;

    //-------------------------------------------------------------------------
    // Task: I2C Write Transaction
    //-------------------------------------------------------------------------
    task i2c_write_task(input [6:0] addr_val, input [7:0] data_val);
    begin
        i2c_addr    = addr_val;
        i2c_data_in = data_val;
        i2c_rw      = 0; // Write operation
        enable      = 1;
        $display("Time=%0t: Starting I2C Write: Addr=%h, Data=%h", $time, addr_val, data_val);
        #400;  
        enable = 0;
        
        wait(i2c_ready == 1);
        #50;
        $display("Time=%0t: I2C Write Completed", $time);
    end
    endtask

    //-------------------------------------------------------------------------
    // Task: I2C Read Transaction
    //-------------------------------------------------------------------------
    task i2c_read_task(input [6:0] addr_val, input [7:0] expected_val);
    begin
        i2c_addr = addr_val;
        i2c_rw   = 1; // Read operation
        enable   = 1;
        $display("Time=%0t: Starting I2C Read: Addr=%h", $time, addr_val);
        #500;  // Wait for transaction to complete 
        enable = 0;
        wait(i2c_ready == 1);
        #50;
        if (i2c_data_out === expected_val)
            $display("Time=%0t: I2C Read Passed: Expected %h, Got %h", $time, expected_val, i2c_data_out);
        else
            $display("Time=%0t: I2C Read Failed: Expected %h, Got %h", $time, expected_val, i2c_data_out);
    end
    endtask

    //-------------------------------------------------------------------------
    // Test Sequence: Multiple Write and Read Transactions
    //-------------------------------------------------------------------------
    initial begin
        // Initialize signals
        clk         = 0;
        rst         = 1;
        enable      = 0;
        i2c_addr    = 7'h50;    // Default address 
        i2c_rw      = 0;
        i2c_data_in = 8'hA5;    // Default data 

        // Reset pulse
        #50;  
        rst = 0;
        #50;

        // Perform multiple write transactions
        i2c_write_task(7'h50, 8'hA5);
        i2c_read_task(7'h50, 8'hA5);
//        #50;
//        i2c_write_task(7'h51, 8'h5A);
//        i2c_read_task(7'h51, 8'h5A);
//        i2c_write_task(7'h52, 8'b10100110);
//        i2c_write_task(7'h53, 8'b10110110);
//        #200
//        i2c_read_task(7'h50, 8'hA5);

        #300;
        $display("Test Completed!");
        $finish;
    end

   
    /*
    initial begin
        $monitor("Time=%0t | Addr=%h | RW=%b | DataIn=%h | DataOut=%h | Ready=%b", 
                 $time, i2c_addr, i2c_rw, i2c_data_in, i2c_data_out, i2c_ready);
    end
    */

endmodule
