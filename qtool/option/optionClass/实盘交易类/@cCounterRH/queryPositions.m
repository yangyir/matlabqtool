function [positionArray, ret] = queryPositions(obj, code)
%cCounterRH
if ~exist('code', 'var')
    code = '';
end

[positionArray, ret] = rh_counter_getpositions(obj.counterId, code);

if ~ret
    disp('≤È—Ø≥÷≤÷ ß∞‹')
end

end