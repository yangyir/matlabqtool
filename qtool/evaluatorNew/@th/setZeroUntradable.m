function [ tradeMat ] = setZeroUntradable ( tradeMat, tradableMat )
% �Ѳ��ɽ��׵ĵط���Ϊ0����򵥴ֱ��Ĵ���ʽ
% [ tradeMat ] = setZeroUntradalbe ( tradeMat, tradableMat )
%     tradeMat�� ���׾���TsMatrix��
%     tradableMat���ɽ���1������0��TsMatrix�ࡣĬ�ϴ�DHȡ
% ---------
% �̸գ�20150521�����汾


%% ǰ����
% �ж�����
if ~isa(tradeMat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�tradeMat');
end


if ~exist('tradableMat', 'var')
    tradableMat = th.dhTradableMat( tradeMat );
end


% ��DH


%% main 
tradeMat.data = tradeMat.data  .*  tradableMat.data;


end

