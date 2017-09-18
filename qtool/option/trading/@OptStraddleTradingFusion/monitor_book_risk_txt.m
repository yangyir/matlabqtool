function monitor_book_risk_txt( obj, S_low, S_high )  
% monitor_book_risk_txt( obj, S_low, S_high )  
% ��ʾbook������greeks
% ��monitor_book_risk���в��Ϊtxt

%%
if ~exist('S_low', 'var')
    S_low = 2.0;
end

if ~exist('S_high', 'var')
    S_high = 3.0;
end


%%

% ʵ��ʱʹ�ã�
b = obj.book;
q = obj.quote;
vs = obj.volsurf;
QMS.set_quoteopt_ptr_in_position_array(b.positions, q)

%% obj ����S
% [p, mat] = getCurrentPrice('510050', '1');
% S = p(1);
obj.quoteS.fillQuote;
S = obj.quoteS.last;
obj.S = S;

%% ��positionsת�ɸ�structure��
% position ת�� pricer��num������structure
pa = b.positions;

p_near = PositionArray;
p_other = PositionArray;

pa_len = length(pa.node);

% �޸����µ���ʱ�ļ������
cur_month = month(today);
cur_year = year(today);
cal = Calendar_Test.GetInstance;
near_T = cal.expirationETFopt(cur_month, cur_year);

%����������������ǰ���õ��º�Լ�������պ��ô��º�Լ��
if today > near_T
    t = addtodate(today, 1, 'month');
    near = month(t);
else
    near = cur_month;
end

for i = 1:pa_len
    pos = pa.node(i);
    t = pos.parseTFromName;
    if near == month(t)
        p_near.push(pos);
    else
        p_other.push(pos);
    end
end


%% �������
fprintf('��%s��\n', b.name);
monitor_positions_risk(p_near, vs, '���³ֲ�', S);
monitor_positions_risk(p_other, vs, 'Զ�³ֲ�', S);
monitor_positions_risk(pa, vs, 'ȫ���ֲ�', S);










end
