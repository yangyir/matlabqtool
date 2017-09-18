classdef Bars < handle
%BAR is a sinlge unit in a K线图
% 为什么用handle？需要另外做copy constructor
% 用handle后，改变对象的某些元素，不会重新生成对象
% ---------------------------------
% ver1.0; 
% ver1.1; Cheng,Gang; 20130418; 加入avgHLOC, avgOC, avgHL 
% ver1.11; Daniel; 20130509; 添加 preSettlement, settlement 
% ver1.12: Zhang Hang; 20130523; 加入 calcdl
% ver1.13; Cheng Gang; 20130916; 加入slicetype,9位整数4.4.1=频率.起始.其它
% ver1.14: Cheng Gang; 20130919; 加入latest, 指向最新一个数据点的index，REPLAY用
% ver1.2:  程刚; 20130920; 加入static method: Bars.genEmpty(len),产生固定长度的空Bars
% ver1.21：Cheng, Gang，20131211；
%                 删去域：barCeil, barFloor, barLen, lenLineUp, lenLineDown, yinYang;
%                 修改域名：openInterest -> openInt, dOpenInterest -> dOpenInt
% ver1.3: 程刚，20131211；
%         大改动：加入dataTable域和fieldnames域
%         存储数据到硬盘尽量以dataTable形式
%         目前看来，域名改动没有造成读取数据出错，顺序应该是最重要的
% ver1.31; 程刚；140707；加入data2，code2域
% ver1.35；程刚；140715；加入toExcel方法
% ver1.36; 潘其超; 140827; 加入fillProfile方法。
% ver1.37; 程刚；140829；加入方法：getCopy，getByIndex


    %% input properties
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
       %% 标量
        code;
        code2; % 中文名或描述
        type;       %TODO: restricted to 'future' or 'stock'
        slicetype;
        latest;  % 指向实际中的最后一个bar
        date;
        
      
       %% 时间序列，用 N*1 vectors
        time; % as double, such as 735496.961201
        time2; %as int32 explicit, such as 230407 
        open;
        high;
        low;
        close;
        vwap;
        volume;     %股     
        amount;     %元
        openInt;
        
        %% 其他标量
        settlement; %当日结算价，是未来数据，慎用！
        preSettlement; % 前日结算价，如果有持仓过夜，则这两个数据用来计算盯市盈亏

         
       %% 其它时间序列
        tickNum; %如果是一个slice, 记录其中包含的tick数量

    end
    
    %% 数据矩阵
%     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
    properties (SetAccess = 'private', GetAccess = 'public', Hidden = false)
        headers;
        data;
        data2; % 标量信息存放矩阵
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
%     没有用     
%     methods (Access = 'public', Static = true, Hidden = false)
%         isYin(obj);
%         isYang(obj);    
%     end
    
    %% 方法
    methods (Access = 'public', Static = false, Hidden = false)
        % 画图用
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
        
        
        % 因为是handle类，需要copy constructor，以免指针赋值
        [ newobj ] = getCopy(obj);
        
        % 按Index从中取一些出来, 用法类似于 b = a(a>0)
        [ newobj ] = getByIndex(obj, idx);
        
        % 向profile指针（也是Ticks类）里注某一层截面，默认为tkIndex = obj.latest
        % 注意：此函数和getByIndex不同，不生成新obj，只往已有的中注入
        [ ] = fillProfile( obj, profileBars, tkIndex );
        
        % 连接用
        [obj]           = merge(obj,bs2);
        
        % 储存用
        [ data, headers, data2] = toTable( obj, headers );
        [ obj ]                 = fromTable( obj );        
        [ obj ]                 = toExcel(obj, filename, sheetname1, sheetname2); 
    end
    
    %% static方法
    methods (Access = 'public', Static = true, Hidden = false)
%         产生固定长度的空Bars，作用上可看作一种constructor
        [ newbars]      = genEmpty( length);
    end
    
end  
    


