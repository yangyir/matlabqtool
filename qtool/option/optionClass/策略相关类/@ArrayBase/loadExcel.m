function [obj] = loadExcel(obj, filename, sheetname)
% LOADEXCEL, �����е�obj����excel���ݣ�ArrayBase��ķ���
% [obj] = loadExcel(obj, filename, sheetname)
% className������ȽϺý��
% ------------------------------------
% �̸գ�20160210
% cg��20160311����������ȡǰ�����
% cg, �е�����ָ�룬û��ȡ, ����try...catch��������

%% Ԥ����
nodeClassName = class(obj.node);

if ~exist('filename', 'var')
    warning('û���ļ������޷�����');
    return;
end

if ~exist('sheetname', 'var')
    sheetname = nodeClassName;
end


%% main
try
    [num, txt, raw] = xlsread(filename, sheetname);
catch e
    disp(e);
end

% �����
eval( ['obj.node = ' nodeClassName ';' ] );

% ��һ����
[L, C] = size(raw);
for i = 2:L
    eval( ['anode = ', nodeClassName, ';'] );
    for j = 1:C
        try
        fd = raw{1,j};
        anode.(fd) = raw{i,j};
        catch
        end
    end
    obj.node(i-1) = anode;
    obj.latest = i-1;
end


%             obj.headers = raw(1,1:end);
%             obj.table   = raw;
end
