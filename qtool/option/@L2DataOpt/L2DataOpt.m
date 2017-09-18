classdef L2DataOpt < handle
    %L2DATA L2���ݵ��࣬��ʱֻ������Ȩ
    % �̸գ�20151108
    
    
    %%
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        code;
        under;
        S;  % ʵʱ����
        CP;  % 1 - call, 2 - put
        K;
        T;
        M; % Moneyness; % (S-K)+  �� (K-S)+
        latest; % ����һ��
        
        
        
    end
    
%% ԭʼl2����
%     ����ʱ��(s)	DataStatus	֤ȯ����	ȫ��(1)/����(2)	���ս����	���ս����	���̼�	��߼�	��ͼ�	���¼�	���̼�	��̬�ο��۸�	����ƥ������	��ǰ��Լδƽ����	������1	�����1	������2	�����2	������3	�����3	������4	�����4	������5	�����5	������1	������1	������2	������2	������3	������3	������4	������4	������5	������5	�ɽ�����	�ɽ����	��Ʒʵʱ�׶α�־	�г�ʱ��(0.01s)

    properties(SetAccess = 'private', GetAccess = 'public', Hidden = false)
       quoteTime;%     ����ʱ��(s)
       dataStatus;%    DataStatus	
       secCode;%֤ȯ����	
       accDeltaFlag;%ȫ��(1)/����(2)	
       preSettle;%���ս����	
       settle;%���ս����	
       open;%���̼�	
       high;%��߼�	
       low;%��ͼ�	
       last;%���¼�	
       close;%���̼�	
       refP;%��̬�ο��۸�	
       virQ;%����ƥ������	
       openInt;%��ǰ��Լδƽ����	
       bidQ1;%������1	
       bidP1;%�����1	
       bidQ2;%������2	
       bidP2;%�����2
       bidQ3;%������3	
       bidP3;%�����3	
       bidQ4;%������4	
       bidP4;%�����4	
       bidQ5;%������5	
       bidP5;%�����5	
       askQ1;%������1	
       askP1;%������1	
       askQ2;%������2	
       askP2;%������2	
       askQ3;%������3	
       askP3;%������3	
       askQ4;%������4	
       askP4;%������4	
       askQ5;%������5	
       askP5;%������5	
       volume;%�ɽ�����	
       amount;%�ɽ����	
       rtflag;%��Ʒʵʱ�׶α�־	
       mktTime;%�г�ʱ��(0.01s)
        
    end
    
    %% �������ֵ
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        % ��Щ��last����
        vol;
        delta;
        gamma;
        theta;
        rho;
        lambda;
        
        
        % ��Щ��ask��bid����
        askvol;
        askdelta;
        askgamma;
        asktheta;
        askrho;
        asklambda;
        
        bidvol;
        biddelta;
        bidgamma;
        bidtheta;
        bidrho;
        bidlambda;
        
    end
 
    %% ���µ�L2���¼
    properties(SetAccess = 'private', GetAccess = 'public', Hidden = false)
        changedL2fields;  % ���¹������¼����
    
        
    end
 
    %% constructor
    methods (Access = 'public', Static = true, Hidden = false)
        function obj = L2Data()
            obj.latest = 0;
        end
    end

    
    %% ��������
    methods (Access = 'public', Static = true, Hidden = false)
        fillL2Data(obj, str);
        dispL2Data(obj);
        updateTicksProfile(obj);
        updateTicksTimeSeries(obj);
               
       
        
    end
    
    methods(Static = true)
        demo(); %ȡ��ʷ��l2���ݣ����
        
        
    end
    
    
    %% Ӧ���õ�һЩ����
    methods (Access = 'public', Static = false, Hidden = false)
         copyTo( obj, dest );
        [ newobj ] = getCopy( obj );
        
        updateAsk( obj, origin);
        updateBid(obj , origin);
        updateNonzeroDifferent(  obj, origin);
        
        [ obj ] = push( obj, newL2DataRecord);
        [ obj ] = pushstr( obj, L2str);
        
        [obj ] = calc();
        [ obj ] = calcVol(obj);
        
        [ obj ] = clearChangedL2fields(obj);
        
        
    end
  
    %% С������ֱ��д������
    methods (Access = 'public', Static = false, Hidden = false)
        
        function mg = margin(obj)
            % ���ֱ�֤��
            % ��ͱ�׼
            % �Ϲ���Ȩ����ֿ��ֱ�֤��[��Լǰ�����+Max��12%����Լ���ǰ���̼�-�Ϲ���Ȩ��ֵ��7%����Լ���ǰ���̼ۣ�] ����Լ��λ
            % �Ϲ���Ȩ����ֿ��ֱ�֤��Min[��Լǰ�����+Max��12%����Լ���ǰ���̼�-�Ϲ���Ȩ��ֵ��7%����Ȩ�۸񣩣���Ȩ�۸�] ����Լ��λ
            % ά�ֱ�֤��
            % ��ͱ�׼
            % �Ϲ���Ȩ�����ά�ֱ�֤��[��Լ�����+Max��12%����Լ������̼�-�Ϲ���Ȩ��ֵ��7%����Լ������̼ۣ�]����Լ��λ
            % �Ϲ���Ȩ�����ά�ֱ�֤��Min[��Լ����� +Max��12%���ϱ�����̼�-�Ϲ���Ȩ��ֵ��7%����Ȩ�۸񣩣���Ȩ�۸�]����Լ��λ
            % ���У��Ϲ���Ȩ��ֵ=Max����Ȩ��-��Լ������̼ۣ�0��
            % �Ϲ���Ȩ��ֵ=max����Լ������̼�-��Ȩ�ۣ�0��
            switch obj.CP
                case {1,'c','C','call','Call', 'CALL'}
                    mg = obj.preSettle + max( obj.S*0.12 - obj.M, obj.S *0.07);
                case {2, 'p', 'P', 'put', 'Put', 'PUT'}
                    mg = min( obj.preSettle+ max( obj.S*0.12 - obj.M,  obj.K*0.07), obj.K);                    
            end
            
        end
        
    end
    
end

