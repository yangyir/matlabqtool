function  [trixVal, trixMa] = trix (ClosePrice, nDay, mDay)
% Trix ����ָ��ƽ��
% default nDay = 12, mDay =20
% 2013/3/21 daniel

% Ԥ�����tr trma ����
if ~exist('nDay','var')
    nDay = 12;
end
if ~exist('mDay','var')
    mDay = 20;
end

%���㲽
trixVal = ind.ma(ind.ma(ind.ma(ClosePrice, nDay, 'e'),nDay,'e'),nDay,'e');
trixMa  = ind.ma(trixVal, mDay, 0);

end %EOF