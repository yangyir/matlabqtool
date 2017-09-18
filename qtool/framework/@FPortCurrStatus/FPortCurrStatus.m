classdef FPortCurrStatus < handle
% FPortCurrStatus, current status of portfolio in a specific future market.
%
% Its properties consist of three parts: 
% 1. instant properties reflecting the lastest status of our portfolio.
%    They are subject to change after each minimum time window. There
%    properties are:
%    enterPrice
%        maxUnit by 1 vector, recording the average cost of each position increment.
%    enterPos
%        maxUnit by 1 vector, number of positions for each increment.
%        Positive numbers for long positions, negative for short.
%        enterPrice and enterPos are updated by class methods.
%        Users cannot modify them directly.
%    stopLoss
%        maxUnit by 1 vector, stop loss price for each position increment.
%        Users can set their own stopLoss after adding position.
%    currUnit
%        current increments(unit) of positions. 
%        currUnit = sum(enterPos~=0);
%    account
%        current account value.
%    fundEmploymentRate
%        current fund employment rate.
%        fund employment rate = current margin/ current account.
%    lastWin
%        flag of result of last transaction.
%        1, last transaction profits; 
%        0, last transaction losses;
%    virtualOn
%        A virtual label is useful when an operation signal should be 
%        monitored but doesn't lead to an operation. A virtual operation is
%        record only in the FPortCurrStatus object. It has no effect on
%        user's account.
%        1, transactin is virtual;
%        0, transaction is not virtual.
        
% 2. risk control properties reflecting risk tolerance of your strategy.
%    They are set when instantiating an object and cannot be altered. These
%    properties are:
%    maxFER
%        maximum fund employment rate.
%    maxUnit
%        maximum units of position allowed.
% 3. market(contract) properties which are some basic parameters that
%    defines the market(contract). They are initialized at instantiation
%    and cannot be modified later.These properties are:
%    tradeCode
%        tradeCode for future contract. Such as 'AU', 'IF', etc.
%    multiplier
%        contract multiplier. for IF, it is 300.
%    marginRate
%        margin rate. For IF, it is 0.12.
%    minQuoteUnit
%        minimum quote unit. For IF, it is 0.2.
%    maxSwing
%        maximum swing limit in each trading day. For IF, it is +-10%.
%    commissionRate
%        commission rate.
%
% Its methods include
% 1. [] = FPortCurrStatus(tCode,mlplr,marginR,minU,commRate,maxS,maxFundEmploymentRate)
%    Constructor that sets the risk control properties and contract properties.
%    If parameter list is empty, create an empty FPortCurrStatus object.
% 2. [] = set_pos(obj,maximumUnit)
%    set_pos sets the maximum position units and sets position related
%    instant properties to zeros or empty.
% 3. [] = set_virtual(obj,direction)
%    set virtual transaction on.
%    direction ==1, long position; -1, short.
% 4. [ position, avgCost, commission] = add_pos( obj,spotPrice, posAdd );
%    Build or increment positions at spotPrice, and output current total
%    position, average cost, and operation commission.
% 5. [ position, avgCost,commission] = close_pos( obj, closePrice);
%    Close all positions at spotPrice, set current total positions and
%    average cost to zeros, and return operation commission.
% 6. [ position, avgCost, commission ] = flop_pos(obj, spotPrice,posNew );
%    Close current positions and build opposite positions, return latest
%    position, avgCost and total commissions.
% 7. [] = set_stopLoss(obj,stopLossPrice)
%    Set stopLoss price for the last increment. 
% 8. flag = touch_stopLoss(obj,spotPrice)
%    Determine if the spotPrice can trigger stop loss.
% 9. [position, avgCost, commission ] = cut_pos(obj, spotPrice, posCut)
% Reduce open interests by selling or buying to cover posCut contracts at spotPrice.
% Return position avgCost and commission after operation.

% Qichao Pan, 2013/04/12 17:07:00, GMT+8, V1.0
% Qichao Pan, 2013/04/16 14:43:00, GMT+8, V2.0
%   1.add cut_pos();
%   2.delete posUnit, nValue.
%%
    % instant properties
    properties (SetAccess = 'private', GetAccess = 'public', Hidden = false)
        enterPrice; 
        enterPos;
    end
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        account             = 0;
        fundEmploymentRate  = 0;
        virtualOn           = 0;
        stopLoss;
    end
    
    % risk control properties
    properties(SetAccess = 'private', GetAccess = 'public', Hidden = false)
        maxFER;
        maxUnit;
        currUnit    = 0;
        lastWin     = 0;
    end
    
    % market(contract) properties
    properties(SetAccess = 'private', GetAccess = 'public', Hidden = true)
        tradeCode; 
        multiplier;
        marginRate;
        minQuoteUnit;
        maxSwing;
        commissionRate;
    end
    
    
    methods (Access = 'public', Static = false, Hidden = false )
        function obj = FPortCurrStatus(tCode,mlplr,marginR,minU,commRate,maxS,maxFundEmploymentRate)
            if nargin == 0
                return;
            end
            obj.tradeCode       = tCode;
            obj.multiplier      = mlplr;
            obj.marginRate      = marginR;
            obj.minQuoteUnit    = minU;
            obj.commissionRate  = commRate;
            obj.maxSwing        = maxS;
            obj.maxFER          = maxFundEmploymentRate;
        end
        
        function [] = set_virtual(obj,direction)
            
            if obj.virtualOn
                error('Virtual position is already on!');
            else
                obj.virtualOn = direction;
            end
        end
        
        function [] = set_pos(obj,maximumUnit)       
            obj.enterPrice  = zeros(1,maximumUnit);
            obj.enterPos    = zeros(1,maximumUnit);
            obj.stopLoss    = zeros(1,maximumUnit);
            obj.currUnit    = 0;
            obj.virtualOn   = 0;
            obj.fundEmploymentRate = 0;
            obj.maxUnit     = maximumUnit;
        end
        
        function [] = set_stopLoss(obj,stopLossPrice)
            absUnit = abs(obj.currUnit);
            if obj.stopLoss(absUnit)
                error('Please add position first!');
            end
            obj.stopLoss(absUnit) = stopLossPrice;
        end
        
        function flag = touch_stopLoss(obj,spotPrice)
            absUnit = abs(obj.currUnit);
            flag = 0;
            if obj.currUnit>0&&spotPrice<obj.stopLoss(absUnit)
                flag = 1;
            elseif obj.currUnit<0&&spotPrice>obj.stopLoss(absUnit)
                flag = 1;
            end
        end
            
        [ position, avgCost, commission]    = add_pos( obj,spotPrice, posAdd );
        [ position, avgCost,commission]     = close_pos( obj, closePrice);
        [ position, avgCost, commission ] 	= flop_pos(obj, spotPrice,posNew );
        [ position, avgCost, commission ]   = cut_pos(obj, spotPrice, posCut);
    end
    
    
    
end

