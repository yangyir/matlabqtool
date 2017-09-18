classdef Vanilla < handle
    %VANILLA 单一正股， 单一期权（或多个？）
    %   Detailed explanation goes here
    
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        % 正股
        underCode;
        underName;
        underP; %S0
        bsVol; %标量

        % 标量
        % 在父类StructureBase中？
        asofDate; % t
        expDate; % T
        remDaysT; % T-t (交易日)
        remDaysN; % T-t (自然日）
        rfr;  % r, risk free rate
        
        
        % 标量？向量？
        ways; % 由多少个vanilla组成
        volSurf;  % 其实是一条线（两列），vol（ K )       
        type; % c, p
        strike;  % K        
        optP;   % 合约当前市场价格
        position; % +1，2，3，4。。, -1, 默认+1
        
        premium1; % 备用
        premium2; % 备用
    end
    
    methods(Access = 'public', Static = false, Hidden = false)
        % constructor
%         obj = Vanilla(obj);
        
        
        % 在父类StructureBase中？
        % 计算剩余日期
        calcRemDays;
        
        
        % 用BS公式计算价格, 不看position
        function [implyVol ] = bsImplyVol(obj)
            %% 简单起见，暂时使用循环求解, 通过BS公式反解求出波动率
            implyVol = nan(obj.ways,1);
            for k = 1:obj.ways
                opt=optimset('Display','off');
                if strncmpi(obj.type{k},'c',1)
                    [implyVol(k), ~, exitFlag] = fsolve(@(sigma) obj.Callprice(obj.underP,obj.strike(k),obj.rfr,obj.remDaysT,sigma)-obj.optP(k),1,opt);
                else
                    [implyVol(k), ~, exitFlag] = fsolve(@(sigma) obj.Putprice(obj.underP,obj.strike(k),obj.rfr,obj.remDaysT,sigma)-obj.optP(k),1,opt);
                end
                
                
                if exitFlag < 0
                    if (implyVol(k) == 1 || implyVol(k) < 0.01)
                        implyVol(k) = NaN;
                    end
                end
            end
        end;
        
        function [value ] = bsValue(obj)
            %% 根据认购认沽使用BS公式直接求得期权的价值，依据波动率的取法结果不同
            value = zeros(obj.ways,1);
            if isempty(obj.volSurf)
                % 使用固定的bs波动率，只与标的相关
                tempVol = obj.bsVol*ones(obj.ways,1);
            else
                % 若有现成的波动率，直接取出来求解
                tempVol = obj.volSurf;
            end
            callMask    = cellfun(@(x)strncmpi(x,'c',1),obj.type);
            putMask     = ~callMask;
            value(callMask)     = obj.Callprice(obj.underP,obj.strike(callMask),obj.rfr,obj.remDaysT,tempVol(callMask));
            value(putMask)      = obj.Putprice(obj.underP,obj.strike(putMask),obj.rfr,obj.remDaysT,tempVol(putMask));
        end;
        
        % 二叉树模型 Cox Ross Rubinstein
        [value, tree] = crrValue;
        
        % Monte Carlo
        [value, paths] = mcValue;
        
        
        
        % 加上premium后的价格，要看position
        price;
        
        % 生成一句描述性的话'基于000301.SZ的看涨期权，S0=5.1, K=5.5, T-t=30交易日, vol=20%, r=5%'
        [] = description(obj);
        
        % 画图
%         plotPayoff;  % price ~  ST
        
        function [h] = plotValue(obj,call_put,price,position)
            maxP = max(price);
            minP = min(price);
            optNum = length(price);
            len  = maxP - minP;
            % 为画图方便， 此处取 0 ~ 1.5倍最大值行权价格的区间取值
            serialS = linspace(0,1.5*maxP,99);
            valueS = zeros(size(serialS));
            for k = 1:optNum
                % 该处使用了线性插值求得隐含波动率
                impVol = obj.getVolSurf(price(k));
