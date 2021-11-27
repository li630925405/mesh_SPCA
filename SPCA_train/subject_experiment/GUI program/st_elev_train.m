function varargout = st_elev_train(varargin)
% ELEV_TRAIN MATLAB code for st_elev_train.fig
%      ELEV_TRAIN, by itself, creates a new ELEV_TRAIN or raises the existing
%      singleton*.
%
%      H = ELEV_TRAIN returns the handle to a new ELEV_TRAIN or the handle to
%      the existing singleton*.
%
%      ELEV_TRAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ELEV_TRAIN.M with the given input arguments.
%
%      ELEV_TRAIN('Property','Value',...) creates a new ELEV_TRAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before st_elev_train_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to st_elev_train_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help st_elev_train

% Last Modified by GUIDE v2.5 19-Jul-2018 17:03:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @st_elev_train_OpeningFcn, ...
                   'gui_OutputFcn',  @st_elev_train_OutputFcn, ...
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


% --- Executes just before st_elev_train is made visible.
function st_elev_train_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to st_elev_train (see VARARGIN)

% Choose default command line output for st_elev_train
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes st_elev_train wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axes(handles.axes1)
t=0:0.01:2*pi; x=sin(t); y=cos(t);
xx=sin(t); yy=0.37*cos(t); i1=find(yy<=0);
plot(x,y,'k','linewidth',3); hold on;
plot(xx(i1),yy(i1),'k'); hold on; plot(xx(i1),abs(yy(i1)),'k--'); hold on;
plot(0.18*x,0.18*y,'k'); hold on;
plot(zeros(1,74),0.27:0.01:1,'k--','linewidth',2); hold on;
x1=0.885*sin(t); y1=cos(t); ff1=find(x1>0);
x2=0.88*sin(t); y2=cos(t); ff2=find(x2>0);
global front_back; global ang_train;
if front_back
    plot(0:0.01:1,zeros(1,101),'k--'); hold on;
    plot(0.145,0.05,'ko'); hold on;
    plot(0.13:0.01:0.15,[-0.09 -0.1 -0.11],'k'); hold on;
    plot(0:0.01:sin(60/180*pi),(0:0.01:sin(60/180*pi))/tan(60/180*pi)*0.37,'k--'); hold on;    
    plot(0.27:0.01:1,zeros(1,74),'k--','linewidth',2);
    plot(0.23:0.01:cos(30.23/180*pi),(0.23:0.01:cos(30.23/180*pi))*tan(30.23/180*pi),'k--','linewidth',2);
    plot(0.14:0.01:cos(58.42/180*pi),(0.14:0.01:cos(58.42/180*pi))*tan(58.42/180*pi),'k--','linewidth',2);
    plot(0.23:0.01:cos(329.77/180*pi),(0.23:0.01:cos(329.77/180*pi))*tan(329.77/180*pi),'k--','linewidth',2);
    plot(x2(ff2),y2(ff2),'k--'); plot(-x2(ff2),y2(ff2),'k');
    set(handles.fb90,'visible','on');
    set(handles.front58,'visible','on');
    set(handles.front30,'visible','on');
    set(handles.front0,'visible','on');
    set(handles.front_30,'visible','on');
    set(handles.back58,'visible','off');
    set(handles.back30,'visible','off');
    set(handles.back_30,'visible','off');
    set(handles.back0,'visible','off');
else
    plot(0.04,0.05,'ko'); hold on;
    plot(0.14,0.05,'ko'); hold on;
    plot(0.13,-0.02,'k>'); hold on;
    plot(0.13:-0.01:0.06,[-0.09 -0.1 -0.11 -0.12 -0.11 -0.11 -0.1 -0.09],'k'); hold on;
    plot(0:0.01:sin(120/180*pi),(0:0.01:sin(120/180*pi))/tan(120/180*pi)*0.37,'k--'); hold on;
    plot(0:0.01:1,zeros(1,101),'k--'); hold on;    
    plot(-1:0.01:-0.27,zeros(1,74),'k--','linewidth',2);
    plot(-0.14:-0.01:cos(121.58/180*pi),(-0.14:-0.01:cos(121.58/180*pi))*tan(121.58/180*pi),'k--','linewidth',2);
    plot(-0.23:-0.01:cos(149.77/180*pi),(-0.23:-0.01:cos(149.77/180*pi))*tan(149.77/180*pi),'k--','linewidth',2);
    plot(-0.23:-0.01:cos(210.23/180*pi),(-0.23:-0.01:cos(210.23/180*pi))*tan(210.23/180*pi),'k--','linewidth',2);   
    plot(x1(ff1),y1(ff1),'k'); plot(-x1(ff1),y1(ff1),'k--');
    set(handles.fb90,'visible','on');
    set(handles.front58,'visible','off');
    set(handles.front30,'visible','off');
    set(handles.front0,'visible','off');
    set(handles.front_30,'visible','off');
    set(handles.back58,'visible','on');
    set(handles.back30,'visible','on');
    set(handles.back_30,'visible','on');
    set(handles.back0,'visible','on');
end
axis equal;
axis off;
ang_train = [90 61.875 33.75 0 -33.75 118.125 146.25 180 213.75];


