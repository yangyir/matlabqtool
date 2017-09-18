classdef Bars < handle
%BAR is a sinlge unit in a K��ͼ
% Ϊʲô��handle����Ҫ������copy constructor
% ��handle�󣬸ı�����ĳЩԪ�أ������������ɶ���
% ---------------------------------
% ver1.0; 
% ver1.1; Cheng,Gang; 20130418; ����avgHLOC, avgOC, avgHL 
% ver1.11; Daniel; 20130509; ��� preSettlement, settlement 
% ver1.12: Zhang Hang; 20130523; ���� calcdl
% ver1.13; Cheng Gang; 20130916; ����slicetype,9λ����4.4.1=Ƶ��.��ʼ.����
% ver1.14: Cheng Gang; 20130919; ����latest, ָ������һ�����ݵ��index��REPLAY��
% ver1.2:  �̸�; 20130920; ����static method: Bars.genEmpty(len),�����̶����ȵĿ�Bars
% ver1.21��Cheng, Gang��20131211��
%                 ɾȥ��barCeil, barFloor, barLen, lenLineUp, lenLineDown, yinYang;
%                 �޸�������openInterest -> openInt, dOpenInterest -> dOpenInt
% ver1.3: �̸գ�20131211��
%         ��Ķ�������dataTable���fieldnames��
%         �洢���ݵ�Ӳ�̾�����dataTable��ʽ
%         Ŀǰ�����������Ķ�û����ɶ�ȡ���ݳ���˳��Ӧ��������Ҫ��
% ver1.31; �̸գ�140707������data2��code2��
% ver1.35���̸գ�140715������toExcel����
% ver1.36; ���䳬; 140827; ����fillProfile������
% ver1.37; �̸գ�140829�����뷽����getCopy��getByIndex


    %% input properties
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
       %% ����
        code;
        code2; % ������������
        type;       %TODO: restricted to 'future' or 'stock'
        slicetype;
        latest;  % ָ��ʵ���е����һ��bar
        date;
        
      
       %% ʱ�����У��� N*1 vectors
        time; % as double, such as 735496.961201
        time2; %as int32 explicit, such as 230407 
        open;
        high;
        low;
        close;
        vwap;
        volume;     %��     
        amount;     %Ԫ
        openInt;
        
        %% ��������
        settlement; %���ս���ۣ���δ�����ݣ����ã�
        preSettlement; % ǰ�ս���ۣ�����гֲֹ�ҹ���������������������㶢��ӯ��

         
       %% ����ʱ������
        tickNum; %�����һ��slice, ��¼���а�����tick����

    end
    
    %% ���ݾ���
%     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
    properties (SetAccess = 'private', GetAccess = 'public', Hidden = false)
        headers;
        data;
        data2; % ������Ϣ��ž���
    end
    
    %% calculated properties
    properties (SetAccess = 'private', GetAccess = 'public', Hidden = false)
%     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
%         barCeil;
%         barFloor;
%         barLen;
%         lineLenUp;
%         lineLenDown;
%         yinYang;
%         avgHLOC; % avg( hi, lo, cl, op)
%         avgOC; % avg(cl, op)
%         avgHL; % avg(hi, lo)
        
        %change of Open Interest
%         dOpenInt;
        
       
    end
    

    % redundant, but convenient
    properties (SetAccess = 'private', GetAccess = 'public', Hidden = true)
        len;
    end
%     û����     
%     methods (Access = 'public', Static = true, Hidden = false)
%         isYin(obj);
%         isYang(obj);    
%     end
    
    %% ����
    methods (Access = 'public', Static = false, Hidden = false)
        % ��ͼ��
        plot(obj);
        plotind(obj, ind, showcond, drawtype);
        plotind2( obj, sig, ind, drawtype, isSplit);
        
        
        % 
        [ newbars]      = autocalc(obj);
        [ newbars]      = calcdl(obj);
        [ bars ]        = getcut( obj, times, flag );
        [ newbars ]     = fixbase( obj, value );
        [ barNum ]      = getBarbyDate( obj, year, month, day );
        [ barNum ]      = getBarbyNum( obj, dateNum);
        
        
        % ��Ϊ��handle�࣬��Ҫcopy constructor������ָ�븳ֵ
        [ newobj ] = getCopy(obj);
        
        % ��Index����ȡһЩ����, �÷������� b = a(a>0)
        [ newobj ] = getByIndex(obj, idx);
        
        % ��profileָ�루Ҳ��Ticks�ࣩ��עĳһ����棬Ĭ��ΪtkIndex = obj.latest
        % ע�⣺�˺�����getByIndex��ͬ����������obj��ֻ�����е���ע��
        [ ] = fillProfile( obj, profileBars, tkIndex );
        
        % ������
        [obj]           = merge(obj,bs2);
        
        % ������
        [ data, headers, data2] = toTable( obj, headers );
        [ obj ]                 = fromTable( obj );        
        [ obj ]                 = toExcel(obj, filename, sheetname1, sheetname2); 
    end
    
    %% static����
    methods (Access = 'public', Static = true, Hidden = false)
%         �����̶����ȵĿ�Bars�������Ͽɿ���һ��constructor
        [ newbars]      = genEmpty( length);
    end
    
end  
    


