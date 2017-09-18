classdef Basket
    %BASKET 一篮子资产，单期权
    %   Detailed explanation goes here
    
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        underNum; % 基底资产数量，防错用
        
        % 多资产
        underCode;
        underName;
        underP; %S0
        bsVol; %标量
        
        
        % 多资产
        volSurf;  % 其实是一条线（两列），vol（ ST )  
        corr; % 相关性矩阵，极其重要
        
        
        % 单期权
        type; % c, p
        strike;  % K        
        position; % +1, -1, 默认+1

    end
    
    methods
    end
    
end

