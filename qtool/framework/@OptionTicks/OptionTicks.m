classdef OptionTicks < Ticks
%TICKSOPT ��Ȩ��Ticks�࣬��Ticks�������������࣬������
% ԭ��Ticksֱ�Ӽ�¼��Ȩ��Ϣ��������
% �̸գ�140616
    
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        optCode; % ������룺'510050C1407M1500'
        optType;  % 'call' , 'put', 'exotic'
        adjustCode; % �����ı��룬 'A', 'B', 'M'
        underCode; % ���ɴ���
        underName; % ��������
        underType; % ��������
        underTicks; % ����Ticks���ݣ�ָ�룩
        underHisVol; % ������ʷvolatility
        strikeCode; % �磬3750
        expCode; % ��1407
        strike;  % K����37.5
%         expDate; % �����գ���735766
        expDate2; % �����գ�yyyymmdd
        naturalT; % ���뵽���ն�����Ȼ��
        tradingT; % ���뵽���ն��ٽ�����
        rfr; % �޷������ʣ���ʱΪ����      
        
    end
    
    methods(Access = 'public', Static = false, Hidden = false)
        % constructor
        
        % �Զ����һЩ��
        [ obj ] = fillUnder(obj); 
        [ obj ] = fillTK(obj);
        
        
    end
    
end

