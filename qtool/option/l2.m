%% decode l2 的期权数据

clear all; rehash;

% 输入是经过解码的level2数据，txt格式，按日存储
% 输出是Ticks类，可存成.m



% optionDataPath = 'G:\上海9002期权解码数据\';
% date = '20150207';
% path = [optionDataPath , date , '\'];

% path = 'G:\逗号分隔期权解码数据\';
path = 'W:\逗号分隔期权解码数据\';

filenames = dir(path);


for idt = 23 : length(filenames)
    if filenames(idt).isdir, continue; end
    fn = filenames(idt).name;
    tday = datenum(fn(1:8), 'yyyymmdd');
    fid = fopen([path, '\',  fn]);   
    
    % 取510050.SH的Bars （因暂缺l2）
    tdaystr = datestr(tday, 'yyyy-mm-dd');
    b50 = Fetch.dhStockBars('510050.SH', tdaystr, tdaystr, 5);
    next50time = 90000;
    i50 = 1;
    
      
    % 建立TK矩阵，基础数据
    loadALLoptInfo;
    
    l2data = L2DataOpt;
    
    % 新的一天，有些变量要清零
    try clear(hisl2str); catch, end
    
    % 初始化所有的profile对象
    Initialize_l2prof;

    % 初始化所有的m2tk对象
    initialize_m2tk;
    
    enterline1= [];
    quitline = [];
    nextmin = 90000;
    
    cnt = 0;
    % 前面的垃圾时间跳掉
    for itmp = 1:63000
        l = fgetl(fid);
        cnt = cnt + 1;
    end

    while ~feof(fid)
        
        l = fgetl(fid);      
        L2DataOpt.fillL2Data(l2data, l);
%         L2DataOpt.dispL2Data(l2data);
        
        %% 只看某只特定合约
%         if strcmp(l2data.secCode,'10000004') & l2data.quoteTime > 93000
%              try
%                  L2DataOpt.dispL2Data( l2data);
%                  L2DataOpt.dispL2Data( l2prof10000004);
%                  l2prof10000004.changedL2fields
%                  
%                  
%                  % 看一下vol， K = 2350, T = 3月, 50etf = 2.291
%                  delta = blsdelta(2.291, 2.350, 0.05, 0.1, vol)
%                  gamma = blsgamma(2.291, 2.350, 0.05, 0.1, vol)
%                  theta = blstheta(2.291, 2.350, 0.05, 0.1, vol)
%                  rho   = blsrho(2.291, 2.350, 0.05, 0.1, vol)
%                  vega  = blsvega(2.291, 2.350, 0.05, 0.1, vol)
%                  lambda = blslambda(2.291, 2.350, 0.05, 0.1, vol)
%                  
%                 
%                 % 画图
%                 
%              catch 
%              end             
%         end
        
        %% 看时间。   ‘00000000’似乎只有报时功能
        if strcmp(l2data.secCode, '00000000')  && mod(l2data.quoteTime, 100) == 0
            disp( l2data.quoteTime);
            if l2data.quoteTime > 93000 && mod(l2data.quoteTime, 1000) == 0
                % 全部重算一遍
%                 calc_all_m2tk;                
                tic
                
                % 画
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
        
        
          %% 如果S价格有更新
        % 更新所有S和Moneyness
        if strcmp(l2data.secCode, '00000000') && l2data.quoteTime > next50time
            % 把50etf的index指到正好将来一格，while用于初次对齐
            while l2data.quoteTime > next50time            
                S = b50.close(i50);
                i50 = i50+1;
                next50time = hour(b50.time(i50))*10000 + minute(b50.time(i50))*100 + second(b50.time(i50));
            end
            
            % 更新所有profile的S和M
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
        
        %% 填入期权类，更新期权截面l2prof.sh*
        % 截面变量命名就用  l2prof.sh代码数字

        if ~strcmp(l2data.secCode, '00000000')
            
            % this指针指向当前profile
            try
                eval(['this = l2prof.sh', l2data.secCode, ';']);
            catch e
                this = nan;
            end
            
            % update Ticks， 如果是全量，
            if l2data.accDeltaFlag == 1 % 全量
                % 全量来了，重算一遍
                this.updateNonzeroDifferent(l2data);
                this.calcVol;
                % this.dispOpt;
                % 干完了事，清空changedL2fields域的记录
                this.clearChangedL2fields;
            end
            
%             if l2data.accDeltaFlag == 2 % 增量
%                 % 有交易
%                 if l2data.volume > 0
%                     % 更新所有非0量
%                     this.updateNonzeroDifferent(l2data);
%                 end
%                 
%                 % 无交易，只是挂单变化
%                 if l2data.volume == 0
%                     % 更新非0量
%                     this.updateNonzeroDifferent(l2data);
%                 end
%             end
            
        end
        

        %% 更新m2TK        
        if l2data.accDeltaFlag == 1 % 全量
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
        
        
        %% 这里是正文了，用profile做点什么


%         算call-put parity策略， c-p = f-k



            % C(K1) - 2*C(K2) + C(K3) > 0 , K1<K2<K3, 
            % 只在最近的T上看，对价:  ask, bid, ask
            % 逐次扫描的思路，效率低下
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
                            zero = p1*p2*p3; % 如有某值为0，说明没数据
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

        
        % 算一条曲线，画，看
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

        

        
         
        
        %% 只是看看
%         % 只看某只特定合约
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
        
        
        %% 同时，有历史变量，保留历史
%         hisVarName = ['hisl2_', l2data.secCode];
%         clear his;
%         % 如不存在，新建变量，只是截面。然后都放到his里
%         if ~exist(hisVarName, 'var')
%             his = L2DataOpt;
%             eval([hisVarName ' = his;']);
%             his.code = l2data.secCode;
%         else
%             eval(['his = ' hisVarName ';']);
%         end
%         
%         % 向his里push一个record
%         his.pushstr(l);

        %% 同一合约的所有quote，灌入一个var， 最后写成file
        hisL2Strname = ['hisl2str.sh', l2data.secCode];
        try
            eval( [ hisL2Strname, ' = sprintf(''%s\n%s'', ' , hisL2Strname, ', l);' ] );
        catch e
            eval(  [ hisL2Strname ' = '''';'] );
        end
        
        
        
        %% 计算vol surface
        
        
        
    cnt = cnt + 1  ;  
    end
    
    fclose(fid);
    
    %% 单只合约的当日的所有数据save txt
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