%                 impVol  = 0.35;
                if strncmpi(call_put{k},'c',1)                    
                    valueS = valueS + position(k)*Callprice(serialS,price(k),obj.rfr,obj.remDaysT,impVol);
                else
                    valueS = valueS + position(k)*Putprice(serialS,price(k),obj.rfr,obj.remDaysT,impVol);
                end
            end
            
            [h] = plot(serialS,valueS,'r');
            
            % 按照上述的点求出的期权价值，再对现货价格作线性插值求出对应现货价格的期权价值
            firstIndex = find(serialS <= obj.underP,1,'last');
            lastIndex  = find(serialS >= obj.underP ,1,'first');
            if firstIndex == lastIndex
                valueP = valueS(firstIndex);
            else
                valueP = (obj.underP - serialS(firstIndex))/(serialS(lastIndex) - serialS(firstIndex))*...
                    (valueS(lastIndex)-valueS(firstIndex)) + valueS(firstIndex);
            end
            
            hold on 
            % 画出现货价格对应期权的价值在图形中的位置
            plot(obj.underP,valueP,'r*','LineWidth',3);
%              text(obj.underP,valueP,['(' num2str(obj.underP) ',' num2str(valueP) ')'] );
            hold off
            % 以下仅仅为了显示一个合适的比例， 可以隐去不写
            mins    = max(0,minP - len);
            maxs    = 1.2*maxP;
            valuew  = valueS(serialS<maxs & serialS > mins);
            axis([mins,maxs,min(valuew)*0.9,max(valuew)*1.1]); 
            grid on;
        end
        
        function [h] = plotPayoff(obj,call_put,price,position)
            
            minK = min(price);
            maxK = max(price);
            
            len = maxK - minK;
            
            nonZeros    = find(position ~= 0);
            % Payoff 的计算可以通过行权价上的点连接出来
            uniqueK     = sort(unique(price(nonZeros)),'ascend');
            uniqueK     = [0;uniqueK;maxK*1.5];
            rateNum     = length(uniqueK);
            value        = zeros(rateNum,1);
            for k = 1:length(nonZeros)
                % 根据买卖仓位以及认购认沽行权价计算各行权价上的期权收益
                indexK = find(uniqueK == price(nonZeros(k)));
                if strncmpi(call_put{nonZeros(k)},'c',1)
                    value(indexK+1:rateNum) =  value(indexK+1:rateNum) + position(nonZeros(k))*...
                        (uniqueK(indexK+1:rateNum) - price(nonZeros(k)));
                else
                    value(1:indexK) = value(1:indexK) + position(nonZeros(k))*...
                        (price(nonZeros(k)) - uniqueK(1:indexK));
                end
            end
            h = plot(uniqueK,value,'b-*','LineWidth',1.5);
            
            % 以下只为了显示出一个合适比例的图形
            mins    = max(0,minK - len);
            maxs    = 1.2*maxK;
            Vol = interp1(uniqueK,value,linspace(mins,maxs,100));
            axis([mins,maxs,min(Vol)*0.9,max(Vol)*1.1]); 
            grid on;
        end
        
        function [h] = plotPV(obj,call_put,price,position)
            % 该函数为了画出对应的期权价值曲线以及收益曲线的复合图形，为plotPayoff 和 plotValue 的复合
            maxP = max(price);
            minP = min(price);
            optNum = length(price);
            len  = maxP - minP;
            serialS = linspace(0,1.5*maxP,99);
            valueS = zeros(size(serialS));
            for k = 1:optNum
                impVol = obj.getVolSurf(price(k))
