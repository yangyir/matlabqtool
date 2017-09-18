function [ obj ] = toTxt( obj, filename, datumFormat, flag_xyProps )
% obj.data写成txt文件，默认二进制， '%0.2f\t'
% [ obj ] = toTxt( obj, filename, datumFormat )
%     filename:  含路径的文件名，默认：[obj.des '_' obj.des2 '_Mat2D.txt']
%     datumFormat：单个数据的格式，默认'%0.2f'
%     flag_label: 是否加入x轴和y轴的项目名字，取值为：''(默认),'x', 'y', 'xy', 'yx'
% ------------
% 程刚，20150518，初版本
% 程刚，20150531，加入flag_xyProps


%% 前处理
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

% path不用管

%% 
tic

% 用fprintf才能得到好效果。慢
tic
fid     = fopen(filename, 'w+');

dat     = obj.data;
[Y,X]   = size(dat);

% 先把一行的表达式搞出来。这样快一点
exp1    = '';
for x = 1:X
    exp1 = [exp1, datumFormat, '\t'];
end
% exp_y = ['%s\t' exp1];


%% 如果需要，输出列名（横坐标值，obj.xProps）
if OUTPUT_XPROPS
%     % 暂时用这种笨方法
%     fprintf( fid, '%s\t','');
%     for x = 1:X
%         fprintf( fid, '%s\t', obj.xProps{x});
%     end
%     fprintf( fid, '\n');

    
    % 试试这种快一点的办法
    out_x   = '';
    exp_x   = '\t';
    for x = 1:X
        exp_x   = [exp_x, '%s\t'];
        out_x   = [out_x  ', ''' obj.xProps{ x }  ''''];
    end    
    eval( [   ' fprintf( fid,  exp_x'  out_x  ');'    ] );
end

%% main 一行一行写,比一个数一个数写快多了
for y = 1:Y
    % 如有需要，输出每行的行名（纵坐标值，obj.yProps)
    if OUTPUT_YPROPS
        fprintf(fid, ['%s\t' exp1 '\n'], obj.yProps{y}, dat(y,:));
    else
        fprintf(fid, [exp1,'\n'],        dat(y,:));
    end
end

%%
fclose(fid);
toc


% 输出格式不能控制，不要用了
% save([dataPath, '\', filename], obj.data, '-ascii' );
    

end

