function [ obj ] = calcVol( obj , R, S)
%CALCVOL ��һ��vol
% ���룺
%     R - �޷������ʣ�Ĭ��6%
%     S - �ʲ��۸�
% ---------------------------------------------------     
% �̸գ�151119

%% Ĭ��ֵ
if ~exist('R', 'var'), R = 0.06; end
if ~exist('S', 'var'), S = 2.291; end


%% �����棺ȫ������һ��
% tic
try
if obj.CP == 1 % call
    res = blsimpv(S, obj.K, R, obj.T, [obj.last, obj.askP1, obj.bidP1], 3, 0, [], {'call'});
    obj.vol = res(1);
    obj.askvol = res(2);
    obj.bidvol = res(3);
elseif obj.CP == 2 % put
    res = blsimpv(S, obj.K, R, obj.T, [obj.last, obj.askP1, obj.bidP1], 3, 0, [], {'put'});
    obj.vol = res(1);
    obj.askvol = res(2);
    obj.bidvol = res(3);    
end
catch e, end
% toc

%% �Ľ��棺ֻ����ı��˼۸�ļ���ֵ
% obj.changedL2fields





end

