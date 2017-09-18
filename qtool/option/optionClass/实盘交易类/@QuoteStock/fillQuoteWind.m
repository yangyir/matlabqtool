
function self = fillQuoteWind( self , w )
% ȡ ��ֻ��Ʊ ��ʵʱ�������ݣ� ���뵽����Ȩ��prof��
% --------------------------------
% �콭������Wind��ȡ��Ʊ��ʵʱ��������ݣ�20160317

% �����ж��Ƿ�Ϊwind��matlab�Ľӿ�
if ~isobject( w )
    return;
end


code = self.code;
if isfloat( code )
    code = num2str( code );
end

if isempty( strfind( code , '.SH' ) )
    code = sprintf( '%s.SH' , code );
end

% ��ȡ��ʱ������
[ S ] = w.wsq( underCode,'rt_last');

self.S = S;

[ w_data ] = w.wsq( code ,'rt_bid1,rt_ask1,rt_vol,rt_last,rt_asize1,rt_bsize1,rt_pre_settle');
bid  = w_data(1);
ask  = w_data(2);
vol  = w_data(3);
last = w_data(4);
askQ = w_data(5);
bidQ = w_data(6);
preSettle = w_data(7);

% ��Ȩ���¼�
self.last = last;
% ��Ȩ�ۼƳɽ�������
self.diffVolume = vol - self.volume;
% ��Ȩ�ۼƳɽ���
self.volume = vol;
% �����1
self.bidP1  = bid;
% ������1
self.bidQ1  = bidQ;	
% ������1	
self.askP1  = ask;
% ������1	
self.askQ1  = askQ;
% pre_settle
self.preSettle = preSettle;

end




