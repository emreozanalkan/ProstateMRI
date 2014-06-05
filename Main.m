function varargout = Main(varargin)
% MAIN MATLAB code for Main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main

% Last Modified by GUIDE v2.5 23-May-2014 16:14:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main (see VARARGIN)

% Choose default command line output for Main
handles.output = hObject;

handles.manuelSegmentationHandle = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global dicomFolderPath;
dicomFolderPath = '';


emptyImage = ones(308, 384);
axes(handles.axesDICOM);
imshow(emptyImage);

% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listboxDICOMImageList.
function listboxDICOMImageList_Callback(hObject, eventdata, handles)
% hObject    handle to listboxDICOMImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxDICOMImageList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxDICOMImageList

% When user clicks list items
index_selected = get(handles.listboxDICOMImageList, 'Value');
file_list = get(handles.listboxDICOMImageList, 'String');
selectedFile = file_list(index_selected);



selectedFile = cellstr(selectedFile);
selectedFile = selectedFile{1};

if isempty(selectedFile)
    return;
end

global dicomFolderPath;

%info = dicominfo('CT-MONO2-16-ankle.dcm');


file = [dicomFolderPath '/' selectedFile];

info = dicominfo(file);

Y = dicomread(info);

axes(handles.axesDICOM);
imshow(Y, []);

[patientName, patientID, patientBirthDate, studyID, studyDate, sliceLocation, instanceNumber] = GetDICOMInfo(info);

set(handles.textPatientName, 'String', patientName);
set(handles.textPatientID, 'String', patientID);
set(handles.textPatientBirthDate, 'String', patientBirthDate);
set(handles.textStudyID, 'String', studyID);
set(handles.textStudyDate, 'String', studyDate);
set(handles.textSliceLocation, 'String', sliceLocation);
set(handles.textInstanceNumber, 'String', instanceNumber);


% --- Executes during object creation, after setting all properties.
function listboxDICOMImageList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxDICOMImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnLoadDICOMImages.
function btnLoadDICOMImages_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadDICOMImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global dicomFolderPath;
dicomFolderPath = uigetdir;

if isequal(dicomFolderPath, 0)
    return;
end

dicomFolderList = dir(dicomFolderPath);

dicomFolderList = dicomFolderList(arrayfun(@(x) ~strcmp(x.name(1),'.'), dicomFolderList)); % Mac returns .DS_Store and hidden files with .

dicomFileNameList = {dicomFolderList(~[dicomFolderList.isdir]).name}';

%dicomFileNameList = dicomFileNameList(2:end);

set(handles.listboxDICOMImageList, 'String', dicomFileNameList, 'Value', 1);


% --- Executes on button press in btnAnonymizeDICOMImages.
function btnAnonymizeDICOMImages_Callback(hObject, eventdata, handles)
% hObject    handle to btnAnonymizeDICOMImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ANONYMOUS SAVE
anonymDICOMFolderPath = uigetdir('.', 'Select Path for Anonym DICOM Images');

file_list = get(handles.listboxDICOMImageList, 'String');
fileListCount = numel(file_list);

global dicomFolderPath;

for ii = 1 : fileListCount
    inputPath = char(strcat(dicomFolderPath, '/', file_list(ii)));
    display(inputPath);
    outputPath = char(strcat(anonymDICOMFolderPath, '/', file_list(ii)));
    display(outputPath);
    AnonymizeDICOM(inputPath, outputPath);
end


% --- Executes on button press in btnConvertDICOMToJPG.
function btnConvertDICOMToJPG_Callback(hObject, eventdata, handles)
% hObject    handle to btnConvertDICOMToJPG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% DICOM 2 JPG
dicomToJPGPath = uigetdir('.', 'Select Path for DICOM to JPG Conversion');

if isequal(dicomToJPGPath, 0)
    return;
end

index_selected = get(handles.listboxDICOMImageList, 'Value');
file_list = get(handles.listboxDICOMImageList, 'String');
selectedFile = file_list(index_selected);
selectedFile = cellstr(selectedFile);
selectedFile = selectedFile{1};

