function [ paxis, defense, mark ] = generate_absolute_levels( b )
%GENERATE_ABSOLUTE_LEVELS 此处显示有关此函数的摘要
% 输出：
% paxis ： 绝对价格坐标
% defense： 挂单量，在绝对坐标上*时间
% mark :    挂单量的性质，0-预估，1-ask，2-bid
% ------------------
% 程刚, 201608




%% 基础处理
Tb = length(b.last);
 
% plot(b.close)
% 
% figure(101); hold off
% plot(b.askP1);
% hold on;
% plot(b.bidP1);

midP = (b.askP(:,1) + b.bidP(:,1)) /2;
II1 = find(midP>0.01, 1, 'first') + 1;
II2 = find(b.askP(:,10)>0, 1, 'first') + 1;
II3 = find(b.bidP(:,10)>0, 1, 'first') + 1;
II = max( [ II1, II2, II3 ] );

% RG = [ min(midP(II:end)), max(midP) ];
% RGpct = 2 * (RG(2) - RG(1)) / sum(RG);
% RGtk = round ( (RG(2) - RG(1)) / 0.01 );


%% 建立绝对坐标，看防守的变化
mx = round( max(b.askP(:,10)) *100 );
mn = round( min(b.bidP(II:end, 10)) *100 );
paxis = mn:mx;
NP = length(paxis);

% 绝对坐标的输出矩阵
defense = nan(Tb, NP);
mark = zeros(Tb, NP);   % 0 - 不确定，不可见，最后一次观察值


% 把b灌入绝对坐标矩阵
tic
% 逐时间tick灌入
for iT = II:Tb
    thisline = nan(1, NP);    
    
    % ja，jb是10档的绝对坐标值
    ja = round( b.askP(iT, :) * 100 - mn + 1 );
    jb = round( b.bidP(iT, :) * 100 - mn + 1 );
   
    
    % 由于挂单稀疏，有空档，j的跨度可能大于10档
    % j跨度内的空档是真实的
    defense(iT, jb(end):ja(end) ) = 0;
    defense(iT, ja ) = b.askQ(iT, :);
    defense(iT, jb ) = b.bidQ(iT, :);

    mark(iT, ja(1):ja(end)) = 1;
    mark(iT, jb(end):jb(1)) = 2;
    

    % 下一行也要写进去，作为“历史影子”
    if iT< Tb
        defense(iT + 1, : ) = defense(iT, :);
    end
    
end
toc



end


