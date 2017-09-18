function [ pos_pct ] = guiyihua( sMat, type, tradableMat )
%GUIYIHUA ��һ��sMat
% ���ɽ��׵�sû�����壬ȫ����0
% ��Σ�
%     sMat
%     tradableMat     Ĭ��ȫ���ɽ���
%     type            'long', 'short', 'long short'(Ĭ�ϣ�
% �����
%     pos_pct         �ٷֱȲ�λ

%% ǰ����
NUMasset = size(sMat,2);

if exist('tradableMat', 'var')
    sMat = sMat .* tradableMat;
else    
%     tradableMat = ones(size(sMat)); 
end

if ~exist('type', 'var'), type = 'long short'; end


%% long, short�ֱ���Ȩ��
% long
sMat_l = sMat;
sMat_l(sMat_l<0) = 0;
ss_l = sum(sMat_l,2);
pos_pct_l = sMat_l ./ (ss_l*ones(1,NUMasset));

% short
sMat_s = sMat;
sMat_s(sMat_s>0) = 0;
ss_s = sum(sMat_s,2);
pos_pct_s = - sMat_s ./ (ss_s* ones(1,NUMasset));

%% ��type���ز�ֵͬ
switch type
    case{'long short'}
        pos_pct = pos_pct_l + pos_pct_s;
    case{'long'}
        pos_pct = pos_pct_l;
    case{'short'}
        pos_pct = pos_pct_s;
end


pos_pct(isnan(pos_pct) ) = 0;
end

