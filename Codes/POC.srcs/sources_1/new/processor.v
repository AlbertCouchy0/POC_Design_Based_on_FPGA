`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/24 09:53:02
// Design Name: 
// Module Name: processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module processor(
input clk,
input [7:0] print_data,
input print_flag,//打印机开关，0为关闭
input print_button,//模拟开始打印按钮
input IRQ,//中断信号，0表示发动中断请求
input [7:0] D_b2a,//POC 回写给 processor 的数据

output reg [1:0] RW,//读写控制（00： 不读不写， 10： 读， 11： 写） ，
output reg [7:0] D_a2b,//POC 接受来自Processor 的输入数据
output reg [2:0] RSA//Register Select Address,寄存器选择地址（110： SR， 111： BR）
);
    always@(posedge clk)
    begin
        if(IRQ == 1)//无效，进入查询方式
        begin
            if(print_flag == 1 && print_button == 1)//printer打开，并按下开始打印按钮
            begin
                //1)读取printer状态，并检查状态
                RW = 2'b10;//read 
                RSA = 3'b110;//读SR寄存器
                #2
                if(D_b2a[7]==1)//SR7=1，表示POC已经准备好
                //2)输出数据到POC
                begin
                    RW = 2'b11;//write
                    RSA = 3'b111;//写BR寄存器
                    D_a2b [7:0] = print_data[7:0];
                    #2//延迟2个时间单位,模拟数据传输过程
                    RSA = 3'b110;//写SR寄存器
                    D_a2b [7:0] = 8'b00000000;//SR7=0，SR0=0
                    #2//延迟2个时间单位,模拟数据传输过程
                    RW = 2'b00;//读写控制清零
                end
            end
            else RW = 2'b00;//未进入工作状态，不读不写
        end
        
        else//有效，进入中断方式
        begin
            if(print_flag == 1 && print_button == 1 )//printer打开，并按下开始打印按钮
            //2)输出数据到POC
            begin
                RW = 2'b11;//write
                RSA = 3'b111;//写BR寄存器
                D_a2b[7:0] = print_data[7:0];
                #2//延迟2个时间单位,模拟数据传输过程
                RSA = 3'b110;//写SR寄存器
                D_a2b[7:0] = 8'b00000001;//SR7=0，SR0=1
                #2//延迟2个时间单位,模拟数据传输过程
                RW = 2'b00;
            end
            else RW = 2'b00;
        end
    end
endmodule
