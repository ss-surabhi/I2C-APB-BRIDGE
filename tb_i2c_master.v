module tb_i2c_master;

    reg clk;                   // System clock
    reg rst;                   // Reset signal
    reg [6:0] addr;            // 7-bit slave address
    reg [7:0] data_in;         // Data to write
    reg enable;                // Enable transaction
    reg rw;                    // Read/Write control
    wire i2c_scl;               // Serial Clock Line (SCL)
    wire i2c_sda;               // Serial Data Line (SDA)
    wire done;                  // Transaction completed signal
    wire [7:0] data_out;       // Data received (if read)

    // Instantiate I2C Master
    i2c_master uut (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .data_in(data_in),
        .enable(enable),
        .rw(rw),
        .i2c_scl(i2c_scl),
        .i2c_sda(i2c_sda),
        .done(done),
        .data_out(data_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 100 MHz clock
    end

    // Dummy Slave simulation logic
    reg [7:0] slave_data_in;
    reg slave_ready;

    always @(posedge i2c_scl or posedge rst) begin
        if (rst) begin
            slave_data_in <= 8'b0;
            slave_ready <= 0;
        end else begin
            if (uut.state == 3'b010) begin // Send Address
                slave_ready <= 1;
            end else if (uut.state == 3'b101) begin // Send Data on Read
                slave_data_in <= 8'h5A; // Data to be sent on read
            end
        end
    end

    // SDA logic for the dummy slave (Open-drain)
    assign i2c_sda = (uut.state == 3'b100) ? slave_data_in[7 - uut.bit_count] : 1'bz;

    // Stimulus to simulate a write and read transaction
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        enable = 0;
        rw = 0;                // Write operation
        addr = 7'b1010101;     // Slave address
        data_in = 8'hA5;       // Data to write
        #10 rst = 1;           // Apply reset
        #10 rst = 0;

        // Start Write Transaction
        #10 enable = 1;        // Enable transaction
        #10 enable = 0;        // Disable after start
        #100;                  // Wait for transaction to complete
        if (done && rw == 0) begin
            $display("Write successful. Data written: %h", data_in);
        end else begin
            $display("Write failed.");
        end

        // Start Read Transaction
        #10 rw = 1;            // Change to Read operation
        data_in = 8'hFF;       // Irrelevant data for read operation
        #10 enable = 1;        // Enable transaction
        #10 enable = 0;        // Disable after start
        #100;                  // Wait for transaction to complete
        if (done && rw == 1 && data_out == 8'h5A) begin
            $display("Read successful. Data read: %h", data_out);
        end else begin
            $display("Read failed.");
        end

        $finish;
    end

endmodule
