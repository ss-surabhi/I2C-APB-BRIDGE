//module tb_apb_ful;

//    // Parameters
//    reg clk;
//    reg rst;
//    reg [7:0] apb_addr;
//    reg [7:0] apb_wdata;
//    reg apb_write;
//    reg apb_read;
//    reg apb_enable;
//    wire apb_pready;
//    wire [7:0] apb_prdata;
//    wire apb_pslverr;   // Error signal from APB slave
//    wire apb_master_ready;

//    // Instantiate the APB Master
//    apb_master u_apb_master (
//        .clk(clk),
//        .rst(rst),
//        .apb_addr(apb_addr),
//        .apb_wdata(apb_wdata),
//        .apb_write(apb_write),
//        .apb_read(apb_read),
//        .apb_enable(apb_enable),
//        .apb_ready(apb_pready),
//        .apb_penable(),
//        .apb_pwrite(),
//        .apb_pwdata(),
//        .apb_paddr(),
//        .apb_pslverr(apb_pslverr),
//        .apb_master_ready(apb_master_ready)
//    );

//    // Instantiate the APB Slave
//    apb_slave #(
//    .MEM_SIZE(256)
//    ) u_apb_slave (
//    .clk(clk),
//    .rst(rst),
//    .apb_paddr(apb_addr),
//    .apb_pwrite(apb_write),
//    .apb_penable(apb_enable),
//    .apb_pwdata(apb_wdata),
//    .apb_prdata(apb_prdata),
//    .apb_pslverr_out(apb_pslverr),  // Correct connection
//    .apb_pready(apb_pready)
//);

//    // Clock generation
//    always #5 clk = ~clk;

//    // Test stimulus
//    initial begin
//        // Initialize signals
//        clk = 0;
//        rst = 1;
//        apb_addr = 8'b0;
//        apb_wdata = 8'hAA;
//        apb_write = 0;
//        apb_read = 0;
//        apb_enable = 0;

//        // Reset the system
//        #10 rst = 0;
//        //#10 rst = 1;

//        // Test Write Operation
//        apb_addr = 8'h10;       // Valid address
//        apb_wdata = 8'h55;      // Write data
//        apb_write = 1;
//        apb_enable = 1;
//        #10 apb_enable = 0;
//        apb_write = 0;

//        // Test Read Operation
//        apb_addr = 8'h10;       // Valid address
//        apb_read = 1;
//        apb_enable = 1;
//        #10 apb_enable = 0;
//        apb_read = 0;

//        // Wait until the slave is ready (apb_pready)
//        wait(apb_pready == 1);
        
//        // Check if data read is correct
//        if (apb_prdata == 8'h55) begin
//            $display("Read success, got %h", apb_prdata);
//        end else begin
//            $display("Read failed, expected 8'h55 but got %h", apb_prdata);
            
//        end

//        // Test Write to Invalid Address
//        apb_addr = 8'hFF;       // Invalid address (outside the memory range)
//        apb_wdata = 8'h77;      // Data to write
//        apb_write = 1;
//        apb_read = 0;
//        apb_enable = 1;
//        #10 apb_enable = 0;
//        apb_write = 0;

//        // Test Read from Invalid Address
//        apb_addr = 8'hFF;       // Invalid address (outside the memory range)
//        apb_read = 1;
//        apb_enable = 1;
//        #10 apb_enable = 0;
//        apb_read = 0;

//        // Wait until the slave is ready (apb_pready)
//        wait(apb_pready == 1);
        
//        // Check for error signal in case of invalid address
//        if (apb_pslverr == 1) begin
//            $display("Error signal asserted for invalid address");
//        end else begin
//            $display("Error not detected for invalid address");
//        end

//        // End simulation
//        $finish;
//    end

//endmodule


//module tb_apb_ful;

//    // Parameters
//    reg clk;
//    reg rst;
//    reg [7:0] apb_addr;
//    reg [7:0] apb_wdata;
//    reg apb_write;
//    reg apb_read;
//    reg apb_enable;
//    wire apb_pready;
//    wire [7:0] apb_prdata;   // Read data from APB slave
//    wire apb_pslverr;   // Error signal from APB slave
//    wire apb_master_ready;
//    wire i2c_serial_out;  // Serial output from the master

