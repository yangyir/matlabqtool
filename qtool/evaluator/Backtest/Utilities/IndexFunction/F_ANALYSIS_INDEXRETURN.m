%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������Ϊ����ָ��IndexCode��ʼ��BeginDate�ͽ�ֹ��EndDate֮�������ʡ�
% ���������SecCode��string����ָ�����룻
%          BeginDate��date������ʼ���ڣ�
%          EndDate��date������ֹ���ڣ�
% ��������� output��float����ָ��������
% ���� output = F_ANALYSIS_INDEXRETURN('000300.SHI','2012-03-01','2012-05-06')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  output = F_ANALYSIS_INDEXRETURN(IndexCode,BeginDate,EndDate)


output = fetch ('F_ANALYSIS_INDEXRETURN',IndexCode,BeginDate,EndDate);

output = cell2mat(output);
end
