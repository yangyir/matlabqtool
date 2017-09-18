%% ��һ���򵥵��������ʽ�ȽϺÿ�)����ͨ������һ��nav���е�ָ�궼�����



%% �ý���һ��nav��yield

% nav
% b
% navyield=evl.Nav2Yield(nav);
% byield=evl.Nav2Yield(b);


%% ��

    
aYield  = evl.annualYield(nav);
        
aVol    = evl.annualVol( nav);
 
alpha   = evl.alpha(nav,b);

beta    = evl.beta(nav,b);



maxConGainTime = evl.maxConGainTime( nav);
      
mddVal         = evl.maxDrawDownVal(nav);

sharpeR        = evl.SharpeRatio( nav);
        
calmarRatio    = evl.CalmarRatio( nav);

burkeR         = evl.BurkeRatio(nav);
        
sortinoR       = evl.SortinoRatio(nav,b);
       
treynorR       = evl.TreynorRatio( nav, b);
       
infoRatio      = evl.InfoRatio( nav, b);

       
        
       
        
      
     
       
       
        



%% ��������ְ汾

fprintf('Annual Yield�� %0.2f\n', aYield,aVol);


%% �����word��

fileID=fopen('review.txt','w');
fprintf(fileID,'\n Annual Yield�� %0.2f\n', aYield);
fprintf(fileID,'\n Annual Volatility�� %0.2f\n', aVol);
fprintf(fileID,'\n Alpha�� %0.2f\n', alpha);
fprintf(fileID,'\n Beta�� %0.2f\n', beta);
fprintf(fileID,'\n MaxConGainTime�� %0.2f\n', maxConGainTime);
fprintf(fileID,'\n MddVal�� %0.2f\n', mddVal);
fprintf(fileID,'\n MddVal�� %0.2f\n', mddVal);
fprintf(fileID,'\n MddVal�� %0.2f\n', mddVal);
fprintf(fileID,'\n MddVal�� %0.2f\n', mddVal);
fprintf(fileID,'\n SharpeRatio�� %0.2f\n', sharpeR);
fprintf(fileID,'\n CalmarRatio�� %0.2f\n', calmarRatio);
fprintf(fileID,'\n Information ratio�� %0.2f\n', infoRatio);


%% ��ͼ
evl.plotSimple(nav, b)
evl.plotNavBmk(nav, b)

