function [  ] = demo1(  )
%DEMO5 ��򵥵�demo��ֱ��дs_generator��payoff���������ϣ�����

clear all; rehash;

%% ����һ��ʹ�õ�·��S�� ������̭�˷�
% ����mcpricer
pricer = MonteCarloPricer;
pricer.iterN    = 100000;
pricer.rfr      = 0.03;

% mcpricer����������������·����S
pricer.SgeneratorHandler = @my_s_generator;
pricer.payoffFunctionHandler = @my_payoff;

% ���ۣ�ʹ�õ�·��S��mcpricer.calc_opt_price()
tic
px1 = pricer.calc_opt_price
toc


%% �������� ʹ�þ����S��Ҫ�ر�ע��payoff_func��д��
% ����mcpricer
pricer2 = MonteCarloPricer;
pricer2.iterN   = 100000;
pricer2.rfr     = 0.03;

% mcpricer�������������� �����S
pricer2.SgeneratorHandler = @my_s_mat_generator;
pricer2.payoffFunctionHandler = @my_payoff;

% ���ۣ�ʹ�þ���S��mcpricer.calc_opt_price_mat()
tic
px2 = pricer2.calc_opt_price_mat
toc

end


%% ����S���У�ֻ��һ��·��
function [S] = my_s_generator()
% ����ֻ����һ��·����Ҫ��pricer��ѭ��
S = rand(1,100);
end


%% ����S ���󣬶���·��һ������
function [S] = my_s_mat_generator(iterN)

S = rand(iterN, 100);

end



%% payoff������ ��·��S�;���Sͨ��
function [payoff] = my_payoff( S )

    % ���S�����У�ת�� 1*stepT
%     payoff = mean( S(:,end-3:end), 2 ) ;
    payoff = S(:,end) .* S(:,end);   

end