% --- Outputs from this function are returned to the command line.
function varargout = st_elev_train_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in EXIT.
function EXIT_Callback(hObject, eventdata, handles)
% hObject    handle to EXIT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p;
if(isobject(p));delete(p);end
close(st_elev_train)
% handle_of_test = guihandles(elev_test);
% set(handle_of_test.PLAY,'Enable','on');


function playAudio(FileName)
global subjectName p;
load(['../HpTFcomp/HpFilts/' subjectName '.mat']);
[hrir, fs] = audioread(FileName);
if(fs_filt~=fs)
    HpFilt = resample(HpFilt, fs, fs_filt);
end
hrir(:, 1) = filter(HpFilt(:, 1), 1, hrir(:, 1));
hrir(:, 2) = filter(HpFilt(:, 2), 1, hrir(:, 2));
if(isobject(p));delete(p);end
p = audioplayer(hrir, fs);
play(p);


% --- Executes on button press in back_30.
function back_30_Callback(hObject, eventdata, handles)
% hObject    handle to back_30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ang_train; global valueTest; global subjectName; global p;
if valueTest == 1
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(9)), '_KEMAR.wav');
elseif valueTest == 2
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(9)), '_',subjectName,'.wav');
elseif valueTest ==3
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(9)), '_',subjectName,'_pca.wav');
else
    error('wrong Test!')
end
playAudio(FilePath);

% --- Executes on button press in back0.
function back0_Callback(hObject, eventdata, handles)
% hObject    handle to back0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ang_train; global valueTest; global subjectName; global p;
if valueTest == 1
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(8)), '_KEMAR.wav');
elseif valueTest == 2
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(8)), '_',subjectName,'.wav');
elseif valueTest ==3
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(8)), '_',subjectName,'_pca.wav');
else
    error('wrong Test!')
end
playAudio(FilePath);

% --- Executes on button press in back30.
function back30_Callback(hObject, eventdata, handles)
% hObject    handle to back30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ang_train; global valueTest; global subjectName; global p;
if valueTest == 1
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(7)), '_KEMAR.wav');
elseif valueTest == 2
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(7)), '_',subjectName,'.wav');
elseif valueTest ==3
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(7)), '_',subjectName,'_pca.wav');
else
    error('wrong Test!')
end
playAudio(FilePath);

% --- Executes on button press in back58.
function back58_Callback(hObject, eventdata, handles)
% hObject    handle to back58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ang_train; global valueTest; global subjectName; global p;
if valueTest == 1
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(6)), '_KEMAR.wav');
elseif valueTest == 2
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(6)), '_',subjectName,'.wav');
elseif valueTest ==3
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(6)), '_',subjectName,'_pca.wav');
else
    error('wrong Test!')
end
playAudio(FilePath);

% --- Executes on button press in fb90.
function fb90_Callback(hObject, eventdata, handles)
% hObject    handle to fb90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ang_train; global valueTest; global subjectName; global p;
if valueTest == 1
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(1)), '_KEMAR.wav');
elseif valueTest == 2
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(1)), '_',subjectName,'.wav');
elseif valueTest ==3
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(1)), '_',subjectName,'_pca.wav');
else
    error('wrong Test!')
end
playAudio(FilePath);

% --- Executes on button press in front58.
function front58_Callback(hObject, eventdata, handles)
% hObject    handle to front58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ang_train; global valueTest; global subjectName; global p;
if valueTest == 1
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(2)), '_KEMAR.wav');
elseif valueTest == 2
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(2)), '_',subjectName,'.wav');
elseif valueTest ==3
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(2)), '_',subjectName,'_pca.wav');
else
    error('wrong Test!')
end
playAudio(FilePath);

% --- Executes on button press in front30.
function front30_Callback(hObject, eventdata, handles)
% hObject    handle to front30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ang_train; global valueTest; global subjectName; global p;
if valueTest == 1
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(3)), '_KEMAR.wav');
elseif valueTest == 2
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(3)), '_',subjectName,'.wav');
elseif valueTest ==3
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(3)), '_',subjectName,'_pca.wav');
else
    error('wrong Test!')
end
playAudio(FilePath);

% --- Executes on button press in front0.
function front0_Callback(hObject, eventdata, handles)
% hObject    handle to front0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ang_train; global valueTest; global subjectName; global p;
if valueTest == 1
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(4)), '_KEMAR.wav');
elseif valueTest == 2
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(4)), '_',subjectName,'.wav');
elseif valueTest ==3
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(4)), '_',subjectName,'_pca.wav');
else
    error('wrong Test!')
end
playAudio(FilePath);

% --- Executes on button press in front_30.
function front_30_Callback(hObject, eventdata, handles)
% hObject    handle to front_30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ang_train; global valueTest; global subjectName; global p;
if valueTest == 1
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(5)), '_KEMAR.wav');
elseif valueTest == 2
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(5)), '_',subjectName,'.wav');
elseif valueTest ==3
    FilePath = strcat('../sound source/elevation/dir', num2str(ang_train(5)), '_',subjectName,'_pca.wav');
else
    error('wrong Test!')
end
playAudio(FilePath);
