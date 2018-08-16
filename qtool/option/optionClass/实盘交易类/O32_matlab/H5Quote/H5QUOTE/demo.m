% 登入连接行情服务器，返回为1时表示登录成功
mktlogin
pause(2);
while 1
    lastP = getCurrentPrice('510050','1');
    disp(['code: 510050, price: ', num2str(lastP(1,1)),' status: ', num2str(lastP(3,1))]);
%     lastP = getCurrentPrice('000001','2');
%     disp(['code: 000001, price: ', num2str(lastP)]);
    pause(2);
end

% 退出行情服务器连接
mktlogout