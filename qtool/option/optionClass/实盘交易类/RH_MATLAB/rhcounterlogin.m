function [counter_id, result, available_entrust_Id] = rhcounterlogin(addr, broker, investor, investor_pwd, product_info, authen_code)
%[counter_id, result, available_entrust_Id] = counterlogin(addr, broker, investor, investor_pwd, product_info, authen_code)
% counter_id �ǹ�̨��ţ�ctp������Ȩ����Ʒ��ETF��Ҫ��ͬ���˺š�
% ���Ҹ��Եķ�������ַҲ��ͬ��
% result ����login�Ƿ�ɹ���
% available_entrust_Id ��ǰ����Entrust ID
%-----------------------------------------------------------------
% �콭 2016.6.20  first draft

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
% ���ھ������⣬ȡcounter_id > 0.1Ϊ�о�
result = (counter_id > 0.1);
cd(oldpath);
end