//    // Instantiate the APB Master
//    apb_master u_apb_master (
//        .clk(clk),
//        .rst(rst),
//        .apb_addr(apb_addr),
//        .apb_wdata(apb_wdata),
//        .apb_write(apb_write),
//        .apb_read(apb_read),
//        .apb_enable(apb_enable),
//        .apb_ready(apb_pready),
//        .apb_penable(),
//        .apb_pwrite(),
//        .apb_pwdata(),
//        .apb_paddr(),
//        .apb_pslverr(apb_pslverr),
//        .apb_master_ready(apb_master_ready),
//        .i2c_serial_out(i2c_serial_out),
//        .apb_prdata(apb_prdata)  // Correct connection
//    );

//    // Instantiate the APB Slave
//    apb_slave #(
//    .MEM_SIZE(256)
//    ) u_apb_slave (
//    .clk(clk),
//    .rst(rst),
//    .apb_paddr(apb_addr),
//    .apb_pwrite(apb_write),
//    .apb_penable(apb_enable),
//    .apb_pwdata(apb_wdata),
//    .apb_prdata(apb_prdata),  // Connect slave read data to master
//    .apb_pslverr_out(apb_pslverr),  // Correct connection
//    .apb_pready(apb_pready)
//);

//    // Clock generation
//    always #5 clk = ~clk;

//    // Test stimulus
//    initial begin
//        // Initialize signals
//        clk = 0;
//        rst = 1;
//        apb_addr = 8'b0;
//        apb_wdata = 8'hAA;
//        apb_write = 0;
//        apb_read = 0;
//        apb_enable = 0;

//        // Reset the system
//        #10 rst = 0;

//        // Test Write Operation
//        apb_addr = 8'h10;       // Valid address
//        apb_wdata = 8'h55;      // Write data
//        apb_write = 1;
//        apb_enable = 1;
//        #10 apb_enable = 0;
//        apb_write = 0;

//        // Test Read Operation
//        apb_addr = 8'h10;       // Valid address
//        apb_read = 1;
//        apb_enable = 1;
//        #10 apb_enable = 0;
//        apb_read = 0;

//        // Wait until the slave is ready (apb_pready)
//        wait(apb_pready == 1);
        
//        // Check if data read is correct
//        if (apb_prdata == 8'h55) begin
//            $display("Read success, got %h", apb_prdata);
//        end else begin
//            $display("Read failed, expected 8'h55 but got %h", apb_prdata);
//        end

//        // Test Write to Invalid Address
//        apb_addr = 8'hFF;       // Invalid address (outside the memory range)
//        apb_wdata = 8'h77;      // Data to write
//        apb_write = 1;
//        apb_read = 0;
//        apb_enable = 1;
//        #10 apb_enable = 0;
//        apb_write = 0;

//        // Test Read from Invalid Address
//        apb_addr = 8'hFF;       // Invalid address (outside the memory range)
//        apb_read = 1;
//        apb_enable = 1;
//        #10 apb_enable = 0;
//        apb_read = 0;

//        // Wait until the slave is ready (apb_pready)
//        wait(apb_pready == 1);
        
//        // Check for error signal in case of invalid address
//        if (apb_pslverr == 1) begin
//            $display("Error signal asserted for invalid address");
//        end else begin
//            $display("Error not detected for invalid address");
//        end

//        // End simulation
//        $finish;
//    end

//endmodule


///////////////////////////////////////working for serial out///////////////////

//module tb_apb_ful;
    
//    reg clk, rst;
//    reg [7:0] apb_addr, apb_wdata;
//    reg apb_write, apb_read, apb_enable;
//    wire apb_ready, apb_pslverr;
//    wire [7:0] apb_prdata;
//    wire apb_penable, apb_pwrite;
//    wire [7:0] apb_pwdata, apb_paddr;
//    wire apb_master_ready;
//    wire i2c_serial_out;
    
//    // APB Slave signals
//    reg apb_pslverr_in;
//    wire apb_pslverr_out, apb_pready;

//    // Instantiate APB Slave
//    apb_slave #(.MEM_SIZE(256)) uut_apb_slave (
//        .clk(clk),
//        .rst(rst),
//        .apb_paddr(apb_paddr),
//        .apb_pwrite(apb_pwrite),
//        .apb_penable(apb_penable),
//        .apb_pwdata(apb_pwdata),
//        .apb_prdata(apb_prdata),
//        .apb_pslverr(apb_pslverr_in),
//        .apb_pready(apb_pready),
//        .apb_pslverr_out(apb_pslverr)
//    );

