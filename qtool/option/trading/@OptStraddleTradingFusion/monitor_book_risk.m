function [ output_args ] = monitor_book_risk( obj, S_low, S_high )
%MONITOR_BOOK_RISK ��ʾbook������greeks
% -------------------------------------
% cg��20160320�������˸���S�ķ���
% cg,20160920, ����S�������ޣ��ֲ��plot_positions_risk
% cg,20160922, ȥ��2%delta�� 2%gamma���
% cg,20161114, ��S0�ķ�Χ��(0.75*S, 1.25*S��
% cg,20161115, �ܼ��У��ֲ���������

%%
if ~exist('S_low', 'var')
    S_low = 2.0;
end

if ~exist('S_high', 'var')
    S_high = 2.4;
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
monitor_positions_risk(p_near, vs, '���³ֲ�', S);
monitor_positions_risk(p_other, vs, 'Զ�³ֲ�', S);
monitor_positions_risk(pa, vs, 'ȫ���ֲ�', S);


%% ͼ�����
figure(532);
subplot(311); hold off
plot_positions_risk(p_near, vs, '���³ֲ�', S, S_low, S_high);
subplot(312); hold off;
plot_positions_risk(p_other, vs, 'Զ�³ֲ�', S, S_low, S_high);
subplot(313); hold off;
plot_positions_risk(pa, vs, 'ȫ���ֲ�', S,  S_low, S_high);






end