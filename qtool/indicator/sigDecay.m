function [ sig_out ] = sigDecay(sig_long, sig_short, param)
% sigDecay lowers signal strength after signal initiation
% ��� param >1����Ĭ���ñ���˥����˥������Ϊ param% 
% ��� param <1, �򰴹̶���ֵ˥����˥������Ϊ param ��ֵ
% method 1: decay by percentage (default: 50%)
% ת�������� sig_long    sig_short   sig_out
%               1           0           1
%               0           0           0.5
%               0           0           0.25
% ------------------------------------------
%            sig_long    sig_short   sig_out
%               1           0           1
%               0           0           0.5
%              -1           0           0
% ------------------------------------------
%            sig_long    sig_short   sig_out
%               1           0           1
%               0           0           0.5
%               0          -1           -0.75
% ------------------------------------------
%            sig_long    sig_short   sig_out
%               1           0           1
%               0           0           0.5
%               1          -1           0.25
% ------------------------------------------
%            sig_long    sig_short   sig_out
%               0           0           0
%               1          -1           0
% ------------------------------------------
%            sig_long    sig_short   sig_out
%               1           0           1
%               0           0           0.5
%               1           0           1

% @daniel 2013/06/03 version 1

%% preparation
[ nPeriod , nAsset ] =size(sig_long);
sig_out = zeros(nPeriod, nAsset);

if ~exist('param', 'var'), param = 50; end
if param >= 1
    type = 'percent';
elseif param <1 && param>0
    type = 'fixleng';
end

switch type
    case 'percent'
        % ������˥����
        for jAsset = 1: nAsset
            out_last = 0; % initial point of  sig_out
            for iPeriod = 1: nPeriod
                nowLong  = sig_long(iPeriod, jAsset);
                nowShort = sig_short(iPeriod, jAsset);
                
                if nowLong ==0 & nowShort ==0 || nowLong ==1 & nowShort == -1
                    % ������û���źŻ���ͬʱ�����źţ�����Ϊû���źţ�ԭ�ź�˥��
                    sig_out(iPeriod, jAsset) = out_last * param/100;
                elseif nowLong == -1 && nowShort == 1
                    % �����վ�Ϊƽ���źţ���ԭ�źŹ���
                    sig_out(iPeriod, jAsset) =0;
                elseif nowLong == 1 && nowShort == 1 
                    % �����վ�Ϊ���࣬��ԭ�źŹ�1
                    sig_out(iPeriod, jAsset) = 1;
                elseif nowLong == 1 && nowShort == 0
                    % �����ͷ�źţ���ԭ�ź�˥���������µĶ�ͷ1�źţ���ֵ�����Ϊ1
                    sig_out(iPeriod, jAsset) = min(1, 1 + out_last*param/100);
                elseif nowLong == -1 && nowShort == -1
                    % �����վ�Ϊ���գ����źŹ�Ϊ-1
                    sig_out(iPeriod, jAsset) = -1;
                elseif nowLong == 0 && nowShort == -1
                    % �����ͷ�����źţ���ԭ�ź�˥���������¿�ͷ-1�źţ���ֵ��СΪ-1
                    sig_out(iPeriod, jAsset) = max(-1, -1+out_last*param/100);
                elseif nowLong == -1 && nowShort == 0
                    % �����ͷƽ���źţ���ԭ��ͷ��0��ԭ��ͷ�����˥��
                    sig_out(iPeriod, jAsset) = min(0, out_last*param/100);
                elseif nowLong == 0 && nowShort == 1 
                    % �����ͷƽ���źţ���ԭ��ͷ��0��ԭ��ͷ�����˥��
                    sig_out(iPeriod, jAsset) = max(0, out_last*param/100);
                end
                out_last = sig_out(iPeriod, jAsset);
            end
        end
    case 'fixleng'
        % ����ֵ˥����
        for jAsset = 1: nAsset
            out_last = 0;
            for iPeriod = 1: nPeriod
                nowLong  = sig_long(iPeriod, jAsset);
                nowShort = sig_short(iPeriod, jAsset);
                if nowLong ==0 & nowShort ==0 || nowLong ==1 & nowShort == -1
                    % ������û���źŻ���ͬʱ�����źţ�����Ϊû���źţ�ԭ�ź�˥��
                    sig_out(iPeriod, jAsset) = m2zero(out_last,  param);
                elseif nowLong == -1 && nowShort == 1
                    % �����վ�Ϊƽ���źţ���ԭ�źŹ���
                    sig_out(iPeriod, jAsset) =0;
                elseif nowLong == 1 && nowShort == 1 
                    % �����վ�Ϊ���࣬��ԭ�źŹ�1
                    sig_out(iPeriod, jAsset) = 1;
                elseif nowLong == 1 && nowShort == 0
                    % �����ͷ�źţ���ԭ�ź�˥���������µĶ�ͷ1�źţ���ֵ�����Ϊ1
                    sig_out(iPeriod, jAsset) = min(1, m2zero(out_last+1, param));
                elseif nowLong == -1 && nowShort == -1
                    % �����վ�Ϊ���գ����źŹ�Ϊ-1
                    sig_out(iPeriod, jAsset) = -1;
                elseif nowLong == 0 && nowShort == -1
                    % �����ͷ�����źţ���ԭ�ź�˥���������¿�ͷ-1�źţ���ֵ��СΪ-1
                    sig_out(iPeriod, jAsset) = max(-1, m2zero(-1+out_last,param));
                elseif nowLong == -1 && nowShort == 0
                    % �����ͷƽ���źţ���ԭ��ͷ��0��ԭ��ͷ�����˥��
                    sig_out(iPeriod, jAsset) = min(0, m2zero(out_last,param));
                elseif nowLong == 0 && nowShort == 1 
                    % �����ͷƽ���źţ���ԭ��ͷ��0��ԭ��ͷ�����˥��
                    sig_out(iPeriod, jAsset) = max(0, m2zero(out_last,param));
                end
                out_last = sig_out(iPeriod, jAsset);
            end
        end
end
end

function [out] = m2zero(a, fixleng)
flag = a>=0;
if flag
    out = max(a-fixleng,0);
else
    out = min(a+fixleng,0);
end
end 
    

