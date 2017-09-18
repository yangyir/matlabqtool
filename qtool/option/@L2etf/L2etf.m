classdef L2etf
    %L2ETF 专门用于放etf的L2数据
    
     %%
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        code;
        latest=1; % 最后的一个
    end
     
    %% 原始l2行情
% 证券代码	时间	最新价	申卖价5	申卖量5	申卖价4	申卖量4	申卖价3	申卖量3	申卖价2	申卖量2	申卖价1	申卖量1	申买价1	申买量1	申买价2	申买量2	申买价3	申买量3	申买价4	申买量4	申买价5	申买量5

    properties(SetAccess = 'private', GetAccess = 'public', Hidden = false)
       secCode;%证券代码	
       quoteTime;%     行情时间(s)
       last;%最新价	
       bidQ1;%申买量1	
       bidP1;%申买价1	
       bidQ2;%申买量2	
       bidP2;%申买价2
       bidQ3;%申买量3	
       bidP3;%申买价3	
       bidQ4;%申买量4	
       bidP4;%申买价4	
       bidQ5;%申买量5	
       bidP5;%申买价5	
       askQ1;%申卖量1	
       askP1;%申卖价1	
       askQ2;%申卖量2	
       askP2;%申卖价2	
       askQ3;%申卖量3	
       askP3;%申卖价3	
       askQ4;%申卖量4	
       askP4;%申卖价4	
       askQ5;%申卖量5	
       askP5;%申卖价5	
        
    end

    
    methods
    end
    
end

