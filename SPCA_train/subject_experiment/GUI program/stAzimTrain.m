function varargout = stAzimTrain(varargin)
% TRAIN MATLAB code for stAzimTrain.fig
%      TRAIN, by itself, creates a new TRAIN or raises the existing
%      singleton*.
%
%      H = TRAIN returns the handle to a new TRAIN or the handle to
%      the existing singleton*.
%
%      TRAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAIN.M with the given input arguments.
%
%      TRAIN('Property','Value',...) creates a new TRAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stAzimTrain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stAzimTrain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stAzimTrain

% Last Modified by GUIDE v2.5 07-May-2018 12:58:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stAzimTrain_OpeningFcn, ...
                   'gui_OutputFcn',  @stAzimTrain_OutputFcn, ...
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


% --- Executes just before stAzimTrain is made visible.
function stAzimTrain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stAzimTrain (see VARARGIN)

% Choose default command line output for stAzimTrain
handles.output = hObject;


% UIWAIT makes stAzimTrain wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% plot a circle
axes(handles.axes2)
t = 0:0.01:2*pi; x = sin(t); y = cos(t);
plot(x,y,'k','linewidth',3)
hold on;
plot(0.1*x,0.1*y,'k')
hold on;
plot(0,0.11,'k^')
hold on;
plot(-0.11,0,'ks')
hold on;
plot(0.11,0,'ks')
hold on;
plot(-1:0.01:-0.2,zeros(1,81),'k--','linewidth',2)
hold on;
plot(0.2:0.01:1,zeros(1,81),'k--','linewidth',2)
hold on;
plot(zeros(1,81),-1:0.01:-0.2,'k--','linewidth',2)
hold on;
plot(zeros(1,81),0.2:0.01:1,'k--','linewidth',2)
hold on;
plot(0.15:0.01:cos(45/180*pi),(0.15:0.01:cos(45/180*pi))*tan(45/180*pi),'k--','linewidth',2)
hold on;
plot(-0.15:-0.01:cos(135/180*pi),(-0.15:-0.01:cos(135/180*pi))*tan(135/180*pi),'k--','linewidth',2)
hold on;
plot(-0.15:-0.01:cos(225/180*pi),(-0.15:-0.01:cos(225/180*pi))*tan(225/180*pi),'k--','linewidth',2)
hold on;
plot(0.15:0.01:cos(315/180*pi),(0.15:0.01:cos(315/180*pi))*tan(315/180*pi),'k--','linewidth',2)
axis equal;
axis off;

global valueTest subjectName Name ang_train train_els;
ang_train = [0 45 90 135 180 225 270 315];
train_els = [609 809 1252 841 641 191 1251 159;...
    613 813 1254 837 637 187 1253 163;...
    617 817 1256 833 633 183 1255 167];
if valueTest == 1
    Name = 'KEMAR';
elseif valueTest == 2
    Name = subjectName;
elseif valueTest == 3
    Name = [subjectName '_pca'];
else
    error('wrong Test!')
end
handles.elevStr = {'0', '22', '45'};
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = stAzimTrain_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function playAudio(FileName)
global subjectName p;
% load(['../HpTFcomp/HpFilts/' subjectName '.mat']);
load([subjectName '.mat']);
disp(FileName);
[hrir, fs] = audioread(FileName);
% if(fs_filt~=fs)
%     HpFilt = resample(HpFilt, fs, fs_filt);
% end
% hrir(:, 1) = filter(HpFilt(:, 1), 1, hrir(:, 1));
% hrir(:, 2) = filter(HpFilt(:, 2), 1, hrir(:, 2));
if(isobject(p));delete(p);end
p = audioplayer(hrir, fs);
play(p);


