function [ ] =  removeRow(obj, idx)
% ɾȥһ�У��ı�obj.yProps��obj.data��obj.Ny
% [ ] =  removeRow(obj, idx)
%     idx: ��ɾ�����к�
% ----------------
% �̸գ�20150519�����汾
% TODO: �ܷ�ĳɽ��ܲ���idx �� nameStr


%% Ԥ����
% �ж�idx��Χ����

if idx < 0 || idx > length( obj.yProps ) 
    error('idx=%d��������Χ��',idx);
end


%% main
obj.yProps(idx)  = [];
obj.data(idx, :) = [];
obj.autoFill;




end

