%% s�����
% ע1������Ϊnan��ǿ�ƿղ֣�����0δ�ؿղ֣���Ϊ��Ҫ���Ի���
% ע2��code�Ǳ����֣���000001.SZ
% ע3��ʱ��ͨ���±�ʵ�֣����Ҫ�����ڣ�
%     dateArr(i)��ͬ'2014-09-14'
%     dateNumArr(i)��ͬ 735839
% ע4, col �Ǳ�����
% ע5�����������ֶ���Main15_basicData���� 
%     open, close, high, low, avg (��ǰ��Ȩ��
%     openRT, closeRT, highRT, lowRT, avgRT������Ȩ��
%     volume, amount, change, retrn������return��
%     retrn2, tradable
% ע6�������õ��ĺ�����mv���У��� mv.avg
% --------------------------------------
% �̸գ�140915
% �̸գ�141001���������
    
%% ����д���֣�

% a = mv.stddev( log(1+retrn2),5);
% b = mv.stddev(log(1+retrn2),50);
% s = a-b;


%% alpha = ma(close, 20) - ma(close, 5) 

s = mv.avg(close,20) - mv.avg(close,5);


%% ��������

% s = (descendRatingNum - ascendRatingNum)./( rating.^4 );

% tmp = 0.1+ descendRatingNum - ascendRatingNum;
% s = sign(tmp).* power(abs(tmp),1/2)./( rating.^1);
% 
% s = 1./rating.^10;
% s = 1./rating.^10 .* power( ratingNum, 1/2);

%% ROE, EPS ����
% s = roeDeducted .* epsDiluted;
% s = roeDeducted .* revenueYoy ;
% s2 = mv.avg(close,20) - mv.avg(close,5);
% s = s .* s2;


%% sum_i(close,20)
% for i = 1:20
%     sum = sum + close(t -i );
% end 



%% INF�ǲ�Ӧ�ó��ֵ�
s(s==Inf) = nan;
s(s==-Inf) = nan;