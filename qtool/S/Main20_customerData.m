%% �������ݡ�����������
% data2ֻ��һ����������
% ע��1�����еı������������� data2.****Mat = ..... 
% ע��2����дsʱ�� ֱ���� **** ������һ����
% ע��3�������� ���ڣ��ݣ� * ��Ʊ���ᣩ��ʽ�������Ҫת��
% ע��4��������double mat���е���int32���е���cell��Ҫת��
% -----
% �̸գ�20140914




% �Ƿ�����ȡ���ݣ���δ�ı�span��universe��������ȡ��
% 0 - ������load��Ҳ������fetch ����ʡʱ�䣩
% 1 - ����load  ***.mat����ҹ�������棬�������ȴ���ü��׻�����
% 2 - ����dhfetch���иı��Ҫ��������������
switch fetchData2Flag 
     case {0}
        % 0 - ������load��Ҳ������fetch ����ʡʱ�䣩
        % do nothing
    case {1}
        % 1 - ����load  ***.mat����ҹ�������棬�������ȴ���ü��׻�����
        load data2;
    case {2}
    
    %% �����ǿͻ��Լ�ȡ���ݵĵط�
    data2.epsDilutedMat = DH_S_FA_I_PS_FaEPSDiluted(stockArr,dateArr)';
    % % ���ʲ�������ROE-�۳��Ǿ�������
    data2.roeDeductedMat = DH_S_FA_I_EA_FaROEDeducted(stockArr,dateArr)';
    data2.revenueYoyMat = DH_S_FA_I_GR_FaYoyOr(stockArr,dateArr)';
    % data2.targetPxMat = DH_S_EST_PRICE_TARGETPRICE(stockArr,dateArr,30,1)';
    
    % PE
    
    
    
    
%     data2.ratingMat = cell2mat( DH_S_EST_RATING_AVG(stockArr,dateArr,30,2)' );
%     data2.ratingNumMat = double( DH_S_EST_RATING_NUM(stockArr,dateArr,30,1)' );
%     
%     % ��Щȡ����ʱint32��Ҫת��double
%     data2.shouciRatingNumMat    = double( DH_S_EST_RATING_NUM(stockArr,dateArr,30,1)' );
%     data2.ascendRatingNumMat    = double( DH_S_EST_RATING_NUM(stockArr,dateArr,30,2)' );
%     data2.drawRatingNumMat      = double( DH_S_EST_RATING_NUM(stockArr,dateArr,30,3)' );
%     data2.descendRatingNumMat   = double( DH_S_EST_RATING_NUM(stockArr,dateArr,30,4)' );
    




%% �Ժ�Ĵ���ͻ���Ҫ��
save('data2.mat', 'data2');
end