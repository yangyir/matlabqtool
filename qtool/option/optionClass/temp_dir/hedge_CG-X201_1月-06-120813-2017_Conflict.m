function varargout = hedge(varargin)
% HEDGE MATLAB code for hedge.fig
%      HEDGE, by itself, creates a new HEDGE or raises the existing
%      singleton*.
%
%      H = HEDGE returns the handle to a new HEDGE or the handle to
%      the existing singleton*.
%
%      HEDGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HEDGE.M with the given input arguments.
%
%      HEDGE('Property','Value',...) creates a new HEDGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hedge_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hedge_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hedge

% Last Modified by GUIDE v2.5 06-Jan-2017 12:04:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hedge_OpeningFcn, ...
                   'gui_OutputFcn',  @hedge_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before hedge is made visible.
function hedge_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hedge (see VARARGIN)

% Choose default command line output for hedge
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hedge wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = hedge_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in do_hedge_pushbutton.
function do_hedge_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to do_hedge_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i = 1;
disp('Do Hedge');
% bh.do_hedge;
% hedger.do_hedge;


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over do_hedge_pushbutton.
function do_hedge_pushbutton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to do_hedge_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function current_value_edit_Callback(hObject, eventdata, handles)
% hObject    handle to current_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of current_value_edit as text
%        str2double(get(hObject,'String')) returns contents of current_value_edit as a double


% --- Executes during object creation, after setting all properties.
function current_value_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_value_edit_Callback(hObject, eventdata, handles)
% hObject    handle to delta_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta_value_edit as text
%        str2double(get(hObject,'String')) returns contents of delta_value_edit as a double
global book_hedger;
current_delta = book_hedger.getRiskDelta;
delta_value = str2double(get(hObject, 'String'));
target_value = current_delta + delta_value;
T = findobj('tag', 'target_value_edit');
set(T, 'String', num2str(target_value));
set(findobj('tag', 'current_value_edit'), 'String', num2str(current_delta));
set(findobj('tag', 'delta_value_edit'), 'String', num2str(delta_value));
% book_hedger.set_target_delta(target_value);

% 设置target value 以显示


% --- Executes during object creation, after setting all properties.
function delta_value_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target_value_edit_Callback(hObject, eventdata, handles)
% hObject    handle to target_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target_value_edit as text
%        str2double(get(hObject,'String')) returns contents of target_value_edit as a double
global book_hedger;
current_value = book_hedger.getRiskDelta;
target_value = str2double(get(hObject,'String'));
delta_value = target_value - current_value;
T = findobj('tag', 'delta_value_edit');
set(T, 'String', num2str(delta_value));
set(findobj('tag', 'current_value_edit'), 'String', num2str(current_value));
% book_hedger.set_target_delta(target_value);
% 设置delta value;

% --- Executes during object creation, after setting all properties.
function target_value_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_delta_button.
function check_delta_button_Callback(hObject, eventdata, handles)
% hObject    handle to check_delta_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global book_hedger;
current_delta = book_hedger.getRiskDelta;
T = findobj('tag', 'current_value_edit');
set(T, 'String', num2str(current_delta));
target_value = str2double(get(findobj('tag', 'target_value_edit'), 'String'));
if ~isnan(target_value)
    delta_value = target_value - current_delta;
    set(findobj('tag', 'delta_value_edit'), 'String', num2str(delta_value));
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in direction_buy_radiobutton.
function direction_buy_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to direction_buy_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of direction_buy_radiobutton


% --- Executes on button press in direction_sell_radiobutton.
function direction_sell_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to direction_sell_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of direction_sell_radiobutton


% --- Executes on button press in offset_open_radiobutton.
function offset_open_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to offset_open_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of offset_open_radiobutton


% --- Executes on button press in offset_close_radiobutton.
function offset_close_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to offset_close_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of offset_close_radiobutton



function time_edit_Callback(hObject, eventdata, handles)
% hObject    handle to time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_edit as text
%        str2double(get(hObject,'String')) returns contents of time_edit as a double


% --- Executes during object creation, after setting all properties.
function time_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function strike_value_edit_Callback(hObject, eventdata, handles)
% hObject    handle to strike_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of strike_value_edit as text
%        str2double(get(hObject,'String')) returns contents of strike_value_edit as a double


% --- Executes during object creation, after setting all properties.
function strike_value_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to strike_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target_vol_edit_Callback(hObject, eventdata, handles)
% hObject    handle to target_vol_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target_vol_edit as text
%        str2double(get(hObject,'String')) returns contents of target_vol_edit as a double


% --- Executes during object creation, after setting all properties.
function target_vol_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target_vol_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setting_pushbutton.
function setting_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to setting_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global book_hedger;
global qms;
% 取时间，取K值, 取类型
iT = str2num(get(findobj('tag', 'time_edit'), 'String'));
K = str2num(get(findobj('tag', 'strike_value_edit'), 'String'));
type = 'call';
select_call = get(findobj('tag', 'call_radiobutton'), 'Value');
if select_call ~= 1
    type = 'put';
end
% 取数量
target_vol =  str2num(get(findobj('tag', 'target_vol_edit'), 'String'));
% 取买卖
direction = 'buy';
select_buy = get(findobj('tag', 'buy_radiobutton'), 'Value');
if select_buy ~= 1
    direction = 'sell';
end
% 取开平
offset = 'open';
select_offset = get(findobj('tag', 'open_radiobutton'), 'Value');
if select_offset ~= 1
    offset = 'close';
