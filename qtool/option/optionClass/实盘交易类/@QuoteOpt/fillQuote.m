function [self] = fillQuote(self)
% ȡ����ͨ�ú���
% [self] = fillQuote(self)
% ֧�ֺ�����CTP,�ɴ�ʵʱ����Դ����֧��L2��Wind
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
