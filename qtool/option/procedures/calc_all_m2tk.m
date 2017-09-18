%% 一次性计算，写入所有价格m2tk
% 费时多效率低


tic
SS = 2.291;
RR = 0.07;
for iT = 1:length(uTs)
    for iK = 1:length(uKs)
        KK = uKs(iK)/1000;
        TT = (uTdatenum(iT) - tday + 1) / 365;
        
        
        % 写入call的
        try
            c_code = call.code.data{iT,iK};
            eval( ['c = l2prof.sh', c_code , ';'] );
            call.ask1.data(iT, iK ) = c.askP1;
            call.ask1vol.data(iT, iK) = blsimpv(SS, KK, RR, TT, c.askP1);
            call.bid1.data(iT, iK) = c.bidP1;
            call.bid1vol.data(iT, iK) = blsimpv(SS, KK, RR, TT, c.bidP1);
        catch
        end
        
        % 写入put的
        try
            p_code = put.code.data{iT, iK};
            eval( ['p = l2prof.sh' p_code ';'] );
            put.ask1.data(iT,iK) = p.askP1;
            put.ask1vol.data(iT,iK) = blsimpv(SS, KK, RR, TT, p.askP1,10,0,[],{'put'});
            put.bid1.data(iT,iK) = p.bidP1;
            put.bid1vol.data(iT,iK) = blsimpv(SS, KK, RR, TT, p.bidP1,10,0,[],{'put'});
        catch
        end
        
    end
end
toc



% 输出一次
call.ask1.data
call.ask1vol.data
put.ask1.data
put.ask1vol.data
