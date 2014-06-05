function varargout = ManualSegmentation(varargin)
% MANUALSEGMENTATION MATLAB code for ManualSegmentation.fig
%      MANUALSEGMENTATION, by itself, creates a new MANUALSEGMENTATION or raises the existing
%      singleton*.
%
%      H = MANUALSEGMENTATION returns the handle to a new MANUALSEGMENTATION or the handle to
%      the existing singleton*.
%
%      MANUALSEGMENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALSEGMENTATION.M with the given input arguments.
%
%      MANUALSEGMENTATION('Property','Value',...) creates a new MANUALSEGMENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ManualSegmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ManualSegmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ManualSegmentation

% Last Modified by GUIDE v2.5 27-May-2014 16:40:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ManualSegmentation_OpeningFcn, ...
                   'gui_OutputFcn',  @ManualSegmentation_OutputFcn, ...
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


% --- Executes just before ManualSegmentation is made visible.
function ManualSegmentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ManualSegmentation (see VARARGIN)

% Choose default command line output for ManualSegmentation
handles.output = hObject;

handles.dicomInfo = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ManualSegmentation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%h = imfreehand;


% --- Outputs from this function are returned to the command line.
function varargout = ManualSegmentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when selected object is changed in panelSegmentationRegion.
function panelSegmentationRegion_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panelSegmentationRegion 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axesImage);

h = imfreehand(gca);

maskImg = h.createMask;

alphaImg(:,:,1) = zeros(size(maskImg));
alphaImg(:,:,2) = zeros(size(maskImg));
alphaImg(:,:,3) = zeros(size(maskImg));

amountIncrease = 255/2;

color = 'blue';
plotText = '';

AreaofRegion_noofpixels = regionprops(maskImg, 'area');

spatialresultion = 0.7891; % same for all images

Areaofregion  = (AreaofRegion_noofpixels.Area) .* spatialresultion;

slicethickness = handles.dicomInfo.SliceThickness;

volumeofregion = Areaofregion * slicethickness;

% display('Surface:');
% display(Areaofregion);
% 
% display('Volume:');
% display(volumeofregion);

dicomImage = dicomread(handles.dicomInfo);

ii = uint8(dicomImage); % HERE IS THE ISSUE

ii2(:,:,1) = ii;
ii2(:,:,2) = ii;
ii2(:,:,3) = ii;

%figure, imshow(ii, []);

% figure, imshow(getimage(gca));
% axes(handles.axesImage);

% if size(ii, 3) == 1
%      ii(:, :, 2) = ii(:, :, 1);
%      ii(:, :, 3) = ii(:, :, 1);
% end

%ii = ii(x,y);
position = wait(h);

if get(handles.tbZP, 'Value') == 1
    % ZP
    setColor(h, 'blue');
    alphaImg(:,:,3) = round(maskImg*(amountIncrease));
    color = 'blue';
    plotText = 'ZP';
    
    set(handles.textZPSurface, 'String', ['Surface(mm2):' num2str(Areaofregion)]);
    set(handles.textZPVolume, 'String', ['Volume(mm3):' num2str(volumeofregion)]);
    
elseif get(handles.tbZT, 'Value') == 1
    % ZT
    setColor(h, 'green');
    alphaImg(:,:,2) = round(maskImg*(amountIncrease));
    color = 'green';
    plotText = 'ZT';
    set(handles.textZTSurface, 'String', ['Surface(mm2):' num2str(Areaofregion)]);
    set(handles.textZTVolume, 'String', ['Volume(mm3):' num2str(volumeofregion)]);
        
elseif get(handles.tbZC, 'Value') == 1
    % ZC
    setColor(h, 'yellow');
    alphaImg(:,:,1) = round(maskImg*(amountIncrease));
    alphaImg(:,:,2) = round(maskImg*(amountIncrease));
    color = 'yellow';
    plotText = 'ZC';
    set(handles.textZCSurface, 'String', ['Surface(mm2):' num2str(Areaofregion)]);
    set(handles.textZCVolume, 'String', ['Volume(mm3):' num2str(volumeofregion)]);
        
elseif get(handles.tbTumorRegion, 'Value') == 1
    % Tumor Region
    setColor(h, 'red');
    alphaImg(:,:,1) = round(maskImg*(amountIncrease));
    color = 'red';
    plotText = 'Tumor Region';
    set(handles.textTumorRegionSurface, 'String', ['Surface(mm2):' num2str(Areaofregion)]);
    set(handles.textTumorRegionVolume, 'String', ['Volume(mm3):' num2str(volumeofregion)]);
    
else
    % No button selected
        
end






 
% alphaImg(:,:,1) = zeros(size(maskImg)); % All zeros.
% alphaImg(:,:,2) = round(maskImg*(amountIncrease)); % Round since we're dealing with integers.
% alphaImg(:,:,3) = zeros(size(maskImg)); % All zeros. 
% Convert alphaImg to have the same range of values (0-255) as the origImg.
alphaImg = uint8(alphaImg);
%alphaImg = double(alphaImg);
%figure, imshow(alphaImg, []);
% alphaImg = rgb2gray(alphaImg);
% 
 blendImg = ii2 + alphaImg;
 %blendImg = imadd(ii, alphaImg);
% hold on
axes(handles.axesImage);
%imshow(blendImg);

axes(handles.axes3DRepresentation);

rotate3d(gca);

hold on;

axis ij;

for k = 1:0.1:64
   plot3(position(:, 1), position(:, 2), ones(size(position, 1), 1) + k, 'Color', color);
end

text(position(1, 1), position(1, 2), [plotText '\downarrow'], 'VerticalAlignment', 'top', 'FontSize', 18);

% 
% text(position(1, 1), position(1, 2), [plotText '\downarrow'], ...
%     'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 16);

hold off;

axis([1, 384, 1, 308]);
