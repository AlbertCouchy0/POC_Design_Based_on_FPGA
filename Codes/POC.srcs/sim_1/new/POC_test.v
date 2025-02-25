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
//test

module POC_test(

    );
    //�������
    reg clk;
    reg Switch;
    reg print_flag;
    reg [7:0] print_data;
    reg print_button;
    //�������
    wire [7:0] print_data_out;
    //��topʵ����
    top top_a(
    .clk(clk),
    .Switch(Switch),
    .print_flag(print_flag),
    .print_button(print_button),
    .print_data_out(print_data_out),
    .print_data(print_data));
    //����ʱ�ӣ�1ʱ�䵥λ��תһ�Σ�
    initial
    begin
        clk = 0;
        forever begin
            #1
            clk = ~clk;
            end
    end
    //���÷�������
    initial
    begin   
      //��һ�Σ���ѯ��ʽ(����ʱ150ns)
      Switch = 0;
      #50
      print_data[7:0] = 8'b10101010;
      print_flag = 1;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_flag = 0;
      #50
        
      //�ڶ��Σ��ж�ģʽ(����ʱ150ns)
      Switch = 1;
      #50
      print_data[7:0] = 8'b10111011;
      print_flag = 1;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_flag = 0;
      #50

      //�����Σ���ѯ��ʽ(����ʱ150ns)  
      Switch = 0;
      #50
      print_data[7:0] = 8'b11001100;
      print_flag = 1;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_flag = 0;
      #50

      //���ĴΣ���ѯģʽ(����ʱ150ns)  
      Switch = 1;
      #50
      print_data[7:0] = 8'b11011101;
      print_flag = 1;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_flag = 0;
      #50

      //����Σ��жϷ�ʽ(����ʱ150ns) 
      Switch = 1;
      #50
      print_data[7:0] = 8'b11101110;
      print_flag = 1;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_flag = 0;
      #50

      //�����Σ���ѯģʽ(����ʱ150ns)  
      Switch = 0;
      #50
      print_data[7:0] = 8'b11111111;
      print_flag = 1;
      print_button = 1;
      #5
      print_button = 0;
      #45
      print_flag = 0;
      #50

      $finish;
    end
    
endmodule
//ʵ���г��ֵ����⣺
//1.û�н�RDY�ڳ�ʼʱ����1�����µ���out��ʱ��print_data_outʼ��û�취���
//2.��һ��״̬���ifû�и�begin��end��3�仰û��ִ����ȫ������һ��ʼ��outȫ��0.