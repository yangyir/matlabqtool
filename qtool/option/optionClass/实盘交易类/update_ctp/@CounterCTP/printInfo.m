function [ txt ] = printInfo( self )
%PRINTINFO Êä³ö
% --------------------------
% zj£¬20180730
%         srcType = 'SSEFC';
%         srcId = -1;
%         isLogedIn = 0;
%         addr@char;
%         trade_port@char;
%         q_port@char;
%         authen_code@char;
%         user@char;
%         password@char;
%         local_mac@char = '00000000000000E0';
%         local_ip@char = '127.0.0.1';        
%         log_file@char = 'ssefc_client.log'
%         quote_url_appendix@char = '/00000001/baseInfo/PriceBoard';

txt = sprintf('Client Info:\n');
txt = sprintf('%s Type = %s\n',txt, self.srcType);
txt = sprintf('%sServerAddr = %s\n',txt, self.addr);
txt = sprintf('%sInvestor = %s:%s\n',txt, self.investor, self.investorPassword);
txt = sprintf('%sIsLoggedin = %d\n', txt, self.is_Counter_Login);
txt = sprintf('%s ID = %d\n', txt, self.srcId);

if nargout == 0
disp(txt);
end

end

