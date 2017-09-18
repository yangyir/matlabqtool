% ȡ��������Ȩ��Ϣ�б�

optinfopath =  'T:\qtool\option\������Ϣ\�ز���������Ȩ�б�\';

% optinfopath =  'D:\qtools\qtool\option\������Ϣ\�ز���������Ȩ�б�\';
fnInfo = 'all��Ȩ�б�20151113.xlsx';

data = importdata( [optinfopath fnInfo] );
% ��ʱ����һ��ֻ��1-40
data = data(1:70, :);
[L,C] = size(data);
secCodes = data(:,1)
% [Ks, under, typ, Ts] = OptionInfo.abbrBreakdown(data(:,2));

[uTs, iaT, icT]    = unique(data(:, 6));
[uKs, iaK, icK]  = unique(str2double(data(:, 3)));
[uCPs, iaCP, icCP] = unique(data(:,5));

uTdatenum = zeros(4,1);
for i = 1: length(uTs)
    mthstr          = uTs{i};
    mthnum          = mthstr(1:end-1);
    uTdatenum(i)    = Calendar.expirationETFopt(mthnum, 2015);
end
            
%% ֱ���ú�Լ�����T��K��index
Tmap = containers.Map;
Kmap = containers.Map;
CPmap = containers.Map;


for i = 1:L
    code = data{i,1};  % 10000100.SH
    code2 = code(1:8); % 10000100
    idx  = icT(i);
    Tmap(code) = idx;
    Tmap(code2) = idx;
    
    idx  = icK(i);
    Kmap(code)  = idx;
    Kmap(code2) = idx;
    
    idx = icCP(i);
    CPmap(code) = idx;
    CPmap(code2) = idx;
end




%% ��ʼ��һЩ��m2TK����
% % vol
% m2tk = Matrix2DBase;
% m2tk.des2 = '�г��ϵ���Ȩ��T��K��ά����';
% m2tk.xLabel = 'T������';
% m2tk.xProps = uTs;
% m2tk.yLabel = 'Kִ�м�';
% m2tk.yProps = uKs';
% 
% call.code = m2tk.getCopy;
% call.ask1 = m2tk.getCopy;
% call.bid1 = m2tk.getCopy;
% call.ask1vol = m2tk.getCopy;
% call.bid1vol = m2tk.getCopy;
% call.ask1q = m2tk.getCopy;
% call.bid1q = m2tk.getCopy;
% put.code = m2tk.getCopy;
% put.ask1 = m2tk.getCopy;
% put.bid1 = m2tk.getCopy;
% put.ask1vol = m2tk.getCopy;
% put.bid1vol = m2tk.getCopy;
% put.ask1q = m2tk.getCopy;
% put.bid1q = m2tk.getCopy;
% 
% call.profptr = m2tk.getCopy;
% put.profptr = m2tk.getCopy;


%% д���Լ����
% m2c = call.code;
% m2c.des = 'call�Ĵ���';
% m2c.datatype = 'string cell';
% d1 = cell(length(uTs), length(uKs));
% m2p = put.code;
% m2p.des = 'put�Ĵ���';
% m2p.datatype = 'string cell';
% d2 = cell(length(uTs), length(uKs));
% 
% for i = 1:L
%     code = data{i,1};  % 10000100.SH
%     code2 = code(1:8); % 10000100
%     if icCP(i) == 1 % ��
%         d2{icT(i), icK(i) } = code2;
%     elseif icCP(i) == 2 % ��
%         d1{icT(i), icK(i) } = code2;
%     end    
% end
% 
% m2c.data = d1;
% m2p.data = d2;
%        
%% ��ָ��profile��ָ��Ž�ȥ





