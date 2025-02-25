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


module top(// ����ϵͳ����������
input clk,//ʱ��
input Switch,//���䷽ʽ�� 0����ѯ��ʽ�� 1���жϷ�ʽ
input print_flag,//ģ��printer����
input print_button,//ģ�⿪ʼ��ӡ��ť
input [7:0] print_data,//��������Ҫ��ӡ������
output [7:0] print_data_out//printer���������
);
    // ����ϵͳ�ڵ����ͱ���
    wire IRQ;//�ж��ź�
    wire [7:0] D_b2a;//��ʾ POC ��д�� processor ������
    wire [1:0] RW;//��д���ƣ�00�� ������д�� 10�� ���� 11�� д��
    wire [7:0] D_a2b;//POC ��������Processor ����������
    wire [2:0] RSA;//�Ĵ���ѡ���ַ��110�� SR�� 111�� BR��
    wire RDY;//Ready��1��printer��׼���ã�0��printerδ׼����
    wire TR;//Transport Request������Ϊ POC����ӡ���Ĵ�ӡ����
    wire [7:0] PD;//Parallel Data���洢����ӡ������
    //����������������
    processor processor_a(
        //����˿�
        .clk(clk), //.�ֲ�������ȫ�ֱ�����
        .IRQ(IRQ),
        .D_b2a(D_b2a),
        .print_data(print_data),
        .print_flag(print_flag),
        .print_button(print_button),
        //����˿�
        .RW(RW),
        .D_a2b(D_a2b),
        .RSA(RSA)
    );
    //POC����������
    POC POC_b(
        //����˿�
        .clk(clk),
        .Switch(Switch),
        .RW(RW),
        .D_a2b(D_a2b),
        .RSA(RSA),
        .RDY(RDY),
        //����˿�
        .D_b2a(D_b2a),
        .IRQ(IRQ),
        .TR(TR),
        .PD(PD)
    );
    //��ӡ������������
    printer printer_c(
        //����˿�
        .clk(clk),
        .TR(TR),
        .PD(PD),
        //����˿�
        .RDY(RDY),
        .print_data_out(print_data_out)
    );

endmodule
