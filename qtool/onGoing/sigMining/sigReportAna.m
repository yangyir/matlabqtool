% summary of signal report

% clear;clc;
% % package
% addpath(genpath('V:\root\qtool\data\'));
% addpath(genpath('V:\root\qtool\framework'));
% addpath(genpath('v:\root\qtool\indicator'));
% 
% % sample cache path
% cachepath = 'd:\huajun\focus\sigMining\cache\';
% filelist  = ls(cachepath);
% filelist(1:2,:) = []; % remove . and ..
% cd(cachepath)
% 
% nFile = size(filelist,1);
% 
% reportList = {'sigReport1','sigReport2','sigReport3','sigReport4','sigReport5','sigReport6'};

% % rename report catagory
% for iF = 1:nFile
%     filename = filelist(nFile,:);
%     load(filename);
%     
%     for iR = 1:6
%         eval( [ 'temp_report =' reportList{iR} ] );
%         for iCat = 1:length(temp_report.catagory)
%             if iscell(temp_report.catagory{iCat,1})
%                 
%                 temp_report.catagory{iCat,1} = cell2mat(temp_report.catagory{iCat,1});
%             
%             end
%         end
%         eval( [ reportList{iR}  '= temp_report']);
%     end
%     
%     save(filename, 'sigReport*','-append');
% 
% end

% summary table by stock

% summary.data =[];
% summary.catagory ={};
% summary.sample ={};
% summary.nBars = [];
% pStart = 1;
% 
% 
% for iF = 1:nFile
%     filename = filelist(nFile,:);
%     load(filename);
% 
%     for iR = 1:6
%         eval( [ 'temp_report =' reportList{iR}; ] );
%         len = length(temp_report.catagory);
%         pEnd = pStart+len-1;
%         
%         summary.data(pStart:pEnd,:) = temp_report.value;
%         
%         
%         
%         summary.catagory(pStart:pEnd,:)=temp_report.catagory;
%         summary.sample(pStart:pEnd,:) = cellstr(filename(1:28));
%         summary.nBars(pStart:pEnd,:) = iR;
%         
%         pStart = pEnd+1;
%     end
% 
% end

% % report result by catagory
% [cat, ix,iy] = unique(summary.catagory(:,1));
% nCat = length(cat);
% 
% summary_cat.name = {};
% summary_cat.nPerDay = [];
% summary_cat.prcPerDay = [];
% summary_cat.prcUp = [];
% summary_cat.prcDown = [];
% summary_cat.mean = [];
% summary_cat.median = [];
% summary_cat.std =[];
% summary_cat.skew =[];
% summary_cat.kurt = [];
% 
% pNow = 1;
% for iCat = 1:nCat
% 
%     idx_cat = find(iy==iCat);
%     temp_cat_data = summary.data(idx_cat,:);
%     temp_cat_nBars = summary.nBars(idx_cat);
% 
%     for iR = 1:6
%         idx_nBars = find(temp_cat_nBars ==iR);
%         
%         temp_data = temp_cat_data(idx_nBars,:);
%         if iR ==1
%             summary_cat.name{pNow}  = cat{iCat};
%         end
%         
%         summary_cat.nPerDay(pNow,iR)     = mean(temp_data(:,1));
%         summary_cat.prcPerDay(pNow,iR)   =  mean(temp_data(:,2));
%         summary_cat.prcUp(pNow,iR)       =  mean(temp_data(:,3));
%         summary_cat.prcDown(pNow,iR)     =  mean(temp_data(:,4));
%         summary_cat.mean(pNow,iR)        =  mean(temp_data(:,5));
%         summary_cat.median(pNow,iR)      =  mean(temp_data(:,6));
%         summary_cat.std(pNow,iR)         = mean(temp_data(:,7));
%         summary_cat.skew(pNow,iR)        = mean(temp_data(:,8));
%         summary_cat.kurt(pNow,iR)        =  mean(temp_data(:,9));
% 
%     end
%     pNow = pNow+1;
%   
% end

% measures = fieldnames(summary_cat);
% holdmin  = {'1分钟','5分钟','15分钟','30分钟','60分钟','180分钟'};
% 
% for iM = 2:length(measures)
%     figure(iM);
%     set(iM,'name',measures{iM},'Numbertitle','off')
%     for iCol = 1:length(holdmin)
%         subplot(2,3,iCol);
%         eval( ['hist( summary_cat.',measures{iM}  ,'(:,',num2str(iCol) ,  ' ) )       ;']        );
%         title(holdmin{iCol});
%         
%     end
%     saveas(iM, [ 'd:\huajun\focus\sigMining\分布_',measures{iM},'.jpg']);
% end
% 
% close all;

% 画出log(up/down prob)
% logUpDown = log(summary_cat.prcUp./summary_cat.prcDown);
% figure(2)
% set(2,'name','Up/Down的对数');
% for iCol = 1:length(holdmin)
%     subplot(2,3,iCol);
%     hist(logUpDown(:,iCol),100);
%     hold all
%     plot([0.5,0.5],[0,300],'r');
%     plot([-0.5,-0.5],[0,300],'r');
%     title(holdmin(iCol));
% end
% saveas(2,'分布_logUpDownPct.jpg');
%     

% 样本筛选条件
% n_valid = zeros(5,6);
% for iN  = 1:5 
% idx_validN = summary_cat.nPerDay>=iN;
% idx_validP = abs(logUpDown)>0.5;
% idx_validA = idx_validN & idx_validP;
% n_valid(iN,:) = sum(idx_validA);
% end
% 
% n_valid = zeros(5,6);
% winr = 0.5:0.05:0.95;
% crit = log(winr./(1-winr));
% 
% for iC  = 1:length(crit)
% idx_validN = summary_cat.nPerDay>=2;
% idx_validP = abs(logUpDown)>=crit(iC);
% idx_validA = idx_validN & idx_validP;
% n_valid(iC,:) = sum(idx_validA);
% end

% % 收益率分析
% rates = 0.001:0.0005:0.003;
% for iRate = 1:length(rates)
%     cRate = rates(iRate);
%     n_rate(iRate,:) = sum(abs(summary_cat.mean).*repmat([1,5,15,30,60,180], length(summary_cat.mean),1)>cRate);
%     n_rate_perdate(iRate,:) = mean(summary_cat.nPerDay.* (abs(summary_cat.mean).*repmat([1,5,15,30,60,180], length(summary_cat.mean),1)>cRate));
% end

% 给信号评分
summary_cat.score = summary_cat.nPerDay .* ...
       (abs(summary_cat.mean).*repmat([1,5,15,30,60,180], length(summary_cat.mean),1) ...
       - summary_cat.std.^2.*repmat([1,5,15,30,60,180].^2, length(summary_cat.mean),1) -0.001) * 30;
       
idx_validN = summary_cat.nPerDay >= 2;
idx_validP = abs(logUpDown) >= 0.2;
idx_validA = idx_validN & idx_validP;

figure(1);
set(1, 'name','score');


for iCol = 1:length(holdmin)
    subplot(2,3,iCol);
    hist(summary_cat.score(:,iCol),50);

    title(holdmin(iCol));
end
saveas(1, '分布_score_无筛选_惩罚.jpg');
    
figure(2);
set(2, 'name','score');
for iCol = 1:length(holdmin)
    subplot(2,3,iCol);
    hist(summary_cat.score(idx_validA(:,iCol),iCol),50);

    title(holdmin(iCol));
end
saveas(2, '分布_score_N=2_P=0.2_惩罚.jpg');

% 列出信号
idx_15 = find(summary_cat.score(idx_validA(:,3) ,3) >0);
list_15 = summary_cat.name(idx_15);


idx_5 = find(summary_cat.score(idx_validA(:,2) ,2) >0);
list_5 = summary_cat.name(idx_5);

figure
hist(summary_cat.score(:,3),50);


% 