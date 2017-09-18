function output = readargument2(name)
Path = which(name);
fid = fopen(Path);
tline = fgetl(fid);
while ischar(tline)
    if ~isempty(tline)&&~strcmp(tline(1),'%')&&strcmp(tline(1:8),'function')
        break;
    end
    tline = fgetl(fid);
end
[~,tline] =strtok(tline,'(');
[tline,~] =strtok(tline,'%');
[tline,~] =strtok(tline,')');
tline =tline(2:end);

argnum = nargin(name);
if argnum ==1
    output{1} = tline;
else
    for index =1:argnum
        [output{index},tline]= strtok(tline,',');
    end
end

end
