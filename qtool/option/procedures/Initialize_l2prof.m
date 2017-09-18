%% ��ʼ��  l2prof.*,  l2prof.sh1000010, ÿ��������
% �������е�l2prof.*,  l2prof.sh1000010

clear('l2prof*');
% ���������������  l2prof.sh+��������, ����l2prof.sh10000040
for i = 1:L
   secCode = data{i,1};
   secCode = secCode(1:8);
   profileVarName = ['l2prof.sh', secCode];
   
   % �½�����
   this = L2DataOpt;
   eval([profileVarName ' = this;']);
   
   % ����ȷ��S, Moneyness, CP, T��Kд��l2data
   try
       %                 disp(secCode);
       this.S = 2.291;
       this.CP = 3 - CPmap(secCode); % ԭ��1��2�㷴��
       if this.CP == 1 % call
           this.M = max(this.S - this.K, 0);
       elseif this.CP == 2 %put
           this.M = max(this.K - this.S, 0);
       end
       this.K = uKs(Kmap(secCode))/1000;
       % T��Ҫ�㣬�е��鷳
       exp     = uTdatenum(Tmap(secCode));
       this.T  = (exp - tday + 1) / 365; % �ֲڴ���Ӧ�ð�Сʱ��ʣ�µ�����
       %             disp([secCode,'   ', num2str(exp), '  ' num2str(this.T)]);
       fprintf('initialization succeeded: %s(%d, %0.4f, %0.4f)\n' ,secCode, this.CP, this.T, this.K);
   catch  e
       disp(['initialization error: ' secCode]);
   end

end