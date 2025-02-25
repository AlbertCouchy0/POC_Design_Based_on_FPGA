`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/24 11:25:34
// Design Name: 
// Module Name: top
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


module top(// 整个系统的输入和输出
input clk,//时钟
input Switch,//传输方式， 0：查询方式， 1：中断方式
input print_flag,//模拟printer开关
input print_button,//模拟开始打印按钮
input [7:0] print_data,//处理器想要打印的数据
output [7:0] print_data_out//printer输出的数据
);
    // 整个系统内的线型变量
    wire IRQ;//中断信号
    wire [7:0] D_b2a;//表示 POC 回写给 processor 的数据
    wire [1:0] RW;//读写控制（00： 不读不写， 10： 读， 11： 写）
    wire [7:0] D_a2b;//POC 接受来自Processor 的输入数据
    wire [2:0] RSA;//寄存器选择地址（110： SR， 111： BR）
    wire RDY;//Ready，1：printer已准备好，0：printer未准备好
    wire TR;//Transport Request，脉冲为 POC给打印机的打印请求
    wire [7:0] PD;//Parallel Data，存储待打印的数据
    //处理器的输入和输出
    processor processor_a(
        //输入端口
        .clk(clk), //.局部变量（全局变量）
        .IRQ(IRQ),
        .D_b2a(D_b2a),
        .print_data(print_data),
        .print_flag(print_flag),
        .print_button(print_button),
        //输出端口
        .RW(RW),
        .D_a2b(D_a2b),
        .RSA(RSA)
    );
    //POC的输入和输出
    POC POC_b(
        //输入端口
        .clk(clk),
        .Switch(Switch),
        .RW(RW),
        .D_a2b(D_a2b),
        .RSA(RSA),
        .RDY(RDY),
        //输出端口
        .D_b2a(D_b2a),
        .IRQ(IRQ),
        .TR(TR),
        .PD(PD)
    );
    //打印机的输入和输出
    printer printer_c(
        //输入端口
        .clk(clk),
        .TR(TR),
        .PD(PD),
        //输出端口
        .RDY(RDY),
        .print_data_out(print_data_out)
    );

endmodule
