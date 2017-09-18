function [idxCross] =  crossOver( A, B, type)
% A ���¶��ϴ�Խ B
% ���� { 0 �� 1 }��bool����
% ����bool���� ��Խ��Ϊ1 ����Ϊ0
% type = 1 ��׼
% type = 2 ���: A B ͬʱ������A�ϴ�B
% type = 3 ���棺A B ͬʱ�½���A�ϴ�B
% @author daniel 20130506 version 1.1
% version 1.2, luhuaibao, 20131114,
% v1.1�����ϸ�K����ֵ����������Ϊ���ڵ�ǰ�����򣬵�Ҳ�п����뵱ǰͬ����Ȼ����ȣ���ᵼ��һ�����⣬���������ϴ����´������м�û���´����ϴ���Ϊ�˱��������������=��ȥ����

%% Ԥ����
if nargin <= 2 || isempty(type)
    type = 1;
    if nargin <2 || isempty(A) || isempty(B)
        error('require input of A and B');
    end
end

[nPeriod, nAsset] = size(A);
if nAsset ~= size(B,2)
    error(' nAsset of A and B does not match');
end

if nPeriod ~= size(B,1)
    nPeriod = min(nPeriod, size(B,1));
    A = A(1:nPeriod, nAsset);
    B = B(1:nPeriod, nAsset);
end

%% ���㲽��

% һ�㽻�棬��棬����
switch type
    case 1
        idxCross = [nan(1:nAsset); A(1:end-1,:)]< [nan(1:nAsset); B(1:end-1,:)] & A>B;
    case 2
        idxCross = [nan(1:nAsset); A(1:end-1,:)]< [nan(1:nAsset); B(1:end-1,:)] ...
            & A > B & A > [nan(1,nAsset); A(1:end-1,:) ] & B > [nan(1,nAsset); B(1:end-1,:)];
    case 3
        idxCross = [nan(1:nAsset); A(1:end-1,:)]< [nan(1:nAsset); B(1:end-1,:)] ...
            & A > B & A < [nan(1,nAsset); A(1:end-1,:) ] & B < [nan(1,nAsset); B(1:end-1,:)];
% version 1.1
%     case 1
%         idxCross = [nan(1:nAsset); A(1:end-1,:)]<= [nan(1:nAsset); B(1:end-1,:)] & A>B;
%     case 2
%         idxCross = [nan(1:nAsset); A(1:end-1,:)]<= [nan(1:nAsset); B(1:end-1,:)] ...
%             & A > B & A > [nan(1,nAsset); A(1:end-1,:) ] & B > [nan(1,nAsset); B(1:end-1,:)];
%     case 3
%         idxCross = [nan(1:nAsset); A(1:end-1,:)]<= [nan(1:nAsset); B(1:end-1,:)] ...
%             & A > B & A < [nan(1,nAsset); A(1:end-1,:) ] & B < [nan(1,nAsset); B(1:end-1,:)];
end
    

