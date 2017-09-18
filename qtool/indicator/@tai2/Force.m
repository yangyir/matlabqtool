function [sig_rs] = Force(bar, nday,thresh, type)
%����forceindex
%���� Close,volume,��ʾ���ڵ�n
%���Ϊforce�ļ���ֵ �Լ������ź� signal
%   Yan Zhang   version 1.0 2013/3/12
% Ĭ�ϵ�����Ϊ13

%force>thresh, ������ǿ���ź�Ϊ-1
%force<-thresh, �����������ź�Ϊ1
%   Yan Zhang   version 1.1 2013/3/21

if ~exist('type', 'var') || isempty(type), type = 1; end
if ~exist('nday', 'var') || isempty(nday), nday = 13; end
if ~exist('thresh', 'var') || isempty(thresh), thresh = 50; end
close = bar.close;
volume = bar.volume;

sig_rs = tai.Force(close, volume, nday, thresh, type);

 
if nargout == 0
    force.force = ind.force(close, volume, nday);
    bar.plotind2(sig_rs, force, true);
    title('force rs');
end
end


 