//    // Instantiate APB Master
//    apb_master uut_apb_master (
//        .clk(clk),
//        .rst(rst),
//        .apb_addr(apb_addr),
//        .apb_wdata(apb_wdata),
//        .apb_write(apb_write),
//        .apb_read(apb_read),
//        .apb_enable(apb_enable),
//        .apb_ready(apb_pready),
//        .apb_pslverr(apb_pslverr),
//        .apb_prdata(apb_prdata),
//        .apb_penable(apb_penable),
//        .apb_pwrite(apb_pwrite),
//        .apb_pwdata(apb_pwdata),
//        .apb_paddr(apb_paddr),
//        .apb_master_ready(apb_master_ready),
//        .i2c_serial_out(i2c_serial_out)
//    );

//    // Clock Generation
//    always #5 clk = ~clk;

//    initial begin
//        // Initialize signals
//        clk = 0;
//        rst = 1;
//        apb_addr = 0;
//        apb_wdata = 0;
//        apb_write = 0;
//        apb_read = 0;
//        apb_enable = 0;
//        apb_pslverr_in = 0;

//        // Reset pulse
//        #10 rst = 0;

//        // Test Case 1: Write Data to APB Slave
//        #10;
//        apb_addr = 8'h10;   // Write to address 0x10
//        apb_wdata = 8'hA5;  // Data 0xA5
//        apb_write = 1;
//        apb_enable = 1;
//        #10;
//        apb_enable = 0;
//        apb_write = 0;

//        // Wait for transaction to complete
//        #20;

//        // Test Case 2: Read Data from APB Slave
//        #10;
//        apb_addr = 8'h10;  // Read from address 0x10
//        apb_read = 1;
//        apb_enable = 1;
//        #10;
//        apb_enable = 0;
//        apb_read = 0;

//        // Wait for transaction to complete
//        #20;

//        // Monitor serial output (i2c_serial_out should transmit 0xA5 bit by bit)
//        $display("Serial output from I2C: ");
//        repeat (8) begin
//            $display("%b", i2c_serial_out);
//            #10;
//        end

//        // End simulation
//        #50;
//        $finish;
//    end
//endmodule


/////////////////////////////single read write transaction////////////////

//`timescale 1ns / 1ps

//module tb_apb_ful;
//    reg clk;
//    reg rst;
//    reg [7:0] apb_addr;
//    reg [7:0] apb_wdata;
//    reg apb_write;
//    reg apb_read;
//    reg apb_enable;
//    wire apb_ready;
//    wire apb_pslverr;
//    wire [7:0] apb_prdata;
//    wire apb_penable;
//    wire apb_pwrite;
//    wire apb_pread;
//    wire [7:0] apb_pwdata;
//    wire [7:0] apb_paddr;
//    wire apb_master_ready;
//    wire i2c_serial_out;
//    wire waiting_for_data;

//    // Instantiate APB Slave
//    apb_slave #(.MEM_SIZE(256)) uut_slave (
//        .clk(clk),
//        .rst(rst),
//        .apb_paddr(apb_paddr),
//        .apb_pwrite(apb_pwrite),
//        .apb_pread(apb_pread),
//        .apb_penable(apb_penable),
//        .apb_pwdata(apb_pwdata),
//        .apb_prdata(apb_prdata),
//        .apb_pslverr(apb_pslverr),
//        .apb_pready(apb_ready),
//        .apb_pslverr_out(apb_pslverr)
//    );

//    // Instantiate APB Master
//    apb_master uut_master (
//        .clk(clk),
//        .rst(rst),
//        .apb_addr(apb_addr),
//        .apb_wdata(apb_wdata),
//        .apb_write(apb_write),
//        .apb_read(apb_read),
//        .apb_enable(apb_enable),
//        .apb_ready(apb_ready),
//        .apb_pslverr(apb_pslverr),
//        .apb_prdata(apb_prdata),
//        .apb_penable(apb_penable),
//        .apb_pwrite(apb_pwrite),
//        .apb_pread(apb_pread),
//        .apb_pwdata(apb_pwdata),
//        .apb_paddr(apb_paddr),
//        .apb_master_ready(apb_master_ready),
//        .i2c_serial_out(i2c_serial_out),
//        .waiting_for_data(waiting_for_data)
//    );

//    // Clock Generation
//    always #5 clk = ~clk;

//    // Test Sequence
//    initial begin
////        $dumpfile("apb_master_slave_tb.vcd");
////        $dumpvars(0, apb_master_slave_tb);

//        clk = 0;
//        rst = 1;
//        #10 rst = 0;

