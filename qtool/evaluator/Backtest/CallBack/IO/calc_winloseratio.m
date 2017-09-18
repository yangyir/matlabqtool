%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڼ����������ʼ�պͽ�ֹ��֮�䣬������Ӯ���������ν���֮�䣩�Լ�ƽ��ӯ����ƽ����ʧ��
% �Ѿ��������н��׳ɱ���û�н��׳ɱ������������

% Qichao Pan, 2013/04/23, v1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [winCount,loseCount,totalCount,win_averet,lose_averet,winratio]...
    = calc_winloseratio(tradeList)

% �ú�����ʱֻ��� [-1��0��1]�ź�
winIndex = find(tradeList(:,1)>0);
loseIndex = find(tradeList(:,1)<0);
winCount = length(winIndex);
loseCount = length(loseIndex);
totalCount = size(tradeList,1);
win_averet = mean(tradeList(winIndex,1));
lose_averet = mean(tradeList(loseIndex,1));
winratio = winCount/totalCount;
end