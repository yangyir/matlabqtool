function [ idx1, idx2, commonTime ] = duiqiTime(times1, times2, type, givenTime)
%DUIQITIME ��������ʱ�����У������Լ��ṩgivenTime
% ����:
%     times1��times2     ������ʱ����
%     type               ���뷽ʽ��'union'��'intersect'(Ĭ�ϣ���'given'
%     givenTime          ������ʱ���У�����������
% ����� 
%     idx1��idx2         ��ţ�ʹ��commonTime = times1(idx1) = times2(idx2)
%     commonTime         ������ʱ���У�������ˣ�����givenTime
% �̸գ�140613


%% 

% Ĭ��ȡ����
if  ~exist('type','var'), type = 'intersect'; end


if max(times1) < min(times2) || min(times1) > max(times2)
    disp('����times1��times2���ཻ');      
    return;
end


%% main
switch type
    case {'union'} % ȡ�����Ĵ�����Щ�鷳���ɴ඼�ŵ����洦��      
        [commonTime, ui1, ui2] = union(times1, times2);
%         idx1 = ui1(ia);
%         idx2 = ui2(ia);

    case {'intersect'} % ���������״���,�ٶ�Ҳ��
        % intersect �Դ�unique��sort('ascend')
        [commonTime1, idx1,idx2] = intersect(times1, times2);

        return;
        
        
    case{'given'}
        commonTime = givenTime; 

end


%% �õ�Ч�ķ�����һ��һ���ң�����
% given һ��commonTime��ֱ����λ��
idx1 = nan(length(commonTime), 1);
idx2 = nan(length(commonTime), 1);

for i = 1:length(commonTime)
    i1 = find(times1<=commonTime(i), 1, 'last');
    i2 = find(times2<=commonTime(i), 1, 'last');
    if isempty(i1)
        idx1(i) = 1;
    else
        idx1(i) = i1;
    end
    
    if isempty(i2)
        idx2(i) = 1;
    else
        idx2(i) = i2;
    end
end


%% ��Ч�ʵķ�����������̫�ϸ�
% [~, idx1] = ismember(times1, commonTime);
% [~, idx2] = ismember(times2, commonTime);
