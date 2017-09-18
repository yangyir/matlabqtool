classdef sig < handle
    % sig �źŷ����Ļ�����
    % �źŵ�������Ԥ��֮��һ��ʱ���ڱ��֤ȯ�ļ۸�����
    % ������Ҫ�����ھ�һ֤ȯ����ͳ�������źţ���ʱ�����Ƕ��ʲ������
    % workflow:  data > indicators {real value}> sig > report
    %            sig (after eval) > Entry and Exit > Strategy Eval
    
    %-------------------------------
    % huajun @20140916
    
    properties
       time;      % full length of trading time
       
       instrument;% instrument name or code
       
       bid;       % sell or sell-short price
       
       ask;       % buy or buy-to-cover price
       
       close;     % latest price at each time spot
       
       ret;       % percentage change using close price
       
       indVal;    % indicators (full length of sample time)
       
       indName;   % description of indicator, used to locate indVal method and parameter
       
       sigVal;    % enumerable value, stem from indicator
       
       sigName;   % description of indicator, used to locate sigVal method and parameter
       
       mapSig2Ind;% mapping sig back to indicator
       
       sigTag;    % unique sig value to be tested
       
       pos;       % full length of position array [ nShare ]       
       
       nTag;      % number of tags
       
       nDay       % number of days in sample

       entry;     % list of entries  [time, price, nShare, tag]
       
       exit;      % list of exits    [time, price, nShare, tag, causeOfExit]
       
       msg;       % char [tag explanation]
             
      costPerTrade ;
       
       costOfTime;
       
    end
    
    methods
        function obj = sig(data )
            if nargin ==0, return
            else
                if isa(data,'Bars')
                    obj.time = data.time;
                    obj.instrument = data.code;
                    obj.bid = data.close;
                    obj.ask = data.close; % Bars���²����������ҵ�
                    obj.close = data.close; % Bars��
                    obj.ret = [0; data.close(2:end)./data.close(1:end-1)-1];
                    obj.nDay = length(unique(datenum(floor(obj.time))));
           
                elseif isa(data,'Ticks')
                    % �����Ticks��
                    obj.time = data.time;
                    obj.instrument = data.code;
                    obj.bid = data.bidP;
                    obj.ask = data.askP;
                    obj.close = data.last;
                    obj.ret = [0; data.last(2:end)./data.last(1:end-1)-1];
                end
            end
        end
        
        obj = setSig(obj,  ind2sig, varargin)
        % sig should be enumerable
        
        obj = testSig(obj, testSigFunc,varargin)
        
        function obj = setEntry(obj,entryFunc)
            % ��ָ��ת��Ϊ�ź�
            % obj.setEntry(@entryFunc);
            obj.entry = entryFunc(obj);
            obj.nTag = length(unique(obj.entry(:,5)));
        end
        
        obj = setExit(obj, param);
        
        [report, tradelist] = testTrade(obj, param);
    end
end

