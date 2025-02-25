`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/24 11:25:20
// Design Name: 
// Module Name: printer
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


module printer(
input clk,
input TR,//Transport Request，脉冲为 POC给打印机的打印请求
input [7:0] PD,//Parallel Data，存储待打印的数据

output reg RDY = 1,//Ready，1：printer已准备好，0：printer未准备好
//重新理解RDY：当RDY=1，说明printer没有工作；当RDY=0，说明printer正在工作
output reg [7:0] print_data_out
);
    always@(posedge clk)
    begin
        if(TR == 1)//收到脉冲
        begin
            RDY <= 0;
            print_data_out [7:0] <= PD[7:0];
            #20//延迟20个时间单位,模拟打印过程
            RDY = 1;//重新准备好
        end
    end
endmodule
