function dist= findFirstEqual(  ts1, ts2, itimes )
%FINDFIRSTEQUAL ���ҵ�һ�����ڵ��ڵ������������ڵ��г�
% inputs:
%       ts1:                ��ǰ����
%       ts2:                ���Ƚ�����
%       itime:              ʱ������
% version 10, luhuaibao, 2014.5.29


n1 = length(ts1);
n2 = length(ts2);
if n1~=n2
    error('�����г��Ȳ�ͬ');
end ;

if ~exist('itimes','var'), itimes = (1:n1)'; end ;


dist = nan(n1,1);
% ����matlab��ʽ��ʱ�䣬����
t = itimes - floor(itimes);

for i = 1:n1-1
    ts0 = ts2(i+1:n2,1);
    id = find(ts0>=ts1(i),1,'first');
    if isempty(id)
        %         dist(i) = itimes(n2)-itimes(i) ;
        dist(i) = nan ;
    else
        % ���磬��ȥ5400��
        if t(i) <= 11.5/24 && t(i+id) > 11.5/24
            dist(i) = itimes(i+id)-itimes(i) - 1.5/24 ;
        else
            dist(i) = itimes(i+id)-itimes(i) ;
        end ;
    end ;
    
    
end ;


end

