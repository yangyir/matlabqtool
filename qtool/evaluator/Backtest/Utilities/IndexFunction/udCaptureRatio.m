%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������Ϊ���������в�������ȡ�UCR��DCR�������в������棬UCRbm��DCRbm�ǻ�׼
% �����в������棬UC��DC�������в�������ȡ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ UC, DC ] = udCaptureRatio(UCR,DCR,UCRbm,DCRbm)
% matlab code
if ~isempty(UCRbm)
UC = UCR/UCRbm*100;
else UC =[];
end

if ~isempty(DCRbm)
DC = DCR/DCRbm*100;
else DC = [];
end


end
