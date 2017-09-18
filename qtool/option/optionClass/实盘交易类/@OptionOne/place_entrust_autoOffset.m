function [ e ] = place_entrust_autoOffset( obj, direc, volume, px )
%PLACE_ENTRUST_AUTOOFFSET �µ�ʱ������position�Զ��жϿ�ƽ��
% Լ������volume�ϴ�ʱ�����ܲ��һ����ƽ�֣�һ���ֿ��֣� ����������Ϳ���
% [ e ] = place_entrust_autoOffset( obj, direc, volume, px )
%   direc�� ��1���򣬡�2������ 1�� -1��
%   volume:  ����
% -----------------------------------
% cg, 20160327


%% pre
% ����λ
switch direc
    case {'1', 1, 'b', 'buy'} % ��
        pos = obj.positionShort;
    case {'2', -1, 's', 'sell'} % ��
        pos = obj.positionLong;  
end


%% main
offset = '1'; 

% ����µ����ڳֲ֣��Ϳ��Թز�

% ��һ���ݴ���������Ϊ���ڹҵ����ı�pos.volume�� �����ѹҳ�tolerance��
% ֻ����ʱ�������������֮�ƣ��Ǽ�Position.volumeSellable
tolerance = 10; 

try
    if volume <= pos.volume - tolerance
        offset = '2';
    end
catch
end


e = obj.place_entrust_opt( direc, volume, offset, px );




end

