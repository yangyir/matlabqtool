%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������������ָ��֤ȯ���루������á�������������Ӧָ����ʼ�ͽ�ֹ����֮�����
% �������ݣ����浽backtest Cache�У��ļ���Ϊ֤ȯ���롣
% ��������������ݸ�ʽ���£�
% 732686	4.460868254	4.48874868	4.419047614	4.453898147	11022101	6.39	215.9386515
% 732687	4.426017721	4.432987827	4.286615588	4.377226974	21426743	6.28	212.2213977
% 732688	4.377226974	4.426017721	4.321466121	4.342376441	9749282     6.23	210.5317369
% 732689	4.328436228	4.377226974	4.314496014	4.377226974	6720529     6.28	212.2213977
% 732690	4.356316654	4.426017721	4.307525908	4.328436228	7996673     6.21	209.8558726
% ����       ǰ��Ȩ����   ǰ��Ȩ���   ǰ��Ȩ���   ǰ��Ȩ����   �ɽ���   ����Ȩ����  ��Ȩ����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tool_download_callback(Path_backtest)

%  ��ȡ֤ȯ����
prompt = {'֤ȯ���루������á�������������','StartDate','EndDate'};
dlg_title = '��������֤ȯ����';
def ={'000300.SHI,000001.SHI','2012-01-01','2012-06-01'};
num_lines = 1;
options.Resize = 'on';

input_arg = inputdlg(prompt,dlg_title,num_lines,def,options);
if ~isempty(input_arg)
    StartDate = input_arg{2};
    EndDate = input_arg{3};
    s = input_arg{1};
    
    token = cell(1,1);
    index = 1;
    [token{index}, remain] = strtok(s,',');
    %  ����ָ��֤ȯ�������������ݲ����浽Cache��
    writeintocache_backtest(token{index},StartDate,EndDate,Path_backtest);
    while ~isempty(remain)
        s =  remain;
        index = index + 1;
        [token{index}, remain] = strtok(s,',');
         writeintocache_backtest(token{index},StartDate,EndDate,Path_backtest);
    end
end


end