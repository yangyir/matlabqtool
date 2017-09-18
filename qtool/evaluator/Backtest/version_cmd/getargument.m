function getargument(edit_handle_in,edit_handle_out)

varname = get(edit_handle_in,'string');

if exist(varname,'var')
    var = eval(varname);
elseif exist(varname,'file')
    [~,~,ext] = fileparts(varname);
    switch ext
        case {'.txt','.mat'}
            var = load(varname);
        case {'.xlsx','.xls'}
            [~,~,var] = xlsread(varname);
        otherwise
    end
else
    error('wrong input');
end

if isstruct(var)
    names = fieldnames(var);
    var = eval(strcat('var','.',names{1,1}));
end
if iscell(var)&&iscell(var{1,1})
    var =var{1,1};
end

if isnumeric(var)
    state1 ='[';
    state2 = ']';
else
    state1 ='{';
    state2 = '}';
end
for index =1 :length(var)
    if index ==1
        state = strcat(state1,'''',var{index} ,'''');
    else
        state = strcat(state,';''',var{index} ,'''');
    end
end
state = strcat(state,state2);
set(edit_handle_out,'string',state);


end
