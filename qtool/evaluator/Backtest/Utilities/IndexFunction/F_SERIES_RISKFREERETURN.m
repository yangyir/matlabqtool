%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������Ϊ������ʼ��BeginDate�ͽ�ֹ��EndDate֮���޷��������������С�
% ���������BeginDate��date������ʼ���ڣ�
%          EndDate��date������ֹ���ڣ�
%          Step��int�����������ɹ�ѡ�1-�գ�2-�ܣ�3-�£�4-����5-���ꣻ6-�ꣻ
%          Style��int����������ʽ���ɹ�ѡ�1-��Ȼ�գ�2-�����գ�
%          Type��int�����޳����򣬿ɹ�ѡ�1-���޳���2-�޳��ռ�¼��
% ��������� output��cell����ָ����������������
% ���� output = F_SERIES_RISKFREERETURN('2012-03-01','2012-05-06',1,1,1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  output = F_SERIES_RISKFREERETURN(BeginDate,EndDate,Step,Style,Type)

output = fetch('F_SERIES_RISKFREERETURN',BeginDate,EndDate,Step,Style,Type);

end