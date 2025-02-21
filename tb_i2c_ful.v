//`timescale 1ns/1ps

//module tb_i2c_full;

//    reg clk;
//    reg rst;
//    reg enable;
//    reg [6:0] addr;
//    reg rw;
//    reg [7:0] data_in;
//    wire [7:0] data_out;
//    wire ready;
//    wire i2c_scl;
//    wire i2c_sda;
//    wire ack_received;
//    wire read_data_received;
//    wire addr_send;

//    // Slave side
//    wire apb_write;
//    wire [6:0] apb_addr;
//    wire [7:0] apb_wdata;
//    wire apb_enable;
//    reg [7:0] i2c_out;  // Data from APB master for read
//    reg waiting_for_data;
//    reg apb_master_ready;
//    wire apb_read;

//    // Instantiate I2C Master
//    i2c_master master (
//        .clk(clk),
//        .rst(rst),
//        .enable(enable),
//        .addr(addr),
//        .rw(rw),
//        .data_in(data_in),
//        .data_out(data_out),
//        .ready(ready),
//        .i2c_scl(i2c_scl),
//        .i2c_sda(i2c_sda),
//        .ack_received(ack_received),
//        .read_data_received(read_data_received),
//        .addr_send(addr_send)
//    );

//    // Instantiate I2C Slave
//    i2c_slave slave (
//        .clk(clk),
//        .rst(rst),
//        .i2c_sda(i2c_sda),
//        .scl(i2c_scl),
//        .apb_write(apb_write),
//        .apb_addr(apb_addr),
//        .apb_wdata(apb_wdata),
//        .apb_enable(apb_enable),
//        .ack_received(ack_received),
//        .read_data_received(read_data_received),
//        .addr_send(addr_send),
//        .i2c_out(i2c_out),
//        .waiting_for_data(waiting_for_data),
//        .apb_master_ready(apb_master_ready),
//        .apb_read(apb_read)
//    );

//    // Clock Generation
//    always #5 clk = ~clk;  // 10ns period (100MHz)

//    initial begin
//        // Initialize signals
//        clk = 0;
//        rst = 1;
//        enable = 0;
//        addr = 7'b1010101; // Example 7-bit address
//        rw = 0; // Writing first
//        data_in = 8'hAB; // Example data to write
//        waiting_for_data = 0;
//        apb_master_ready = 0;
//        i2c_out = 8'hCD; // Data for read transaction

//        // Reset Pulse
//        #20 rst = 0;
//        #10 enable = 1; // Start I2C transaction (Write)

//        #300; // Wait for the write transaction to complete
//        enable = 0;

//        // Verify Slave received the write
//        if (apb_write && apb_addr == addr && apb_wdata == data_in) begin
//            $display("WRITE TEST PASSED: Data correctly written to Slave!");
//        end else begin
//            $display("WRITE TEST FAILED: Incorrect data received by Slave.");
//        end

//        // Start Read Operation
//        #50;
//        enable = 1;
//        rw = 1; // Read Operation
//        waiting_for_data = 1;
//        apb_master_ready = 1;

//        #700; // Wait for Read transaction

//        // Verify Read Data
//        if (data_out == i2c_out) begin
//            $display("READ TEST PASSED: Correct data received from Slave!");
//        end else begin
//            $display("READ TEST FAILED: Expected %h, got %h", i2c_out, data_out);
//        end

//        #50;
//        $finish;
//    end
//endmodule





//////////////////for read///////////////////////
//`timescale 1ns/1ps

//module tb_i2c_full;

//    reg clk;
//    reg rst;
//    reg enable;
//    reg [6:0] addr;
//    reg rw;
//    reg [7:0] data_in;
//    wire [7:0] data_out;
//    wire ready;
//    wire i2c_scl;
//    wire i2c_sda;
//    wire ack_received;
//    wire read_data_received;
//    wire addr_send;

//    // Slave side
//    reg [7:0] i2c_out;  // Data from APB master for read
//    reg waiting_for_data;
//    reg apb_master_ready;
//    wire apb_read;

//    // Instantiate I2C Master
//    i2c_master master (
//        .clk(clk),
//        .rst(rst),
//        .enable(enable),
//        .addr(addr),
//        .rw(rw),
//        .data_in(data_in),  // Not used in read
//        .data_out(data_out),
//        .ready(ready),
//        .i2c_scl(i2c_scl),
//        .i2c_sda(i2c_sda),
//        .ack_received(ack_received),
//        .read_data_received(read_data_received),
//        .addr_send(addr_send)
//    );

//    // Instantiate I2C Slave (Read)
//    i2c_slave slave (
//        .clk(clk),
//        .rst(rst),
//        .i2c_sda(i2c_sda),
//        .scl(i2c_scl),
//        .ack_received(ack_received),
//        .read_data_received(read_data_received),
//        .addr_send(addr_send),
//        .i2c_out(i2c_out),
//        .waiting_for_data(waiting_for_data),
//        .apb_master_ready(apb_master_ready),
//        .apb_read(apb_read)
//    );

//    // Clock Generation
//    always #5 clk = ~clk;  // 10ns period (100MHz)

//    initial begin
//        // Initialize signals
//        clk = 0;
//        rst = 1;
//        enable = 0;
//        addr = 7'b1010101; // Example 7-bit address
//        rw = 1; // Read Operation
//        waiting_for_data = 1;
//        apb_master_ready = 1;

