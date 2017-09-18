clear all; rehash;

S = 0.95:0.001:1.2;
size(S)
y = zeros(size(S));
size(y)
[~,count] = size(S);
for i = 1:count
    %     y(i) = payoff_design_7_cmp(S(i));
    y(i) = payoff_design_1_call(S(i));
end
y
plot (S,y);