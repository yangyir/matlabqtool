function [ Vmat ] = qmat2vmat( Qmat, pMat)
% ��Qmat��������ת�ɽ�����Vmat
% [ Vmat ] = tradeQmat2tradeVmat( Qmat, pMat)
% pMat���۸���󣬿����Լ�����Ĭ�ϴ�dhȡclose����Ȩ
% -------------
% �̸գ����汾��20150521



%% Ԥ����
if ~isa( Qmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�Qmat');
end

if ~exist('pMat', 'var')
    pMat = th.dhPriceMat(Qmat);
end



%% main
Vmat            = Qmat.getCopy;
Vmat.des2       = '���';
Vmat.datatype   = '���';
Vmat.data       = Qmat.data .* pMat.data;


end

