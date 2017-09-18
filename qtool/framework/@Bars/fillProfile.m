function [ output_args ] = fillProfile( obj, profileBars, index )
%FILLPROFILE ��obj�����½������profileBars��ָ�룩��
% ���룺
%     profileBars     ����ע��Ľ��棨ָ�룩
%     index         Ҫ��ȡ�Ľ���ı�ţ�Ĭ��Ϊobj.latest
% û���������Ϊ��ע��
% ���䳬���̸գ�140829

%% 
if ~exist('index', 'var')
    index    = obj.latest;
end

%%
try
    %% ��������������
    profileBars.latest  = index;
    profileBars.time    = obj.time(index);
    profileBars.open    = obj.open(index);
    profileBars.high    = obj.high(index);
    profileBars.low     = obj.low(index);
    profileBars.close   = obj.close(index);
    profileBars.volume  = obj.volume(index);
    profileBars.amount  = obj.amount(index);
    
    %% ���п��ܳ������
    profileBars.time2   = obj.time2(index);
catch e
end

%% δ�ض��е���
try
profileBars.openInt = obj.openInt(index);
catch e
end

try
profileBars.tickNum = obj.tickNum(index);
catch e
end

end

