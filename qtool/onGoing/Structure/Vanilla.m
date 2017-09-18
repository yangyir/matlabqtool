classdef Vanilla < handle
    %VANILLA ��һ���ɣ� ��һ��Ȩ����������
    %   Detailed explanation goes here
    
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        % ����
        underCode;
        underName;
        underP; %S0
        bsVol; %����

        % ����
        % �ڸ���StructureBase�У�
        asofDate; % t
        expDate; % T
        remDaysT; % T-t (������)
        remDaysN; % T-t (��Ȼ�գ�
        rfr;  % r, risk free rate
        
        
        % ������������
        ways; % �ɶ��ٸ�vanilla���
        volSurf;  % ��ʵ��һ���ߣ����У���vol�� K )       
        type; % c, p
        strike;  % K        
        optP;   % ��Լ��ǰ�г��۸�
        position; % +1��2��3��4����, -1, Ĭ��+1
        
        premium1; % ����
        premium2; % ����
    end
    
    methods(Access = 'public', Static = false, Hidden = false)
        % constructor
%         obj = Vanilla(obj);
        
        
        % �ڸ���StructureBase�У�
        % ����ʣ������
        calcRemDays;
        
        
        % ��BS��ʽ����۸�, ����position
        function [implyVol ] = bsImplyVol(obj)
            %% ���������ʱʹ��ѭ�����, ͨ��BS��ʽ�������������
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
            %% �����Ϲ��Ϲ�ʹ��BS��ʽֱ�������Ȩ�ļ�ֵ�����ݲ����ʵ�ȡ�������ͬ
            value = zeros(obj.ways,1);
            if isempty(obj.volSurf)
                % ʹ�ù̶���bs�����ʣ�ֻ�������
                tempVol = obj.bsVol*ones(obj.ways,1);
            else
                % �����ֳɵĲ����ʣ�ֱ��ȡ�������
                tempVol = obj.volSurf;
            end
            callMask    = cellfun(@(x)strncmpi(x,'c',1),obj.type);
            putMask     = ~callMask;
            value(callMask)     = obj.Callprice(obj.underP,obj.strike(callMask),obj.rfr,obj.remDaysT,tempVol(callMask));
            value(putMask)      = obj.Putprice(obj.underP,obj.strike(putMask),obj.rfr,obj.remDaysT,tempVol(putMask));
        end;
        
        % ������ģ�� Cox Ross Rubinstein
        [value, tree] = crrValue;
        
        % Monte Carlo
        [value, paths] = mcValue;
        
        
        
        % ����premium��ļ۸�Ҫ��position
        price;
        
        % ����һ�������ԵĻ�'����000301.SZ�Ŀ�����Ȩ��S0=5.1, K=5.5, T-t=30������, vol=20%, r=5%'
        [] = description(obj);
        
        % ��ͼ
%         plotPayoff;  % price ~  ST
        
        function [h] = plotValue(obj,call_put,price,position)
            maxP = max(price);
            minP = min(price);
            optNum = length(price);
            len  = maxP - minP;
            % Ϊ��ͼ���㣬 �˴�ȡ 0 ~ 1.5�����ֵ��Ȩ�۸������ȡֵ
            serialS = linspace(0,1.5*maxP,99);
            valueS = zeros(size(serialS));
            for k = 1:optNum
                % �ô�ʹ�������Բ�ֵ�������������
                impVol = obj.getVolSurf(price(k));
%                 impVol  = 0.35;
                if strncmpi(call_put{k},'c',1)                    
                    valueS = valueS + position(k)*Callprice(serialS,price(k),obj.rfr,obj.remDaysT,impVol);
                else
                    valueS = valueS + position(k)*Putprice(serialS,price(k),obj.rfr,obj.remDaysT,impVol);
                end
            end
            
            [h] = plot(serialS,valueS,'r');
            
            % ���������ĵ��������Ȩ��ֵ���ٶ��ֻ��۸������Բ�ֵ�����Ӧ�ֻ��۸����Ȩ��ֵ
            firstIndex = find(serialS <= obj.underP,1,'last');
            lastIndex  = find(serialS >= obj.underP ,1,'first');
            if firstIndex == lastIndex
                valueP = valueS(firstIndex);
            else
                valueP = (obj.underP - serialS(firstIndex))/(serialS(lastIndex) - serialS(firstIndex))*...
                    (valueS(lastIndex)-valueS(firstIndex)) + valueS(firstIndex);
            end
            
            hold on 
            % �����ֻ��۸��Ӧ��Ȩ�ļ�ֵ��ͼ���е�λ��
            plot(obj.underP,valueP,'r*','LineWidth',3);
