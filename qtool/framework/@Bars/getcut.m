function [ newbars ] = getcut( obj, times,  flag )
%UNTITLED �ض�ԭbars��Ϊnewbars
% [ newbars ] = getcut( obj, times )
%   times        ���ָ�ʽ�������ʱ��Ҫ�󲻸ߣ������ʽΪ[3��200]��ָ���г�3��200�С�
%                �����ʱ�侫��Ҫ��ߣ������ʽΪ[20130101��20130801]��ָ�����2013��1��1����2013��8��1�յ�����
%   flag         ����Ǹ�ʽ1��flagΪ1������Ǹ�ʽ2��flagΪ2
% -------------------------------------------
% ver1.0; Zhang,Hang;
% ver1.1; Cheng,Gang; 20130420; ��ǿע�ͣ��޸ı�����
% ver1.2; Lu, Huaibao ; 20130927; �����зַ�ʽ������ָ�������⣬��ָ���������ڸ�ʽ��ʱ��Ρ�



% -----------------------------------����Ϊ20130927���벿��------------------------
switch flag
    case 1
        times = times; 
    case 2
        var0 = times(1);
        var1 = times(2);
        var0 = num2str(var0);
        var0 = datenum(var0,'yyyymmdd');
        var1 = num2str(var1);
        var1 = datenum(var1,'yyyymmdd');
        var2 = obj.time;
        var2 = floor(var2);
        id0 = find( var2 >= var0, 1, 'first');
        id1 = find( var2 <= var1, 1, 'last');
        times = id0:id1;
end;
% -----------------------------------����Ϊ20130927���벿��------------------------


newbars = Bars;

fields = fieldnames(obj);

for i = 1:length(fields)
    eval(['newbars.', fields{i}, '=copyval(obj.', fields{i}, ', times);']);
end

newbars = newbars.autocalc();
        
function b = copyval(a, times)
if ~isempty(a)
    if isvector(a) && length(a) >= length(times)
        b = a(times);
    else
        b = a;
    end
else
    b = [];
end

