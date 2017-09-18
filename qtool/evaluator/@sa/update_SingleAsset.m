function [ asset ] = update_SingleAsset( asset, indicator, indName )
%UPDATE_SINGLEASSET Summary of this function goes here
%   Detailed explanation goes here
%%
asset.tstypes = horzcat(asset.tstypes,{indName});
asset.data = horzcat(asset.data, indicator);
asset.N = asset.N +1;

end

