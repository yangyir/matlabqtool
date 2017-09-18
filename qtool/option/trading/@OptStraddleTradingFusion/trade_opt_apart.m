function trade_opt_apart(obj, direc, volume, offset, px)
% ����trade_opt�Ĳ��µ�����
% trade_opt_apart(obj, direc, volume, offset, px)
% wyf 20161229

% Ԥ���ж�
if ~exist('direc', 'var'),     direc = '1';     end
if ~exist('volume','var'),     volume = 1;      end
if ~exist('offset', 'var'),    offset = '1';    end


% �𵥲���
entrust_amounts = obj.split_amount(volume);


% �����µ�����
if ~exist('px', 'var')
    for entrust_t = 1:length(entrust_amounts)
        entrust_amount = entrust_amounts(entrust_t);
        obj.trade_opt(direc, entrust_amount, offset);
    end
else
    for entrust_t = 1:length(entrust_amounts)
        entrust_amount = entrust_amounts(entrust_t);
        obj.trade_opt(direc, entrust_amount, offset, px);
    end
end








end