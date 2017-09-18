function [ idx ] = getIdxByPropvalue( obj, propvalueStr)
%GETIDXBYPROPVALUE Summary of this function goes here
%   Detailed explanation goes here

idx = find(   strcmp(propvalueStr, obj.yProps)   );


end

