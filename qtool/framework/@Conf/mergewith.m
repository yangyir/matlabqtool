function [ newconf, obj ] = mergewith( obj, conf, overwrite_type )
% 新的conf加入，组成更完整的config，可直接输出
% overright_type = 1, conf 覆盖 obj.conf  默认
% overright_type = 2, obj.conf 覆盖 conf

% 程刚，20131210

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

