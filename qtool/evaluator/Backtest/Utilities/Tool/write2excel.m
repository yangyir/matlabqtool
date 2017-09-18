function [] = write2excel( filename,varargin )
% data is a cell matrix;
%% Check input argument;
tic
if ~mod(nargin,2)
    error('Input argument error for write2excel()');
end
%% 
% Set file path
dirPath = [cd, '\res\'];
if ~isdir(dirPath)
    mkdir(dirPath);
end

filePath = [cd,'\res\',filename];
if exist(filePath,'file')
    delete(filePath);
end
% Open an excel object. This step is very slow.
Excel = actxserver('Excel.Application');

% Set it to be visible.
set(Excel, 'Visible', 1);
% Disable excel alert
% set(Excel,'DisplayAlerts',0);
% Create workbook object
Workbooks = Excel.Workbooks;
% Add a new workbook
Workbook = invoke(Workbooks,'Add');
% Get currently active sheet group. A workbook have 3 active sheets. 
Sheets = Excel.ActiveWorkBook.Sheets;

for i = 1:(nargin-1)/2
    cellForm = varargin{2*i-1};
    formName = varargin{2*i};
    disp(['Saving ' formName ' to ' filename]);
    % Calculate data range
    [rows,cols] = size(cellForm);
    dataRange = ['A1:',num2UpperStr(cols),num2str(rows)];
    if i<=3   
        % Get one sheet from the group, the index cannot be larger than 3.
        sheet1 = get(Sheets, 'Item', i);
    else
        sheet1 = Sheets.Add([], Sheets.Item(Sheets.Count));
    end

    
    sheet1.Name = formName;
    %Sheets.Item(1).Name = objectName;
    % activate the sheet.
    invoke(sheet1, 'Activate');
    % Get a handle to the active sheet
    Activesheet = Excel.Activesheet;

    % Set active range, assign value for active range, use either of the two statement
    ActivesheetRange = get(Activesheet, 'Range', dataRange);
    set(ActivesheetRange, 'Value', cellForm);
end
% If the workbook was created as new, invoke 'SaveAs' here.
% If opened an existing workbook, invoke 'Save'
invoke(Workbook, 'SaveAs',filePath);
% Exit excel.
% invoke(Excel, 'Quit');
delete(Excel);
toc
end


