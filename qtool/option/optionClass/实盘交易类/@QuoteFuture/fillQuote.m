function [self] = fillQuote(self)
% ȡ����ͨ�ú���
% [self] = fillQuote(self)
% ֧�ֺ�����CTP,�ɴ�ʵʱ����Դ����֧��L2��Wind
% �ڻ��ݲ�֧��XSpeed.�˴��ڻ�Ϊdummy function.
switch self.srcType
    case 'H5'
        self.fillQuoteH5();
    case 'CTP'
        self.fillQuoteCTP();
    case 'XSpeed'
        self.fillQuoteXSpeed();
end

end
