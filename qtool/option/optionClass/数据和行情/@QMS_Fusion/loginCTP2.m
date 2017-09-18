function [ret] = loginCTP2(obj)

obj.srcType = 'CTP';
front_addr_ = 'tcp://140.207.227.81:41213';
broker_id_ = '16337';
investor_id_ = '8880010013';
investor_password_ = '458230';
mdlogout;
pause(3);
ret = mdlogin(front_addr_, broker_id_, investor_id_, investor_password_);

end