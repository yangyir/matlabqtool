function [self] = fillQuote(self)
% 取行情通用函数
% [self] = fillQuote(self)
% 支持恒生，CTP,飞创实时行情源，不支持L2和Wind
% 期货暂不支持XSpeed.此处期货为dummy function.
switch self.srcType
    case 'H5'
        self.fillQuoteH5();
    case 'CTP'
        self.fillQuoteCTP();
    case 'XSpeed'
        self.fillQuoteXSpeed();
end

end
