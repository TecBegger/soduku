module i2c_controller (
  input clk,
  input rstn,
  input sda_i,
  output reg sda_o,
  output reg scl_o
);

parameter SDA_IDLE = 1'b1;
parameter SDA_START = 1'b0;
parameter SDA_ACK = 1'b0;
parameter SDA_NACK = 1'b1;
parameter SDA_STOP = 1'b1;
parameter SDA_READ = 1'b1;
parameter SDA_WRITE = 1'b0;

parameter SCL_IDLE = 1'b1;
parameter SCL_START = 1'b0;
parameter SCL_STOP = 1'b1;

reg [7:0] addr_reg;
reg [7:0] data_reg;
reg [2:0] state;
reg bit ack_bit;

assign sda_o = (state == SDA_READ) ? data_reg[0] : SDA_IDLE;
assign scl_o = (state == SCL_START || state == SCL_STOP) ? ~scl_o : scl_o;

always @(posedge clk) begin
  if (!rstn) begin
    state <= SDA_IDLE;
    sda_o <= SDA_IDLE;
    scl_o <= SCL_IDLE;
    ack_bit <= 1'b0;
    addr_reg <= 8'h00;
    data_reg <= 8'h00;
  end else begin
    case (state)
      SDA_IDLE: begin
        if (sda_i == SDA_START) begin
          state <= SCL_START;
        end
      end
      SDA_START: begin
        addr_reg <= 8'h00;
        ack_bit <= 1'b0;
        state <= SDA_READ;
      end
      SDA_READ: begin
        if (addr_reg == 8'hFF) begin
          state <= SDA_STOP;
        end else if (ack_bit == 1'b1) begin
          data_reg <= read_data(addr_reg);
          addr_reg <= addr_reg + 1;
          ack_bit <= 1'b0;
          state <= SDA_ACK;
        end
      end
      SDA_ACK: begin
        if (sda_i == SDA_NACK) begin
          state <= SDA_STOP;
        end else begin
          state <= SCL_START;
        end
        ack_bit <= 1'b1;
      end
      SDA_WRITE: begin
        if (addr_reg == 8'hFF) begin
          state <= SDA_STOP;
        end else if (ack_bit == 1'b1) begin
          write_data(addr_reg, data_reg);
          addr_reg <= addr_reg + 1;
          ack_bit <= 1'b0;
          state <= SDA_ACK;
        end
      end
      SDA_STOP: begin
        state <= SDA_IDLE;
      end
      SCL_START: begin
        scl_o <= SCL_IDLE;
        state <= SDA_WRITE;
      end
    endcase
  end
end

function automatic byte read_data(input [7:0] addr);
  // 读取数据
endfunction

function automatic void write_data(input [7:0] addr, input [7:0] data);
  // 写入数据
endfunction

endmodule
