function output = readfromcache_returns(indexcode,startdate,enddate,Style)
global Path_Gildata;
Path = strcat(Path_Gildata,'\Backtest\Cache\returns.dat');
data = dlmread(Path);

indexcode = lower(indexcode);
switch indexcode
    case '000300.shi'
        column = 2;
    case '000001.shi'
        column = 3 ;
    case 'riskfree'
        column = 4;
    otherwise
        error('²ÎÊı´íÎó£¡');
end

data = data(:,[1,column]);
startdate = datenum(startdate);
enddate =datenum(enddate);
if Style ==2
    data = data(data(:,1)>=startdate & data(:,1)<=enddate,:);
    output =[cellstr(datestr(data(:,1),29)),num2cell(data(:,2))];
else
    data1 = data(data(:,1)>=startdate & data(:,1)<=enddate,:);
    Date = (startdate:enddate)';
    Temp = cell(size(Date,1),1);
    loc = ismember(Date,data1(:,1));
    Temp(loc) = num2cell(data1(:,2));
    output =[cellstr(datestr(Date,29)),Temp];
end


end

