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
xspeed_query_fund_and_position(self.counterId);
pause(1);
switch self.counterType
    case 'ETF'
        [positionArray, ret] = xspeed_getstkposition(self.counterId, code);
    case 'Option'
        [positionArray, ret] = xspeed_getoptposition(self.counterId, code);
end


if ~ret
    disp('查询持仓失败');
end
    
end