global dicomFolderPath;
path = char(strcat(dicomFolderPath, '/', selectedFile));

%function DICOM2JPG(dicomFilePath, newFileName, path)
DICOM2JPG(path, selectedFile, dicomToJPGPath);

dicomInfo = dicominfo(path);

save(char(strcat(selectedFile, '.mat')),'dicomInfo');

% --- Executes on button press in btnConvertJPGToDICOM.
function btnConvertJPGToDICOM_Callback(hObject, eventdata, handles)
% hObject    handle to btnConvertJPGToDICOM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% JPG TO DICOM
% jpgToDICOMPath = uigetdir('.', 'Select JPG image to convert DICOM');
[jpgFileName, jpgPathName] = uigetfile({'*.jpg';'*.jpeg'},'Select Path for JPG to DICOM Conversion');

if isequal(jpgPathName, 0)
    return;
end

jpgFullPath = fullfile(jpgPathName, jpgFileName);

jpgImage = imread(jpgFullPath);

jpgNameWithoutExtension = strsplit(jpgFileName, '.');
jpgNameWithoutExtension = jpgNameWithoutExtension{1};

jpgDICOMInfoPath = char(strcat(jpgNameWithoutExtension, '.mat'));

display(jpgDICOMInfoPath);

%global dicomFolderPath;

if  exist(jpgDICOMInfoPath, 'file')

    jpgDICOMInfo = importdata(jpgDICOMInfoPath);
    
    fullPathNewDICOM = fullfile(jpgPathName, jpgNameWithoutExtension);
    
    dicomwrite(jpgImage, fullPathNewDICOM, jpgDICOMInfo);
    
else
    msgbox('No DICOM info found matching the JPG. Make sure JPG file name did not change.');
end





% --- Executes on button press in btnPlayDICOMImages.
function btnPlayDICOMImages_Callback(hObject, eventdata, handles)
% hObject    handle to btnPlayDICOMImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(handles.listboxDICOMImageList, 'Value');
file_list = get(handles.listboxDICOMImageList, 'String');

fileListCount = numel(file_list);

if fileListCount < 1
    return;
end

% selectedFile = file_list(index_selected);
% 
% 
% 
% selectedFile = cellstr(selectedFile);
% selectedFile = selectedFile{1};
% 
% if isempty(selectedFile)
%     return;
% end

global dicomFolderPath;

axes(handles.axesDICOM);

for ii = 1 : fileListCount
    
    selectedFile = file_list(ii);
    selectedFile = cellstr(selectedFile);
    selectedFile = selectedFile{1};
    
    filePath = [dicomFolderPath '/' selectedFile];
    
    info = dicominfo(filePath);

    Y = dicomread(info);

    imshow(Y, []);
    
    pause(0.1);
    
end


% --- Executes on button press in btnManualSegmentation.
function btnManualSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to btnManualSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

index_selected = get(handles.listboxDICOMImageList, 'Value');

file_list = get(handles.listboxDICOMImageList, 'String');

fileListCount = numel(file_list);
if fileListCount < 1
    return;
end

selectedFile = file_list(index_selected);
selectedFile = cellstr(selectedFile);
selectedFile = selectedFile{1};

if isempty(selectedFile)
    return;
end

global dicomFolderPath;

file = [dicomFolderPath '/' selectedFile];

dicomInfo = dicominfo(file);

dicomImage = dicomread(dicomInfo);

if isempty(handles.manuelSegmentationHandle)
   handles.manuelSegmentationHandle  = ManualSegmentation;
end

if ~isempty(handles.manuelSegmentationHandle)
    
    manuelSegmentationData = guidata(handles.manuelSegmentationHandle);
    manuelSegmentationData.dicomInfo = dicomInfo;
    guidata(handles.manuelSegmentationHandle, manuelSegmentationData);
    
    axes(manuelSegmentationData.axesImage);
    imshow(dicomImage, []);
    %h = imfreehand;
end



