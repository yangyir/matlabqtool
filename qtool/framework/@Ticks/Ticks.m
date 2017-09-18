classdef Ticks < handle
% TICKS 核心类。存放tick数据。
% last T*1；bid，ask采取矩阵，如T*5

% 20131220，和群；创建
% 20131223，程刚；放入qtool\framework\
%     商榷：按日的数据是否应保留？
% 20140503, chenggang, 加入plotind
% 20140606, chenggang, 加入properties： code2，date，date2
% 20140618, chenggang, 把一些properties放入hidden = true
% 20140715；程刚；加入toExcel方法
% 20140726；程刚；加入[ newobj ] = getByIndex(obj, idx);
%                加入copy constructor： [ newobj ] = getCopy(obj);
% 140801;程刚；加入[obj] = prune(obj); （潘其超写的）
% 140821;程刚；加入expDate域
% 140827;潘其超; 加入了fillProfile方法。
% 160826; 程刚； 读取通联L2干净数据   readCSV_cleanL2_Tonglian(obj,  filename );
% 160826; 程刚；加入域 tranCnt ： 累计交易笔数 
% 160827; 程刚； 把askV，bidV改为askQ，bidQ，纯属处女座行为
%                 原askV，bidV保留，但设置为不可见
% 160828; 程刚； 加入绝对坐标挂单 计算函数和播放函数 play_absolute_levels( b, s_itk, e_itk  )
%      [ paxis, defense, mark ] = generate_absolute_leves(obj);
%     function [ ] = play_absolute_levels( b, s_itk, e_itk  )
% 160903; 程刚； 加入数据清洗的一些方法，命名规则 cleasing_XXXXXXXX()
%             [] = cleasing_emptyLast(obj);
%             [] = cleasing_emptyPQ(obj);
%             function [] = cleasing(obj)
% 160905，程刚，加入域：askA，bidA，为了方便
% 170712, 程刚，加入域：midP，abs，都是计算值; 函数 function [] = calc_midp_abs(obj)



%% **************  核心域，可见 ********************************
properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
    %% 标量
    code;       % 标准代码
    code2@char;      % 文本表达
    type@char;       %TODO: restricted to 'future', 'stock', 'etf', 'option'
    levels;     %行情档数，1，5，10，etc.
    latest;      %最新的Tick序号，做实时数据更新时使用
    expDate@double;    % 到期日，如735766，仅对future，option有意义

     
    
    %% 标量，或 D*1 向量
    % 按日的数据    
    date@double;   % 数字
    date2@char;  % 文本    
    preSettlement; % 前日结算价，如果有持仓过夜，则这两个数据用来计算盯市盈亏
    settlement;  % 当日结算价，仅对future有意义
    
    %% 时间序列，用 T*1 vectors
    % 按最小时间单位的数据
    time@double; % as double, such as 735496.961201
    time2; %as int32 explicit, such as 230407
    last;
    volume;   %累积量, 股、手
    amount;   %累积量，元
    openInt;  %累积量    
    tranCnt;  %累积成交笔数    
    
    %% 时间序列，用 T*levels vectors
    bidP; %买价
    bidQ; %买量
    bidA; %买额，amount，元

    askP; %卖价
    askQ; %卖量    
    askA; %卖额，amount，元
    
    
    %% 计算量
    midP;   % ( askP1 + bidP1 ) / 2  
    abs;    %  ask-bid spread
    
    

end

%% **************  储存输出域，不可更改 ******************************
properties (SetAccess = 'private', GetAccess = 'public', Hidden = false)

    % 输出储存用，矩阵
    headers;  % data的表头
    data;   % 时间序列
    data2;  % 标量信息

        
end


%% ********** 看不到的域，暂时不删除，改名的 ***************
 properties (SetAccess = 'public', GetAccess = 'public', Hidden = true)
     % 标量，或 D*1 向量
     open;
     high;
     low;
     close;
     dayVolume;
     dayAmount;
     %settlement; %当日结算价，是未来数据，慎用！
     
     % 已改名为askQ，bidQ
     bidV; %买量
     askV; %卖量
     
 end
 
  %% Constructor, 非常初级，有待完善
 methods(Access = 'public', Static = false, Hidden = false)
     function [obj] = Ticks(obj)
         obj.latest = 0;
         
     end
     
     % 因为是handle类，需要copy constructor，以免指针赋值
     [ newobj ] = getCopy(obj);

 end
 %% 方法
 methods(Access = 'public', Static = false, Hidden = false)
     %待填充
     [obj] = merge(obj,ts2);
     
     % 组装成变成Bars
     [bs]  = toBars(obj, slice_seconds, slice_start);
          
     % 按Index从中取一些出来, 用法类似于 b = a(a>0)
     [ newobj ] = getByIndex(obj, idx);
     
     % 向profile指针（也是Ticks类）里注某一层截面，默认为tkIndex = obj.latest
     % 注意：此函数和getByIndex不同，不生成新obj，只往已有的中注入
     [ ] = fillProfile( obj, profileTicks, tkIndex );
     
     % 截去obj.latest之后的部分，慎用
     [obj] = prune(obj);
     
     % 把5档或10档数据放入绝对坐标体系中
     [ paxis, defense, mark ] = generate_absolute_leves(obj);
     
     
     %% 作图，动画     
          
     % 播放展示，双轴，其中y1轴是last
     [ ] = playYY( obj, y2, xwin, y1win, step, pausesec, t_start, t_end);

     % 播放展示，绝对坐标的挂单情况
     [ ] = play_absolute_levels(obj, s_itk, e_itk);
     
     % 画图：盘口情况，默认只画一个tick
     [] = plotPankou(obj, cur, pre_win, post_win );
     
     % 画图：ask - last - bid图，及其常用，局部
     [] = plotLocalALB( obj, stk, etk );
     
     % 画图： stk:etk局部的Histogram，若有输出就不画图（类似hist）
     [N, X, R, cumR] = localHist(obj, stk, etk, type, grids);
     
     % 作图，用last数据，idx序列上标识
     [ output_args ] = plotind( obj, idx, drawtype);
    
 end
     
     
  %% 输入输出
 methods(Access = 'public', Static = false, Hidden = false)
    % 输出数据的方法
    [data, headers, data2]  = toTable( obj, headers );
    [obj]                   = toExcel(obj, filename, sheetname1, sheetname2);

            
     % 读处理好的CVS数据——通联数据
      [ obj ]     = readCSV_cleanL2_Tonglian(obj,  filename );
      
     % 
     [ obj ] = pushOneTick(obj, onetick)
      
 end
 
 
 %% 数据清洗的方法
 methods(Access = 'public', Static = false, Hidden = false)
     
     [] = cleasing_emptyLast(obj);
     [] = cleasing_emptyPQ(obj);
     
     function [] = cleasing(obj)         
        cleasing_emptyLast(obj);
        cleasing_emptyPQ(obj);
        
     end
         
     
     function [obj] = calc_midp_abs(obj)
         obj.midP = ( obj.askP(:,1) + obj.bidP(:,1) )  / 2;
         obj.abs  = obj.askP(:,1) - obj.bidP(:,1) ;
     end
     
 end
 
 
 %% 实时交易用的类， 前缀以rt_
  methods(Access = 'public', Static = false, Hidden = false)
     
     [ ] =  rt_NewTicks( obj, T , levels);
     
    
         
     
 end
    
 %% ********** static方法  *****************
 methods(Static = true)
     
     %         [ts1] = merge(ts1,ts2);
     
 end
end



