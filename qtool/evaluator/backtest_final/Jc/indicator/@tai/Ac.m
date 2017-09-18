function [sig_long, sig_short] = Ac(HighPrice,LowPrice,nDay,mDay, type)
%accelerator oscillator  ���ؽ����ź�(-1,0,1)
%����
% �����ݡ�HighPrice, LowPrice ��ʱ�� X ��Ʊ����
% ��������nDay, mDay ���ٺ������ƶ�ƽ���������� ����Ȼ����
%   Yan Zhang   version 1.0 2013/3/12

%% Ԥ����
if ~exist('nDay', 'var') || isempty(nDay), nDay = 5; end
if ~exist('mDay', 'var') || isempty(mDay), mDay = 34; end
if ~exist('type', 'var') || isempty(type), type = 1; end

[nPeriod , nAsset] = size(LowPrice);
acVal=zeros(nPeriod , nAsset);
sig_long = zeros(nPeriod , nAsset);
sig_short= zeros(nPeriod , nAsset);

if nDay > mDay %��������������������
    temp = nDay;
    nDay = mDay;
    mDay = temp;
    clear temp;
end


[acVal] = ind.aco(HighPrice,LowPrice,nDay,mDay);

%% �źŲ�
%sig_long,sig_short
%����������֮�ϣ���������ɫ��;
%����������֮�£���������ɫ��;
%����������֮�ϣ���������ɫ��;
%����������֮�£���������ɫ��.

% difac ����ʱ����ɫ��ʾ��Ϊ����ʱ�ú�ɫ��ʾ
if type == 1
    difac=acVal(2:end,:)-acVal(1:end-1,:);
    difac=[zeros(1,nAsset);difac]; 
    zeroline=0;
    for i=1:nAsset
        for j=3:nPeriod-1
            if acVal(j,i)<zeroline && acVal(j-1,i)<zeroline
                if acVal(j-2,i)<zeroline &&  difac(j,i)>0 && difac(j-1,i)>0 && difac(j-2,i)<0
                    sig_long(j,i)=1;
                elseif difac(j,i)<0 && difac(j-1,i)<0
                    sig_short(j,i)=-1;
                end
            elseif acVal(j,i)>zeroline && acVal(j-1,i)>zeroline
                if acVal(j-2,i)>zeroline &&  difac(j,i)<0 && difac(j-1,i)<0 && difac(j-2,i)<0
                    sig_short(j,i)=-1;
                elseif difac(j,i)>0 && difac(j-1,i)>0
                    sig_long(j,i)=1;
                end
            end
        end
    end
else
end
end %EOF
 