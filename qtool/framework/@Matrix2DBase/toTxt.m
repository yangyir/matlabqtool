function [ obj ] = toTxt( obj, filename, datumFormat, flag_xyProps )
% obj.dataд��txt�ļ���Ĭ�϶����ƣ� '%0.2f\t'
% [ obj ] = toTxt( obj, filename, datumFormat )
%     filename:  ��·�����ļ�����Ĭ�ϣ�[obj.des '_' obj.des2 '_Mat2D.txt']
%     datumFormat���������ݵĸ�ʽ��Ĭ��'%0.2f'
%     flag_label: �Ƿ����x���y�����Ŀ���֣�ȡֵΪ��''(Ĭ��),'x', 'y', 'xy', 'yx'
% ------------
% �̸գ�20150518�����汾
% �̸գ�20150531������flag_xyProps


%% ǰ����
if ~exist('filename', 'var')
    className = class(obj);
    filename = [obj.des '_' obj.des2 '_' className '.txt'];
end

if ~exist('format', 'var')
    datumFormat = '%0.2f';
end

if ~exist('flag_xyProps', 'var')
    flag_xyProps = '';
end

switch lower( flag_xyProps )
    case {'x'}
        OUTPUT_XPROPS = 1;
        OUTPUT_YPROPS = 0;
    case{'y'}
        OUTPUT_XPROPS = 0;
        OUTPUT_YPROPS = 1;   
    case{  'xy', 'yx'}        
        OUTPUT_XPROPS = 1;
        OUTPUT_YPROPS = 1;
    otherwise        
        OUTPUT_XPROPS = 0;
        OUTPUT_YPROPS = 0;
end

% path���ù�

%% 
tic

% ��fprintf���ܵõ���Ч������
tic
fid     = fopen(filename, 'w+');

dat     = obj.data;
[Y,X]   = size(dat);

% �Ȱ�һ�еı��ʽ�������������һ��
exp1    = '';
for x = 1:X
    exp1 = [exp1, datumFormat, '\t'];
end
% exp_y = ['%s\t' exp1];


%% �����Ҫ�����������������ֵ��obj.xProps��
if OUTPUT_XPROPS
%     % ��ʱ�����ֱ�����
%     fprintf( fid, '%s\t','');
%     for x = 1:X
%         fprintf( fid, '%s\t', obj.xProps{x});
%     end
%     fprintf( fid, '\n');

    
    % �������ֿ�һ��İ취
    out_x   = '';
    exp_x   = '\t';
    for x = 1:X
        exp_x   = [exp_x, '%s\t'];
        out_x   = [out_x  ', ''' obj.xProps{ x }  ''''];
    end    
    eval( [   ' fprintf( fid,  exp_x'  out_x  ');'    ] );
end

%% main һ��һ��д,��һ����һ����д�����
for y = 1:Y
    % ������Ҫ�����ÿ�е�������������ֵ��obj.yProps)
    if OUTPUT_YPROPS
        fprintf(fid, ['%s\t' exp1 '\n'], obj.yProps{y}, dat(y,:));
    else
        fprintf(fid, [exp1,'\n'],        dat(y,:));
    end
end

%%
fclose(fid);
toc


% �����ʽ���ܿ��ƣ���Ҫ����
% save([dataPath, '\', filename], obj.data, '-ascii' );
    

end