%                 impVol  = 0.35;
                if strncmpi(call_put{k},'c',1)                    
                    valueS = valueS + position(k)*obj.Callprice(serialS,price(k),obj.rfr,obj.remDaysT,impVol);
                else
                    valueS = valueS + position(k)*obj.Putprice(serialS,price(k),obj.rfr,obj.remDaysT,impVol);
                end
            end
            [h] = plot(serialS,valueS,'r');
            firstIndex = find(serialS <= obj.underP,1,'last');
            lastIndex  = find(serialS >= obj.underP ,1,'first');
            if firstIndex == lastIndex
                valueP = valueS(firstIndex);
            else
                valueP = (obj.underP - serialS(firstIndex))/(serialS(lastIndex) - serialS(firstIndex))*...
                    (valueS(lastIndex)-valueS(firstIndex)) + valueS(firstIndex);
            end
            hold on 
            plot(obj.underP,valueP,'r*','LineWidth',3);
%              text(obj.underP,valueP,['(' num2str(obj.underP) ',' num2str(valueP) ')'] );
            
            mins    = max(0,minP - len);
            maxs    = 1.2*maxP;
            valuew  = valueS(serialS<maxs & serialS > mins);
            maxV    = max(valuew)*1.1;
            minV    = min(valuew)*0.9;
            
            nonZeros    = find(position ~= 0);
            uniqueK     = sort(unique(price(nonZeros)),'ascend');
            uniqueK     = [0;uniqueK;maxP*1.5];
            rateNum     = length(uniqueK);
            value        = zeros(rateNum,1);
            for k = 1:length(nonZeros)
                indexK = find(uniqueK == price(nonZeros(k)));
                if strncmpi(call_put{nonZeros(k)},'c',1)
                    value(indexK+1:rateNum) =  value(indexK+1:rateNum) + position(nonZeros(k))*...
                        (uniqueK(indexK+1:rateNum) - price(nonZeros(k)));
                else
                    value(1:indexK) = value(1:indexK) + position(nonZeros(k))*...
                        (price(nonZeros(k)) - uniqueK(1:indexK));
                end
            end
            h = plot(uniqueK,value,'b-*','LineWidth',1.5);
            mins    = max(0,minP - len);
            maxs    = 1.2*maxP;
            Vol = interp1(uniqueK,value,linspace(mins,maxs,100));
            axis([mins,maxs,min(min(Vol)*0.9,minV),max(max(Vol)*1.1,maxV)]); 
            grid on;
            hold off
        end
        
        % 计算greeks
        function delta = bsDelta(obj,call_put,price,position, vol)
            % 计算delta的值，期权价格关于正股价格的变化率
            delta = nan(size(call_put));
            callMask    = cellfun(@(x)strncmpi(x,'c',1),call_put);
            putMask     = ~callMask;
            d1 = (log(obj.underP./price)+(obj.rfr+(vol.^2)/2).*obj.remDaysT)./vol./obj.remDaysT.^0.5; 
            cd = normcdf(d1); 
            if any(callMask)
                delta(callMask) = cd(callMask);
            end
            if any(putMask)
                delta(putMask) = cd(putMask) - 1;
            end
            delta   = sum(position.*delta);
        end
        
        function gamma = bsGamma(obj,price,position, vol)
            % 期权价格关于 delta的变化率
            d1 = (log(obj.underP./price)+(obj.rfr+(vol.^2)/2).*obj.remDaysT)./vol./obj.remDaysT.^0.5;            
            gamma = (normpdf(d1))./(obj.underP.*vol.*sqrt(obj.remDaysT));     
            gamma   = sum(position.*gamma);
        end
        
        function rho = bsRho(obj,call_put,price,position, vol)
            % 计算期权价格关于无风险利率的变化率
            rho         = nan(size(call_put));
            callMask    = cellfun(@(x)strncmpi(x,'c',1),call_put);
            putMask     = ~callMask;
            disfac = price.*obj.remDaysT.*exp(-obj.rfr.*obj.remDaysT); 
            d1 = (log(obj.underP./price)+(obj.rfr+(vol.^2)/2).*obj.remDaysT)./vol./obj.remDaysT.^0.5;
            d2 = d1 - vol.*obj.remDaysT.^0.5;
            if any(callMask)
                rho(callMask) = disfac(callMask).*normcdf(d2(callMask)); 
            end
            if any(putMask)
                rho(putMask) = -disfac(putMask).*normcdf(-d2(putMask));
            end
            rho     = sum(rho.*position);
        end
        
        function theta = bsTheta(obj,call_put,price,position, vol)
            % 计算期权关于到期时间的变化率
            theta       = nan(size(call_put));
            callMask    = cellfun(@(x)strncmpi(x,'c',1),call_put);
            putMask     = ~callMask;
            d1 = (log(obj.underP./price)+(obj.rfr+(vol.^2)/2).*obj.remDaysT)./vol./obj.remDaysT.^0.5;
            d2 = d1 - vol.*obj.remDaysT.^0.5;
            if any(callMask)
                theta(callMask) = -obj.underP.*normpdf(d1(callMask)).*...
                    vol./(2.*sqrt(obj.remDaysT))...
                    -obj.rfr.*price(callMask).*exp(-obj.rfr.*obj.remDaysT).*...
                    normcdf(d2(callMask));
            end
            if any(putMask)
            theta(putMask) = -obj.underP.*normpdf(d1(putMask)).*vol...
                ./(2.*sqrt(obj.remDaysT))+...
                obj.rfr.*price(putMask).*exp(-obj.rfr.*obj.remDaysT).*normcdf(-d2(putMask));
            end
            theta = sum(theta.*position);
        end
        
        function vega = bsVega(obj,price,position, vol)
            % 计算期权关于波动率的变化率
            d1 = (log(obj.underP./price)+(obj.rfr+(vol.^2)/2).*obj.remDaysT)./vol./obj.remDaysT.^0.5;
            vega = obj.underP.*sqrt(obj.remDaysT).*normpdf(d1);    
            vega = sum(vega.*position);
        end
        
        
        function Vol = getVolSurf(obj,strike)
            [implyVol ] = obj.bsImplyVol();
            %%  作线性插值求其他行权价格的期权合约价值
            % 根据类中call和put的数量选择数量多的期权合约进行插值
            callMask    = cellfun(@(x)strncmpi(x,'c',1),obj.type);
            if length(find(callMask)) < 1/2 * length(callMask)
                mask = ~callMask;
            else
                mask = callMask;
            end
            callStike   = obj.strike(mask);
            callImpV    = implyVol(mask);
            Vol = interp1(callStike,callImpV,strike);
            % 当所求合约的行权价格小于已知合约的最小行权价时，直接赋最小行权价对应合约的波动率
            [minK , minIn] = min(callStike);
            if ~isempty(find(strike < minK,1))
                Vol(strike < minK)         = callImpV(minIn);
            end
            % 当所求合约的行权价格大于已知合约的最大行权价时，直接赋最大行权价对应合约的波动率
            [maxK , maxIn] = max(callStike);
            if ~isempty(find(strike > maxK,1))
                Vol(strike > maxK)         = callImpV(maxIn);
            end
            
        end

        
        
    end
    
    methods(Access = 'public', Static = false, Hidden = true)
        function cp = Callprice(obj,S,K,r,T,sigma)
            % 计算认购期权的合约价值
            d1 = (log(S./K)+(r+(sigma.^2)/2).*T)./sigma./T.^0.5;            % Important parameter for computing the following functions;
            d2 = d1 - sigma.*T.^0.5;                                        % Important parameter for computing the following functions;
            cp = S.*cdf('norm',d1,0,1)-K.*exp(-r.*T).*cdf('norm',d2,0,1);   %Call price of a European option;
        end
        
        function pp = Putprice(obj,S,K,r,T,sigma)
            % 计算认沽期权的合约价值
            d1 = (log(S./K)+(r+(sigma.^2)/2).*T)./sigma./T.^0.5;            % Important parameter for computing the following functions;
            d2 = d1 - sigma.*T.^0.5;                                        % Important parameter for computing the following functions;
            pp = K.*exp(-r.*T).* cdf('norm',-d2,0,1)-S.*cdf('norm',-d1,0,1); % Put price of a European option;
        end
    end
    
end