//        // Reset Pulse
//        #20 rst = 0;
//        #10;

//        // --------------- First Read Transaction ---------------
//        i2c_out = 8'b11101101; // Example data from slave
//        enable = 1;  // Start I2C Read
//        $display("STARTING READ 1: Expected Data = %h", i2c_out);

//        #400; // Wait for Read transaction to complete
//        enable = 0;

//        if (data_out == i2c_out) 
//            $display("READ 1 PASSED: Received %h", data_out);
//        else 
//            $display("READ 1 FAILED: Expected %h, got %h", i2c_out, data_out);

//        wait (ready);
//        #100;  // Small delay before next read

//        // --------------- Second Read Transaction ---------------
//        addr = 7'b1011101;
//        i2c_out = 8'b10100101; // Different data for second read
//        enable = 1;  // Start I2C Read
//        $display("STARTING READ 2: Expected Data = %h", i2c_out);
//        #100;
//        enable = 0;
//        #400; // Wait for Read transaction to complete
        

//        if (data_out == i2c_out) 
//            $display("READ 2 PASSED: Received %h", data_out);
//        else 
//            $display("READ 2 FAILED: Expected %h, got %h", i2c_out, data_out);

//        wait (ready);
//        #100;  // Small delay before next read

//        // --------------- Third Read Transaction ---------------
//        addr = 7'b1011000;
//        i2c_out = 8'b11000001; // Different data for third read
//        enable = 1;  // Start I2C Read
//        $display("STARTING READ 3: Expected Data = %h", i2c_out);

//        #400; // Wait for Read transaction to complete
//        enable = 0;

//        if (data_out == i2c_out) 
//            $display("READ 3 PASSED: Received %h", data_out);
//        else 
//            $display("READ 3 FAILED: Expected %h, got %h", i2c_out, data_out);

//        $display("ALL READ TRANSACTIONS COMPLETED!");
//        #500;
//        $finish;
//    end
//endmodule

//////////////////////multiplr read and write..//////////////////////////

`timescale 1ns/1ps

module tb_i2c_full;

    reg clk;
    reg rst;
    reg enable;
    reg [6:0] addr;
    reg rw;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire ready;
    wire i2c_scl;
    wire i2c_sda;
    wire ack_received;
    wire read_data_received;
    wire addr_send;

    // Slave side
    reg [7:0] i2c_out;  // Data from APB master for read
    reg waiting_for_data;
    reg apb_master_ready;
    wire apb_read;

    // Instantiate I2C Master
    i2c_master master (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .addr(addr),
        .rw(rw),
        .data_in(data_in),  // Not used in read
        .data_out(data_out),
        .ready(ready),
        .i2c_scl(i2c_scl),
        .i2c_sda(i2c_sda),
        .ack_received(ack_received),
        .read_data_received(read_data_received),
        .addr_send(addr_send)
    );

    // Instantiate I2C Slave (Read)
    i2c_slave slave (
        .clk(clk),
        .rst(rst),
        .i2c_sda(i2c_sda),
        .scl(i2c_scl),
        .ack_received(ack_received),
        .read_data_received(read_data_received),
        .addr_send(addr_send),
        .i2c_out(i2c_out),
        .waiting_for_data(waiting_for_data),
        .apb_master_ready(apb_master_ready),
        .apb_read(apb_read)
    );

    // Clock Generation
    always #5 clk = ~clk;  // 10ns period (100MHz)

    // Task for Write Operation
    task i2c_write(input [6:0] dev_addr, input [7:0] data);
        begin
            addr = dev_addr;
            rw = 0; // Write operation
            data_in = data;
            enable = 1;
            $display("STARTING WRITE: Addr=%h, Data=%h", dev_addr, data);
            #500; // Wait for transaction to complete
            enable = 0;
            wait (ready);
            #50;
        end
    endtask

    // Task for Read Operation (with proper synchronization)
    task i2c_read(input [6:0] dev_addr, input [7:0] expected_data);
        begin
            addr = dev_addr;
            rw = 1; // Read operation
            
            // Ensure slave has data before master starts reading
            i2c_out = expected_data; // Provide expected data from slave
            waiting_for_data = 1;
            apb_master_ready = 1;
            
            #10; // Small delay before starting read
            enable = 1;
            $display("STARTING READ: Addr=%h, Expected Data=%h", dev_addr, expected_data);
            
            #600; // Wait for Read transaction to complete
            enable = 0;
            
            // Wait until master signals ready
            wait (ready);
            
            // Verify the received data
            if (data_out === expected_data) 
                $display("READ PASSED: Received %h", data_out);
            else 
                $display("READ FAILED: Expected %h, got %h", expected_data, data_out);
            
            #50;
        end
    endtask

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        enable = 0;
        waiting_for_data = 0;
        apb_master_ready = 0;

        // Reset Pulse
        #20 rst = 0;
        #10;

        // Perform Write Transactions
        i2c_write(7'b1010101, 8'hAB);
//        i2c_write(7'b1011101, 8'h34);
//        i2c_write(7'b1011000, 8'h78);

        // Perform Read Transactions
        i2c_read(7'b1010101, 8'hAB);
//        i2c_read(7'b1011101, 8'h34);
//        i2c_read(7'b1011000, 8'h78);

        $display("ALL READ & WRITE TRANSACTIONS COMPLETED!");
        #500;
        $finish;
    end
endmodule
