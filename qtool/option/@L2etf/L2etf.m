classdef L2etf
    %L2ETF ר�����ڷ�etf��L2����
    
     %%
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        code;
        latest=1; % ����һ��
    end
     
    %% ԭʼl2����
% ֤ȯ����	ʱ��	���¼�	������5	������5	������4	������4	������3	������3	������2	������2	������1	������1	�����1	������1	�����2	������2	�����3	������3	�����4	������4	�����5	������5

    properties(SetAccess = 'private', GetAccess = 'public', Hidden = false)
       secCode;%֤ȯ����	
       quoteTime;%     ����ʱ��(s)
       last;%���¼�	
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
        
    end

    
    methods
    end
    
end

