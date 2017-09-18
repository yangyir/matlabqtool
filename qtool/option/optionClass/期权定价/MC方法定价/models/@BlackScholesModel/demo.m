function [  ] = demo(  )
%DEMO Summary of this function goes here
%   Detailed explanation goes here


m = BlackScholesModel;


m.stepT = 20;
m.mu = 0.03;
m.iterN = 10;

S = m.generate_S_from_model;


plot(S')


end

