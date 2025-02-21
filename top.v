module top (
    input wire clk,
    input wire rst,
    input wire enable,       // Enable I2C transaction
    input wire [6:0] i2c_addr,  // I2C Slave address
    input wire i2c_rw,       // Read/Write flag (1 = Read, 0 = Write)
    input wire [7:0] i2c_data_in,  // Data to be written (if write)

    output wire [7:0] i2c_data_out, // Data received from APB Slave
    output wire i2c_ready,     // I2C Master ready signal

    inout wire i2c_scl,   // Shared I2C Clock
    inout wire i2c_sda    // Shared I2C Data
);

    // Internal signals
    wire ack_received;
    wire addr_send;
    wire read_data_received;
    wire apb_write, apb_read;
    wire [7:0] apb_wdata, apb_prdata;
    wire [6:0] apb_addr;
    wire apb_enable;
    wire data_send;
    wire apb_ready;
    wire apb_pslverr;
    wire apb_pwrite, apb_penable;
    wire [7:0] apb_pwdata;
    wire [6:0] apb_paddr;
    wire apb_master_ready;
    wire [7:0] i2c_out;
    wire waiting_for_data;

    // Instantiate I2C Master
    i2c_master i2c_m (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .addr(i2c_addr),
        .rw(i2c_rw),
        .data_in(i2c_data_in),
        .data_out(i2c_data_out),
        .ready(i2c_ready),
        .i2c_scl(i2c_scl),
        .i2c_sda(i2c_sda),
        .ack_received(ack_received),
        .read_data_received(read_data_received),
        .addr_send(addr_send)
    );

    // Instantiate I2C Slave
    i2c_slave i2c_s (
        .clk(clk),
        .rst(rst),
        .i2c_sda(i2c_sda),
        .scl(i2c_scl),
        .apb_write(apb_write),
        .apb_addr(apb_addr),
        .apb_wdata(apb_wdata),
        .ack_received(ack_received),
        .read_data_received(read_data_received),
        .apb_master_ready(apb_master_ready),
        .addr_send(addr_send),
        .i2c_out(i2c_out),
        .waiting_for_data(waiting_for_data),
        .apb_read(apb_read),
        .apb_enable(apb_enable),
        .data_send(data_send)
    );


    // Instantiate APB Master
    apb_master apb_m (
        .clk(clk),
        .rst(rst),
        .apb_addr(apb_addr),
        .apb_wdata(apb_wdata),
        .apb_write(apb_write),
        .apb_read(apb_read),
        .apb_enable(apb_enable),
        .data_send(data_send),
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
        .waiting_for_data(waiting_for_data)
 );
 
    apb_slave #(.MEM_SIZE(128)) apb_s (
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
    
    

endmodule
