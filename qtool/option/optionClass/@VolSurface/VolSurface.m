classdef VolSurface < handle
    %VolSurface是一个隐含波动率曲面的类
    %   此处显示详细说明
    %-------------------------------------------
    % 吴云峰，20160226
    % 朱江， integrate with QMS, 20160304
    % cg, 21060311, 修改calc_Sigma()中的错误
    properties( GetAccess = public , SetAccess = public , Hidden  = false )
        % 这里是一些核心的变量
        S@double = 0.0;                      % 50ETF的价格
        currentDate@double  = today;         % 如果收盘后计算应该为today+1，开盘前为today，这个应该要有灵活性
        m2tkCallQuote@M2TK  = M2TK('call');  % Call的实时行情
        m2tkPutQuote@M2TK   = M2TK('put');   % Put的实时行情
        m2tkCallImpvol@M2TK = M2TK('call');  % Call的隐含波动率M2TK
        m2tkPutImpvol@M2TK  = M2TK('put');   % Put的隐含波动率的M2TK
    end

    methods( Access = public , Hidden = false , Static = false )        
        % init_from_sse_excel这是一个最初初始化的函数
        % 开盘前都应该最先进行初始化( 接下来只需要不断更新行情Quote和更新Impvol )
        % 这里面感觉用Static = false比较好，因为m2tkcalllQuote和m2tkputQuote是类内的数据都要赋予进来
        function init_from_sse_excel( self , xlsxPath )  
            
            if ~exist( 'xlsxFile' , 'var' ); xlsxPath = 'OptInfo.xlsx';end;
            % 读取当日的M2TK的行情,这个应该是读取一个就行
            [ ~ ,  self.m2tkCallQuote, self.m2tkPutQuote ] = QuoteOpt.init_from_sse_excel( xlsxPath );
            
            % 将数据首先赋予给m2tkCallImpvol和m2tkPutImpvol里面
            self.m2tkCallImpvol = self.m2tkCallQuote.getCopy();
            self.m2tkPutImpvol  = self.m2tkPutQuote.getCopy();
            
            xProps = self.m2tkCallQuote.xProps;
            yProps = self.m2tkCallQuote.yProps;
            nT = length( yProps );
            nK = length( xProps );
            
            % 数据的初始化，这些数据都最先设置为nan值
            self.m2tkCallImpvol.data = nan( nT , nK );
            self.m2tkPutImpvol.data  = nan( nT , nK );
            
        end
%         regular_timer_ = []; % 定时器，用于定期计算vol surface
%         callQuotes_@M2TK ; % call quote 矩阵
%         putQuotes_@M2TK ; % put quote 矩阵

        
        function init_from_qms(self, qms)
            % init_from_qms 是用QMS的数据来初始化VolSurface 的Quote矩阵。
            self.m2tkCallQuote = qms.callQuotes_;
            self.m2tkPutQuote = qms.putQuotes_;
            
            % reference impVol matrix;
            self.m2tkCallImpvol = self.m2tkCallQuote.getCopy();
            self.m2tkPutImpvol  = self.m2tkPutQuote.getCopy();
            xProps = self.m2tkCallQuote.xProps;
            yProps = self.m2tkCallQuote.yProps;
            nT = length( yProps );
            nK = length( xProps );
            
            % 数据的初始化，这些数据都最先设置为nan值
            self.m2tkCallImpvol.data = nan( nT , nK );
            self.m2tkPutImpvol.data  = nan( nT , nK );
%             % 构造一个属性引用的矩阵
%             prop_ref_mat(nT, nK) = PropertyReference;
%             self.m2tkCallImpvol.data = prop_ref_mat;
%             self.m2tkPutImpvol.data  = prop_ref_mat;
            
