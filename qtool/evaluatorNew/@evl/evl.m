classdef evl
% ���������ָ����㺯���������ĺ�����
% ����ֻ��Ϊһ����������ȫ����static������û��properties
% ȫ����Ԫ��������γ��ζ��Ǽ���������
% ---------------------------
% Pan, Qichao; 2013; �þ�û�ù�
% �̸գ�20150510�����ָ�Ϊevl������eval
% �̸գ�20150517������
%     [hfig] = plotSimple(nav,benchmark);
%     [hfig] = plotNavBmk(nav,benchmark);
% �̸գ�20150530������ [txt, txt2] = rptSimple( nav, rfr, period, benchmark );


    properties
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        % �Ѳ飬����
        
        % nav  <--> yield
        [ nav ]     = yield2nav( yield, flag );
        [ yield ]   = nav2yield( nav,   flag );
        
        % ����ָ�����
        [ aYield ]      = annualYield( nav, period);
        [ aVol ]        = annualVol( nav, period);        
        maxConGainTime  = maxConGainTime( nav);
        [mddVal, idx]   = maxDrawDownVal(nav);
        [ mdd ]         = maxDrawDown( nav );
        [ preHi, idx ]  = preHigh( nav );
        [ span, t1, t2] = longestDrawDown( nav );
        

        
        % ����ָ�꣬ratioָ�����
        alpha   = alpha( nav, benchmark, rf,period);
        beta    = beta( nav, benchmark);
        sharpeR = SharpeRatio( nav, rf, period);
        calmarR = CalmarRatio( nav, rf, period);
        
        
        % ��һ���Ѹ�


        
        % �Ѳ飬���󣬻��������껯������
        burkeR  = BurkeRatio(nav, rf);
        sortinoR = SortinoRatio( nav, rf);
        treynorR = TreynorRatio( nav, benchmark, rf);
        infoRatio = InfoRatio( nav, benchmark);

        % δ�飬 ���в���
        lretExclMax = LretExclMax(navOrRate, flag)
        retExclMax  = RetExclMax(navOrRate, flag)
        upRatio = upr(ret, MAR);
        
        % �̸��¼�

        
        % ��һ���¼�

        
        
        
        % TODO: дnav2yield�� yield2nav
        % ��һ������

        [ annualY ] = Annualize( yield, flag);

        
    end
    
    %% ��ͼ�����ͼ򵥱���͸��ӱ���
    methods (Access = 'public', Static = true, Hidden = false)
        
        [ hfig ]    = plotSimple(nav, rfr, period, benchmark);
        [ hfig ]    = plotNavBmk(nav, benchmark);
        
        %[txt, txt2] = rptSimple( nav, rfr, period, benchmark );
       [ txt, txt2 ] = rptSimple( nav, varargin);
       
       % �Ƚϸ��ӵı���
       [] = reportWord(xlsFilename, period);
       [] = reportWord2(xlsFilename);

    end
    
end

