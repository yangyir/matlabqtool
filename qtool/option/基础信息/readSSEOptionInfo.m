% %
% 1, copy �Ͻ������պ�Լ��Ϣֻtxt��xlsx
% 2�����д�script���룬��ת���.m������


path = 'D:\qtools\qtool\option\������Ϣ\�Ͻ������պ�Լ��Ϣ\';
fn = '151113';
fntxt = [fn, '.txt'];

txtin = importdata( [path, fntxt] );

L = size(txtin,1); %����
C = size(regexp(txtin{1},'\t', 'split'),2); %������16
% �����cell
outTable = cell(L, C);
for i = 1:L
    l = regexp(txtin{i},'\t', 'split');
    for j = 1:C
        outTable{i,j} = l{j};
    end
    
    oinfo = OptionInfo;
    oinfo.readSSEdailyInfo(txtin{i});
end

% ����
save([path, fn] , 'outTable');



%% meta infomation
[Ts, ia, ic]    = unique(str2double(outTable(2:end, 10)));
[Ks, ia2, ic2]  = unique(str2double(outTable(2:end, 6)));

m2contractCode = Matrix2DBase;
m2contractCode.des = '�г��ϵ���Ȩ��T��K��ά����';
m2contractCode.xLabel = 'T������';
m2contractCode.xProps = Ts;
m2contractCode.yLabel = 'Kִ�м�';
m2contractCode.yProps = Ks';

m2contractCode.datatype = 'cell of string';
m2contractCode.data = {};

% ������󴢴��Լ����ţ�������ʱ��
m2contractIdx = m2contractCode.getCopy;
m2contractIdx.des = '��Ȩ��Լ�����Ա���';
m2contractCode.datatype = 'number';

for jj = 1:L-1
    m2contractCode.data(ic(jj), ic2(jj)) = outTable(jj+1, 1);
    m2contractIdx.data(ic(jj), ic2(jj) ) = jj+1;
end


contractCode = oinfo.contractCode
contractCode = outTable{2:end, 1}
containers.Map( {  } , ic);



% uniqueTs = 


i = 3;

str = outTable{i,3};
% 50ETF��12��2150






