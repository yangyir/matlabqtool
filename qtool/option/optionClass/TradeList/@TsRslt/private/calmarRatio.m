function calmarR = calmarRatio( nav ,Rf,slicesPerDay)

% ���䳬��20140710��V1.0

% ��������������
R = log(nav(2:end)./nav(1:end-1));

% �������س�
md = calcMaxDD(nav);

calmarR = mean(R-Rf)/min(md);
calmarR = calmarR*(250*slicesPerDay);

end

