function [ output_args ] = copyTo( obj, dest )
%COPYTO 从老的object上copy到destination上 
% chenggang， 151111

%% check Class
c1 = class(obj);
c2 = class(dest);

if ~strcmp(c1, c2) 
    error(['error: original class = ' c1  ';  destination class = ' c2 '!']);
end

%%
flds    = fields( obj );

for i = 1:length(flds)
    fd          = flds{i};
    dest.(fd) = obj.(fd);
end    

end

