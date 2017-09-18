% script of setting indicator

indPointer = 1;
sigTest.indVal = [];
sigTest.indName = cell(0);


%% 自带信号触发机制的，主要以技术指标为主


% AC
nBar = [3:3:30];
mBar = [5:5:50];
for iN = 1:length(nBar)
    for jM = 1:length(mBar)
        if nBar(iN)<mBar(jM)
            [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Ac(sBars, nBar(iN), mBar(jM));
            sigTest.indName{indPointer} = ['tai2.ac_long_n=',num2str(nBar(iN)),'_m=',num2str(mBar(jM))];
            sigTest.indName{indPointer+1} = ['tai2.ac_short_n=',num2str(nBar(iN)),'_m=',num2str(mBar(jM))];
            indPointer = indPointer +2;
        end
    end
end

        
% Alligator
Fast = [3:3:12];
Mid  = [5:5:20];
Slow = [8:8:32];
Delta = 0.005:0.005:0.02;

for iN = 1:length(Fast)
    for jM = 1:length(Mid)
        for kO = 1:length(Slow)
            for lD = 1:length(Delta)
                if Fast(iN)<Mid(jM) && Mid(jM) <Slow(kO)
                    [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Alligator(sBars, Fast(iN), Mid(jM), Slow(kO), Delta(lD));
                    sigTest.indName{indPointer} = ['tai2.Alligator_long_fast=',num2str(Fast(iN)) ,'_mid=',num2str(Mid(jM)),'_slow=',num2str(Slow(kO)),'_delta=',num2str(Delta(lD))];
                    sigTest.indName{indPointer+1} = ['tai2.Alligator_short_fast=',num2str(Fast(iN)) ,'_mid=',num2str(Mid(jM)),'_slow=',num2str(Slow(kO)),'_delta=',num2str(Delta(lD))];
                    indPointer = indPointer +2;
                end
            end
        end
    end
end

% 
% % Aroon

% MACD
Short   = [3:3:30];
Long    = [5:5:50];
Compare = [5:5:15];
Type    = [1,2];

for iS = 1:length(Short)
    for iL = 1:length(Long)
        for iC = 1:length(Compare)
            for iT = 1:length(Type)
                if Short(iS)< Long(iL)
               [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Macd( sBars, Short(iS), Long(iL), Compare(iC), Type(iT));
               sigTest.indName{indPointer} = ['tai.macd_long_short=', num2str(Short(iS)), '_Long=',num2str(Long(iL)), '_Compare=',num2str(Compare(iC)), '_Type=',num2str(Type(iT))];
               sigTest.indName{indPointer+1} = ['tai.macd_short_short=', num2str(Short(iS)), '_Long=',num2str(Long(iL)), '_Compare=',num2str(Compare(iC)), '_Type=',num2str(Type(iT))];
               indPointer = indPointer+2;
                end
            end
        end
    end
end

% RSI
Long = [5:5:50];
Short = [3:3:30];
Type = [1,2];

for iL = 1:length(Long)
    for iS = 1:length(Short)
        for iT = 1:length(Type)
            if Long(iL)>Short(iS)
                [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Rsi(sBars, Long(iL), Short(iS), Type(iT));
                sigTest.indName{indPointer} = ['tai.Rsi_long_long=', num2str(Long(iL)), '_Short=',num2str(Short(iS)), '_Type=',num2str(Type(iT))];
                sigTest.indName{indPointer+1} = ['tai.Rsi_short_long=', num2str(Long(iL)), '_Short=',num2str(Short(iS)), '_Type=',num2str(Type(iT))];
                indPointer = indPointer+2;
            end
        end
    end
end

% KDJ
Thread1 = [10:10:40];
Thread2 = [60:10:90];
Nday = [5:5:50];
Type = [1,2];

for iT1 = 1:length(Thread1)
    for iT2 = 1:length(Thread2)
        for iN = 1:length(Nday)
            for iT = 1:length(Type)
                [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Kdj(sBars, Thread1(iT1), Thread2(iT2), Nday(iN),3,3,Type(iT));
                sigTest.indName{indPointer} = ['tai.Kdj_long_Thread1=', num2str(Thread1(iT1)), '_Thread2=',num2str(Thread2(iT2)),'_nday=',num2str(Nday(iN)), '_Type=',num2str(Type(iT))];
                sigTest.indName{indPointer+1} = ['tai.Kdj_short_Thread1=', num2str(Thread1(iT1)), '_Thread2=',num2str(Thread2(iT2)), '_nday=',num2str(Nday(iN)),'_Type=',num2str(Type(iT))];
                indPointer = indPointer+2;
                
            end
        end
    end
end

% Willr
Thread1 = [10:10:40];
Thread2 = [60:10:90];
Nday = [5:5:50];

for iT1 = 1:length(Thread1)
    for iT2 = 1:length(Thread2)
        for iN = 1:length(Nday)
            for iT = 1:length(Type)
                [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Willr(sBars,Nday(iN), Thread1(iT1), Thread2(iT2));
                sigTest.indName{indPointer} = ['tai.Willr_long_Thread1=', num2str(Thread1(iT1)), '_Thread2=',num2str(Thread2(iT2)),'_nday=',num2str(Nday(iN))];
                sigTest.indName{indPointer+1} = ['tai.Willr_short_Thread1=', num2str(Thread1(iT1)), '_Thread2=',num2str(Thread2(iT2)), '_nday=',num2str(Nday(iN))];
                indPointer = indPointer+2;
                
            end
        end
    end
end

% DMI
Lag  = [5:5:50];
Thread = [6:6:60];

for iL = 1:length(Lag)
    for iT = 1:length(Thread)
         [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Dmi(sBars, Lag(iL), Thread(iT));
         sigTest.indName{indPointer} = ['tai.DMI_long_Thread=', num2str(Thread(iT)), '_lag=',num2str(Lag(iL))];
         sigTest.indName{indPointer+1} = ['tai.DMI_short_Thread=', num2str(Thread(iT)), '_lag=',num2str(Lag(iL))];               
         indPointer = indPointer+2;        
    end
end

% MFI
Nday = [5:5:50];
for iN = 1:length(Nday)
    temp_rs = tai2.Mfi(sBars,Nday(iN));
    [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = pos2trade(temp_rs);
    sigTest.indName{indPointer} = ['tai.Mfi_long_Nday=', num2str(Nday(iN))];
    sigTest.indName{indPointer+1} = ['tai.Mfi_short_Nday=', num2str(Nday(iN))];
    indPointer = indPointer+2;
end

% Aroon
Nday = [5:5:50];
Up   = [60:10:90];
Low  = [10:10:40];
for iU = 1:length(Up)
    for iL = 1:length(Low)
        for iN = 1:length(Nday)
                [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Aroon(sBars,Nday(iN), Up(iU), Low(iL));
                sigTest.indName{indPointer} = ['tai.Aroon_long_Nday=', num2str(Nday(iN)), '_Upband=',num2str(Up(iU)),'_Lowband=',num2str(Low(iL))];
                sigTest.indName{indPointer+1} = ['tai.Aroon_short_Nday=', num2str(Nday(iN)), '_Upband=',num2str(Up(iU)),'_Lowband=',num2str(Low(iL))];
                indPointer = indPointer+2;
        end
    end
end

% Asi
Nday = [5:5:50];
for iN = 1:length(Nday)
    [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Asi(sBars,Nday(iN));
    sigTest.indName{indPointer} = ['tai.Asi_long_Nday=', num2str(Nday(iN))];
    sigTest.indName{indPointer+1} = ['tai.Asi_short_Nday=', num2str(Nday(iN))];
    indPointer = indPointer+2;
end

% SAR
Step = [0.01:0.01:0.05];
Max  = [0.1:0.1:0.5];

for iS = length(Step)
    for iM = length(Max)
         [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Sar(sBars, Step(iS), Max(iM));
         sigTest.indName{indPointer} = ['tai.Sar_long_step=', num2str(Step(iS)), '_max=',num2str(Max(iM))];
         sigTest.indName{indPointer+1} = ['tai.Sar_short_step=', num2str(Step(iS)), '_max=',num2str(Max(iM))];
         indPointer = indPointer+2;
        
    end
end

% Mtm
Nday = [5:5:50];
for iN = 1:length(Nday)
    [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Mtm(sBars,Nday(iN));
    sigTest.indName{indPointer} = ['tai.Mtm_long_Nday=', num2str(Nday(iN))];
    sigTest.indName{indPointer+1} = ['tai.Mtm_short_Nday=', num2str(Nday(iN))];
    indPointer = indPointer+2;
end

% Bias
Nday = [5:5:50];
for iN = 1:length(Nday)
    temp_rs = tai2.Bias(sBars,Nday(iN));
    [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = pos2trade(temp_rs);
    sigTest.indName{indPointer} = ['tai.Bias_long_Nday=', num2str(Nday(iN))];
    sigTest.indName{indPointer+1} = ['tai.Bias_short_Nday=', num2str(Nday(iN))];
    indPointer = indPointer+2;
end

% CMF
Lag  = [5:5:50];
Thread = [0.05:0.05:0.4];

for iL = 1:length(Lag)
    for iT = 1:length(Thread)
        temp_rs = tai2.Cmf(sBars, Lag(iL), Thread(iT));
         [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = pos2trade(temp_rs);
         sigTest.indName{indPointer} = ['tai.CMF_long_Thread=', num2str(Thread(iT)), '_nDay=',num2str(Lag(iL))];
         sigTest.indName{indPointer+1} = ['tai.CMF_short_Thread=', num2str(Thread(iT)), '_nDay=',num2str(Lag(iL))];               
         indPointer = indPointer+2;        
    end
end

% Force
Lag  = [5:5:50];
Thread = 30:10:70;

for iL = 1:length(Lag)
    for iT = 1:length(Thread)
        temp_rs = tai2.Force(sBars, Lag(iL), Thread(iT));
         [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = pos2trade(temp_rs);
         sigTest.indName{indPointer} = ['tai.Force_long_Thread=', num2str(Thread(iT)), '_nDay=',num2str(Lag(iL))];
         sigTest.indName{indPointer+1} = ['tai.Force_short_Thread=', num2str(Thread(iT)), '_nDay=',num2str(Lag(iL))];               
         indPointer = indPointer+2;        
    end
end

% Tsi
Short = [3:3:30];
Long = [5:5:50];

for iL = 1:length(Long)
    for iS = 1:length(Short)
            if Long(iL)>Short(iS)
                temp_rs = tai2.Tsi(sBars, Short(iS), Long(iL) );
                [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = pos2trade(temp_rs);
                sigTest.indName{indPointer} = ['tai.Tsi_long_short=', num2str(Short(iS)), '_long=',num2str(Long(iL)) ];
                sigTest.indName{indPointer+1} = ['tai.Tsi_short_Short=', num2str(Short(iS)), '_long=',num2str(Long(iL)) ];
                indPointer = indPointer+2;
            end
    end
end

% Trix
Short = [3:3:30];
Long = [5:5:50];

for iL = 1:length(Long)
    for iS = 1:length(Short)
            if Long(iL)>Short(iS)                
                [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] =  tai2.Trix(sBars, Short(iS), Long(iL) );
                sigTest.indName{indPointer} = ['tai.Trix_long_short=', num2str(Short(iS)), '_long=',num2str(Long(iL)) ];
                sigTest.indName{indPointer+1} = ['tai.Trix_short_Short=', num2str(Short(iS)), '_long=',num2str(Long(iL)) ];
                indPointer = indPointer+2;
            end
    end
end

% LeadLag
Short = [5:5:50];
Long = [10:10:200];

for iL = 1:length(Long)
    for iS = 1:length(Short)
            if Long(iL)>Short(iS)                
                [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] =  tai2.Leadlag(sBars, Short(iS), Long(iL) );
                sigTest.indName{indPointer} = ['tai.Leadlag_long_short=', num2str(Short(iS)), '_long=',num2str(Long(iL)) ];
                sigTest.indName{indPointer+1} = ['tai.Leadlag_short_Short=', num2str(Short(iS)), '_long=',num2str(Long(iL)) ];
                indPointer = indPointer+2;
            end
    end
end

% PSY
Short = [5:5:50];
Long = [10:10:200];

for iL = 1:length(Long)
    for iS = 1:length(Short)
            if Long(iL)>Short(iS)                
                [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] =  tai2.Psy(sBars, Short(iS), Long(iL) );
                sigTest.indName{indPointer} = ['tai.Psy_long_short=', num2str(Short(iS)), '_long=',num2str(Long(iL)) ];
                sigTest.indName{indPointer+1} = ['tai.Psy_short_Short=', num2str(Short(iS)), '_long=',num2str(Long(iL)) ];
                indPointer = indPointer+2;
            end
    end
end

% Bbi
Lag1 = [3:3:12];
Lag2 = [5:5:20];
Lag3 = [8:8:32];
Lag4 = [13:13:52];
for iL1 = 1:length(Lag1)
    for iL2 = 1:length(Lag2)
        for iL3 = 1:length(Lag3)
            for iL4 = 1:length(Lag4)
                if Lag1(iL1)<Lag2(iL2) && Lag2(iL2)<Lag3(iL3) && Lag3(iL3)<Lag4(iL4)
                    [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] =  tai2.Bbi(sBars, Lag1(iL1), Lag2(iL2), Lag3(iL3), Lag4(iL4));
                    sigTest.indName{indPointer} = ['tai2.Bbi_long_lag1=', num2str(Lag1(iL1)), '_lag2=',num2str(Lag2(iL2)),'_lag3=',num2str(Lag2(iL3)),'_lag4=',num2str(Lag2(iL4)) ];
                    sigTest.indName{indPointer+1} = ['tai2.Bbi_short_lag1=', num2str(Lag1(iL1)), '_lag2=',num2str(Lag2(iL2)),'_lag3=',num2str(Lag2(iL3)),'_lag4=',num2str(Lag2(iL4)) ];
                    indPointer = indPointer+2;
                    
                end
            end
        end
    end
end

%
Wsize = [5:5:20];
Wts  = [0,1];
Nstd = [1.5:0.5:3];
Wlow = [5:5:20];
Type = [1,2];

for iWs = 1:length(Wsize)
    for iWt = 1:length(Wts)
        for iN = 1:length(Nstd)
            for iWl = 1:length(Wlow)
                for iT = 1:length(Type)
                    [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] =  tai2.Bollinger(sBars, Wsize(iWs), Wts(iWt), Nstd(iN), Wlow(iWl), Type(iT));
                    sigTest.indName{indPointer} = ['tai2.Bollinger_long_Wsize=', num2str(Wsize(iWs)), '_Wts=',num2str(Wts(iWt)),'_Nstd=',num2str(Nstd(iN)),'_Type=',num2str(Type(iT)) ];
                    sigTest.indName{indPointer+1} = ['tai2.Bollinger_short_Wsize=', num2str(Wsize(iWs)), '_Wts=',num2str(Wts(iWt)),'_Nstd=',num2str(Nstd(iN)),'_Type=',num2str(Type(iT)) ];
                    indPointer = indPointer+2;
                end
            end
        end
    end
end

% PVT
Nday = [5:5:50];
for iN = 1:length(Nday)
    [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Pvt(sBars,Nday(iN));
    sigTest.indName{indPointer} = ['tai.Pvt_long_Nday=', num2str(Nday(iN))];
    sigTest.indName{indPointer+1} = ['tai.Pvt_short_Nday=', num2str(Nday(iN))];
    indPointer = indPointer+2;
end

% Cle
Up   = [0.03:0.03:0.12];
Low  = [0.03:0.03:0.12];
for iU = 1:length(Up)
    for iL = 1:length(Low)
                [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = tai2.Cle(sBars,Up(iU), Low(iL));
                sigTest.indName{indPointer} = ['tai2.Cle_long_muUp=',num2str(Up(iU)),'_muDown=',num2str(Low(iL))];
                sigTest.indName{indPointer+1} = ['tai2.Cle_short_muUp=',num2str(Up(iU)),'_muDown=',num2str(Low(iL))];
                indPointer = indPointer+2;
    end
end

% Cci
Tp =5:5:50;
Md =5:5:50;
Const = 0.001:0.0005:0.004;
for iT = 1:length(Tp)
    for iM = 1:length(Md)
        for iC = 1:length(Const)
            temp_rs = tai2.Cci(sBars, Tp(iT), Md(iM), Const(iC));
            [sigTest.indVal(:,indPointer), sigTest.indVal(:,indPointer+1)] = pos2trade(temp_rs);
            sigTest.indName{indPointer} = ['tai2.Cci_long_Tp=',num2str(Tp(iT)),'_Md=',num2str(Md(iM)), '_Const',num2str(Const(iC))];
            sigTest.indName{indPointer+1} = ['tai2.Cci_short_Tp=',num2str(Tp(iT)),'_Md=',num2str(Md(iM)), '_Const',num2str(Const(iC))];
            indPointer = indPointer+2;
        end
    end
end

%         [ sig_rs ]                      = Obv( sBars, type);




