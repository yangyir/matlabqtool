function [ output_args ] = freezeUntradable( posQmat, tradableMat )
% ͣ�ƹ�Ʊ�ֲ�������
% ��׼ȷ�Ķ��ᣬ�����������ᣬ
%     ͬʱ�����ǲ�ɵȸ�Ȩ���⣨ȫ���ú�Ȩ���ݣ��Ϳ��Խ��������ǣ�
% �Ƚϲڵķ�����������ֵ���ᣨ���������ǵ�ͣ���ᣩ
% �����ðٷֱȶ���
% -------------
% �̸գ����汾��20150522

%% ǰ����
% �ж�����
if ~isa(posQmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�posMat');
end


if ~exist('tradableMat', 'var')
    tradableMat = th.dhTradableMat( tradeMat );
end



% ��DH


%% 
% �Ȱ����о���ת��Qmat


% �ٶ���Qmat����ز�λ������V�����λ

% �ٻ�ȥ��Vmat���������ط���V�ɽ��ײ�λ

% �ٻص�Qmat��PCTmat




end

