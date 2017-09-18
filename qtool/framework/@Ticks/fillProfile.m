function [ ] = fillProfile( obj, profileTicks, tkIndex )
%FILLPROFILE ��obj�����½������profileTicks��ָ�룩��
% ���룺
%     profileTicks    ����ע��Ľ��棨ָ�룩
%     tkIndex         Ҫ��ȡ�Ľ���ı�ţ�Ĭ��Ϊobj.latest
% û���������Ϊ��ע��
% ���䳬���̸գ�140829


if ~exist('tkIndex', 'var')
    tkIndex    = obj.latest;
end

%         ts_fields = {'time', 'time2', 'last', 'high'

try
%% ��Щ���޿��ܳ���
profileTicks.latest  =  tkIndex;
profileTicks.time    = obj.time(tkIndex);
profileTicks.last    = obj.last(tkIndex);
profileTicks.volume  = obj.volume(tkIndex);
profileTicks.amount  = obj.amount(tkIndex);

%% ��Щ���ܳ���
profileTicks.askP(1,:) = obj.askP(tkIndex,:);
profileTicks.askV(1,:) = obj.askV(tkIndex,:);
profileTicks.bidP(1,:) = obj.bidP(tkIndex,:);
profileTicks.bidV(1,:) = obj.bidV(tkIndex,:);

%% ��Щ���п��ܳ���
profileTicks.time2   = obj.time2(tkIndex);

catch e
end

%% ���ֻ��future��
try
    profileTicks.openInt = obj.openInt(tkIndex);
catch e
end




%% ��Щ���ǿ��ܳ����
try
    profileTicks.high    = obj.high(tkIndex);
    profileTicks.low     = obj.low(tkIndex);
catch e
end

% try
%     profileTicks.time2   = obj.time2(tkIndex);
% catch e
% end



end

