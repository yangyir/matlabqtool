function [ ] =  removeCol(obj, idx)
% ɾȥһ�У��ı�obj.yProps��obj.data��obj.Ny
% [ ] =  removeCol(obj, idx)
%     idx: ��ɾ�����к�
% ----------------
% �̸գ�20150519�����汾
% TODO: �ܷ�ĳɽ��ܲ���idx �� nameStr


%% Ԥ����
% �ж�idx��Χ����

if idx < 0 || idx > length(obj.xProps) 
    error('idx=%d��������Χ��',idx);
end


%% main
obj.xProps(idx)  = [];
obj.data(:, idx) = [];
obj.autoFill;



end

