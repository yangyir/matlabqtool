function  [trixVal, trixMa] = trix (ClosePrice, nDay, mDay)
% Trix 三重指数平均
% default nDay = 12, mDay =20
% 2013/3/21 daniel

% 预处理和tr trma 计算
if ~exist('nDay','var')
    nDay = 12;
end
if ~exist('mDay','var')
    mDay = 20;
end

%计算步
trixVal = ind.ma(ind.ma(ind.ma(ClosePrice, nDay, 'e'),nDay,'e'),nDay,'e');
trixMa  = ind.ma(trixVal, mDay, 0);

end %EOF