%             for k = 1:nK % 列下标
%                 for t = 1:nT % 行下标
%                     call_quote = self.m2tkCallQuote.getByIndex(k, t);
%                     put_quote = self.m2tkPutQuote.getByIndex(k, t);
%                     
%                     if(isempty(self.S_Ref_) && call_quote.is_obj_valid())
%                         self.S_Ref_ = PropertyReference(call_quote, 'S');
%                     end
%                     
%                     % 构造QutoeOpt中属性impvol的引用
%                     call_impl = PropertyReference(call_quote, 'impvol');
%                     put_impl = PropertyReference(put_quote, 'impvol');
%                     
%                     % 此时Call、Put的隐含波动率矩阵不再是一个个的数值，而是数值的引用
%                     % 使用方式并没有改变。
%                     self.m2tkCallImpvol.data(t, k) = call_impl;
%                     self.m2tkPutImpvol.data(t, k) = put_impl;
%                 end
%             end            
        end
        
    end
    
    methods
        
        % 增加一个设置currentDate的函数，因为开盘前计算和收盘之后计算可能会不一样
        % 如果开盘前计算的话为today，收盘的时候最好计算为today+1
        function set.currentDate( self , currentDate )
            % 将CurrentDate进行变动和更新Tau的值
            % 首先依据currentDate进行筛选
            if ischar( currentDate ),currentDate = datenum( currentDate );end;
            
            self.currentDate = currentDate;
            m2tkCallQuote = self.m2tkCallQuote;
            m2tkPutQuote  = self.m2tkPutQuote;
            
            xProps = m2tkCallQuote.xProps;
            yProps = m2tkCallQuote.yProps;
            nT = length( yProps );
            nK = length( xProps );
            
            for t = 1:nT
                for k = 1:nK
                    callOptQuote = m2tkCallQuote.data( t , k );
                    putOptQuote  = m2tkPutQuote.data( t , k );
                    % 最主要更新tau值
                    if ~strcmp( callOptQuote.optName , '无名期权' )
                        callOptQuote.currentDate = currentDate;
                        callOptQuote.calcTau;
                    end
                    if ~strcmp( putOptQuote.optName , '无名期权' )
                        putOptQuote.currentDate = currentDate;
                        putOptQuote.calcTau;
                    end
                end
            end
        end
    end
     
    methods( Access = public , Hidden = false , Static = false )
        
        % 构造函数
        function self = VolSurface( )
        end
        
        % 这个是实时更新的情形( m2tkCallQuote和m2tkPutQuote需要更新 )
        % 现在修改为既可以从Wind也可以从H5里面获取行情
        % 在已经初始化好的情况下进行更新( 在更新之中根据需要来更新currentDate )
        function update_VolSurface( self , quoteMethod ,varargin )  
            % 选择获取行情的methods( quoteMethod )，即wind或者是h5
            % update_VolSurface( 'h' )
            % w = windmatlab;update_VolSurface( 'w' , w )
            
            if ~exist( 'quoteMethod' , 'var'  ),quoteMethod = 'h';end;
            switch quoteMethod
                case{ 'h','H','H5','h5','H5Quote','H5QUOTE'}
                    quoteMethod = 'h';
                case{'w','W','wind','Wind','WIND','windmatlab'}
                    quoteMethod = 'w';
                    % 检查输入的变量
                    if isempty( varargin )
                        w = windmatlab;
                    else
                        w = varargin{ 1 };
                        if ~isobject( w ) || ~isa( w , 'windmatlab' )
                            w = windmatlab;
                        end
                    end
                otherwise
                    warning( '行情获取的方法输入有误,无法获取到行情.............' );
                    return;
            end
            
            xProps = self.m2tkCallQuote.xProps;
            yProps = self.m2tkCallQuote.yProps;
            nT = length( yProps );
            nK = length( xProps );
            
            % 更新currentDate和更新行情
            for t = 1:nT
                for k = 1:nK
                    callOptQuote = self.m2tkCallQuote.data( t , k );
                    putOptQuote  = self.m2tkPutQuote.data( t , k );
                    if ~strcmp( callOptQuote.optName , '无名期权' )
                        switch quoteMethod
                            case 'w'
                                % 基于Wind来更新行情
                                callOptQuote.fillQuoteWind( w ); 
                            case 'h'
                                % 基于H5来更新行情
                                callOptQuote.fillQuoteH5;         
                        end
                        % 计算隐含波动率
                        self.m2tkCallImpvol.data( t , k ) = callOptQuote.calcImpvol;
                        self.S  =  callOptQuote.S;
                        dispString = sprintf( '------call：code = %s 实时更新成功--------' ,callOptQuote.code );
                        disp( dispString )
                    end
                    if ~strcmp( putOptQuote.optName , '无名期权' )
                        switch quoteMethod
                            case 'w'
                                putOptQuote.fillQuoteWind( w ); 
                            case 'h'
                                putOptQuote.fillQuoteH5;
                        end
                        self.m2tkPutImpvol.data( t , k ) = putOptQuote.calcImpvol;
                        self.S  =  putOptQuote.S;
                        dispString = sprintf( '------put：code = %s 实时更新成功--------' ,putOptQuote.code );
                        disp( dispString )
                    end
                end  
            end
            disp( '---------------------M2TK实时更新成功---------------' )
            
        end
        
        function sync_ImpVol(self, pxType)
            if ~exist('pxType', 'var'),  pxType = 'last';   end
            xProps = self.m2tkCallQuote.xProps;
            yProps = self.m2tkCallQuote.yProps;
            nT = length( yProps );
            nK = length( xProps );
            for t=1:nT
                for k=1:nK
                    callOptQuote = self.m2tkCallQuote.data( t , k );
                    putOptQuote  = self.m2tkPutQuote.data( t , k );
                    if callOptQuote.is_obj_valid
                        self.S = callOptQuote.S;
                    end
                    switch pxType
                        case {'ask'}
                            self.m2tkCallImpvol.data(t,k) = callOptQuote.askimpvol;
                            self.m2tkPutImpvol.data(t,k) = putOptQuote.askimpvol;
                        case{'bid'}
                            self.m2tkCallImpvol.data(t,k) = callOptQuote.bidimpvol;
                            self.m2tkPutImpvol.data(t,k) = putOptQuote.bidimpvol;
                            
                        otherwise
                            self.m2tkCallImpvol.data(t,k) = callOptQuote.impvol;
                            self.m2tkPutImpvol.data(t,k) = putOptQuote.impvol;
                    end
                end
            end

        end
        
        % 这个是用于计算的函数
        function [ val ]= calc_Sigma( self , t , s , k ,CP ,calcMethod )
            % 这个t应该为四个到期日T之中选择其一，所以可以为1:4，也可以为具体的char日期或者double格式的日期
            % s,k应该为任意选择的s和k值
            % calcMethod是用于插值的方法
            
            if ~exist( 't','var' ),t   = 1;     end;
            if ~exist( 's','var' ),s   = self.S;end;
            if ~exist( 'k','var' ),k   = self.S;end;
            if ~exist( 'CP','var' ),CP = 'call';end;
            % liner | nearest | cubic | spline
            if ~exist( 'calcMethod','var' ),calcMethod = 'nearest';end;
            
            m2tkCallImpvol = self.m2tkCallImpvol;
            m2tkPutImpvol  = self.m2tkPutImpvol;
            m2tkCallQuote  = self.m2tkCallQuote;
            m2tkPutQuote   = self.m2tkPutQuote;
            xProps         = m2tkCallQuote.xProps;
            yProps         = m2tkCallQuote.yProps;
            sDivideK       = s./xProps; % S/K
            yPropsDouble   = datenum( yProps );
            
            % 针对t的筛选
            if ~ismember( t,1:4 )
                if ischar( t ),t = datenum( t );end; % 将char转换为double
                if isnan( t ),val = nan;return;end;  % 返回
                if ~ismember( t , yPropsDouble );val = nan;return;end; % 如果时间还没有兑上则返回
            else
                t = yPropsDouble( t ); 
            end
            
            [ xPropsMat , yPropsMat ] = meshgrid( sDivideK , yPropsDouble );
            
            switch CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    val = interp2( xPropsMat , yPropsMat , m2tkCallImpvol.data , s./k , t , calcMethod );
                    return;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    val = interp2( xPropsMat , yPropsMat , m2tkPutImpvol.data , s./k , t , calcMethod );
                    return;
            end
            val = nan;
            
        end
        
        % 保存到Excel里面
        function toExcel( self , filename )
            
            className = class( self );
            if ~exist('filename', 'var')
                filename = [ 'my_' className '.xlsx'];
            else
                po = strfind(filename, '.xls');
                if isempty(po)
                    % 添加扩展名
                    filename = [filename '.xlsx'];
                else
                    po = po(end);
                    ext = filename(po:end);
                    if ~strcmp(ext, '.xls') ||  ~strcmp(ext, '.xlsx') ...
                            || ~strcmp(ext, '.xlsm') || ~strcmp(ext, '.xlsb')
                        % 改变扩展名
                        filename = [filename(1:po-1) '.xlsx'];
                    end
                end
            end
            
            % 输出结果
            callImpvol = self.m2tkCallImpvol.data;
            putImpvol  = self.m2tkPutImpvol.data;
            [ nT , nK ] = size( callImpvol );
            if nT == 0 || nK == 0;return;end;
            
            impvolTable = cell( 2*( 3+nT ) , nK+1 ); % 这个是将要输出的Excel
            S      = self.S;
            xProps = self.m2tkCallImpvol.xProps;
            yProps = self.m2tkCallImpvol.yProps;
            sDivideK = S./xProps;
            yProps = yProps( : );
            str_xProps = cell( 1 , nK );
            for j = 1:nK
                str_xProps{ j } = sprintf( '%.3f\n(K=%.2f)', sDivideK(j) , xProps(j) );
            end
            
            % 添加数据
            impvolTable{ 1 , 1 } = 'CALL Impvol';  
            impvolTable{ 1 , 2 } = 'S/K(K)';
            impvolTable{ nT+3 , 1 } = 'PUT Impvol';
            impvolTable{ nT+3 , 2 } = 'S/K(K)';
            impvolTable( 2 , 2:end )    = str_xProps;
            impvolTable( nT+4 , 2:end ) = str_xProps;
            impvolTable( 3:nT+2 , 1 )   = yProps;
            impvolTable{  2 , 1 }       = 'T';
            impvolTable( nT+5:end-2,1 ) = yProps;
            impvolTable{  nT+4 , 1 }    = 'T';
            impvolTable( 3:nT+2 , 2:end )     = num2cell( callImpvol );
            impvolTable( nT+5:end-2 , 2:end ) = num2cell( putImpvol );
            impvolTable{ end-1 , 1 }          = sprintf( 'S=%.3f', S );
            impvolTable{ end , 1 }            = sprintf( 'currentDate=%s',datestr( self.currentDate , 'yyyy-mm-dd' ) );  
            
            xlswrite( filename , impvolTable , 'VolSurface' );
            
        end
        
        % 做出波动率的曲面图
        function plot( self )
            % 获取数据
            m2tkCallImpvol = self.m2tkCallImpvol;
            m2tkPutImpvol  = self.m2tkPutImpvol;
            S              = self.S;
            yProps   = m2tkCallImpvol.yProps;
            xProps   = m2tkCallImpvol.xProps;

            xPropsSK = S./xProps ; % 转换为S/K(这个转换非常重要)
            nT = length( yProps );
            nK = length( xPropsSK );
            if nT == 0 || nK == 0;return;end;
            
            % 画图
            rgbk = 'rgbk';
            scrsz = get(0,'ScreenSize');
            h_Figure_Position = [scrsz(3)*0.05 scrsz(4)*0.1 scrsz(3)*1.05 scrsz(4)*0.95]*0.9;
            h_Figure = figure;
            set( h_Figure ,'Position',h_Figure_Position,'Name','Impvol Surface',...
                'NumberTitle','off','Menubar','none','Resize','off' ) 
            movegui( h_Figure , 'center' )
            h_axes1 = axes( 'Parent',h_Figure , 'Units' , 'normalized', 'Position' , [ 0.05 0.050 0.925 0.415 ] , 'FontWeight','bold' );
            h_axes2 = axes( 'Parent',h_Figure , 'Units' , 'normalized', 'Position' , [ 0.05 0.555 0.925 0.415 ] , 'FontWeight','bold' );
            
            % Call的Impvol的图
            axes( h_axes2 ),hold on;
            call_impvol =  m2tkCallImpvol.data;
            nan_nums = numnan(call_impvol);
            valid_nums = nnz(call_impvol);
            str = sprintf('call impvol matrix: nan nodes num: %d, valid node num: %d \n', nan_nums, valid_nums);
            disp(str);
            
            for i = 1:nT
                plot( xPropsSK , call_impvol(i, :) , [rgbk(i),'*-'] , 'LineWidth',2 );
            end;
            legend( yProps ,'Location','Best' );
            sort_xProps = sort( xPropsSK );
            set( h_axes2 , 'xTick', sort_xProps )
            str_xProps = cell( 1 , nK );
            for j = 1:nK
                str_xProps{ j } = sprintf( '%.2f', sort_xProps(j) );
            end
            set( h_axes2 , 'xTickLabel', str_xProps )
            ylabel( 'Impvol','FontName','Times','FontWeight','bold' )
            xlabel( 'S/K','FontName','Times','FontWeight','bold' )  
            title( 'Call Impvol','FontName','Times','FontWeight','bold' )
            grid on
            
            % Put的Impvol的图
            axes( h_axes1 ),hold on;
            put_impvol = m2tkPutImpvol.data;
            nan_nums = numnan(put_impvol);
            valid_nums = nnz(put_impvol);
            str = sprintf('put matrix : nan nodes num: %d, valid node num: %d \n', nan_nums, valid_nums);
            disp(str);
            
            for i = 1:nT
                plot( xPropsSK , put_impvol( i,: ), [rgbk(i),'*-'] , 'LineWidth',2 );
            end;
            legend( yProps ,'Location','Best' );
            set( h_axes1 , 'xTick', sort_xProps )
            set( h_axes1 , 'xTickLabel', str_xProps )
            ylabel( 'Impvol','FontName','Times','FontWeight','bold' )
            xlabel( 'S/K','FontName','Times','FontWeight','bold' )  
            title( 'Put Impvol','FontName','Times','FontWeight','bold' )
            grid on
            
        end
        
    end
    
    methods( Access = public , Hidden = false , Static = true )
    
        % 一个Demo的例子
        function [] = demo( )
            vs = VolSurface;
            % 首先得进行初始化
            vs.init_from_sse_excel;
            % 更新当前的日期
            vs.currentDate = today + 1;
            % 更新当前的行情
            % w = windmatlab;
            % vs.update_VolSurface( 'w'  ,w );
            vs.update_VolSurface( 'h' );
            % 如果是基于H5Quote来获取行情就是
            % vs.update_VolSurface( 'h' );
            % 作图
            vs.plot;
            % 输出
            s = 1.95;
            k = 2.0;
            t = 1; % 第一个时期
            vs.calc_Sigma(t,s,k,'call')
            vs.calc_Sigma(t,s,k,'put')
            % 输出到Excel里面
            vs.toExcel;
            save( 'vs.mat' , 'vs' )
        end
        
        function [] = demo2()
            load vs
            % 作图
            vs.plot;
            s = 1.95;
            k = 2.0;
            t = 1:4; % 四个时期
            vs.calc_Sigma(t,s,k,'call')
            vs.calc_Sigma(t,s,k,'put')
        end
        
        [] = test_with_qms();
    end    
    
end