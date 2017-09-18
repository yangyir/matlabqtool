function [ obj ] = setExit(obj, param)

% param: struct
%      .nT
%      .nB
%      .stopWin
%      .stopLoss
%      .waterMarkStart
%      .waterMarkFall
%————————————————————
% huajun @20140910


[nTrade, ~ ]= size(obj.entry);
obj.exit = nan(nTrade,6);
obj.exit(:,1) = obj.entry(:,1);
obj.exit(:,4) = -1*obj.entry(:,4);
obj.exit(:,5) = obj.entry(:,5);

try 
    nT =  param.nT;
catch
    nT = [];
end

try 
    nB  = param.nB;
catch
    nB = [];
end

try 
    stopWin =  param.stopWin;
catch
    stopWin = [];
end

try 
    stopLoss =  param.stopLoss;
catch
    stopLoss = [];
end

try
    WMStart = param.waterMarkStart;
    WMFall  = param.waterMarkFall;
catch
    WMStart = [];
    WMFall  = [];
end

try 
    flagDayEnd = param.flagDayEnd;
catch
    flagDayEnd = [];
end



for iT  = 1:nTrade

    entryTime  = obj.entry(iT,2);
    entryPrice = obj.entry(iT,3);
    entryDirect = sign(obj.entry(iT,4));
    
    pointer = find(entryTime   < obj.time,1,'first');
    ExitFlag =0;
    
    while pointer <= length(obj.time) && ExitFlag ==0 
        if ~isempty(nT)
            timepass = obj.time(pointer) - entryTime;
            if timepass >= nT
                ExitFlag =1;
            end
        end

        if ~isempty(nB)
            barspass = sum(obj.time>entryTime && obj.time <= obj.time(pointer));
            
            if barspass >= nB
                ExitFlag =2;
            end
        end

       if ~isempty(stopLoss)
           
           if entryDirect ==1
               pctpnl = obj.bid(pointer)/entryPrice-1;
           else
               pctpnl = 1- obj.ask(pointer)/entryPrice;
           end
           
           if pctpnl <= stopLoss
               ExitFlag =3;
           end
           
           

       end

       if ~isempty(stopWin)
           if entryDirect ==1
               pctpnl = obj.bid(pointer)/entryPrice-1;
           else
               pctpnl = 1- obj.ask(pointer)/entryPrice;
           end
           
           if pctpnl >= stopLoss
               ExitFlag =4;
           end
        end

        if ~isempty(WMStart) && ~isempty(WMFall)
            if WMFlag ==0
                if entryDirect ==1
                    pctpnl = obj.bid(pointer)/entryPrice-1;
                    if pctpnl > WMStart
                        WMFlag = 1;
                        WMHigh = obj.bid(pointer);
                    end
                else
                    pctpnl = 1- obj.ask(pointer)/entryPrice;
                    if pctpnl > WMStart
                        WMFlag =1;
                        WMLow  =obj.ask(pointer);
                    end
                end
            else
                if entryDirect ==1
                    if obj.bid(pointer) >= WMHigh                        
                        WMHigh = obj.bid(pointer);
                    else
                        if (WMHigh - obj.bid(pointer))/ (WMHigh  - entryPrice) >= WMFall
                            ExitFlag = 5;
                        end
                    end
                else % direct  == -1
                    if obj.ask(pointer) <= WMLow
                        WMLow = obj.ask(pointer);
                    else
                        if  (obj.ask(pointer) - WMLow)/(entryPrice-WMLow ) >= WMFall
                            ExitFlag = 5;
                        end
                    end
                end     
            end
        end % end of watermark
        
         if pointer == length(obj.time)
             ExitFlag = 6; % 样本结束退出
         end
         
         if flagDayEnd
             if pointer+1 <= length(obj.time)
                 if floor(obj.time(pointer)) <= floor(obj.time(pointer+1))
                     ExitFlag = 7; % 日末平仓
                 end
             end
         end
         
        
        if ExitFlag ~= 0
            obj.exit(iT,2) = obj.time(pointer);
            if entryDirect ==1
                obj.exit(iT,3) = obj.bid(pointer); 
            else
                obj.exit(iT,3) = obj.ask(pointer);
            end
            obj.exit(iT,6) = ExitFlag;
        end

        
        pointer = pointer+1;
        
    end
    
end


