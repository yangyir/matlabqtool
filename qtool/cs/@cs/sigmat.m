function [sigmat] = sigmat( bars,flag )
%SIGMAT         生成技术指标矩阵
%
% version 1.0, luhuaibao, 2013 08 29
% version 1.1, luhuaibao, 2013 08 30, 增加flag，1为开仓信号，2为持仓信号
switch flag
    case 1
        
        %-----------------------------------------
        [sig_long, sig_short]           = tai2.Ac(bars )                     ;
        sig_Ac = sig_long + sig_short;
        
        sigmat.signame{1,1} = 'Ac';
        sigmat.sig(:,1) = sig_Ac;
        %-----------------------------------------
        [sig_long, sig_short]          = tai2.Alligator(bars)               ;
        sig_Alligator = sig_long + sig_short;
        
        
        sigmat.signame{2,1} = 'Alligator';
        sigmat.sig(:,2) = sig_Alligator;
        
        
        %-----------------------------------------
        [ sig_long, sig_short, sig_rs ] = tai2.Aroon(bars )                  ;
        sig_Aroon = sig_long + sig_short;
        
        sigmat.signame{3,1} = 'Aroon';
        sigmat.sig(:,3) = sig_Aroon;
        
        %-----------------------------------------
        [sig_long, sig_short]           = tai2.Asi(bars )                     ;
        sig_Asi = sig_long + sig_short;
        
        sigmat.signame{4,1} = 'Asi';
        sigmat.sig(:,4) = sig_Asi;
        
        %-----------------------------------------
        [sig_long,sig_short, sig_rs]    = tai2.Bbi(bars )                    ;
        sig_Bbi = sig_long + sig_short;
        
        sigmat.signame{5,1} = 'Bbi';
        sigmat.sig(:,5) = sig_Bbi;
        
        %-----------------------------------------
        [sig_Bias]                        = tai2.Bias(bars )                   ;
        
        sigmat.signame{6,1} = 'Bias';
        sigmat.sig(:,6) = sig_Bias;
        
        %-----------------------------------------
        [ sig_long, sig_short, sig_rs]  = tai2.Bollinger( bars)              ;
        sig_Bollinger = sig_long + sig_short;
        
        sigmat.signame{7,1} = 'Bollinger';
        sigmat.sig(:,7) = sig_Bollinger;
        
        %-----------------------------------------
        [ sig_Cci ]                      = tai2.Cci( bars )                   ;
        
        sigmat.signame{8,1} = 'Cci';
        sigmat.sig(:,8) = sig_Cci;
        
        %-----------------------------------------
        
        [sig_Cmf]                        = tai2.Cmf (bars )                    ;
        
        sigmat.signame{9,1} = 'Cmf';
        sigmat.sig(:,9) = sig_Cmf;
        
        %-----------------------------------------
        [ sig_long, sig_short, sig_rs]  = tai2.Dmi( bars )                   ;
        sig_Dmi = sig_long + sig_short;
        
        sigmat.signame{10,1} = 'Dmi';
        sigmat.sig(:,10) = sig_Dmi;
        
        %-----------------------------------------
        [sig_Force]                        = tai2.Force(bars )                  ;
        
        sigmat.signame{11,1} = 'Force';
        sigmat.sig(:,11) = sig_Force;
        
        %-----------------------------------------
        [sig_long, sig_short, sig_rs]   = tai2.Kdj(bars )                    ;
        sig_Kdj = sig_long + sig_short;
        
        sigmat.signame{12,1} = 'Kdj';
        sigmat.sig(:,12) = sig_Kdj;
        
        %-----------------------------------------
        [sig_long, sig_short, sig_rs]   = tai2.Leadlag(bars )                ;
        sig_Leadlag = sig_long + sig_short;
        
        sigmat.signame{13,1} = 'Leadlag';
        sigmat.sig(:,13) = sig_Leadlag;
        
        %-----------------------------------------
        [ sig_long, sig_short, sig_rs]  = tai2.Macd( bars  )                 ;
        sig_Macd = sig_long + sig_short;
        
        sigmat.signame{14,1} = 'Macd';
        sigmat.sig(:,14) = sig_Macd;
        
        %-----------------------------------------
        [sig_Mfi]                        = tai2.Mfi(bars )                    ;
        
        sigmat.signame{15,1} = 'Mfi';
        sigmat.sig(:,15) = sig_Mfi;
        
        %-----------------------------------------
        [sig_long, sig_short  ]         = tai2.Mtm(bars )                    ;
        sig_Mtm = sig_long + sig_short;
        
        sigmat.signame{16,1} = 'Mtm';
        sigmat.sig(:,16) = sig_Mtm;
        
        %-----------------------------------------
        [ sig_Obv ]                      = tai2.Obv( bars )                   ;
        
        sigmat.signame{17,1} = 'Obv';
        sigmat.sig(:,17) = sig_Obv;
        
        %-----------------------------------------
        [sig_long, sig_short ]          = tai2.Psy(bars )                    ;
        sig_Psy = sig_long + sig_short;
        
        sigmat.signame{18,1} = 'Psy';
        sigmat.sig(:,18) = sig_Psy;
        
        %-----------------------------------------
        [sig_long, sig_short,sig_rs]    = tai2.Pvt(bars )                    ;
        sig_Pvt = sig_long + sig_short;
        
        sigmat.signame{19,1} = 'Pvt';
        sigmat.sig(:,19) = sig_Pvt;
        
        %-----------------------------------------
        [ sig_long, sig_short, sig_rs ] = tai2.Rsi(bars )                    ;
        sig_Rsi = sig_long + sig_short;
        
        sigmat.signame{20,1} = 'Rsi';
        sigmat.sig(:,20) = sig_Rsi;
        
        %-----------------------------------------
        [ sig_long,sig_short,sig_rs]    = tai2.Sar( bars )                   ;
        sig_Sar = sig_long + sig_short;
        
        sigmat.signame{21,1} = 'Sar';
        sigmat.sig(:,21) = sig_Sar;
        
        %-----------------------------------------
        [sig_long, sig_short, sig_rs]   = tai2.Trix (bars )                  ;
        sig_Trix = sig_long + sig_short;
        
        sigmat.signame{22,1} = 'Trix';
        sigmat.sig(:,22) = sig_Trix;
        
        %-----------------------------------------
        [sig_Tsi]                        = tai2.Tsi (bars )                   ;
        
        sigmat.signame{23,1} = 'Tsi';
        sigmat.sig(:,23) = sig_Tsi;
        
        %-----------------------------------------
        [sig_long, sig_short]           = tai2.Willr(bars )                  ;
        sig_Willr = sig_long + sig_short;
        
        sigmat.signame{24,1} = 'Willr';
        sigmat.sig(:,24) = sig_Willr;
        
        % ---------------------------------------------------------------------------end
        
    case 2

        


        %-----------------------------------------
        [sig_long, sig_short]           = tai2.Ac(bars )                     ;
        sig_Ac = trade2pos(sig_long,sig_short);
        
        sigmat.signame{1,1} = 'Ac';
        sigmat.sig(:,1) = sig_Ac;
        %-----------------------------------------
        [sig_long, sig_short]          = tai2.Alligator(bars)               ;
        sig_Alligator = trade2pos(sig_long,sig_short);
        
        
        sigmat.signame{2,1} = 'Alligator';
        sigmat.sig(:,2) = sig_Alligator;
        
        
        %-----------------------------------------
        [ sig_long, sig_short, sig_rs ] = tai2.Aroon(bars )                  ;
        sig_Aroon = trade2pos(sig_long,sig_short);
        
        sigmat.signame{3,1} = 'Aroon';
        sigmat.sig(:,3) = sig_Aroon;
        
        %-----------------------------------------
        [sig_long, sig_short]           = tai2.Asi(bars )                     ;
        sig_Asi = trade2pos(sig_long,sig_short);
        
        sigmat.signame{4,1} = 'Asi';
        sigmat.sig(:,4) = sig_Asi;
        
        %-----------------------------------------
        [sig_long,sig_short, sig_rs]    = tai2.Bbi(bars )                    ;
        sig_Bbi = trade2pos(sig_long,sig_short);
        
        sigmat.signame{5,1} = 'Bbi';
        sigmat.sig(:,5) = sig_Bbi;
        
        %-----------------------------------------
        [sig_Bias]                        = tai2.Bias(bars )                   ;
        
        sigmat.signame{6,1} = 'Bias';
        sigmat.sig(:,6) = sig_Bias;
        
        %-----------------------------------------
        [ sig_long, sig_short, sig_rs]  = tai2.Bollinger( bars)              ;
        sig_Bollinger = trade2pos(sig_long,sig_short);
        
        sigmat.signame{7,1} = 'Bollinger';
        sigmat.sig(:,7) = sig_Bollinger;
        
        %-----------------------------------------
        [ sig_Cci ]                      = tai2.Cci( bars )                   ;
        
        sigmat.signame{8,1} = 'Cci';
        sigmat.sig(:,8) = sig_Cci;
        
        %-----------------------------------------
        
        [sig_Cmf]                        = tai2.Cmf (bars )                    ;
        
        sigmat.signame{9,1} = 'Cmf';
        sigmat.sig(:,9) = sig_Cmf;
        
        %-----------------------------------------
        [ sig_long, sig_short, sig_rs]  = tai2.Dmi( bars )                   ;
        sig_Dmi = trade2pos(sig_long,sig_short);
        
        sigmat.signame{10,1} = 'Dmi';
        sigmat.sig(:,10) = sig_Dmi;
        
        %-----------------------------------------
        [sig_Force]                        = tai2.Force(bars )                  ;
        
        sigmat.signame{11,1} = 'Force';
        sigmat.sig(:,11) = sig_Force;
        
        %-----------------------------------------
        [sig_long, sig_short, sig_rs]   = tai2.Kdj(bars )                    ;
        sig_Kdj = trade2pos(sig_long,sig_short);
        
        sigmat.signame{12,1} = 'Kdj';
        sigmat.sig(:,12) = sig_Kdj;
        
        %-----------------------------------------
        [sig_long, sig_short, sig_rs]   = tai2.Leadlag(bars )                ;
        sig_Leadlag = trade2pos(sig_long,sig_short);
        
        sigmat.signame{13,1} = 'Leadlag';
        sigmat.sig(:,13) = sig_Leadlag;
        
        %-----------------------------------------
        [ sig_long, sig_short, sig_rs]  = tai2.Macd( bars  )                 ;
        sig_Macd = trade2pos(sig_long,sig_short);
        
        sigmat.signame{14,1} = 'Macd';
        sigmat.sig(:,14) = sig_Macd;
        
        %-----------------------------------------
        [sig_Mfi]                        = tai2.Mfi(bars )                    ;
        
        sigmat.signame{15,1} = 'Mfi';
        sigmat.sig(:,15) = sig_Mfi;
        
        %-----------------------------------------
        [sig_long, sig_short  ]         = tai2.Mtm(bars )                    ;
        sig_Mtm = trade2pos(sig_long,sig_short);
        
        sigmat.signame{16,1} = 'Mtm';
        sigmat.sig(:,16) = sig_Mtm;
        
        %-----------------------------------------
        [ sig_Obv ]                      = tai2.Obv( bars )                   ;
        
        sigmat.signame{17,1} = 'Obv';
        sigmat.sig(:,17) = sig_Obv;
        
        %-----------------------------------------
        [sig_long, sig_short ]          = tai2.Psy(bars )                    ;
        sig_Psy = trade2pos(sig_long,sig_short);
        
        sigmat.signame{18,1} = 'Psy';
        sigmat.sig(:,18) = sig_Psy;
        
        %-----------------------------------------
        [sig_long, sig_short,sig_rs]    = tai2.Pvt(bars )                    ;
        sig_Pvt = trade2pos(sig_long,sig_short);
        
        sigmat.signame{19,1} = 'Pvt';
        sigmat.sig(:,19) = sig_Pvt;
        
        %-----------------------------------------
        [ sig_long, sig_short, sig_rs ] = tai2.Rsi(bars )                    ;
        sig_Rsi = trade2pos(sig_long,sig_short);
        
        sigmat.signame{20,1} = 'Rsi';
        sigmat.sig(:,20) = sig_Rsi;
        
        %-----------------------------------------
        [ sig_long,sig_short,sig_rs]    = tai2.Sar( bars )                   ;
        sig_Sar = trade2pos(sig_long,sig_short);
        
        sigmat.signame{21,1} = 'Sar';
        sigmat.sig(:,21) = sig_Sar;
        
        %-----------------------------------------
        [sig_long, sig_short, sig_rs]   = tai2.Trix (bars )                  ;
        sig_Trix = trade2pos(sig_long,sig_short);
        
        sigmat.signame{22,1} = 'Trix';
        sigmat.sig(:,22) = sig_Trix;
        
        %-----------------------------------------
        [sig_Tsi]                        = tai2.Tsi (bars )                   ;
        
        sigmat.signame{23,1} = 'Tsi';
        sigmat.sig(:,23) = sig_Tsi;
        
        %-----------------------------------------
        [sig_long, sig_short]           = tai2.Willr(bars )                  ;
        sig_Willr = trade2pos(sig_long,sig_short);
        
        sigmat.signame{24,1} = 'Willr';
        sigmat.sig(:,24) = sig_Willr;
        
        % ---------------------------------------------------------------------------end
        

end;

save('sigmat.mat','sigmat');


end

