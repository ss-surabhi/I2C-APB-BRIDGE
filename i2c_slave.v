module i2c_slave (
    input wire clk,
    input wire rst,
    inout wire i2c_sda,  
    inout wire scl,      

    output reg apb_write,
    output reg [6:0] apb_addr,
    output reg [7:0] apb_wdata,
    output reg apb_enable,
    output reg ack_received,  
    output reg read_data_received,
    input wire addr_send,      
    input wire [7:0] i2c_out,  
    input wire waiting_for_data,
    input wire apb_master_ready,
    output reg data_send,
    output reg apb_read        
    
);

    localparam IDLE = 0, READ_ADDR = 1, READ_WRITE = 2, 
               SLAVE_RECEIVE = 3, SLAVE_TRANSMIT = 4, 
               SERIAL_SEND = 5, STOP = 6;

    reg [3:0] state;
    reg [7:0] addr_rw;  
    reg [7:0] received_data;
    reg [7:0] i2c_shift_reg; 
    reg sda_dir;
    reg sda_out;
    reg [3:0] bit_counter;

    assign i2c_sda = (sda_dir) ? sda_out : 1'bz;  

    always @(posedge scl or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sda_dir <= 0;
            sda_out <= 1;
            apb_write <= 0;
            apb_read <= 0;
            apb_enable <= 0;
            ack_received <= 0;
            read_data_received <= 0;
            data_send <= 0;
            bit_counter <= 0;
            addr_rw <= 8'b0;
            received_data <= 8'b0;
            i2c_shift_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    ack_received <= 0;
                    apb_enable <= 0;
                    apb_write <= 0;
                    apb_read <= 0;
                    sda_dir <= 0; // Release SDA
                    if (i2c_sda == 0 && scl == 1) begin  
                        state <= READ_ADDR;
                        bit_counter <= 8;
                    end
                end

                READ_ADDR: begin
                    addr_rw[bit_counter - 1] <= i2c_sda;
                    if (bit_counter == 1) begin
                        apb_addr <= addr_rw[7:1];
                        state <= READ_WRITE;
                    end else begin
                        bit_counter <= bit_counter - 1;
                    end
                end

                READ_WRITE: begin
                    ack_received <= 1;
                    if (addr_rw[0] == 0) begin // Write operation
                        apb_write <= 1;
                        apb_enable <= 1;
                        state <= SLAVE_RECEIVE;
                        bit_counter <= 8;
                    end else begin // Read operation
                        apb_read <= 1;
                        apb_enable <= 1;
                        state <= SLAVE_TRANSMIT;
                    end
                end 

                SLAVE_RECEIVE: begin
                    received_data <= {received_data[7:0], i2c_sda}; // Shift in SDA bits
//                    $display("received_data=%0b",received_data);
                    if (bit_counter == 0) begin
                        apb_wdata <= received_data;
                        data_send <= 1;
                        state <= STOP;
                    end else begin
                        bit_counter <= bit_counter - 1;
                    end
                end

                SLAVE_TRANSMIT: begin
                    if (waiting_for_data && apb_master_ready) begin
//                    $display("inside SLAVE_TRANSMIT");
                        i2c_shift_reg <= i2c_out; 
//                        $display("i2c_out=%0b",i2c_out);
//                        $display("i2c_out=%0b",i2c_out);
                        bit_counter <= 8; // Set bit counter for transmission
                        state <= SERIAL_SEND; 
                    end
                end

                SERIAL_SEND: begin  
//                $display("SERIAL_SEND");
                sda_dir <= 1;
                    if (bit_counter > 0) begin                        
                        sda_out <= i2c_shift_reg[7]; // Output LSB first (or adjust if MSB first)
//                        $display("SERIAL_SEND i2c_shift_reg=%0b",i2c_shift_reg);
//                        $display("bit_counter=%0d",bit_counter);
                        i2c_shift_reg <= {i2c_shift_reg[6:0], 1'b0};
                        bit_counter <= bit_counter - 1;
                        read_data_received <=1;
                    end else begin
                        sda_dir <= 0; // Release SDA after transmission
                        read_data_received <=0;
                        state <= STOP;
                    end
                end

                STOP: begin
                    sda_dir <= 0;
                    apb_write <= 0;
                    apb_read <= 0;
                    apb_enable <= 0;
                    ack_received <= 0;
                    data_send <= 0;
                    read_data_received <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
