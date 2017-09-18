classdef th
% Trading �� Holding��صĺ������߰�
% �������ຯ����
%   1��ȡ���ݣ�����DH��wind�ȣ�
%   2��TsMatrix֮���ת��
%   3�������Լ�飨��֤backtest������ŵĹؼ���
%   4��ͳ�ƽ��NAV��
% �������ݣ��������ϣ���tradeMat �� posMat
% �����������ϣ� ��Qmat����������Vmat����ֵ����PCTmat��ռ�ȣ�
% �ۺ�����:������TsMatrix�ࣩ
% 
% tradeQmat <--> tradeVmat 
%     ^
%     |
%     v
% posQmat   <--> posVmat   <--> posPCTmat
% 
% -------------
% �̸գ�20150521


properties
end


%% ��dh��ȡ�������ݾ���
methods (Access = 'public', Static = true, Hidden = false)
    [ pMat ]        = dhPriceMat( tsMat, datatype, fuquan );
    [ tradableM ]   = dhTradableMat( tsMat );
    [ztMat, dtMat]  = dhZhangDieTingMat( tsMat, type);
    [ holdableM ]   = dhXinguHoldable(  tsMat  );

end

%% trade����,pos����֮��Ļ���ת��
% qmat������pmat�۸�vmat��pctmatռ��
% TsMatrix.datatype������������
methods (Access = 'public', Static = true, Hidden = false)    
    %% qmat��vmat��pctmat֮���ת��
    [Vmat]      = qmat2vmat(qMat, pMat);
    [ qMat ]    = vmat2qmat( vmat, pMat);
    [pctmat]    = vmat2pctmat(vmat);
    
    % �������������ô�򵥣��������ӣ������ѻز��ȫ��������һ��
    [ vmat ]    = pctmat2vmat(pctmat, initValue);
    


    %% trade��pos֮���ת��
    [ posQmat ]     = tradeQmat2posQmat( tradeQmat );
    [ tradeQmat ]   = posQmat2tradeQmat( posQmat );
    
end

%% ͳ�ƽ��׽��portfolio
% posMat, tradeMat ����TsMatrix��
% port��SingleAsset�࣬ÿһ����һ����������
methods (Access = 'public', Static = true, Hidden = false)
    % ����nav
    [port] = posQmat2nav( posMat, pMat );
    [port] = posVmat2nav( posVMat );
    
    % ��������/�����/�����
    [port] = tradeVmat2volume( tradeVMat );    
    
    
    
end

%% trade��hold�������Լ��
methods (Access = 'public', Static = true, Hidden = false)
    % �Ѳ��ɽ��׵Ľ�������
    [ tradeMat ] = setZeroUntradable( tradeMat, tradableMat );
    
    % Qmat��������ȡ��
    [  qmat    ] = setIntQmat( qmat, round_type);
    
    % ��ϴtradeQmat
    [ newTradeQmat, log, log2]  = reviseTrade( tradeQmat, tradableMat, pMat) 
    
    % ��ϴ���ɳֲֵĲ���
    [ newPosPCTmat, log]    = reviseHoldingPCTmat( posPCTmat, holdableMat)
    % δ���еģ����ɳֲ֣�����ϸ�һ�㣬���к�Ҳ���ɳֲ֣�ֱ������ͣ
    [ newPosMat, log ]          = revisePosPCTmatBeforeIPO( posMat ); 
    
    
    % ��ϴtradeQmat��ʹ���ǵ�ͣ��Ϣ��ϴ
    [ newTradeQmat, log, log2]  = reviseTradeZDT( tradeQmat, ztMat, dtMat, pMat);
    

    
    % ��holdingMat�в��ɽ��׵ĸ��ɳֲ���������ס����������·���
    freezeUntradable( posMat, tradableMat);
    
    
    % ���������ѣ�ë������ֱ���ý�����*���ʣ�û�и���
    [ port ] = feeMaogugu( tradeVmat, feeRatio );
    
end

        



   
    
end

