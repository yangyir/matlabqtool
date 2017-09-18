%% decode l2 ����Ȩ����

clear all; rehash;

% �����Ǿ��������level2���ݣ�txt��ʽ�����մ洢
% �����Ticks�࣬�ɴ��.m



% optionDataPath = 'G:\�Ϻ�9002��Ȩ��������\';
% date = '20150207';
% path = [optionDataPath , date , '\'];

% path = 'G:\���ŷָ���Ȩ��������\';
path = 'W:\���ŷָ���Ȩ��������\';

filenames = dir(path);


for idt = 23 : length(filenames)
    if filenames(idt).isdir, continue; end
    fn = filenames(idt).name;
    tday = datenum(fn(1:8), 'yyyymmdd');
    fid = fopen([path, '\',  fn]);   
    
    % ȡ510050.SH��Bars ������ȱl2��
    tdaystr = datestr(tday, 'yyyy-mm-dd');
    b50 = Fetch.dhStockBars('510050.SH', tdaystr, tdaystr, 5);
    next50time = 90000;
    i50 = 1;
    
      
    % ����TK���󣬻�������
    loadALLoptInfo;
    
    l2data = L2DataOpt;
    
    % �µ�һ�죬��Щ����Ҫ����
    try clear(hisl2str); catch, end
    
    % ��ʼ�����е�profile����
    Initialize_l2prof;

    % ��ʼ�����е�m2tk����
    initialize_m2tk;
    
    enterline1= [];
    quitline = [];
    nextmin = 90000;
    
    cnt = 0;
    % ǰ�������ʱ������
    for itmp = 1:63000
        l = fgetl(fid);
        cnt = cnt + 1;
    end

    while ~feof(fid)
        
        l = fgetl(fid);      
        L2DataOpt.fillL2Data(l2data, l);
%         L2DataOpt.dispL2Data(l2data);
        
        %% ֻ��ĳֻ�ض���Լ
%         if strcmp(l2data.secCode,'10000004') & l2data.quoteTime > 93000
%              try
%                  L2DataOpt.dispL2Data( l2data);
%                  L2DataOpt.dispL2Data( l2prof10000004);
%                  l2prof10000004.changedL2fields
%                  
%                  
%                  % ��һ��vol�� K = 2350, T = 3��, 50etf = 2.291
%                  delta = blsdelta(2.291, 2.350, 0.05, 0.1, vol)
%                  gamma = blsgamma(2.291, 2.350, 0.05, 0.1, vol)
%                  theta = blstheta(2.291, 2.350, 0.05, 0.1, vol)
%                  rho   = blsrho(2.291, 2.350, 0.05, 0.1, vol)
%                  vega  = blsvega(2.291, 2.350, 0.05, 0.1, vol)
%                  lambda = blslambda(2.291, 2.350, 0.05, 0.1, vol)
%                  
%                 
%                 % ��ͼ
%                 
%              catch 
%              end             
%         end
        
        %% ��ʱ�䡣   ��00000000���ƺ�ֻ�б�ʱ����
        if strcmp(l2data.secCode, '00000000')  && mod(l2data.quoteTime, 100) == 0
            disp( l2data.quoteTime);
            if l2data.quoteTime > 93000 && mod(l2data.quoteTime, 1000) == 0
                % ȫ������һ��
%                 calc_all_m2tk;                
                tic
                
                % ��
                for iFig = 1:4 
                    try
                        figure(iFig);hold off; 
                        plot(call.ask1vol.data(iFig,:),'r-*');hold on;
                        plot(call.bid1vol.data(iFig,:), 'r-o');
                        plot(put.ask1vol.data(iFig,:),'b-*');
                        plot(put.bid1vol.data(iFig,:),'b-o');
                        title( sprintf('%d, S=%d',l2data.quoteTime,S*1000) );
                        set(gca,'XTickLabel',call.ask1vol.yProps);
                    catch e
                        sprintf('Fig error: %d', iFig);
                    end
                end
                
                

%                 figure(1);hold off; plot(call.ask1.data(1,:),'r-*');
%                 hold on; title(l2data.quoteTime);
%                 plot(call.bid1.data(1,:), 'r-o');
%                 plot(put.ask1.data(1,:),'b-*');
%                 plot(put.bid1.data(1,:),'b-o');
%                 set(gca,'XTickLabel',call.ask1.yProps);
%                 
%                 figure(2);hold off; plot(call.ask1.data(2,:),'r-*');
%                 hold on; title(l2data.quoteTime);
%                 plot(call.bid1.data(2,:), 'r-o');
%                 plot(put.ask1.data(2,:),'b-*');
%                 plot(put.bid1.data(2,:),'b-o');
%                 set(gca,'XTickLabel',call.ask1.yProps);
                                
                toc
            end
                
        end
        
        
          %% ���S�۸��и���
        % ��������S��Moneyness
        if strcmp(l2data.secCode, '00000000') && l2data.quoteTime > next50time
            % ��50etf��indexָ�����ý���һ��while���ڳ��ζ���
            while l2data.quoteTime > next50time            
                S = b50.close(i50);
                i50 = i50+1;
                next50time = hour(b50.time(i50))*10000 + minute(b50.time(i50))*100 + second(b50.time(i50));
            end
            
            % ��������profile��S��M
                for iK = 1:length(uKs)
                    cM = max( S - uKs(iK)/1000, 0);
                    pM = max( uKs(iK)/1000 - S, 0);
                    for iT = 1:length(uTs)
                        call.profptr.data{iT, iK}.M = cM;
                        call.profptr.data{iT, iK}.S = S;
                        put.profptr.data{iT, iK}.M = pM;
                        put.profptr.data{iT, iK}.S = S;                        
                    end
                end            
        end
        
        %% ������Ȩ�࣬������Ȩ����l2prof.sh*
        % ���������������  l2prof.sh��������

        if ~strcmp(l2data.secCode, '00000000')
            
            % thisָ��ָ��ǰprofile
            try
                eval(['this = l2prof.sh', l2data.secCode, ';']);
            catch e
                this = nan;
            end
            
            % update Ticks�� �����ȫ����
            if l2data.accDeltaFlag == 1 % ȫ��
                % ȫ�����ˣ�����һ��
                this.updateNonzeroDifferent(l2data);
                this.calcVol;
                % this.dispOpt;
                % �������£����changedL2fields��ļ�¼
                this.clearChangedL2fields;
            end
            
%             if l2data.accDeltaFlag == 2 % ����
%                 % �н���
%                 if l2data.volume > 0
%                     % �������з�0��
%                     this.updateNonzeroDifferent(l2data);
%                 end
%                 
%                 % �޽��ף�ֻ�ǹҵ��仯
%                 if l2data.volume == 0
%                     % ���·�0��
%                     this.updateNonzeroDifferent(l2data);
%                 end
%             end
            
        end
        

        %% ����m2TK        
        if l2data.accDeltaFlag == 1 % ȫ��
            try
                if this.CP == 1 % call
                    iT = Tmap(this.secCode);
                    iK = Kmap(this.secCode);
                    call.ask1.data(iT, iK )     = this.askP1;
                    call.ask1vol.data(iT, iK)   = this.askvol;
                    call.bid1.data(iT, iK)      = this.bidP1;
                    call.bid1vol.data(iT, iK)   = this.bidvol;
                    call.ask1q.data(iT,iK)      = this.askQ1;
                    call.bid1q.data(iT,iK)      = this.bidQ1;
                elseif this.CP == 2 % put
                    iT = Tmap(this.secCode);
                    iK = Kmap(this.secCode);
                    put.ask1.data(iT, iK )      = this.askP1;
                    put.ask1vol.data(iT, iK)    = this.askvol;
                    put.bid1.data(iT, iK)       = this.bidP1;
                    put.bid1vol.data(iT, iK)    = this.bidvol;
                    put.ask1q.data(iT,iK)      = this.askQ1;
                    put.bid1q.data(iT,iK)      = this.bidQ1;
                end
            catch e
            end    
        end
        
        
        %% �����������ˣ���profile����ʲô


%         ��call-put parity���ԣ� c-p = f-k



            % C(K1) - 2*C(K2) + C(K3) > 0 , K1<K2<K3, 
            % ֻ�������T�Ͽ����Լ�:  ask, bid, ask
            % ���ɨ���˼·��Ч�ʵ���
        if strcmp(l2data.secCode, '00000000') 
            iT = 1;
            for iK1 = 1:length(uKs)-2
                for iK2 = 2:length(uKs) -1
                    for iK3 = 3:length(uKs)
                        if iK1<iK2 && iK2<iK3
                        try
                            p1 = call.ask1.data(iT, iK1);
                            p2 = call.bid1.data(iT, iK2);
                            p3 = call.ask1.data(iT, iK3);
                            k1 = uKs(iK1)/1000; 
                            k2 = uKs(iK2)/1000; 
                            k3 = uKs(iK3)/1000;
                            c1 = call.ask1.data(iT, iK1) - call.profptr.data{iT, iK1}.M;
                            c2 = call.bid1.data(iT, iK2) - call.profptr.data{iT, iK2}.M;
                            c3 = call.ask1.data(iT, iK3) - call.profptr.data{iT, iK3}.M;                            
                            zero = p1*p2*p3; % ����ĳֵΪ0��˵��û����
%                             pay = (c1-2*c2+c3) * (zero>0);
                            pay = ((p1-2*p2+p3) + max(k1-2*k2+k3,0) )* (zero>0);                                                      
%                             pay = ((p1-2*p2+p3) + (k1-2*k2+k3) )* (zero>0);
                            if pay < 0
                                q1 = call.ask1q.data(iT,iK1);
                                q2 = call.ask1q.data(iT,iK2);
                                q3 = call.ask1q.data(iT,iK3);
%                                 m1 = call.profptr.data{iT, iK1}.margin;
                                m2 = call.profptr.data{iT, iK2}.margin;
%                                 m3 = call.profptr.data{iT, iK3}.margin;

                                fprintf('t=%d, T=%s\n',l2data.quoteTime,uTs{iT});
                                fprintf('%0.4f\t%0.4f\t%0.4f\n', p1,p2,p3);
                                fprintf('%0.4f\t%0.4f\t%0.4f\n', c1,c2,c3);
                                fprintf('%d\t\t%d\t\t%d\n', q1,q2,q3);
                                fprintf('%d\t%d\t%d\n', uKs(iK1), uKs(iK2), uKs(iK3));
                                fprintf('pay=%0.4f / margin=%0.4f \n\n',pay, 2*m2);
                            end
                        catch e
                        end

                        end
                        
                    end
                end
            end
        end

        
        % ��һ�����ߣ�������
        if strcmp(l2data.secCode, '00000000') && l2data.quoteTime > nextmin
            try
                c1 = call.ask1.data(iT, 2);
                c2 = call.bid1.data(iT, 3);
                c3 = call.ask1.data(iT, 4);
                pay = (c1 - 2*c2 + c3);
                enterline1(end+1) = pay;
                
                c1 = call.bid1.data(iT, 2);
                c2 = call.ask1.data(iT, 3);
                c3 = call.bid1.data(iT, 4);
                get = (- c1 + 2*c2 - c3);
                quitline(end+1) = - get;
                
            catch e
            end
            
            nextmin = nextmin + 100;
        end

        

        
         
        
        %% ֻ�ǿ���
%         % ֻ��ĳֻ�ض���Լ
%         if strcmp(l2data.secCode,'10000004') & l2data.quoteTime > 93000
%              try
%                  L2DataOpt.dispL2Data( l2data);
%                  L2DataOpt.dispL2Data( l2prof10000004);
%                  l2prof10000004.changedL2fields
%              catch 
%              end  
%              l2prof10000004.clearChangedL2fields;
% 
%         end
        
        
        %% ͬʱ������ʷ������������ʷ
%         hisVarName = ['hisl2_', l2data.secCode];
%         clear his;
%         % �粻���ڣ��½�������ֻ�ǽ��档Ȼ�󶼷ŵ�his��
%         if ~exist(hisVarName, 'var')
%             his = L2DataOpt;
%             eval([hisVarName ' = his;']);
%             his.code = l2data.secCode;
%         else
%             eval(['his = ' hisVarName ';']);
%         end
%         
%         % ��his��pushһ��record
%         his.pushstr(l);

        %% ͬһ��Լ������quote������һ��var�� ���д��file
        hisL2Strname = ['hisl2str.sh', l2data.secCode];
        try
            eval( [ hisL2Strname, ' = sprintf(''%s\n%s'', ' , hisL2Strname, ', l);' ] );
        catch e
            eval(  [ hisL2Strname ' = '''';'] );
        end
        
        
        
        %% ����vol surface
        
        
        
    cnt = cnt + 1  ;  
    end
    
    fclose(fid);
    
    %% ��ֻ��Լ�ĵ��յ���������save txt
    mkdir( path, fn(1:8) );
    svpath = [path, '\' , fn(1:8), '\']; 
    a = fields(hisl2str);
    for j = 1: length(a)
        tmp     = hisl2str.(a{j});
        svfn    = [a{j} , '.txt'];
        svfid   = fopen([ svpath,svfn ], 'w+');
        fprintf(svfid, '%s', tmp);
        fclose(svfid);
    end
        
    
end

