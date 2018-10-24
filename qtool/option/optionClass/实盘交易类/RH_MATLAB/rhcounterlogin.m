function [counter_id, result, available_entrust_Id] = rhcounterlogin(addr, broker, investor, investor_pwd, product_info, authen_code)
%[counter_id, result, available_entrust_Id] = counterlogin(addr, broker, investor, investor_pwd, product_info, authen_code)
% counter_id 是柜台编号，ctp交易期权，商品，ETF需要不同的账号。
% 并且各自的服务器地址也不同。
% result 表明login是否成功。
% available_entrust_Id 当前可用Entrust ID
%-----------------------------------------------------------------
% 朱江 2016.6.20  first draft

oldpath = pwd;
libpath = rh_lib_dir;

cd(libpath);
if not(libisloaded('RonHangSystem'))
    [notfound, warnings] = loadlibrary('RonHangSystem', 'rh_counter_export_wrapper.h');
end
available_entrust_Id = 0;
% [counter_id, available_entrust_Id] = ctpcounterlogin(addr, broker, investor, investor_pwd, product_info, authen_code);
counter_id = rh_counter_login(addr, broker, investor, investor_pwd, product_info, authen_code);
% counter_id > 0
% 鉴于精度问题，取counter_id > 0.1为判据
result = (counter_id > 0.1);
cd(oldpath);
end
