classdef cdl
% 蜡烛图形态判别
% 参考书：《日本蜡烛图技术》，1998年5月第一版
% Pan, Qichao; 201304; 测试ok
    
    properties (Constant,Access = 'public', Hidden = false)
        pattern = ...
        {'BeltHoldDown'
        'BeltHoldUp'
        'CounterattackDown'
        'CounterattackUp'
        'CrossAfterLongYang'
        'CrossHarami'
        'DarkCloudCover'
        'DownSeparating'
        'DownSidebySideYang'
        'DownsideGapYinyang'
        'DownThreeMethod'
        'EngulfingDown'
        'EngulfingUp'
        'EveningCrossStar'
        'EveningStar'
        'GravestoneCross'
        'Hammer'
        'Harami'
        'HighWave'
        'LongLeggedCross'
        'MorningCrossStar'
        'MorningStar'
        'PiercingDown'
        'PiercingUp'
        'Rickshaw'
        'ShootingStar'
        'ThreeCrows'
        'ThreeStars'
        'ThreeWhite'
        'TweezerBottom'
        'TweezerTop'
        'UnclosedWindowUp'
        'UnclosedWindowDown'
        'UpSeparating'
        'UpSidebySideYang'
        'UpsideGapYinyang'
        'UpsideTwoCrows'
        'UpThreeMethod'
        };   
    end
    properties (SetAccess = 'private',GetAccess = 'public')
        zoomFactor = 1;
    end
    
    methods (Access = 'public', Static = false, Hidden = false)
        [ indBeltHoldDown ] = isBeltHoldDown( obj, bars );
        [ indBeltHoldUp ] = isBeltHoldUp( obj, bars );
        [ indCounterattackDown ] = isCounterattackDown( obj, bars );
        [ indCounterattackUp ] = isCounterattackUp( obj, bars );
        [ indCrossAfterLongYang ] = isCrossAfterLongYang(obj,  bars );
        [ indCrossHarami ] = isCrossHarami( obj,bars );
        [ indDarkCloudCover ] = isDarkCloudCover(obj,  bars );
        [ indDownSeparating ] = isDownSeparating(obj,  bars );
        [ indDownSidebySideYang ] = isDownSidebySideYang(obj,  bars );
        [ indDownsideGapYinyang ] = isDownsideGapYinyang( obj,bars );
        [ indDownThreeMethod ] = isDownThreeMethod( obj, bars );
        [ indEngulfingDown ] = isEngulfingDown( obj,bars );
        [ indEngulfingUp ] = isEngulfingUp( obj,bars);
        [ indEveningCrossStar ] = isEveningCrossStar(obj, bars );
        [ indEveningStar ] = isEveningStar(obj, bars );
        [ indGravestoneCross ] = isGravestoneCross(obj,  bars );
        [ indHammer ] = isHammer(~,bars);
        [ indHarami ] = isHarami(obj,  bars );
        [ indHighWave ] = isHighWave( obj, bars );
        [ indLongLeggedCross ] = isLongLeggedCross( obj, bars );
        [ indMorningCrossStar ] = isMorningCrossStar(obj, bars );
        [ indMorningStar ] = isMorningStar(obj, bars );
        [ indPiercingDown ] = isPiercingDown( obj,bars );
        [ indPiercingUp ] = isPiercingUp( obj,bars );
        [ indRickshaw ] = isRickshaw( obj,bars );
        [ indShootingStar ] = isShootingStar(~, bars );
        [ indThreeCrows ] = isThreeCrows(obj, bars );
        [ indThreeStar ] = isThreeStars( obj,bars );
        [ indThreeWhite ] = isThreeWhite( obj,bars );
        [ indTweezerBottom ] = isTweezerBottom(obj, bars );
        [ indTweezerTop ] = isTweezerTop(obj, bars );
        [ indUnclosedWindowUp ] = isUnclosedWindowUp(~, bars );
        [ indUnclosedWindowDown ] = isUnclosedWindowDown(~, bars );
        [ indUpSeparating ] = isUpSeparating(obj, bars );
        [ indUpSidebySideYang ] = isUpSidebySideYang(obj, bars );
        [ indUpsideGapYinyang ] = isUpsideGapYinyang( obj,bars );
        [ indUpsideTwoCrows ] = isUpsideTwoCrows( ~,bars);
        [ indUpThreeMethod ] = isUpThreeMethod(obj, bars );
        
        % supporting function
        [ indCross ] = isCross(obj, bars );
        [ indHalt ] = isHalt(~, bars );
        [ indStar ] = isStar(obj, bars );
        [ indWindow ] = isWindow( ~,bars );
    end
    methods(Access = 'public',Static = true, Hidden = false)
        % plot
        [] = label_pattern( bars,ind,varargin);
    end
    
    methods
        function obj = cdl(value)
            if nargin ==0
                return;
            else
                obj.zoomFactor = value;
            end
        end

    end
    
    
end

