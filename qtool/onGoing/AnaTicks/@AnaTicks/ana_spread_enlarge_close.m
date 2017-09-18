function [ output_args ] = ana_spread_enlarge_close( input_args )
%% 说明
% 配合onenote：spread张口和闭口的方式
% 已完成
% 程刚；1405


%%
clear;
clc;
rehash;


%% configuration


WORKING_PATH = 'F:\LHB\temp\s2\';


%% 取日度tick数据
t = 1;
clear arrDate arrTicks;
tic
for yy = 2013:2013
for mm = 2:2
for dd = 1:31
    tday    = datenum(yy,mm,dd);
    sdt     = datestr(tday,'yyyymmdd');
    ticks   = Fetch.dmTicks('IFHot',sdt,sdt);
    p       = ticks.last;
    if isempty(p), continue; end    
    % 记录
    arrDate(t)  = tday;
    arrTicks(t) = ticks;
    t = t+1;
end
end
end
toc


%% 分析
for idt = 1:length(arrDate)
    tday = uni_dt( idt );    
    dtstr = datestr(tday,'yyyymmdd');
    
    ticks = arrTicks(idt);
    S = ticks.last;  
    len = ticks.latest; %length(S);    
    sigma = std(S);
    

    
    bid = ticks.bidP(:,1);
    ask = ticks.askP(:,1);
    ask_bid_spread = ask - bid;
    askV = ticks.askV(:,1);
    bidV = ticks.bidV(:,1);
    
    
    vo = ticks.volume;
    dvo = [vo(1); diff(vo)];

    
    
    
    %% 分类看
    % 同时上升类
    ind = ask_bid_spread >=1;

    
    dask = [0;diff(ask)]; dbid = [0;diff(bid)];
    au = dask>0; ad = dask<0; af = dask==0;
    bu = dbid>0; bd = dbid<0; bf = dbid==0;
        
    
    spreadMat = [au&bu, au&bf, au&bd, af&bu,  af&bf, af&bd, ad&bu, ad&bf, ad&bd, ];
    col = size(spreadMat,2);
    
    
    spreadMat_post = [spreadMat(2:end, :);zeros(1,col)];
    
    
    encur = zeros(col+1,col+1);
    rectk = cell(col, col);

    
    for i = 1:col
        for j = 1:col
            encur(i,j) = sum(ind & spreadMat(:,i) & spreadMat_post(:,j));
            indtmp = ind & spreadMat(:,i) & spreadMat_post(:,j);
            rectk{i,j} = find(indtmp==1);
            ts_rectk{i,j,t} = find(indtmp==1);
            
            % 画图
%             if i==1 && j==1 
%                 figure(106); hold off;
%                 ts.plotind(indtmp, '==1','or');
%                 hold on;
%                 ts.plotind([0;indtmp(1:end-1)], '==1','*r');
%                 [ax,h1,h2]=plotyy(1:len, [ask, bid], 1:len, ask_bid_spread,@plot,@bar);
%                 
%                 set(h2,'facecolor','y','edgecolor','y');
%                 YMX = max(ask_bid_spread); set(ax(2),'ylim',[0.8, YMX*2]);
%                 
%                 title(sprintf('%s, sigma%0.1f, sum%d' ,dtstr, sigma, sum(indtmp) ));
%                 legend('abs>=1', 'last', 'ask','bid','abspread');
%                 atr=0;
%             end
            
        end
    end
    
    % 扩充，把边缘求和加进来
    encur(col+1,:) = sum(encur,1);
    encur(:,col+1) = sum(encur,2);
    

    
%     ts_rec{:,:,t} = rectk{:,:};
    ts_date{t} = dtstr;
    ts_encur(:,:,t) = encur(:,:);
    t= t+1;
end

%% save
save( 'tmpresult.mat', 'ts_encur', 'ts_rectk', 'ts_date');

%% 对ts_encur作处理

for i = 1:col+1
    for j=1:col+1
        avg(i,j) = mean(ts_encur(i,j,:));
        stdv(i,j) = std(ts_encur(i,j,:));
        mm(i,j) = max(ts_encur(i,j,:));
        mn(i,j) = min(ts_encur(i,j,:));
    end
end


% 每日总数
ts_N = zeros(t-1,1);
ts_N(:) = ts_encur(col+1, col+1, :);

figure;
bar(ts_N);

% 概率
prob = avg/avg(col+1,col+1)*100;
for i = 1:col+1
prob_v(:,i) = avg(:,i)/avg(10,i)*100;
prob_h(i,:) = avg(i,:)/avg(i,10)*100;
end


end

