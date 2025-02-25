`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/28 09:56:02
// Design Name: 
// Module Name: POC_test
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


module POC_test(

    );
    //输入变量
    reg clk;
    reg Switch;
    reg print_flag;
    reg [7:0] print_data;
    reg print_button;
    //输出变量
    wire [7:0] print_data_out;
    //将top实例化
    top top_a(
    .clk(clk),
    .Switch(Switch),
    .print_flag(print_flag),
    .print_button(print_button),
    .print_data_out(print_data_out),
    .print_data(print_data));
    //设置时钟（1时间单位反转一次）
    initial
    begin
        clk = 0;
        forever begin
            #1
            clk = ~clk;
            end
    end
    //设置仿真条件
    initial
    begin   
      //第一次，查询方式(共耗时300ns)
      //刚开机
      Switch = 0;
      print_flag = 1;
      print_data[7:0] = 8'b00000000;
      #50
      //输入第一组数据
      print_data[7:0] = 8'b10101010;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_data[7:0] = 8'b00000000;
      #75
      //输入第二组数据
      print_data[7:0] = 8'b10111011;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_data[7:0] = 8'b00000000;
      #75
      //第二次，中断方式(共耗时400ns)
      //切换模式
      Switch = 1;
      #25
      //输入第三组数据
      print_data[7:0] = 8'b11001100;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_data[7:0] = 8'b00000000;
      #75
      //输入第四组数据
      print_data[7:0] = 8'b11011101;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_data[7:0] = 8'b00000000;
      #75
      //输入第五组数据
      print_data[7:0] = 8'b11101110;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_data[7:0] = 8'b00000000;
      #75
      //第三次，查询方式(共耗时150ns)
      //切换模式
      Switch = 0;
      #25
      //输入第六组数据
      print_data[7:0] = 8'b11111111;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_data[7:0] = 8'b00000000;
      #75

      $finish;
    end
    
endmodule
//实验中出现的问题：
//1.没有将RDY在初始时候置1，导致到了out的时候，print_data_out始终没办法输出
//2.有一个状态里的if没有给begin和end，3句话没有执行完全，导致一开始的out全是0.