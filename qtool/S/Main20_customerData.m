%% 附加数据——定制数据
% data2只是一个容器作用
% 注意1：所有的变量命名必须是 data2.****Mat = ..... 
% 注意2：在写s时， 直接用 **** 引用这一变量
% 注意3：必须是 日期（纵） * 股票（横）格式，大多需要转置
% 注意4：必须是double mat，有的是int32，有的是cell，要转换
% -----
% 程刚；20140914




% 是否重新取数据（如未改变span和universe则不需重新取）
% 0 - 不重新load，也不重新fetch （最省时间）
% 1 - 重新load  ***.mat（隔夜工作储存，可以事先储存好几套环境）
% 2 - 重新dhfetch（有改变就要重来，极其慢）
switch fetchData2Flag 
     case {0}
        % 0 - 不重新load，也不重新fetch （最省时间）
        % do nothing
    case {1}
        % 1 - 重新load  ***.mat（隔夜工作储存，可以事先储存好几套环境）
        load data2;
    case {2}
    
    %% 里面是客户自己取数据的地方
    data2.epsDilutedMat = DH_S_FA_I_PS_FaEPSDiluted(stockArr,dateArr)';
    % % 净资产收益率ROE-扣除非经常损益
    data2.roeDeductedMat = DH_S_FA_I_EA_FaROEDeducted(stockArr,dateArr)';
    data2.revenueYoyMat = DH_S_FA_I_GR_FaYoyOr(stockArr,dateArr)';
    % data2.targetPxMat = DH_S_EST_PRICE_TARGETPRICE(stockArr,dateArr,30,1)';
    
    % PE
    
    
    
    
%     data2.ratingMat = cell2mat( DH_S_EST_RATING_AVG(stockArr,dateArr,30,2)' );
%     data2.ratingNumMat = double( DH_S_EST_RATING_NUM(stockArr,dateArr,30,1)' );
%     
%     % 这些取出来时int32，要转成double
%     data2.shouciRatingNumMat    = double( DH_S_EST_RATING_NUM(stockArr,dateArr,30,1)' );
%     data2.ascendRatingNumMat    = double( DH_S_EST_RATING_NUM(stockArr,dateArr,30,2)' );
%     data2.drawRatingNumMat      = double( DH_S_EST_RATING_NUM(stockArr,dateArr,30,3)' );
%     data2.descendRatingNumMat   = double( DH_S_EST_RATING_NUM(stockArr,dateArr,30,4)' );
    




%% 以后的代码客户不要动
save('data2.mat', 'data2');
end