//        // Write to memory address 0x10
//        apb_addr = 8'h10;
//        apb_wdata = 8'hAA;
//        apb_write = 1;
//        apb_read = 0;
//        apb_enable = 1;
//        #10;
//        apb_enable = 0;
//        #20;

//        // Read from memory address 0x10
//        apb_addr = 8'h10;
//        apb_write = 0;
//        apb_read = 1;
//        apb_enable = 1;
//        #10;
//        apb_enable = 0;
//        #100;
        
//        


//        // Monitor serial output (i2c_serial_out should transmit 0xA5 bit by bit)
////        $display("Serial output from I2C: ");
////        repeat (8) begin
////            $display("%b", i2c_serial_out);
////            #10;
////        end

//        // Check error condition for invalid address
////        apb_addr = 8'hFF; // Out of range address
////        apb_write = 1;
////        apb_wdata = 8'h55;
////        apb_enable = 1;
////        #10;
////        apb_enable = 0;
//        #20;
        
//        // Monitor serial output (i2c_serial_out should transmit 0xA5 bit by bit)
////        $display("Serial output from I2C: ");
////        repeat (8) begin
////            $display("%b", i2c_serial_out);
////            #10;
////        end
        

//        $finish;
//    end
//endmodule



/////////////////////////multiple read write transaction///////////////////////

module tb_apb_ful;

    reg clk;
    reg rst;
    reg [6:0] apb_addr;
    reg [7:0] apb_wdata;
    reg apb_write;
    reg apb_read;
    reg apb_enable;
    wire apb_ready;
    wire apb_pslverr;
    wire [7:0] apb_prdata;
    wire apb_penable;
    wire apb_pwrite;
    wire apb_pread;
    wire [7:0] apb_pwdata;
    wire [6:0] apb_paddr;
    wire apb_master_ready;
    wire i2c_out;
    wire waiting_for_data;
    reg data_send;
    
    // Instantiate APB Slave
    apb_slave #(.MEM_SIZE(128)) uut_slave (
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
        .apb_pslverr_out(apb_pslverr)
    );

    // Instantiate APB Master
    apb_master uut_master (
        .clk(clk),
        .rst(rst),
        .apb_addr(apb_addr),
        .apb_wdata(apb_wdata),
        .apb_write(apb_write),
        .apb_read(apb_read),
        .apb_enable(apb_enable),
        .apb_ready(apb_pready),
        .apb_pslverr(apb_pslverr),
        .apb_prdata(apb_prdata),
        .apb_penable(apb_penable),
        .apb_pwrite(apb_pwrite),
        .apb_pread(apb_pread),
        .apb_pwdata(apb_pwdata),
        .apb_paddr(apb_paddr),
        .apb_master_ready(apb_master_ready),
        .i2c_out(i2c_out),
        .waiting_for_data(waiting_for_data),
        .data_send(data_send)
 );

    assign apb_ready = apb_pready;  


    // Clock generation
    always #5 clk = ~clk;

    // Task for writing to APB
    task apb_write_task(input [6:0] addr, input [7:0] data);
        begin
            apb_addr = addr;
            apb_wdata = data;
            apb_write = 1;
            data_send = 1;
            apb_enable = 1;
            #10;
            apb_enable = 0;
            apb_write = 0;
            #100;
            $display("WRITE: Addr = %0d, Data = %0d", addr, data);
        end
    endtask

    // Task for reading from APB
    task apb_read_task(input [6:0] addr);
        begin
            apb_addr = addr;
            apb_read = 1;
            apb_enable = 1;
            #10;
            apb_enable = 0;
            apb_read = 0;
            #150;
            $display("READ: Addr = %0d, Data = %0d", addr, apb_prdata);
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        apb_enable = 0;
        apb_write = 0;
        apb_read = 0;
        apb_addr = 0;
        apb_wdata = 0;
 
        // Reset
        #10 rst = 0;
        
        apb_write_task(7'h10,8'b11001111);
        apb_write_task(7'h11,8'hab);
        apb_write_task(7'h12,8'hac);
        apb_read_task(7'h10);
        apb_read_task(7'h11);
        apb_write_task(7'h13,8'had);
        apb_write_task(7'h14,8'hae);
        apb_read_task(7'h12);
        apb_read_task(7'h13);
        apb_write_task(7'h15,8'b10111011);
        apb_read_task(7'h14);
        apb_read_task(7'h15);
        $display("Testbench completed.");
        $finish;
    end
endmodule



