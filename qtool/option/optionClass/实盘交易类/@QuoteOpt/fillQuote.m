function [self] = fillQuote(self)
% 取行情通用函数
% [self] = fillQuote(self)
% 支持恒生，CTP,飞创实时行情源，不支持L2和Wind
switch self.srcType
    case 'H5'
        self.fillQuoteH5();
    case 'CTP'
        self.fillQuoteCTP();
    case 'XSpeed'
        self.fillQuoteXSpeed();
    otherwise
        disp('invalid srcType or element');
        return;
end
    % calculate last_percent and last_percent_annualize
    self.last_pct = self.last / self.S;
    self.last_pct_a = self.last_pct / self.tau;
end
