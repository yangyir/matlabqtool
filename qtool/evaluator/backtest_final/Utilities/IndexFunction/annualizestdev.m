%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڼ����껯������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  annstdR =annualizestdev(R,slicesPerDay)
%%
R(isnan(R)) = [];
% ���㲨����
stdR =std(R);
% �����껯ϵ��
annualCoe = 250*slicesPerDay;
annstdR = stdR*(annualCoe^0.5);
end
