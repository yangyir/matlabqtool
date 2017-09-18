%% ���ݴ���
clc
clear
close all




%%
% if matlabpool('size')<=0 %�жϲ��м��㻷���Ƿ���Ȼ����
%   matlabpool('open','local',4); %����δ���������������л���
% end


%% ���ع�̬����
 


load('dataIF.mat');



%% ����Ŀ����
 

% ����Ŀ������Ǳ�����桪Ǳ�ڿ�����ΪĿ������proIF��losIF��ʼ��ʱ��nan���Ȱ�nanת��Ϊ0��Ȼ���������
load('potenPL.mat');
proIF(isnan(proIF)) = 0;
losIF(isnan(losIF)) = 0;
proIF = proIF + losIF;


%% ԭ����Ԥ����
flag = 2 ;


%% ���㶯��-=-------------------------------------------
switch flag
    case 1
        vclose = dataIF.close;
        
        % ����
        vmtm = ind.mtm(vclose,15);
        
        % ���໮�ֱ���
        kp = -2:0.5:2;
        
        % Ԥ�����ȼ�����
        [ cmtm15 ] = cs.tagging2( vmtm, 1, kp );
        
        
        % ����
        vmtm = ind.mtm(vclose,5);
        
        % ���໮�ֱ���
        kp = -2:0.5:2;
        
        % Ԥ�����ȼ�����
        [ cmtm5 ] = cs.tagging2( vmtm, 1, kp );
        
        % ����
        vmtm = ind.mtm(vclose,10);
        
        % ���໮�ֱ���
        kp = -2:0.5:2;
        
        % Ԥ�����ȼ�����
        [ cmtm10 ] = tagging2( vmtm, 1, kp );
        % �������----------------------------------------------------------------
        
        [vtime,ia,ib] = intersect(dataIF.time,dataHS300.time);
        
        bd = dataIF.close(ia) - dataHS300.close(ib);
        
        kp = -2:0.5:2;
        
        [ cbd ] = tagging2( bd, 1, kp );
        
        data = [vtime proIF(ia) cmtm5(ia) cmtm10(ia) cmtm15(ia) cbd];
        
    case 2
        % ���� + volume/openInterest
        % 5���Ӷ���
        m = 5;
        kp = -2:0.5:2;
        para{1,1} = m;
        para{2,1} = kp;
        cmtm5 = cs.tagging(dataIF,'mtm',para);
        
        % 15���Ӷ���
        m = 15;
        kp = -2:0.5:2;
        para{1,1} = m;
        para{2,1} = kp;
        cmtm15 = cs.tagging(dataIF,'mtm',para);
        
        % volume/openInterest
        para = -2:0.5:2;
        cvolume2oi = cs.tagging( dataIF, 'vol2oi', para );
        
        
        
        vtime = dataIF.time;
        data = [vtime , proIF, cmtm5, cmtm15, cvolume2oi];
        
        
        %% ----------------------�Թ�ȥ10��bar�е�����ͳ��
    case 3
        vclose  = dataIF.close;
        vopen = dataIF.open;
        
        yinYang = vclose > vopen;
        
        [ cyinYang ] = tagging2( yinYang, 2, 0 );
        
        vtime = dataIF.time;
        
        data = [vtime proIF cyinYang ];
        
        
        
        %% -----------------------��̬����ʶ��-----------------
        
    case 4
        % �۸���̬
        
        nk = 5;
        nperiod = 15;
        vclose = dataIF.close;
        vclosepct = price2pct(nperiod,vclose);
        vclosepctNK = priceNK(vclosepct,nk,1,2);
        
        % ˮƽ��ת����ʱ����������
        vclosepctNK = fliplr(vclosepctNK);
        
        
        kp = -2:0.5:2;
        
        ntag = nan(length(vclose),1);
        for i = 1:nk
            ntag(:,i) = tagging2(vclosepctNK(:,i),1,kp);
        end;
        
        %         % ��volume/openInterest����
        %         para = -2:1:2;
        %         cvolume2oi = tagging( dataIF, 'vol2oi', para );
        %
        %
        vtime = dataIF.time;
        
        data = [vtime , proIF, ntag ];
        
        
        
    case 5
        %% ��������-----------------------------------------------------------
        
        
        % ��high��low��close����
        kp = -2:0.5:2;
        m = 5;
        para{1,1} = m;
        para{2,1} = kp;
        
        ntag = tagging( dataIF, 'hlc', para );
        
        % william R
        ind        = 'willr';
        para      = [14,-90:10:-10];% nday
        cwr = tagging(dataIF,ind,para);
        
        
        
        
        % ��volume/openInterest����
        para = -2:1:2;
        cvolume2oi = tagging( dataIF, 'vol2oi', para );
        
        % ��dif����
        
        ind   = 'leadlag';
        para  = [12 26];
        cdif = tagging( dataIF, ind, para);
        
        %  mfi
        ind        = 'mfi';
        para       = 10:10:90;
        cmfi = tagging(dataIF,ind,para);
        
        % macd
        ind        = 'macd';
        para       = [12 26 9];
        cmacd = tagging(dataIF,ind,para);
        
        vtime = dataIF.time;
        data = [vtime , proIF, ntag, cvolume2oi   ];
        
        
        
        
    case 6
        %% willr��Ϊ״̬����ͳ��--------------------------------------------------
        
        vhigh = dataIF.high;
        vlow = dataIF.low;
        vclose = dataIF.close;
        
        nday = 14;
        wrval = ind.willr( vhigh, vlow, vclose, nday );
        
        wrlgc = wrval < -80;
        
        [ cwrlgc ] = tagging2( wrlgc, 2, 0 );
        
        vtime = dataIF.time;
        
        data = [vtime proIF cwrlgc ];
    case 7
        %%  ˫��ʱ��ṹ����ϵͳ��ͳ��
        % ����׼��
        vclose = dataIF.close;
        t_L = 20;
        t_S = 20;
        L = 5; % ��ʱ������Ϊ5����
        mtm_L = ind.mtm(vclose,L*t_L);
        mtm_S = ind.mtm(vclose,t_S);
        
        t_rsi = 14;
        rsi_L = ind.rsi(vclose, L*t_rsi);
        
        
        % �߼�����
        condl1 = mtm_L > 0 & rsi_L > 50;
        condl2 = crossOver(mtm_S,zeros(length(mtm_S),1),1);
        condl3 = price2pct(-1,dataIF.high) > 0; % �¸�K�ߵ�highҪͻ��
        %         condl4 = wrval > -50;
        cond_L = condl1 & condl2 & condl3;
        
        conds1 = mtm_S < 0 & rsi_L < 50;
        conds2 = crossUnder(mtm_S,zeros(length(mtm_S),1),1);
        conds3 = price2pct(-1,dataIF.low) < 0; % �¸�K�ߵ�highҪͻ��
        %         conds4 = wrval < -80;
        cond_S = conds1 & conds2 & conds3;
        
        vtime = dataIF.time;
        
        data = [vtime proIF cond_L ];
        
    case 8
        %% highlow -------------------------------------------------
        vclose = dataIF.close;
        
        para = [30, 2];
        %         bollhighlow(dataIF, 30, 2);
        
        [ highlow, lastsure ] = highlowpoint( dataIF, 'boll',para );
        %
        %         flaglastsure = nan(length(highlow),1);
        %
        %         phigh = nan(length(highlow),1);
        %         plow = nan(length(highlow),1);
        %
        %         flaglastsure(~isnan(lastsure)) = highlow( lastsure(~isnan(lastsure)) );
        %
        %         phigh(~isnan(flaglastsure) & flaglastsure == 1) = vclose( ~isnan(lastsure) & flaglastsure == 1);
        %
        %         phigh(~isnan(flaglastsure) & flaglastsure == -1) = vclose( find(lastsure>lastsure(),1,'last') );
        [var0,ia,ic] = unique(lastsure,'first');
        
        ia ( isnan(var0) ) = [];
        var0 ( isnan(var0) ) = [];
        
        np = 4;
        
        var1 = highlow(var0);
        uclose = vclose(var0);
        
        %         var2 = priceNK(var0,np,1,2);
        var3 = priceNK(var1,np,1,2);
        pclose = priceNK(uclose,np,1,2);
        
        %         var2 = fliplr(var2);
        var3 = fliplr(var3);
        pclose = fliplr(pclose);
        
        pclose(:,5) = vclose(ia);
        
        %         var2(1:np-1,:) = [];
        var3(1:np-1,:) = [];
        pclose(1:np-1,:) = [];
        
        tag1 = nan(length(pclose),1);
        
        %         for i = 1:length(pclose)
        %             if ( ( pclose(i,1)<pclose(i,3) ) & (pclose(i,2)<pclose(i,4)) )
        %                 tag1(i) = 1;
        %             elseif ( ( pclose(i,1)>pclose(i,3) ) & (pclose(i,2)>pclose(i,4)) )
        %                 tag1(i) = 2;
        %             else tag1(i) = 3;
        %             end;
        %         end;
        for i = 1:length(pclose)
            if ( ( pclose(i,1)<pclose(i,3) ) & (pclose(i,2)<pclose(i,4)) )
                tag1(i) = 1;
                %             elseif ( ( pclose(i,4)>pclose(i,2) ) & (pclose(i,4)>pclose(i,6)) )
                %                 tag1(i) = 2;
            else tag1(i) = 2;
            end;
        end;
        
        
        pct = ( pclose(:,4) - pclose(:,5) )./( pclose(:,4) - pclose(:,3) )*100;
        
        
        flag = 3;
        kp = [20 50 80];
        [ tag2 ] = tagging2( pct, flag , kp);
        
        tag3 = pclose(:,5) > pclose(:,2);
        
        % ����Ŀ����
        proIF = proIF(ia);
        proIF(1:np-1,:) = [];
        vtime = dataIF.time(ia);
        vtime(1:np-1,:) = [];
        
        data = [vtime, proIF, var3, tag1, tag3];
        
        
        
        
        
    case 9
        %% ����
        vclose = dataIF.close;
        nday = length(vclose)/270;
        vclose = reshape( vclose,270,nday );
        
        vmax = max(vclose);
        vmin = min(vclose);
        vvol = (vmax - vmin)./vclose(1,:);
        vvol = vvol';
        
        len = 5;
        
        volavg = ind.ma(vvol,len,0);
        volavg(1:len,1) = nanmean(volavg);
        
        
        var5 = [];
        for i = 1:nday
            var4 = [];
            dayclose = vclose(:,i);
            mtm = ind.mtm(dayclose,15);
            evol = dayclose(1)*volavg(i)/3;
            var0 = 1:270;
            wavecome = mtm > evol;
            
            var1 = var0(mtm > evol);
            
            drawdown = mtm.*0.382;
            
            
            
            if ~isempty(var1)
                n = length(var1);
                for j = 1:n
                    jp = var1(j);
                    
                    if jp<240
                        
                        %                         [mclose,idx] = max( dayclose(jp:jp+15) );
                        mclose = dayclose(jp);
                        
                        var2 = dayclose(jp+1:end);
                        
                        var3 = find(var2 < mclose - drawdown(jp),1,'first');
                        
                        if ~isempty(var3)
                            var4 = [var4; jp + var3];
                        end;
                        
                    end;
                    
                end;
            end;
            var5 = [var5; var4 + (i-1)*270];
            
            
        end;
        var5 = unique(var5);
        vtime = dataIF.time(var5);
        proIF = proIF(var5);
        tag = ones(length(var5),1);
        
        data = [vtime,proIF,tag];
        
    case 10
        nday = size(dataIF.time,1)/270;
        vclose = dataIF.close;
        vhigh = dataIF.high;
        vlow = dataIF.low;
        price = (vclose+vhigh+vlow)/3;
        ma4 = ind.ma(price,5,0);
        ma9 = ind.ma(price,9,0);
        ma18 = ind.ma(price,18,0);
        ma50 = ind.ma(price,50,0);
        mtm9 = ind.mtm(ma9, 14) ;
        mtm5 = ind.mtm(price,5);
        mtm10 = ind.mtm(price,10);
        mtm15 = ind.mtm(price,15);
        mtm20 = ind.mtm(price,20);
        mtm25 = ind.mtm(price,25);
        mtm30 = ind.mtm(price,30);
        %         tag1 = price > ma9 & ma9 > ma18 & ma18 > ma50  ;
        %         tag2 = crossOver( price ,ma4, 1) & ma4 > ma9 ;
        %         tag3 = price < ma9 & ma9 < ma18 & ma18 < ma50  ;
        %         tag4 = crossUnder( price ,ma4, 1) & ma4 < ma9 ;
        
        tag1 =   ma9 > ma18 & ma18 > ma50  ;
        tag2 = crossOver( price ,ma4, 1) & ma4 > ma9 ;
        tag3 =   ma9 < ma18 & ma18 < ma50  ;
        tag4 = crossUnder( price ,ma4, 1) & ma4 < ma9 ;
        
        vhigh(isnan(vhigh),:) = 0;
        vlow(isnan(vlow),:) = 0;
        volatility = nan(nday,1);
        for i  = 1:nday
            hightoday = vhigh( (i-1)*270+1:i*270 ,1);
            lowtoday = vlow( (i-1)*270+1:i*270 ,1);
            volatility(i,1) = max(hightoday) - min(lowtoday);
        end;
        volavg = ( volatility + [0 ; volatility(1:end-1,1) ] )/2;
        volavg = [0; volavg(1:end-1,1)];
        volavg = repmat(volavg,1,270);
        volavg = volavg';
        volavg = volavg(:);
        volavg = volavg/4;
        tag5 = mtm5 > volavg | mtm10 > volavg | mtm15 > volavg | mtm20 > volavg | mtm25 > volavg | mtm30 > volavg;
        tag6 = mtm5 < volavg | mtm10 < volavg | mtm15 < volavg | mtm20 < volavg | mtm25 < volavg | mtm30 < volavg;
        %         tag5 =   mtm10 > volavg   | mtm20 > volavg |   mtm30 > volavg;
        %         tag6 =   mtm10 < volavg   | mtm20 < volavg |   mtm30 < volavg;
        condl = tag2 & tag3   ;
        conds = tag1 & tag4   ;
        
        tag = zeros ( size(dataIF.time,1) ,1 );
        tag ( condl ) = 1;
        tag ( conds ) = -1;
        
        vtime = dataIF.time;
        data = [vtime,proIF,tag];
        
    case 11 % �ų������������
        vclose = dataIF.close;
        nday = length(vclose)/270;
        vclose = reshape( vclose,270,nday );
        
        vmax = max(vclose);
        vmin = min(vclose);
        vmax = vmax';
        vmin = vmin';
        
        v5dmax = priceNK(vmax,5,1,2);
        v5dmin = priceNK(vmin,5,1,2);
        
        % ȡ5�켫ֵ����������
        [v5dmax,idmax] = max(v5dmax,[],2);
        [v5dmin,idmin] = min(v5dmin,[],2);
        % ����һ�죬��ǰ5�켫ֵ��
        v5dmax = [0; v5dmax(1:end-1,1)];
        v5dmin = [0; v5dmin(1:end-1,1)];
        idmax =  [0; idmax(1:end-1,1)];
        idmin =  [0; idmin(1:end-1,1)];     
        
        w1 = 0.382 ; 
        w2 = 0.618 ;
        
        vh = v5dmax ;  % ���
        vl = v5dmin ;  % ���
        dhl = v5dmax - v5dmin ;  % �ߵͲ�
        vm = vh - dhl * 0.5 ;    % �ߵ��е�
        
        Gu = vh - dhl * w1 ;     % �����ߵ�Ļƽ�ָ��
        Gd = vh - dhl * w2 ;     % �����͵�Ļƽ�ָ��
        
        DLd = Gd - (Gd - vl).* w2 ; % �ͻƽ�ָ����͵�֮�俿�µĻƽ�ָ��
        DLu = Gd - (Gd - vl).* w1 ; % �ͻƽ�ָ����͵�֮�俿�ϵĻƽ�ָ��   
        
        UDd = Gu - (Gu - Gd).* w2 ; % ���ƽ�ָ��֮�俿�µĻƽ�ָ��
        UDu = Gu - (Gu - Gd).* w1 ; % ���ƽ�ָ��֮�俿�ϵĻƽ�ָ��       
       
        HUd = vh - (vh - Gu).* w2 ; % �߻ƽ�ָ����ߵ�֮�俿�µĻƽ�ָ��
        HUu = vh - (vh - Gu).* w1 ; % �߻ƽ�ָ����ߵ�֮�俿�ϵĻƽ�ָ��        
        
        Hd = vh + (vh - Gu).* w1 ; % �ߵ�֮�ϵ�һ���ƽ�ָ��
        lu = vl - (vh - Gu).* w1 ; % �͵�֮�µ�һ���ƽ�ָ��
             
        Hd = repmat(Hd,1,270);
        Hd = Hd';
        Hd = Hd(:);     
        
        vh = repmat(vh,1,270);
        vh = vh';
        vh = vh(:);
        
        HUu = repmat(HUu,1,270);
        HUu = HUu';
        HUu = HUu(:);
        
        HUd = repmat(HUd,1,270);
        HUd = HUd';
        HUd = HUd(:);
        
        Gu = repmat(Gu,1,270);
        Gu = Gu';
        Gu = Gu(:);
        
        UDu = repmat(UDu,1,270);
        UDu = UDu';
        UDu = UDu(:);
        
        vm = repmat(vm,1,270);
        vm = vm';
        vm = vm(:);
        
        UDd = repmat(UDd,1,270);
        UDd = UDd';
        UDd = UDd(:);
        
        Gd = repmat(Gd,1,270);
        Gd = Gd';
        Gd = Gd(:);
        
        DLu = repmat(DLu,1,270);
        DLu = DLu';
        DLu = DLu(:);
        
        DLd = repmat(DLd,1,270);
        DLd = DLd';
        DLd = DLd(:);

        vl = repmat(vl,1,270);
        vl = vl';
        vl = vl(:);
        
        lu = repmat(lu,1,270);
        lu = lu';
        lu = lu(:);    

        idmax = repmat(idmax,1,270);
        idmax = idmax';
        idmax = idmax(:); 
        
        idmin = repmat(idmin,1,270);
        idmin = idmin';
        idmin = idmin(:); 
        
        
        vclose = dataIF.close;
        
        tag11 = crossOver( vclose ,Hd, 1);
        tag12 = crossUnder( vclose ,Hd, 1);
        
        tag21 = crossOver( vclose ,vh, 1);
        tag22 = crossUnder( vclose ,vh, 1);

        tag31 = crossOver( vclose ,HUu, 1);
        tag32 = crossUnder( vclose ,HUu, 1);
        
        tag41 = crossOver( vclose ,HUd, 1);
        tag42 = crossUnder( vclose ,HUd, 1);        
        
        tag51 = crossOver( vclose ,Gu, 1);
        tag52 = crossUnder( vclose ,Gu, 1);
        
        tag61 = crossOver( vclose ,UDu, 1);
        tag62 = crossUnder( vclose ,UDu, 1);  
        
        tag71 = crossOver( vclose ,vm, 1);
        tag72 = crossUnder( vclose ,vm, 1);
        
        tag81 = crossOver( vclose ,UDd, 1);
        tag82 = crossUnder( vclose ,UDd, 1);

        tag91 = crossOver( vclose ,Gd, 1);
        tag92 = crossUnder( vclose ,Gd, 1);
        
        tag101 = crossOver( vclose ,DLu, 1);
        tag102 = crossUnder( vclose ,DLu, 1);        
        
        tag111 = crossOver( vclose ,DLd, 1);
        tag112 = crossUnder( vclose ,DLd, 1);
        
        tag121 = crossOver( vclose ,vl, 1);
        tag122 = crossUnder( vclose ,vl, 1);   
        
        tag131 = crossOver( vclose ,lu, 1);
        tag132 = crossUnder( vclose ,lu, 1);    
        
