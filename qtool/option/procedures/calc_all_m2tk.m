%% һ���Լ��㣬д�����м۸�m2tk
% ��ʱ��Ч�ʵ�


tic
SS = 2.291;
RR = 0.07;
for iT = 1:length(uTs)
    for iK = 1:length(uKs)
        KK = uKs(iK)/1000;
        TT = (uTdatenum(iT) - tday + 1) / 365;
        
        
        % д��call��
        try
            c_code = call.code.data{iT,iK};
            eval( ['c = l2prof.sh', c_code , ';'] );
            call.ask1.data(iT, iK ) = c.askP1;
            call.ask1vol.data(iT, iK) = blsimpv(SS, KK, RR, TT, c.askP1);
            call.bid1.data(iT, iK) = c.bidP1;
            call.bid1vol.data(iT, iK) = blsimpv(SS, KK, RR, TT, c.bidP1);
        catch
        end
        
        % д��put��
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



% ���һ��
call.ask1.data
call.ask1vol.data
put.ask1.data
put.ask1vol.data
