% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �������ڽ���ʼ�����ֹ��֮�佻���ջ�����Ȼ�հ��ղ����г�С���䡣����������ʼ����
% �кͽ�ֹ������
% ���������BeginDate��date������ʼ���ڣ�
%          EndDate��date������ֹ���ڣ�
%          Step��int�����������ɹ�ѡ�1-�գ�2-�ܣ�3-�£�4-����5-���ꣻ6-�ꣻ
%          Style��int����������ʽ���ɹ�ѡ�1-��Ȼ�գ�2-�����գ�
% ��������� Tradingdate_b��cell����������ʼ������
%           Tradingdate_e��cell���������ֹ������
% ���� [Tradingdate_b,Tradingdate_e] = cutintointerval('2012-03-01','2012-05-06',1,1,1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function  [Tradingdate_b,Tradingdate_e] = cutintointerval(BeginDate,EndDate,Step,Style)

%  ��ǰ���������һ�����ڣ�����ԭ���п��ܲ���������ʼ�ͽ�ֹ���ڡ�����ʹ��convtobegin��convtoend
%  ��ȡ������ʼ�����кͽ�ֹ������ʱ��BeginDate��EndDate���������Ƿ�������һֱ���ڡ�
switch Step
    case 1
        back = 0;
    case 2
        back = 6;
    case 3
        back = 30;
    case 4
        back = 91;
    case 5
        back = 182;
    case 6
        back = 365;
    otherwise
        
end
begindate =  datestr(datenum(BeginDate)-back,29);
enddate =  datestr(datenum(EndDate)+back,29);

% ��Ȼ�պͽ�����ѡ����ڸ�ʽ����yyyy-mm-dd
switch Style
    case 1
        Tradingdate = (datenum(begindate):datenum(enddate))';
    case 2
        Tradingdate = datenum(DQ_GetDate_V('000001.SHI',begindate,enddate,0,1));
    otherwise
       
end

% ȡ����չ����ʼ�����ֹ��֮�������������ʼ�����кͽ�ֹ������
Index = convtobegin(Tradingdate,Step,Style);
Index2 = convtoend(Tradingdate,Step);

Tradingdate_b = Tradingdate(Index,:);
Tradingdate_e = Tradingdate(Index2,:);



% ��������ʼ�պ��ڼ��ֹ��ƥ������
if  isempty(Tradingdate_b) || isempty(Tradingdate_e)
    Tradingdate_b = []; 
    Tradingdate_e = [];
    return;
else
    Tradingdate_e2 = zeros(size(Tradingdate_b,1),1);
    for Index3 = 1:size(Tradingdate_b,1)
         Tradingdate_temp = Tradingdate_e( Tradingdate_e >= Tradingdate_b(Index3)) ;
         if isempty(Tradingdate_temp)
            Tradingdate_temp = nan;
         end
         Tradingdate_e2 (Index3) = Tradingdate_temp(1,1);  
    end
end  

% ����ʼ��ǰ�ͽ�ֹ�պ�������޳�
Tradingdate_b2 = Tradingdate_b(Tradingdate_b >= datenum(BeginDate) & Tradingdate_e2 <= datenum(EndDate));
Tradingdate_e = Tradingdate_e2(Tradingdate_b >= datenum(BeginDate) & Tradingdate_e2 <= datenum(EndDate));
Tradingdate_b = Tradingdate_b2;

% ����ת��
Tradingdate_b = cellstr(datestr(Tradingdate_b,29));
Tradingdate_e = cellstr(datestr(Tradingdate_e,29));

end

