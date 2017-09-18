function [ pos_pct, posL_pct, posS_pct ] = guiyihua( sMat, type, tradableMat )
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
ss_l        = sum(sMat_l,2);
posL_pct   = sMat_l ./ (ss_l*ones(1,NUMasset));
posL_pct(isnan(posL_pct) ) = 0;


% short
sMat_s = sMat;
sMat_s(sMat_s>0) = 0;
ss_s        = sum(sMat_s,2);
posS_pct   = - sMat_s ./ (ss_s* ones(1,NUMasset));
posS_pct(isnan(posS_pct) ) = 0;

%% ��type���ز�ֵͬ
switch type
    case{'long short'}
        pos_pct = posL_pct + posS_pct;
    case{'long'}
        pos_pct = posL_pct;
    case{'short'}
        pos_pct = posS_pct;
end


% pos_pct(isnan(pos_pct) ) = 0;
% posL_pct  = pos_pct( pos_pct>0 );
% posS_pct  = pos_pct( pos_pct<0 );
end

