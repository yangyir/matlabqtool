%% 初始化  l2prof.*,  l2prof.sh1000010, 每天早上做
% 创建所有的l2prof.*,  l2prof.sh1000010

clear('l2prof*');
% 截面变量命名就用  l2prof.sh+代码数字, 例如l2prof.sh10000040
for i = 1:L
   secCode = data{i,1};
   secCode = secCode(1:8);
   profileVarName = ['l2prof.sh', secCode];
   
   % 新建变量
   this = L2DataOpt;
   eval([profileVarName ' = this;']);
   
   % 把正确的S, Moneyness, CP, T，K写进l2data
   try
       %                 disp(secCode);
       this.S = 2.291;
       this.CP = 3 - CPmap(secCode); % 原本1，2搞反了
       if this.CP == 1 % call
           this.M = max(this.S - this.K, 0);
       elseif this.CP == 2 %put
           this.M = max(this.K - this.S, 0);
       end
       this.K = uKs(Kmap(secCode))/1000;
       % T需要算，有点麻烦
       exp     = uTdatenum(Tmap(secCode));
       this.T  = (exp - tday + 1) / 365; % 粗糙处理，应该按小时算剩下的天数
       %             disp([secCode,'   ', num2str(exp), '  ' num2str(this.T)]);
       fprintf('initialization succeeded: %s(%d, %0.4f, %0.4f)\n' ,secCode, this.CP, this.T, this.K);
   catch  e
       disp(['initialization error: ' secCode]);
   end

end