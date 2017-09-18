function objSingleAsset = build_SingleAsset(assetname,data, dates)
%%
%
%%
objSingleAsset = SingleAsset;
dateSpan = size(data,1);

if dateSpan == size(dates,1)
    objSingleAsset.T=dateSpan;
else
    error('Data and dates dimension conflict!');
end

objSingleAsset.data = data;
objSingleAsset.dates = dates;
objSingleAsset.tstypes = {assetname};
objSingleAsset.N = size(data,2);

end