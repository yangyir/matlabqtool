function [ holdableMat ] = dhXinguHoldable( tsMat )
% ��DHȡ���ݣ���Ʊ�Ŀɳֲ��ԣ�δ���У��¹�δ�򿪣������У������ɳֲ֣�
%   tsMat:  �ṩһ�������ܣ�assets * dates�� ��TsMatrix��
% ---------------------------
% �̸գ�20150616�����汾

%% Ԥ����



%% δ����
assets = tsMat.xProps;
dtsStr = tsMat.yProps;
dtsNum = datenum(dtsStr);
listedDt = DH_D_OTH_ListedDay(assets);
listedDtnum = datenum(listedDt);

% �ɳֲ�
h_listed = zeros(size(tsMat.data));
for ix = 1:length(assets)
    h_listed(:,ix) = dtsNum >= listedDtnum(ix);
end



%% �򵥹������к�20d���ֲܳ�

% �ɳֲ�
h_simple = zeros(size(tsMat.data));
for ix = 1:length(assets)
    h_simple(:,ix) = dtsNum >= listedDtnum(ix) + 20;
end





%% ϸ�¼�飺���к�δ��, ֻ������к�30���������з��
% % �ֲ飺close == open ����Ϊδ��
% hiMat   = th.dhPriceMat( tsMat, 'High', 2);
% preCMat = th.dhPriceMat( tsMat, 'PreClose', 2);
% loMat   = th.dhPriceMat( tsMat, 'Low', 2);
% hi      = hiMat.data;
% preC    = preCMat.data;
% lo      = loMat.data;
% clMat   = th.dhPriceMat( tsMat, 'Close', 2);
% cl      = clMat.data;
% 
% yiziZhangting = ( hi == lo ) & (hi == cl) & (cl > preC*1.09) ;
% 
% % ��֧��Ʊѭ��
% for ix = 1:length(assets)
%     shangshi = h_listed(:,ix);  % 1 Ϊ�ɽ��ף� 0 Ϊδ����
%     
%     % �Ѿ����еģ������ˣ�ֱ������ѭ��
%     if shangshi(1) == shangshi(end) % ʼ�յ�����״̬�ޱ仯
%         if max(shangshi) == min(shangshi)  % ���̵�����״̬�ޱ仯
%             continue;
%         end
%     end
%     
%     
%     % �м侭��������
% %     �����У�����δ��
%     % �ҵ�������
%     sh = shangshi(1:end-1)==0 & shangshi(2:end)==1;
%     sh = [0;sh];
%     % ������֮��������ͣ��δ�򿪣�ȫ�����ɳֲ�
%     yzzt = yiziZhangting(:,ix);  % 1 - һ����ͣ
%     weidakai = zeros(size(yzzt));
%     
%     
%     h_listed(:,ix) = dtsNum > listedDtnum(ix);
%     
%     
%     
% end









%% ������

% DH_D_OTH_DelistedDay('')



%% �����
holdableMat = tsMat.getCopy;
holdableMat.des = '�ɳֲ�';
holdableMat.des2 = '0/1';
holdableMat.datatype = '0/1';
holdableMat.data = h_simple;


end

