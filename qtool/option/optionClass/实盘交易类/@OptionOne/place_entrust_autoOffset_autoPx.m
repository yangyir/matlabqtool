function [e] = place_entrust_autoOffset_autoPx( obj, direc, volume, pxType)
%PLACE_ENTRUST_AUTOOFFSET_AUTOPX �µ�ʱ���Զ����㿪ƽ�֣�����pxType�µ�
% ��Ҫ�õ���λ
% [e] = place_entrust_autoOffset_autoPx( obj, direc, volume, pxType)  
%   direc�� ��1���򣬡�2������ 1�� -1��
%   volume:  ����
%   pxType�� �Լ�oppo��Ĭ�ϣ����޼۳�ƽatpar��last�ۣ�mid��
% -----------------------------
% cg, 20160327


%% pre
if ~exist('pxType', 'var')
    pxType = 'oppo';
end
    

%% ����λ�� ��offset
switch direc
    case {'1', 1} % ��
        pos = obj.positionShort;
    case {'2', -1} % ��
        pos = obj.positionLong;  
end


% ����µ��ܴ󣬾�ֱ�ӿ��²�
% ���򣬹ز�
offset = '1'; % ����
try
    if volume <= pos.volume
        offset = '2';
    end
catch
end

%% �µ�
e = obj.place_entrust_autoPx( direc, volume, offset, pxType );

end

