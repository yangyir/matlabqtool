function  biasVal= bias(ClosePrice,nDay)
% bias ������
% default nDay = 14
% 2013/3/21 daniel

% Ԥ����
if ~exist('nDay','var')
    nDay = 14;
end

% ���㲽
% Yֵ�����������мۣ�N�����ƶ�ƽ�����мۣ�/N�����ƶ�ƽ�����мۡ�100��
% ���У�N��Ϊ�����������ɰ��Լ�ѡ���ƶ�ƽ��������������һ��ֶ�Ϊ6�գ�12�գ�24��
% ��72�գ���ɰ�10�գ�30�գ�75���趨��

maVal = ind.ma(ClosePrice,nDay, 0);
biasVal = 100*(ClosePrice-maVal)./maVal;

end %EOF

