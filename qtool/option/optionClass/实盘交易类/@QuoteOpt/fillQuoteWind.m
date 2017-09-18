
function self = fillQuoteWind( self , w )
% ȡ ��ֻ��Ȩ ��ʵʱ�������ݣ� ���뵽����Ȩ��prof��
% --------------------------------
% ���Ʒ壬����Wind��ȡ��Ȩ��������������ݣ�20160218
% ���Ʒ壬������һ��������preCloseΪ�˼��㱣֤��ı���

% �����ж��Ƿ�Ϊwind��matlab�Ľӿ�
if ~isobject( w )
    return;
end

% ���Ȼ�ȡ��Ȩ�ı��Last�۸�
underCode = self.underCode;
if isfloat( underCode )
    underCode = num2str( underCode );
end
if isempty( strfind( underCode , '.SH' ) )
    underCode = sprintf( '%s.SH' , underCode );
end

code = self.code;
if isfloat( code )
    code = num2str( code );
end

if isempty( strfind( code , '.SH' ) )
    code = sprintf( '%s.SH' , code );
end

% ��ȡ��ʱ������( last�����̼� )
[ S,~,~,~,w_wsq_errorid ] = w.wsq( underCode,'rt_last,rt_pre_close');

if w_wsq_errorid == 0
    self.S = S(1);
    self.etfpreClose = S(2);
end

[ w_data,~,~,~,w_wsq_errorid ] = w.wsq( code ,...
    'rt_bid1,rt_ask1,rt_vol,rt_last,rt_asize1,rt_bsize1,rt_pre_settle,rt_settle');

if ~any( w_wsq_errorid )  

    bid  = w_data(1);
    ask  = w_data(2);
    vol  = w_data(3);
    last = w_data(4);
    askQ = w_data(5);
    bidQ = w_data(6);
    preSettle = w_data(7);
    settle = w_data(8);

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
    % settle
    self.settle = settle;

end




end


