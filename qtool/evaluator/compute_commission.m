function [commission_array] = compute_commission(oprnValue,commission_index)
%%
% If commission_index<1, 
%   fixed commission rate.
% If commission_index==1, 
%   5 yuan when transaction value x<=5000yuan, 
%   10bp when x>5000.
% If commission_index==2,
%   10bp stamp duty;
%   5 yuan when transaction value x<=2000 yuan, 
%   25bp when 2000<x<=10000, 
%   20bp when 10000<x<=50000, 
%   15bp when 50000<x<=100000,
%   10bp when x>100000.
%%
oprnValue = abs(oprnValue);
switch floor(commission_index)
    case 0
        commission_array = commission_index.*oprnValue;
    case 1
        fun = @(x)5.*(x<=5000)+0.0001*x.*(x>5000);
        commission_array = fun(oprnValue);     
    case 2
        stampDuty = 0.001.*oprnValue;
        fun = @(x)5.*(x<=2000)+0.0025*x.*(2000<x&x<=10000)+0.002*x.*(10000<x&x<=50000)+0.0015*x.*(50000<x&x<=100000)+0.001*x.*(x>100000);
        commission_array = stampDuty+fun(oprnValue);
    otherwise
        error('Cannot compute commission!');
end        
end