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
input Switch,//���䷽ʽ�� 0����ѯ��ʽ�� 1���жϷ�ʽ
input [1:0] RW,//��д���ƣ�00�� ������д�� 10�� ���� 11�� д��
input [7:0] D_a2b,//POC ��������Processor ����������
input [2:0] RSA,//Register Select Address,�Ĵ���ѡ���ַ��110�� SR�� 111�� BR��
input RDY,//Ready��1��printer��׼���ã�0��printerδ׼����

output reg IRQ,//�ж��ź�
output reg [7:0] D_b2a,//POC ��д�� processor ������
output reg TR,//Transport Request������Ϊ POC����ӡ���Ĵ�ӡ����
output reg [7:0] PD//Parallel Data���洢����ӡ������
);
   reg [7:0]SR = 8'b00000000;
   reg [7:0]BR = 8'b00000000; 
   reg [1:0] state = 2'b00;//��ʼstate����Ϊ00 ��00��CPU�Ѿ�д�����ݸ�POC����δ����01��POC�ʹ�ӡ�����֣�10���ȴ���ӡ����ӡ��
   //��Processor��ͨ��
   always@(posedge clk)
   begin
        if(RW == 2'b10)//������ָʾread
        begin
            if(RSA == 3'b110)//��SR�Ĵ���
                D_b2a[7:0] = SR[7:0];
            if(RSA == 3'b111)//��BR�Ĵ��������״̬Ӧ���ò���
                D_b2a[7:0] = BR[7:0];
        end
        if(RW == 2'b11)//������ָʾwrite
        begin
            if(RSA == 3'b110)//дSR�Ĵ���
                SR[7:0] = D_a2b[7:0];
            if(RSA == 3'b111)//дBR�Ĵ���
                BR[7:0] = D_a2b[7:0];
        end
   end
   //POC��printer��ͨ��
   always@(posedge clk)
   begin
        SR[0] = Switch;//��Switch������ʽ��0����ѯ��1���ж�
        case(state)
        //00��CPU�Ѿ�д�����ݸ�POC����δ����
        2'b00:
        begin
            if(SR[7] == 0) //CPU�ὫSR7��0
            begin
                state<=2'b01;//������һ��״̬
            end
        end
        //01��POC�ʹ�ӡ������
        2'b01:
        begin
            if(RDY == 1)//׼������
            begin   
                TR = 1;//���ʹ�ӡ��������
                PD[7:0] = BR[7:0];//�����������
                state <= 2'b10;//������һ��״̬
            end
        end
        //10���ȴ���ӡ����ӡ
        2'b10:
        begin
            if(RDY == 0)//���ֽ���,��ӡ����ӡ
            begin
                TR = 0;//��ֹ��ӡ��������
                SR[7] = 1;//��ʾPOC�Ѿ���������ݣ�����׼������������
                state <= 2'b00;//�ص���ʼ״̬
            end
        end
        default:;
        endcase
   end
   //��SR״̬����IRQ
   always@(posedge clk)
   begin
        if(SR[7]==1 && SR[0] == 1) IRQ = 0;//SR0=1��˵�������ж�ģʽ��SR7=1��˵��POC�Ѿ�׼���ý���������
        else IRQ = 1;
   end
endmodule
//ע�⵽��POCû���ӳٹ��̣���Ϊ���ǰ���ʵ�ʹ�����ƣ�����Ҫģ��Ч��