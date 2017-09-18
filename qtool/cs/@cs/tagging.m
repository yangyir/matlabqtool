function tagseries = tagging( Bars, type, para )
%TAGGING            �����зֵ�������Ԫ����tagging2
%   inputs:
    %   Bars            ԭ����bar
    %   para            �ֵ�����
    %   type            �ֵ�����
%   outputs:
    %   tagseries       �ֵ����

%   ver 1.0, luhuaibao, 2013 08 14�� ԭ������bar����ʽ���ݽ���




% time  = Bars.time;
% open  = Bars.open;
close   = Bars.close;
high    = Bars.high;
low     = Bars.low;
volume  = Bars.volume;

% Ϊ��������ڴ�
tagseries = nan( length( close ), 1 );

%
switch type

    case 'mtm'
        % ����
        
        m = para{1,1}; % ������
        kp = para{2,1}; % ��������
        
        vmtm = ind.mtm(close,m);

        % Ԥ�����ȼ�����
        [ tagseries ] = tagging2( vmtm, 1, kp );        
    
    case 'hlc'% �۸����
        price(:,1) = Bars.high;
        price(:,2) = Bars.low;
        price(:,3) = Bars.close;
        
        nperiod = para{1,1};    % 1�����ǵ���
        kp = para{2,1};
        
        [ pricepct(:,1),pricepct(:,2),pricepct(:,3) ]  = price2pct( nperiod,price(:,1),price(:,2),price(:,3) );

        ntag = nan( length( close ), 3 );
        
        for i = 1:3
            ntag(:,i) = tagging2(  pricepct(:,i), 1, kp);
        end;        
        
        tagseries = ntag;
        
    case 'vol2oi' % volume over openInterest

        % qdata�е����ݣ�2010��5��6�գ�openInterest��Ϊ0���������Ϊ���������Բ��
        Bars.time( Bars.openInterest == 0 ) = [];
        Bars.openInterest( Bars.openInterest == 0 ) = [];
        Bars = datafill(Bars,1,8);

        % volume��0����Բ��
        Bars.time( Bars.volume == 0 ) = [];
        Bars.volume( Bars.volume == 0 ) = [];
        Bars = datafill(Bars,1,6);

        vvolume = Bars.volume;
        vopenInterest = Bars.openInterest;
        volume2oi = vvolume./vopenInterest;
        volume2oi = log(volume2oi); % ������

        [ tagseries ] = tagging2( volume2oi, 1, para );        
    
    
  
    
    
    

        
    case 'vol'% ����������
        mavol = ind.ma(volume, 30, 0);
        norvol = volume ./ mavol * 100;
        nc = length( para );
        for i = 1:nc
            if i == 1
                tagseries( norvol < para(i) ) = 1;
            else
                tagseries(norvol >= para(i-1) & norvol < para(i) ) = i;
            end
        end
        tagseries( norvol > para(end) ) = nc+1;
        


    case 'vlt'% �����ʷ���
        wsize = para(1);
        yield = log(close./[NaN;close(1:(end-1))]);
        vlt = nan( length(close), 1 );
        for i = wsize:length(close)
            vlt(i) = std(yield(i-wsize+1:i));
        end
        logvlt = log(vlt);
        meanlogvlt = nanmean( logvlt );
        stdlogvlt = nanstd( logvlt );
        tagseries( logvlt < meanlogvlt-2*stdlogvlt ) = -3;
        tagseries( logvlt >= meanlogvlt-2*stdlogvlt & logvlt < meanlogvlt-stdlogvlt) = -2;
        tagseries( logvlt >= meanlogvlt-stdlogvlt & logvlt < meanlogvlt ) = -1;
        tagseries( logvlt >= meanlogvlt & logvlt < meanlogvlt+stdlogvlt ) = 1;
        tagseries( logvlt >= meanlogvlt+stdlogvlt & logvlt < meanlogvlt+2*stdlogvlt ) = 2;
        tagseries( logvlt >= meanlogvlt+2*stdlogvlt ) = 3;
        
    case 'leadlag'
        lead = para(1);
        lag = para(2);
        [leadVal, lagVal] = ind.leadlag( close, lead, lag );
        tagseries( leadVal > lagVal ) = 1;
        tagseries( leadVal <= lagVal ) = -1;
        
    case 'macd'% macd����ָ�����
        short = para(1);
        long = para(2);
        compare = para(3);
        [ ~, ~, barVal ] = ind.macd( close, long, short, compare);
%         barValmean = mean( barVal );
%         barValstd = std( barVal );
%         nstdup = ceil( (max( barVal )-barValmean )/barValstd );
%         nstddn = ceil( ( barValmean-min( barVal ) )/barValstd );
%         for nstd = -nstddn:1:(nstdup-1)
%             tagseries(  barVal >= barValmean+nstd*barValstd & barVal < barValmean+(nstd+1)*barValstd ) = nstd;
%         end
        tagseries = sign( barVal );
        
     case 'bollinger'% ���ִ�����
         wsize = para(1);
         nstd = para(2);
        [~, uppr, lowr] = ind.bollinger( close, wsize, 0, nstd );
        tagseries( close <= lowr ) = 1; % �´�֮��1��
        tagseries( lowr < close & close < uppr ) = 2; % ���´�֮��2��
        tagseries( close >= uppr ) = 3; % �ϴ�֮��3��
                    
    case 'cci' % cci����
        cci = ind.cci( high, low, close );
        nc = length( para );
        for i = 1:nc
            if i == 1
                tagseries( cci < para(i) ) = 1;
            else
                tagseries(cci >= para(i-1) & cci < para(i) ) = i;
            end
        end
        tagseries( cci > para(end) ) = nc+1;
        
    case 'dmi'% Dmi����
        [~, ~, adx] = ind.dmi(high, low, close);
        nc = length(para);
        for i = 1: nc
            if i == 1
                tagseries( adx < para(i)) = 1;
            else
                tagseries( adx >= para(i-1) & adx < para(i)) = i;
            end
        end
        tagseries( adx > para(end)) = nc+1;
        
    case 'mfi' % Mfi����
        [ mfi, ~, ~ ] = ind.mfi( high, low, close, volume );
        nc = length( para );
        for i = 1:nc
            if i == 1
                tagseries( mfi < para(i) ) = 1;
            else
                tagseries( mfi >= para(i-1) & mfi < para(i) ) = i;
            end
        end
        tagseries( mfi >= para(end) ) = nc+1;
    
    case 'rsi'
        rsival = ind.rsi(close, para(1));
        nc = length(para);
        for i = 2:nc
            if i == 2
                tagseries( rsival < para(i)) = i-1;
            else
                tagseries( rsival > para(i-1) & rsival < para(i)) = i-1;
            end
        end
        tagseries( rsival >= para(end)) = nc + 1;
        
    case 'trix'% trix����ָ�����
        emaday = para(1);
        maday = para(2);
        [trix, trma] = ind.trix( close, emaday, maday );
        tagseries( trix >= trma ) = 1;
        tagseries( trix < trma ) = -1;
        
    case 'willr'% william R����
         nday = para(1);
         wrval = ind.willr( high, low, close, nday );
         cval = para(2:end);
         for i=1:length(cval)
             if i == 1
                 tagseries( wrval < cval(i) ) = i;
             else
                 tagseries( wrval >= cval(i-1) & wrval < cval(i) ) = i;
             end
         end
         tagseries( wrval >= cval(end) ) = i+1;
         
end

end