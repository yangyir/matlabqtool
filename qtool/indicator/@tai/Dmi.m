function [ sig_long, sig_short, sig_rs] = Dmi( highPrice, lowPrice, closePrice, lag, thred,type)
%DMI ����DMI(����ָ�����������ź�
%   ���룺
%    highPrice ��߼۸�
%    lowPrice ��ͼ۸�
%    closePrice ���̼۸�
%    lag ��ʱ��Ĭ��14��
%    thred ADXţƤ�з�ֵ
%   �����
%    sig �����ź�
%    dmi.diup +DI��
%    dmi.didown -DI
%    dmi.dx DXָ��
%    dmi.adx ADXָ����DX����EMA��õ���


if ~exist('lag', 'var') || isempty(lag), lag = 14; end
if ~exist('thred', 'var') || isempty(thred), thred = 20; end
if ~exist('type', 'var') || isempty(type), type = 1; end
[nPeriod, nAsset] = size(highPrice);

if nPeriod<lag
    error('data is too short');
end


% ����+DM��-DM


[dmiup, dmidown, adx ]=ind.dmi(highPrice, lowPrice, closePrice, lag);

sig_long = zeros(nPeriod, nAsset);
sig_short = zeros(nPeriod, nAsset);
sig_rs = zeros(nPeriod, nAsset);

if type==1
for jAsset = 1: nAsset
    for iPeriod = 2: nPeriod -1 
        %ADXС��thredΪţƤ�У��źŲ��ɿ�
        if adx( iPeriod, jAsset) > thred
            %��DMI��������DMI�½������Ѷ��
            if dmiup(iPeriod - 1, jAsset) < dmidown(iPeriod - 1, jAsset) && dmiup(iPeriod, jAsset) > dmidown(iPeriod, jAsset)
                sig_long(iPeriod, jAsset ) = 1;
            end
            %��DMI�½�����DMI����������Ѷ��
            if dmiup(iPeriod - 1, jAsset) > dmidown(iPeriod - 1, jAsset) && dmiup(iPeriod, jAsset) < dmidown(iPeriod, jAsset)
                sig_short(iPeriod, jAsset ) = -1;
            end
            
            %ADX�������У���ǿԭ������
            if adx(iPeriod, jAsset) > adx(iPeriod - 1, jAsset) 
                if dmiup(iPeriod, jAsset) > dmiup( iPeriod -1, jAsset) && dmiup(iPeriod, jAsset) > dmidown(iPeriod, jAsset)
                    sig_rs(iPeriod, jAsset) = 1;
                end
                if dmidown(iPeriod, jAsset) > dmidown(iPeriod - 1, jAsset) && dmidown(iPeriod, jAsset) > dmiup(iPeriod, jAsset)
                    sig_rs(iPeriod, jAsset) = -1;
                end
            end
        end

    end
end
else
;
end
end