% --- Executes on button press in START.
function START_Callback(hObject, eventdata, handles)
% hObject    handle to START (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Name p valueElev ang_train train_els subjectName;
handles.EXIT.Enable = 'off';
angel=[90,45,0,-45,-90,-135,180,135]/180*pi;
ang_train = [0 45 90 135 180 225 270 315];
for i=1:8
    x = [0, cos(angel(i))];
    y = [0, sin(angel(i))];
    h = plot(x,y,'k','linewidth',3);
    if(strcmp(Name, 'KEMAR'))
        FilePath = strcat('../sound source/azimuth/dir', num2str(train_els(valueElev, i)), '_',Name,'.wav');
    else
        FilePath = strcat('../sound source/azimuth/azi_', handles.elevStr{valueElev}, '_dir', num2str(ang_train(i)), '_',Name,'.wav');
    end
    if(~exist(FilePath, 'file'))
        FilePath = ['../sound source/azimuth/azi_', handles.elevStr{valueElev}, '_dir', num2str(ang_train(i)), '_',subjectName,'.wav'];
    end
    disp(FilePath);
    playAudio(FilePath);
    pause(5);
    set(h,'Visible','off');
end
handles.EXIT.Enable = 'on';


% --- Executes on button press in azimuth0.
function azimuth0_Callback(hObject, eventdata, handles)
% hObject    handle to azimuth0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Name valueElev ang_train train_els;
if(strcmp(Name, 'KEMAR'))
    FilePath = strcat('../sound source/azimuth/dir', num2str(train_els(valueElev, 1)), '_',Name,'.wav');
else
    FilePath = strcat('../sound source/azimuth/azi_', handles.elevStr{valueElev}, '_dir', num2str(ang_train(1)), '_',Name,'.wav');
end
playAudio(FilePath);

% --- Executes on button press in azimuth45.
function azimuth45_Callback(hObject, eventdata, handles)
% hObject    handle to azimuth45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Name p valueElev ang_train train_els;
if(strcmp(Name, 'KEMAR'))
    % FilePath = strcat('../sound source/azimuth/dir', num2str(train_els(valueElev, 2)), '_',Name,'.wav');
    FilePath = strcat('dir', num2str(train_els(valueElev, 2)), '_',Name,'.wav');
else
    % FilePath = strcat('../sound source/azimuth/azi_' , handles.elevStr{valueElev}, '_dir', num2str(ang_train(2)), '_',Name,'.wav');
    FilePath = strcat('azi_' , handles.elevStr{valueElev}, '_dir', num2str(ang_train(2)), '_',Name,'.wav');
end
playAudio(FilePath);


% --- Executes on button press in azimuth90.
function azimuth90_Callback(hObject, eventdata, handles)
% hObject    handle to azimuth90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Name p valueElev ang_train train_els subjectName;
if(strcmp(Name, 'KEMAR'))
    FilePath = strcat('../sound source/azimuth/dir', num2str(train_els(valueElev, 3)), '_',Name,'.wav');
else
    FilePath = strcat('../sound source/azimuth/azi_' , handles.elevStr{valueElev}, '_dir', num2str(ang_train(3)), '_',Name,'.wav');
end
if(~exist(FilePath, 'file'))
    FilePath = ['../sound source/azimuth/azi_', handles.elevStr{valueElev}, '_dir', num2str(ang_train(3)), '_',subjectName,'.wav'];
end
playAudio(FilePath);


% --- Executes on button press in azimuth135.
function azimuth135_Callback(hObject, eventdata, handles)
% hObject    handle to azimuth135 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Name p valueElev ang_train train_els;
if(strcmp(Name, 'KEMAR'))
    FilePath = strcat('../sound source/azimuth/dir', num2str(train_els(valueElev, 4)), '_',Name,'.wav');
else
    FilePath = strcat('../sound source/azimuth/azi_' , handles.elevStr{valueElev}, '_dir', num2str(ang_train(4)), '_',Name,'.wav');
end
playAudio(FilePath);


% --- Executes on button press in azimuth180.
function azimuth180_Callback(hObject, eventdata, handles)
% hObject    handle to azimuth180 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Name p valueElev ang_train train_els;
if(strcmp(Name, 'KEMAR'))
    FilePath = strcat('../sound source/azimuth/dir', num2str(train_els(valueElev, 5)), '_',Name,'.wav');
else
    FilePath = strcat('../sound source/azimuth/azi_' , handles.elevStr{valueElev}, '_dir', num2str(ang_train(5)), '_',Name,'.wav');
end
playAudio(FilePath);


% --- Executes on button press in azimuth225.
function azimuth225_Callback(hObject, eventdata, handles)
% hObject    handle to azimuth225 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Name p valueElev ang_train train_els;
if(strcmp(Name, 'KEMAR'))
    FilePath = strcat('../sound source/azimuth/dir', num2str(train_els(valueElev, 6)), '_',Name,'.wav');
else
    FilePath = strcat('../sound source/azimuth/azi_' , handles.elevStr{valueElev}, '_dir', num2str(ang_train(6)), '_',Name,'.wav');
end
playAudio(FilePath);


% --- Executes on button press in azimuth270.
function azimuth270_Callback(hObject, eventdata, handles)
% hObject    handle to azimuth270 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Name p valueElev ang_train train_els subjectName;
if(strcmp(Name, 'KEMAR'))
    FilePath = strcat('../sound source/azimuth/dir', num2str(train_els(valueElev, 7)), '_',Name,'.wav');
else
    FilePath = strcat('../sound source/azimuth/azi_' , handles.elevStr{valueElev}, '_dir', num2str(ang_train(7)), '_',Name,'.wav');
end
if(~exist(FilePath, 'file'))
    FilePath = ['../sound source/azimuth/azi_', handles.elevStr{valueElev}, '_dir', num2str(ang_train(7)), '_',subjectName,'.wav'];
end
playAudio(FilePath);


% --- Executes on button press in azimuth315.
function azimuth315_Callback(hObject, eventdata, handles)
% hObject    handle to azimuth315 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Name p valueElev ang_train train_els;
if(strcmp(Name, 'KEMAR'))
    FilePath = strcat('../sound source/azimuth/dir', num2str(train_els(valueElev, 8)), '_',Name,'.wav');
else
    FilePath = strcat('../sound source/azimuth/azi_' , handles.elevStr{valueElev}, '_dir', num2str(ang_train(8)), '_',Name,'.wav');
end
playAudio(FilePath);


% --- Executes on button press in EXIT.
function EXIT_Callback(hObject, eventdata, handles)
% hObject    handle to EXIT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p;
if(isobject(p));delete(p);end
handle_of_testGUI = guihandles(stAzimGUI);
set(handle_of_testGUI.PLAY,'Enable','on');
stAzimTrain;
close(gcf);
