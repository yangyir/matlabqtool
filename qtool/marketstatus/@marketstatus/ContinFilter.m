function [FiltLoc, newsignal]=ContinFilter(signal, tol)
% v.2.0 by Yang Xi
% ��������signal����Ч�ź�������ĿС��tol��1ֱ�ӹ��˳�0�������ظı�ֵ��λ��
% signal ���� 1 �� 0 ��ɵ����ִ��� 1 Ϊ��Ч��0 Ϊ��Ч
% tol ��ʾ��Ч�ź���Ҫ�����̳���
% FiltLoc ��ʾ������ֵ��λ��
% newsignal ����֮��õ������ź�

i =1;
ntotal = length(signal);
newsignal = signal;
while i <= ntotal
    if newsignal(i) == 1,
        start = i; % һ����Ч�źŵ���ʼλ��
        j = i;
        while j <= ntotal
            if newsignal(j) == 1,
                j = j+1;
            else
                break;
            end
        end
        stop = j-1; % һ����Ч�źŵ���ֹλ��
        len = stop-start+1; % һ����Ч�źŵĳ���
        if len < tol
            newsignal(start:stop)=zeros(1,len);
        end
        i = j+1;
    else
        i = i+1;
    end
end
FiltLoc = find(newsignal-signal == -1);
end


            
  