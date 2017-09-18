function [isequal] = double_equal(src, dst)
% double_equal 目的是检查两个浮点数是否相等，由于浮点数运算会有精度损失，用==或者 >= <= 等逻辑运算符
% 未必能够得到预期的结果。所以用double_equal来判断相等。
% true = abs(src - dst) < exp(-8)
% false = abs(src - dst) >= exp(-8)
    isequal = abs(src - dst) < exp(-8);
end