%              text(obj.underP,valueP,['(' num2str(obj.underP) ',' num2str(valueP) ')'] );
            hold off
            % ���½���Ϊ����ʾһ�����ʵı����� ������ȥ��д
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
            % Payoff �ļ������ͨ����Ȩ���ϵĵ����ӳ���
            uniqueK     = sort(unique(price(nonZeros)),'ascend');
            uniqueK     = [0;uniqueK;maxK*1.5];
            rateNum     = length(uniqueK);
            value        = zeros(rateNum,1);
            for k = 1:length(nonZeros)
                % ����������λ�Լ��Ϲ��Ϲ���Ȩ�ۼ������Ȩ���ϵ���Ȩ����
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
            
            % ����ֻΪ����ʾ��һ�����ʱ�����ͼ��
            mins    = max(0,minK - len);
            maxs    = 1.2*maxK;
            Vol = interp1(uniqueK,value,linspace(mins,maxs,100));
            axis([mins,maxs,min(Vol)*0.9,max(Vol)*1.1]); 
            grid on;
        end
        
        function [h] = plotPV(obj,call_put,price,position)
            % �ú���Ϊ�˻�����Ӧ����Ȩ��ֵ�����Լ��������ߵĸ���ͼ�Σ�ΪplotPayoff �� plotValue �ĸ���
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
        
        % ����greeks
        function delta = bsDelta(obj,call_put,price,position, vol)
            % ����delta��ֵ����Ȩ�۸�������ɼ۸�ı仯��
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
            % ��Ȩ�۸���� delta�ı仯��
            d1 = (log(obj.underP./price)+(obj.rfr+(vol.^2)/2).*obj.remDaysT)./vol./obj.remDaysT.^0.5;            
            gamma = (normpdf(d1))./(obj.underP.*vol.*sqrt(obj.remDaysT));     
            gamma   = sum(position.*gamma);
        end
        
        function rho = bsRho(obj,call_put,price,position, vol)
            % ������Ȩ�۸�����޷������ʵı仯��
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
            % ������Ȩ���ڵ���ʱ��ı仯��
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
            % ������Ȩ���ڲ����ʵı仯��
            d1 = (log(obj.underP./price)+(obj.rfr+(vol.^2)/2).*obj.remDaysT)./vol./obj.remDaysT.^0.5;
            vega = obj.underP.*sqrt(obj.remDaysT).*normpdf(d1);    
            vega = sum(vega.*position);
        end
        
        
        function Vol = getVolSurf(obj,strike)
            [implyVol ] = obj.bsImplyVol();
            %%  �����Բ�ֵ��������Ȩ�۸����Ȩ��Լ��ֵ
            % ��������call��put������ѡ�����������Ȩ��Լ���в�ֵ
            callMask    = cellfun(@(x)strncmpi(x,'c',1),obj.type);
            if length(find(callMask)) < 1/2 * length(callMask)
                mask = ~callMask;
            else
                mask = callMask;
            end
            callStike   = obj.strike(mask);
            callImpV    = implyVol(mask);
            Vol = interp1(callStike,callImpV,strike);
            % �������Լ����Ȩ�۸�С����֪��Լ����С��Ȩ��ʱ��ֱ�Ӹ���С��Ȩ�۶�Ӧ��Լ�Ĳ�����
            [minK , minIn] = min(callStike);
            if ~isempty(find(strike < minK,1))
                Vol(strike < minK)         = callImpV(minIn);
            end
            % �������Լ����Ȩ�۸������֪��Լ�������Ȩ��ʱ��ֱ�Ӹ������Ȩ�۶�Ӧ��Լ�Ĳ�����
            [maxK , maxIn] = max(callStike);
            if ~isempty(find(strike > maxK,1))
                Vol(strike > maxK)         = callImpV(maxIn);
            end
            
        end

        
        
    end
    
    methods(Access = 'public', Static = false, Hidden = true)
        function cp = Callprice(obj,S,K,r,T,sigma)
            % �����Ϲ���Ȩ�ĺ�Լ��ֵ
            d1 = (log(S./K)+(r+(sigma.^2)/2).*T)./sigma./T.^0.5;            % Important parameter for computing the following functions;
            d2 = d1 - sigma.*T.^0.5;                                        % Important parameter for computing the following functions;
            cp = S.*cdf('norm',d1,0,1)-K.*exp(-r.*T).*cdf('norm',d2,0,1);   %Call price of a European option;
        end
        
        function pp = Putprice(obj,S,K,r,T,sigma)
            % �����Ϲ���Ȩ�ĺ�Լ��ֵ
            d1 = (log(S./K)+(r+(sigma.^2)/2).*T)./sigma./T.^0.5;            % Important parameter for computing the following functions;
            d2 = d1 - sigma.*T.^0.5;                                        % Important parameter for computing the following functions;
            pp = K.*exp(-r.*T).* cdf('norm',-d2,0,1)-S.*cdf('norm',-d1,0,1); % Put price of a European option;
        end
    end
    
end