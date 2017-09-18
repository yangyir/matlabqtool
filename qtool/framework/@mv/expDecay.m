function [ outSeq ] = expDecay(      inSeq, days )
%EXPDACAY ָ��˥��n����ΪȨ�أ�Ӱ���������ӣ���Ȩƽ��
% �����ϣ�n->infʱ�� mv.expDecay(s, n) -> mv.expSmooth(s, 1 - 1/e)
% �̸գ�20140913

%% ǰ���� 

if ~exist('days','var'), days = 0; end
days = round(days);
if days<0,     days =0;  end




%% ������nan�ĸɾ���inSeq, ������index
inSeq2 = inSeq(~isnan(inSeq));
idx = find(~isnan(inSeq));


%% ����ɾ��ġ�inSeq -> outSeq
N = length(inSeq2);

% �������
mat     = nan(N, days+1);
wtmat   = nan(N,days+1);
% mat(:,1) = inSeq2;
% wtmat(:,1) = exp(0);

for dt = 1:days+1
    wtmat(dt:end ,dt)   = exp(-dt);
    mat( dt:end ,dt)    = inSeq2(1:end-dt+1) * exp(-dt);
end

% �������Ȩ���ֵ
outSeq2 = nan(N,1);
for i = 1:N
    outSeq2(i) = nansum(mat(i,:))  /  nansum(wtmat(i,:));
end


%% ��ԭoutSeq�е�nan
outSeq = nan(size(inSeq));
outSeq(idx) = outSeq2;

end

