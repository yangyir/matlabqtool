%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 函数作用为计算上下行捕获收益比。UCR、DCR是上下行捕获收益，UCRbm、DCRbm是基准
% 上下行捕获收益，UC、DC是上下行捕获收益比。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ UC, DC ] = udCaptureRatio(UCR,DCR,UCRbm,DCRbm)
% matlab code
if ~isempty(UCRbm)
UC = UCR/UCRbm*100;
else UC =[];
end

if ~isempty(DCRbm)
DC = DCR/DCRbm*100;
else DC = [];
end


end
