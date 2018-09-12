function [positionArray, ret] = queryPositions(self, code)
% 查询持仓
% [positionArray, ret] = queryPositions(code)
% 当code为空时,查询所有持仓。
% 当code为某合约代码时，查询该合约上的持仓。
% --------------------------
% 朱江，20160712

if ~exist('code', 'var')
    code = '';
end

[positionArray, ret] = ctpcounter_getpositions(self.counterId, code);

if ~ret
    disp('查询持仓失败');
end
    
end