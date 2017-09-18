function  [e] = place_entrust_autoPx( obj, direc, volume, offset, pxType)
% �ó����ļ۸�ʽ�µ�
% [e] = place_entrust_autoPx( obj, direc, volume, offset, pxType)
% pxType: �Լ�oppo��Ĭ�ϣ����޼۳�ƽatpar��last�ۣ�mid��
% ��1tick?
% �ð�1?
%------------------------------------


%% pre
if ~exist('pxType', 'var')
    pxType = 'oppo';
end
    
% ȡ�õ�ǰ�۸�
opt = obj.quote;
% ����quoteOpt
% ��H5������£���Ҫinitʱ����H5����
% ������²�̫��ʱ���þ�ȡ����
while 1
    opt.fillQuote;
    if opt.askQ1>0
        break;
    else
        disp('��Ȩ����δ�ӵ�');
        pause(1);
    end
end


%% main
bid = opt.bidP1;
ask = opt.askP1;
last = opt.last;
mid = (ask+bid)/2;

switch direc
    case {'1', 1}  % ��
        switch pxType
            case{'oppo'}
                px = ask;
            case{'atpar'}
                px = bid;
            case{'last'} 
                px = last;
            case{'mid'}
                px = ceil(10000*(ask+bid)/2)/10000;
        end
        
    case {'2', -1}
         switch pxType
            case{'oppo'}
                px = bid;
            case{'atpar'}
                px = ask;
            case{'last'} 
                px = last;
            case{'mid'}
                px = floor(10000*(ask+bid)/2)/10000;
         end
        
end


e = obj.place_entrust_opt( direc, volume, offset, px );


end