%         tag01 = idmax > idmin ;
%         tag02 = idmax <= idmin ;
        tag0 = zeros(length(vclose),1);
        tag0(idmax >= idmin) = 1;
        tag0(idmax < idmin) = -1;
        
        tag = [tag11,tag12,tag21,tag22,tag31,tag32,tag41,tag42,tag51,tag52,...
            tag61,tag62,tag71,tag72,tag81,tag82,tag91,tag92,tag101,tag102,...
            tag111,tag112,tag121,tag122,tag131,tag132 ];
        
        
        
        vtime = dataIF.time;
        data = [vtime,proIF,tag0,tag132];

        
        %% end of switch
end;



%% ����
tic
category = categorize(data);
toc

%% �޳�С������
sless  = 50; % ��������������
[ category.time,id1 ] = excldPa( category.time,sless );
category.pattern(id1)=[];
category.pro(id1)=[];


%% ��Ŀ������ͳ��
% evamat % 2.Ǳ������Ϊ0�ĸ�������������֮�ȣ� 3.Ϊ��ֵ��4.Ϊ���5.Ϊ��λ����6.Ϊƫ�ȣ�7.Ϊ���
[ scoremat,evamat ] = patternscore( category.pro );


%% ����ͳ�ƽ����ѡģʽ
% 
% pct = 0.03; % ���޸�
% 
% [ evamat_L ] = choosepattern( evamat,scoremat, pct, 1 );
% [ evamat_s ] = choosepattern( evamat,scoremat, pct, 2 );

%%
% if matlabpool('size')>0
%   matlabpool('close');
% end