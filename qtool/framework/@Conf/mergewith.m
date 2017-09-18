function [ newconf, obj ] = mergewith( obj, conf, overwrite_type )
% �µ�conf���룬��ɸ�������config����ֱ�����
% overright_type = 1, conf ���� obj.conf  Ĭ��
% overright_type = 2, obj.conf ���� conf

% �̸գ�20131210

%% 
if ~exist('overwrite_type', 'var')||overwrite_type ~= 2
    overwrite_type = 1;
end

%% main
switch overwrite_type
    case {1}
        fn = fieldnames(conf);
        for i = 1: length(fn)
            % obj.config.xxx = conf.xxx;
            eval( ['obj.config.' fn{i} '= conf.' fn{i} ';'] );
        end
        
    case {2}
        fn = fieldnames(obj.config);
        for i = 1:length(fn)
            % conf.xxx = obj.config.xxx;
            eval( ['conf.' fn{i} ' = obj.config.' fn{i} ';' ] );            
        end
        obj.config = conf;
end

newconf = obj.config;


end

