function  biasVal= bias(ClosePrice,nDay)
% bias 乖离率
% default nDay = 14
% 2013/3/21 daniel

% 预处理
if ~exist('nDay','var')
    nDay = 14;
end

% 计算步
% Y值＝（当日收市价－N日内移动平均收市价）/N日内移动平均收市价×100％
% 其中，N日为设立参数，可按自己选用移动平均线日数设立，一般分定为6日，12日，24日
% 和72日，亦可按10日，30日，75日设定。

maVal = ind.ma(ClosePrice,nDay, 0);
biasVal = 100*(ClosePrice-maVal)./maVal;

end %EOF

