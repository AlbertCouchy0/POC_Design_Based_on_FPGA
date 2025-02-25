`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/24 10:38:15
// Design Name: 
// Module Name: POC
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


module POC(
input clk,
input Switch,//传输方式， 0：查询方式， 1：中断方式
input [1:0] RW,//读写控制（00： 不读不写， 10： 读， 11： 写）
input [7:0] D_a2b,//POC 接受来自Processor 的输入数据
input [2:0] RSA,//Register Select Address,寄存器选择地址（110： SR， 111： BR）
input RDY,//Ready，1：printer已准备好，0：printer未准备好

output reg IRQ,//中断信号
output reg [7:0] D_b2a,//POC 回写给 processor 的数据
output reg TR,//Transport Request，脉冲为 POC给打印机的打印请求
output reg [7:0] PD//Parallel Data，存储待打印的数据
);
   reg [7:0]SR = 8'b00000000;
   reg [7:0]BR = 8'b00000000; 
   reg [1:0] state = 2'b00;//初始state设置为00 （00：CPU已经写入数据给POC且尚未处理，01：POC和打印机握手，10：等待打印机打印）
   //和Processor的通信
   always@(posedge clk)
   begin
        if(RW == 2'b10)//处理器指示read
        begin
            if(RSA == 3'b110)//读SR寄存器
                D_b2a[7:0] = SR[7:0];
            if(RSA == 3'b111)//读BR寄存器，这个状态应该用不上
                D_b2a[7:0] = BR[7:0];
        end
        if(RW == 2'b11)//处理器指示write
        begin
            if(RSA == 3'b110)//写SR寄存器
                SR[7:0] = D_a2b[7:0];
            if(RSA == 3'b111)//写BR寄存器
                BR[7:0] = D_a2b[7:0];
        end
   end
   //POC与printer的通信
   always@(posedge clk)
   begin
        SR[0] = Switch;//由Switch决定方式，0：查询，1：中断
        case(state)
        //00：CPU已经写入数据给POC且尚未处理
        2'b00:
        begin
            if(SR[7] == 0) //CPU会将SR7置0
            begin
                state<=2'b01;//进入下一个状态
            end
        end
        //01：POC和打印机握手
        2'b01:
        begin
            if(RDY == 1)//准备握手
            begin   
                TR = 1;//发送打印请求脉冲
                PD[7:0] = BR[7:0];//缓存数据输出
                state <= 2'b10;//进入下一个状态
            end
        end
        //10：等待打印机打印
        2'b10:
        begin
            if(RDY == 0)//握手结束,打印机打印
            begin
                TR = 0;//终止打印请求脉冲
                SR[7] = 1;//表示POC已经处理好数据，可以准备接收新数据
                state <= 2'b00;//回到初始状态
            end
        end
        default:;
        endcase
   end
   //由SR状态决定IRQ
   always@(posedge clk)
   begin
        if(SR[7]==1 && SR[0] == 1) IRQ = 0;//SR0=1，说明进入中断模式；SR7=1，说明POC已经准备好接收新数据
        else IRQ = 1;
   end
endmodule
//注意到，POC没有延迟过程，因为它是按照实际功能设计，不需要模拟效果