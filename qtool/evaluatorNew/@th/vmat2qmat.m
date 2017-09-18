function [ Qmat ] = vmat2qmat( Vmat, pMat )
% �ѹ�������Qmatת�ɽ�����Vmat
% ���� * �۸� = �� ���۸��и�Ȩ���⣬��Ӧ�ģ��������۸����Ӧ
% [ Vmat ] = tradeQmat2tradeVmat( Qmat, pMat)
% pMat���۸���󣬿����Լ�����Ĭ�ϴ�dhȡclose����Ȩ
% -------------
% �̸գ����汾��20150521


%% Ԥ����
if ~isa( Vmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�Qmat');
end

if ~exist('pMat', 'var')
    pMat = th.dhPriceMat(Vmat);
end


%% main
Qmat            = Vmat.getCopy;
Qmat.des2       = '����';
Qmat.datatype   = '����';
Qmat.data       = Vmat.data ./ pMat.data;

end

