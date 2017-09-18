classdef VolSurface < handle
    %VolSurface��һ�������������������
    %   �˴���ʾ��ϸ˵��
    %-------------------------------------------
    % ���Ʒ壬20160226
    % �콭�� integrate with QMS, 20160304
    % cg, 21060311, �޸�calc_Sigma()�еĴ���
    properties( GetAccess = public , SetAccess = public , Hidden  = false )
        % ������һЩ���ĵı���
        S@double = 0.0;                      % 50ETF�ļ۸�
        currentDate@double  = today;         % ������̺����Ӧ��Ϊtoday+1������ǰΪtoday�����Ӧ��Ҫ�������
        m2tkCallQuote@M2TK  = M2TK('call');  % Call��ʵʱ����
        m2tkPutQuote@M2TK   = M2TK('put');   % Put��ʵʱ����
        m2tkCallImpvol@M2TK = M2TK('call');  % Call������������M2TK
        m2tkPutImpvol@M2TK  = M2TK('put');   % Put�����������ʵ�M2TK
    end

    methods( Access = public , Hidden = false , Static = false )        
        % init_from_sse_excel����һ�������ʼ���ĺ���
        % ����ǰ��Ӧ�����Ƚ��г�ʼ��( ������ֻ��Ҫ���ϸ�������Quote�͸���Impvol )
        % ������о���Static = false�ȽϺã���Ϊm2tkcalllQuote��m2tkputQuote�����ڵ����ݶ�Ҫ�������
        function init_from_sse_excel( self , xlsxPath )  
            
            if ~exist( 'xlsxFile' , 'var' ); xlsxPath = 'OptInfo.xlsx';end;
            % ��ȡ���յ�M2TK������,���Ӧ���Ƕ�ȡһ������
            [ ~ ,  self.m2tkCallQuote, self.m2tkPutQuote ] = QuoteOpt.init_from_sse_excel( xlsxPath );
            
            % ���������ȸ����m2tkCallImpvol��m2tkPutImpvol����
            self.m2tkCallImpvol = self.m2tkCallQuote.getCopy();
            self.m2tkPutImpvol  = self.m2tkPutQuote.getCopy();
            
            xProps = self.m2tkCallQuote.xProps;
            yProps = self.m2tkCallQuote.yProps;
            nT = length( yProps );
            nK = length( xProps );
            
            % ���ݵĳ�ʼ������Щ���ݶ���������Ϊnanֵ
            self.m2tkCallImpvol.data = nan( nT , nK );
            self.m2tkPutImpvol.data  = nan( nT , nK );
            
        end
%         regular_timer_ = []; % ��ʱ�������ڶ��ڼ���vol surface
%         callQuotes_@M2TK ; % call quote ����
%         putQuotes_@M2TK ; % put quote ����

        
        function init_from_qms(self, qms)
            % init_from_qms ����QMS����������ʼ��VolSurface ��Quote����
            self.m2tkCallQuote = qms.callQuotes_;
            self.m2tkPutQuote = qms.putQuotes_;
            
            % reference impVol matrix;
            self.m2tkCallImpvol = self.m2tkCallQuote.getCopy();
            self.m2tkPutImpvol  = self.m2tkPutQuote.getCopy();
            xProps = self.m2tkCallQuote.xProps;
            yProps = self.m2tkCallQuote.yProps;
            nT = length( yProps );
            nK = length( xProps );
            
            % ���ݵĳ�ʼ������Щ���ݶ���������Ϊnanֵ
            self.m2tkCallImpvol.data = nan( nT , nK );
            self.m2tkPutImpvol.data  = nan( nT , nK );
%             % ����һ���������õľ���
%             prop_ref_mat(nT, nK) = PropertyReference;
%             self.m2tkCallImpvol.data = prop_ref_mat;
%             self.m2tkPutImpvol.data  = prop_ref_mat;
            
