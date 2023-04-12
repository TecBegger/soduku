module i2c_controller (
    input clk,        // 时钟信号
    input rst,        // 复位信号
    output reg sda,   // 数据线信号
    output reg scl,   // 时钟线信号
    input busy,       // 忙碌信号（用于检测I2C总线是否被占用）
    input write_en,   // 写入使能信号
    input read_en,    // 读取使能信号
    input [6:0] addr, // 从设备地址
    input [7:0] data, // 数据
    output reg done   // 完成信号
);

reg [3:0] state;      // 状态机状态
reg [7:0] reg_addr;   // 寄存器地址
reg [7:0] reg_data;   // 寄存器数据
reg [6:0] device_addr;// 从设备地址
reg [2:0] bit_count;  // 位计数器
reg        ack;        // 响应信号

parameter IDLE_STATE = 4'b0000;
parameter START_STATE = 4'b0001;
parameter ADDR_STATE = 4'b0010;
parameter DATA_STATE = 4'b0011;
parameter STOP_STATE = 4'b0100;

always @(posedge clk or posedge rst)
begin
    if (rst)  // 复位信号为高电平
    begin
        state <= IDLE_STATE;
        bit_count <= 0;
        sda <= 1'b1;
        scl <= 1'b1;
        ack <= 1'b0;
    end
    else
    begin
        case (state)
            IDLE_STATE:
                begin
                    if (write_en || read_en)  // 如果有写入或读取使能信号
                        state <= START_STATE; // 进入起始状态
                end
            START_STATE:
                begin
                    sda <= 1'b0;  // 拉低数据线
                    scl <= 1'b0;  // 拉低时钟线
                    bit_count <= 0;
                    state <= ADDR_STATE;
                end
            ADDR_STATE:
                begin
                    if (bit_count < 7)  // 如果还没有发送完地址
                    begin
                        sda <= device_addr[bit_count];
                        bit_count <= bit_count + 1;
                    end
                    else  // 如果地址已经发送完毕
                    begin
                        if (write_en)  // 如果是写入操作
                            state <= DATA_STATE;
                        else  // 如果是读取操作
                            state <= START_STATE;
                        bit_count <= 0;
                    end
                end
            DATA_STATE:
                begin
                    if (bit_count < 7)  // 如果还没有发送完数据
                    begin
                        sda <= reg_data[bit_count];
                        bit_count <= bit_count + 1;
                    end
                    else  // 如果数据已经发送完毕
                    begin
                        state <= STOP_STATE;  // 进入停止状态
                        bit_count <= 0;
                    end
                end
