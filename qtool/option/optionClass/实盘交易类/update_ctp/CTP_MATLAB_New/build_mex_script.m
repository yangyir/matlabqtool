
cpp_files = dir('*.cpp');

L = length(cpp_files);
for i = 1:L
    file_name = cpp_files(i).name;
    ret = false;
    trytime = 0;
    while ~ret & trytime < 10
        try
            disp(file_name);
            mex('-g', file_name);
            disp(file_name);
            ret = true;
            trytime = 0;
        catch e
            ret = false;
            trytime = trytime + 1;
        end
    end
%     pause(3);
end