end
% 检查是否已有。
asset_quote = qms.getOptQuoteByTK(iT, K, type);
code = asset_quote.code;
[found, index] = book_hedger.hedgers_.contains(code);
% 是，更新。
if found
    % 提供更新方法
    book_hedger.updateHedger(index, direction, offset, target_vol);
else
    % 否，新增。
    book_hedger.attachHedger(asset_quote, direction, offset, target_vol);
end
% 更新其他控件展示
% 更新列表
display_hedgers_table;
% 更新变化Delta
book_hedger.check_hedge_condition;
current_delta = book_hedger.getRiskDelta;
delta_delta = book_hedger.getHedgeDelta;
target_delta = current_delta + delta_delta;

set(findobj('tag', 'current_value_edit'), 'String', num2str(current_delta));
set(findobj('tag', 'delta_value_edit'), 'String', num2str(delta_delta));
set(findobj('tag', 'target_delta'), 'String', num2str(target_delta));
% 更新目标Delta


% --- Executes on button press in delete_hedger_pushbutton.
function delete_hedger_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to delete_hedger_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 


% --- Executes on button press in initial_pushbutton.
function initial_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to initial_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 从外部载入所需对象
global qms;
qms = getappdata(handles.output, 'QMS');
global book_hedger;
book_hedger = getappdata(handles.output, 'BookHedger');
book_hedger.check_hedge_condition;
current_delta = book_hedger.getRiskDelta;
T = findobj('tag', 'current_value_edit');
set(T, 'String', num2str(current_delta));
target_delta = 0;
delta_delta = target_delta - current_delta;
set(findobj('tag', 'delta_value_edit'), 'String', num2str(delta_delta));
set(findobj('tag', 'target_value_edit'), 'String', num2str(target_delta));
set(hObject, 'Enable', 'off');

%更新表格
display_hedgers_table;
% count = book_hedger.hedgers_.count;
% % data = cell(count, 5);
% for i = 1:count
%     quote = book_hedger.hedgers_.node(i).asset_quote_;
%     name(i) = {quote.getName};
%     quantity(i) = book_hedger.hedgers_.node(i).target_vol_;
%     direction(i) = {book_hedger.hedgers_.node(i).direction_};
%     offset(i) = {book_hedger.hedgers_.node(i).offset_};
%     hedge_delta(i) = quote.calcDollarDelta1 * quantity(i);
%     data(i, :) = [name(i), quantity(i), direction(i), offset(i), hedge_delta(i)];
% end

% set(findobj('tag', 'hedgers_uitable'), 'data', data);



% --- Executes during object creation, after setting all properties.
function hedgers_uitable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hedgers_uitable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function display_hedgers_table()
%function display_hedgers_table()
%更新表格
global book_hedger;
count = book_hedger.hedgers_.count;
% data = cell(count, 5);
for i = 1:count
    quote = book_hedger.hedgers_.node(i).asset_quote_;
    name(i) = {quote.getName};
    quantity(i) = book_hedger.hedgers_.node(i).target_vol_;
    direction(i) = {book_hedger.hedgers_.node(i).direction_};
    offset(i) = {book_hedger.hedgers_.node(i).offset_};
    hedge_delta(i) = book_hedger.hedgers_.node(i).target_delta;
    data(i, :) = [name(i), quantity(i), direction(i), offset(i), hedge_delta(i)];
end
set(findobj('tag', 'hedgers_uitable'), 'data', data);


function display_hedger_detail(hedger)
%function display_hedger_detail(hedger)
% 展示所选的T K 买卖信息 target 等等
iT = hedger.asset_quote_.iT;
K = hedger.asset_quote_.K;
type = hedger.asset_quote_.CP;
target_vol = hedger.target_vol_;
dir = hedger.direction_;
offset = hedger.offset_;

% 设置展示。
% iT
set(findobj('tag', 'time_edit'), 'String', num2str(iT));
% K
set(findobj('tag', 'strike_value_edit'), 'String', num2str(K));
% target
set(findobj('tag', 'target_vol_edit'), 'String', num2str(target_vol));
% 设置Radiobuttons
value_type = 1;
if strcmp(type, 'call')
    set(findobj('tag', 'call_radiobutton'), 'Value', value_type);    
else
    set(findobj('tag', 'put_radiobutton'), 'Value', value_type);
end
value_dir = 1;
if strcmp(dir, 'buy')    
    set(findobj('tag', 'buy_radiobutton'), 'Value', value_dir);
else
    set(findobj('tag', 'sell_radiobutton'), 'Value', value_dir);
end

value_offset = 1;
if strcmp(offset, 'open')
    set(findobj('tag', 'open_radiobutton'), 'Value', value_offset);
else
    set(findobj('tag', 'close_radiobutton'), 'Value', value_offset);
end





% --- Executes on key press with focus on hedgers_uitable and none of its controls.
function hedgers_uitable_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to hedgers_uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in hedgers_uitable.
function hedgers_uitable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to hedgers_uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global book_hedger;
% 根据index找到hedger
row_index = eventdata.Indices(1);
hedger = book_hedger.hedgers_.node(row_index);

% 展示所选的T K 买卖信息 target 等等
display_hedger_detail(hedger);

% --- Executes when entered data in editable cell(s) in hedgers_uitable.
function hedgers_uitable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to hedgers_uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in arrange_pushbutton.
function arrange_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to arrange_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查并分配对冲数量
% 更新表格