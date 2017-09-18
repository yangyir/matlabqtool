function [es] = place_entrust_opt_apart(obj, direc, volume, offset, px)
% ����place_entrust_opt�Ĳ��µ�����
% place_entrust_opt_apart(obj, direc, volume, offset, px)
% wyf 20161229 
% cg, 170727, ��������entrusts


% Ԥ���ж�
if ~exist('direc', 'var'),    direc  = '1';    end
if ~exist('volume','var'),    volume = 1;      end
if ~exist('offset', 'var'),   offset = '1';    end


% ��ȡ����
if ~exist('px', 'var')
    opt = obj.opt;
    opt.fillQuote;
    % Ĭ��ȡ����1��
    if strcmp(direc, '1')
        px = opt.askP1;
    elseif strcmp(direc, '2')
        px = opt.bidP1;
    end
end


% ���в𵥲���
entrust_amounts = obj.split_amount(volume);
L = length(entrust_amounts);
es(1:L) = Entrust;
for iEntrust = 1:L
    entrust_amount = entrust_amounts(iEntrust);
    es(iEntrust) = obj.place_entrust_opt( direc, entrust_amount, offset, px );
end








end