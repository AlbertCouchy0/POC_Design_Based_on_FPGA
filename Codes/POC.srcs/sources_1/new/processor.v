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
input print_flag,//��ӡ�����أ�0Ϊ�ر�
input print_button,//ģ�⿪ʼ��ӡ��ť
input IRQ,//�ж��źţ�0��ʾ�����ж�����
input [7:0] D_b2a,//POC ��д�� processor ������

output reg [1:0] RW,//��д���ƣ�00�� ������д�� 10�� ���� 11�� д�� ��
output reg [7:0] D_a2b,//POC ��������Processor ����������
output reg [2:0] RSA//Register Select Address,�Ĵ���ѡ���ַ��110�� SR�� 111�� BR��
);
    always@(posedge clk)
    begin
        if(IRQ == 1)//��Ч�������ѯ��ʽ
        begin
            if(print_flag == 1 && print_button == 1)//printer�򿪣������¿�ʼ��ӡ��ť
            begin
                //1)��ȡprinter״̬�������״̬
                RW = 2'b10;//read 
                RSA = 3'b110;//��SR�Ĵ���
                #2
                if(D_b2a[7]==1)//SR7=1����ʾPOC�Ѿ�׼����
                //2)������ݵ�POC
                begin
                    RW = 2'b11;//write
                    RSA = 3'b111;//дBR�Ĵ���
                    D_a2b [7:0] = print_data[7:0];
                    #2//�ӳ�2��ʱ�䵥λ,ģ�����ݴ������
                    RSA = 3'b110;//дSR�Ĵ���
                    D_a2b [7:0] = 8'b00000000;//SR7=0��SR0=0
                    #2//�ӳ�2��ʱ�䵥λ,ģ�����ݴ������
                    RW = 2'b00;//��д��������
                end
            end
            else RW = 2'b00;//δ���빤��״̬��������д
        end
        
        else//��Ч�������жϷ�ʽ
        begin
            if(print_flag == 1 && print_button == 1 )//printer�򿪣������¿�ʼ��ӡ��ť
            //2)������ݵ�POC
            begin
                RW = 2'b11;//write
                RSA = 3'b111;//дBR�Ĵ���
                D_a2b[7:0] = print_data[7:0];
                #2//�ӳ�2��ʱ�䵥λ,ģ�����ݴ������
                RSA = 3'b110;//дSR�Ĵ���
                D_a2b[7:0] = 8'b00000001;//SR7=0��SR0=1
                #2//�ӳ�2��ʱ�䵥λ,ģ�����ݴ������
                RW = 2'b00;
            end
            else RW = 2'b00;
        end
    end
endmodule