%             for k = 1:nK % ���±�
%                 for t = 1:nT % ���±�
%                     call_quote = self.m2tkCallQuote.getByIndex(k, t);
%                     put_quote = self.m2tkPutQuote.getByIndex(k, t);
%                     
%                     if(isempty(self.S_Ref_) && call_quote.is_obj_valid())
%                         self.S_Ref_ = PropertyReference(call_quote, 'S');
%                     end
%                     
%                     % ����QutoeOpt������impvol������
%                     call_impl = PropertyReference(call_quote, 'impvol');
%                     put_impl = PropertyReference(put_quote, 'impvol');
%                     
%                     % ��ʱCall��Put�����������ʾ�������һ��������ֵ��������ֵ������
%                     % ʹ�÷�ʽ��û�иı䡣
%                     self.m2tkCallImpvol.data(t, k) = call_impl;
%                     self.m2tkPutImpvol.data(t, k) = put_impl;
%                 end
%             end            
        end
        
    end
    
    methods
        
        % ����һ������currentDate�ĺ�������Ϊ����ǰ���������֮�������ܻ᲻һ��
        % �������ǰ����Ļ�Ϊtoday�����̵�ʱ����ü���Ϊtoday+1
        function set.currentDate( self , currentDate )
            % ��CurrentDate���б䶯�͸���Tau��ֵ
            % ��������currentDate����ɸѡ
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
                    % ����Ҫ����tauֵ
                    if ~strcmp( callOptQuote.optName , '������Ȩ' )
                        callOptQuote.currentDate = currentDate;
                        callOptQuote.calcTau;
                    end
                    if ~strcmp( putOptQuote.optName , '������Ȩ' )
                        putOptQuote.currentDate = currentDate;
                        putOptQuote.calcTau;
                    end
                end
            end
        end
    end
     
    methods( Access = public , Hidden = false , Static = false )
        
        % ���캯��
        function self = VolSurface( )
        end
        
        % �����ʵʱ���µ�����( m2tkCallQuote��m2tkPutQuote��Ҫ���� )
        % �����޸�Ϊ�ȿ��Դ�WindҲ���Դ�H5�����ȡ����
        % ���Ѿ���ʼ���õ�����½��и���( �ڸ���֮�и�����Ҫ������currentDate )
        function update_VolSurface( self , quoteMethod ,varargin )  
            % ѡ���ȡ�����methods( quoteMethod )����wind������h5
            % update_VolSurface( 'h' )
            % w = windmatlab;update_VolSurface( 'w' , w )
            
            if ~exist( 'quoteMethod' , 'var'  ),quoteMethod = 'h';end;
            switch quoteMethod
                case{ 'h','H','H5','h5','H5Quote','H5QUOTE'}
                    quoteMethod = 'h';
                case{'w','W','wind','Wind','WIND','windmatlab'}
                    quoteMethod = 'w';
                    % �������ı���
                    if isempty( varargin )
                        w = windmatlab;
                    else
                        w = varargin{ 1 };
                        if ~isobject( w ) || ~isa( w , 'windmatlab' )
                            w = windmatlab;
                        end
                    end
                otherwise
                    warning( '�����ȡ�ķ�����������,�޷���ȡ������.............' );
                    return;
            end
            
            xProps = self.m2tkCallQuote.xProps;
            yProps = self.m2tkCallQuote.yProps;
            nT = length( yProps );
            nK = length( xProps );
            
            % ����currentDate�͸�������
            for t = 1:nT
                for k = 1:nK
                    callOptQuote = self.m2tkCallQuote.data( t , k );
                    putOptQuote  = self.m2tkPutQuote.data( t , k );
                    if ~strcmp( callOptQuote.optName , '������Ȩ' )
                        switch quoteMethod
                            case 'w'
                                % ����Wind����������
                                callOptQuote.fillQuoteWind( w ); 
                            case 'h'
                                % ����H5����������
                                callOptQuote.fillQuoteH5;         
                        end
                        % ��������������
                        self.m2tkCallImpvol.data( t , k ) = callOptQuote.calcImpvol;
                        self.S  =  callOptQuote.S;
                        dispString = sprintf( '------call��code = %s ʵʱ���³ɹ�--------' ,callOptQuote.code );
                        disp( dispString )
                    end
                    if ~strcmp( putOptQuote.optName , '������Ȩ' )
                        switch quoteMethod
                            case 'w'
                                putOptQuote.fillQuoteWind( w ); 
                            case 'h'
                                putOptQuote.fillQuoteH5;
                        end
                        self.m2tkPutImpvol.data( t , k ) = putOptQuote.calcImpvol;
                        self.S  =  putOptQuote.S;
                        dispString = sprintf( '------put��code = %s ʵʱ���³ɹ�--------' ,putOptQuote.code );
                        disp( dispString )
                    end
                end  
            end
            disp( '---------------------M2TKʵʱ���³ɹ�---------------' )
            
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
        
        % ��������ڼ���ĺ���
        function [ val ]= calc_Sigma( self , t , s , k ,CP ,calcMethod )
            % ���tӦ��Ϊ�ĸ�������T֮��ѡ����һ�����Կ���Ϊ1:4��Ҳ����Ϊ�����char���ڻ���double��ʽ������
            % s,kӦ��Ϊ����ѡ���s��kֵ
            % calcMethod�����ڲ�ֵ�ķ���
            
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
            
            % ���t��ɸѡ
            if ~ismember( t,1:4 )
                if ischar( t ),t = datenum( t );end; % ��charת��Ϊdouble
                if isnan( t ),val = nan;return;end;  % ����
                if ~ismember( t , yPropsDouble );val = nan;return;end; % ���ʱ�仹û�ж����򷵻�
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
        
        % ���浽Excel����
        function toExcel( self , filename )
            
            className = class( self );
            if ~exist('filename', 'var')
                filename = [ 'my_' className '.xlsx'];
            else
                po = strfind(filename, '.xls');
                if isempty(po)
                    % �����չ��
                    filename = [filename '.xlsx'];
                else
                    po = po(end);
                    ext = filename(po:end);
                    if ~strcmp(ext, '.xls') ||  ~strcmp(ext, '.xlsx') ...
                            || ~strcmp(ext, '.xlsm') || ~strcmp(ext, '.xlsb')
                        % �ı���չ��
                        filename = [filename(1:po-1) '.xlsx'];
                    end
                end
            end
            
            % ������
            callImpvol = self.m2tkCallImpvol.data;
            putImpvol  = self.m2tkPutImpvol.data;
            [ nT , nK ] = size( callImpvol );
            if nT == 0 || nK == 0;return;end;
            
            impvolTable = cell( 2*( 3+nT ) , nK+1 ); % ����ǽ�Ҫ�����Excel
            S      = self.S;
            xProps = self.m2tkCallImpvol.xProps;
            yProps = self.m2tkCallImpvol.yProps;
            sDivideK = S./xProps;
            yProps = yProps( : );
            str_xProps = cell( 1 , nK );
            for j = 1:nK
                str_xProps{ j } = sprintf( '%.3f\n(K=%.2f)', sDivideK(j) , xProps(j) );
            end
            
            % �������
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
        
        % ���������ʵ�����ͼ
        function plot( self )
            % ��ȡ����
            m2tkCallImpvol = self.m2tkCallImpvol;
            m2tkPutImpvol  = self.m2tkPutImpvol;
            S              = self.S;
            yProps   = m2tkCallImpvol.yProps;
            xProps   = m2tkCallImpvol.xProps;

            xPropsSK = S./xProps ; % ת��ΪS/K(���ת���ǳ���Ҫ)
            nT = length( yProps );
            nK = length( xPropsSK );
            if nT == 0 || nK == 0;return;end;
            
            % ��ͼ
            rgbk = 'rgbk';
            scrsz = get(0,'ScreenSize');
            h_Figure_Position = [scrsz(3)*0.05 scrsz(4)*0.1 scrsz(3)*1.05 scrsz(4)*0.95]*0.9;
            h_Figure = figure;
            set( h_Figure ,'Position',h_Figure_Position,'Name','Impvol Surface',...
                'NumberTitle','off','Menubar','none','Resize','off' ) 
            movegui( h_Figure , 'center' )
            h_axes1 = axes( 'Parent',h_Figure , 'Units' , 'normalized', 'Position' , [ 0.05 0.050 0.925 0.415 ] , 'FontWeight','bold' );
            h_axes2 = axes( 'Parent',h_Figure , 'Units' , 'normalized', 'Position' , [ 0.05 0.555 0.925 0.415 ] , 'FontWeight','bold' );
            
            % Call��Impvol��ͼ
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
            
            % Put��Impvol��ͼ
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
    
        % һ��Demo������
        function [] = demo( )
            vs = VolSurface;
            % ���ȵý��г�ʼ��
            vs.init_from_sse_excel;
            % ���µ�ǰ������
            vs.currentDate = today + 1;
            % ���µ�ǰ������
            % w = windmatlab;
            % vs.update_VolSurface( 'w'  ,w );
            vs.update_VolSurface( 'h' );
            % ����ǻ���H5Quote����ȡ�������
            % vs.update_VolSurface( 'h' );
            % ��ͼ
            vs.plot;
            % ���
            s = 1.95;
            k = 2.0;
            t = 1; % ��һ��ʱ��
            vs.calc_Sigma(t,s,k,'call')
            vs.calc_Sigma(t,s,k,'put')
            % �����Excel����
            vs.toExcel;
            save( 'vs.mat' , 'vs' )
        end
        
        function [] = demo2()
            load vs
            % ��ͼ
            vs.plot;
            s = 1.95;
            k = 2.0;
            t = 1:4; % �ĸ�ʱ��
            vs.calc_Sigma(t,s,k,'call')
            vs.calc_Sigma(t,s,k,'put')
        end
        
        [] = test_with_qms();
    end    
    
end