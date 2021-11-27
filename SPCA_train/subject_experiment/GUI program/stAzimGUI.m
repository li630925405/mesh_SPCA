function varargout = stAzimGUI(varargin) % run
% TESTGUI MATLAB code for stAzimGUI.fig
%      TESTGUI, by itself, creates a new TESTGUI or raises the existing
%      singleton*.
%
%      H = TESTGUI returns the handle to a new TESTGUI or the handle to
%      the existing singleton*.
%
%      TESTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTGUI.M with the given input arguments.
%
%      TESTGUI('Property','userdata',...) creates a new TESTGUI or raises the
%      existing singleton*.  Starting from the left, property userdata pairs are
%      applied to the GUI before stAzimGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid userdata makes property application
%      stop.  All inputs are passed to stAzimGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stAzimGUI

% Last Modified by GUIDE v2.5 17-Jan-2019 18:29:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stAzimGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @stAzimGUI_OutputFcn, ...
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


% --- Executes just before stAzimGUI is made visible.
function stAzimGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stAzimGUI (see VARARGIN)

% Choose default command line output for stAzimGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stAzimGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axes(handles.axes)
t=0:0.01:2*pi; x=sin(t); y=cos(t);
plot(x,y,'k','linewidth',2)
hold on;
plot(zeros(1,81),-1:0.01:-0.2,'k--','linewidth',1)
hold on;
plot(zeros(1,81),0.2:0.01:1,'k--','linewidth',1)
hold on;
plot(-1:0.01:-0.2,zeros(1,81),'k--')
hold on;
plot(0.2:0.01:1,zeros(1,81),'k--')
hold on;
plot(0.2:0.01:cos(0/180*pi),(0.2:0.01:cos(0/180*pi))*tan(0/180*pi),'k--','linewidth',1)
hold on;
plot(0.15:0.01:cos(30/180*pi),(0.15:0.01:cos(30/180*pi))*tan(30/180*pi),'k--','linewidth',1)
hold on;
plot(0.1:0.01:cos(60/180*pi),(0.1:0.01:cos(60/180*pi))*tan(60/180*pi),'k--','linewidth',1)
hold on;
plot(-0.1:-0.01:cos(120/180*pi),(-0.1:-0.01:cos(120/180*pi))*tan(120/180*pi),'k--','linewidth',1)
hold on;
plot(-0.15:-0.01:cos(150/180*pi),(-0.15:-0.01:cos(150/180*pi))*tan(150/180*pi),'k--','linewidth',1)
hold on;
plot(-0.2:-0.01:cos(180/180*pi),(-0.2:-0.01:cos(180/180*pi))*tan(180/180*pi),'k--','linewidth',1)
hold on;
plot(-0.15:-0.01:cos(210/180*pi),(-0.15:-0.01:cos(210/180*pi))*tan(210/180*pi),'k--','linewidth',1)
hold on;
plot(-0.1:-0.01:cos(240/180*pi),(-0.1:-0.01:cos(240/180*pi))*tan(240/180*pi),'k--','linewidth',1)
hold on;
plot(0.1:0.01:cos(300/180*pi),(0.1:0.01:cos(300/180*pi))*tan(300/180*pi),'k--','linewidth',1)
hold on;
plot(0.15:0.01:cos(330/180*pi),(0.15:0.01:cos(330/180*pi))*tan(330/180*pi),'k--','linewidth',1)
hold on;
plot(0.1*x,0.1*y,'k')
hold on;
plot(0,0.11,'k^')
hold on;
plot(-0.11,0,'ks')
hold on;
plot(0.11,0,'ks')
axis equal;
axis off;

set(handles.NEXT,'Enable','off');
set(handles.NEXT,'userdata',0);
set(handles.PLAY,'Enable','off');
global index1; global val1; global ang whileCnt;
global dir_els;
whileCnt = 0;
dir_els = [1209 1109 909 609 309 109 9 141 341 641 941 1141;...
    1213 1113 913 613 313 113 13 137 337 637 937 1137;...
    1217 1117 917 617 317 117 17 133 333 633 933 1133];
ang = [80 55 30 0 330 305 280 235 210 180 150 125];
index1  = [randperm(12) randperm(12) randperm(12)];
val1 = zeros(36,1);
handles.elevs = [0, 22.5, 45];
handles.methods = {'_KEMAR', '', '_pca'};
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = stAzimGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Test1.
function Test1_Callback(hObject, eventdata, handles)
% hObject    handle to Test1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global index1;
global val1;
index1  = [randperm(12) randperm(12) randperm(12)];
val1 = zeros(36,1);
set(handles.NEXT,'Enable','off')
set(handles.NEXT,'userdata',0);
handles.NEXT.String = 'NEXT';
set(handles.PLAY,'Enable','off');
guidata(hObject, handles);

% --- Executes on button press in Test2.
function Test2_Callback(hObject, eventdata, handles)
% hObject    handle to Test2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global index1;
global val1;
index1  = [randperm(12) randperm(12) randperm(12)];
val1 = zeros(36,1);
set(handles.NEXT,'Enable','off')
set(handles.NEXT,'userdata',0);
handles.NEXT.String = 'NEXT';
set(handles.PLAY,'Enable','off');
guidata(hObject, handles);

% --- Executes on button press in Test2.
function Test3_Callback(hObject, eventdata, handles)
% hObject    handle to Test2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global index1;
global val1;
index1  = [randperm(12) randperm(12) randperm(12)];
val1 = zeros(36,1);
set(handles.NEXT,'Enable','off')
set(handles.NEXT,'userdata',0);
handles.NEXT.String = 'NEXT';
set(handles.PLAY,'Enable','off');
guidata(hObject, handles);

% --- Executes on button press in el0.
function el0_Callback(hObject, eventdata, handles)
% hObject    handle to el0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.NEXT,'Enable','off')
set(handles.NEXT,'userdata',0);
handles.NEXT.String = 'NEXT';
set(handles.PLAY,'Enable','off');
guidata(hObject, handles);

% --- Executes on button press in el22_5.
function el22_5_Callback(hObject, eventdata, handles)
% hObject    handle to el22_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.NEXT,'Enable','off')
set(handles.NEXT,'userdata',0);
handles.NEXT.String = 'NEXT';
set(handles.PLAY,'Enable','off');
guidata(hObject, handles);

% --- Executes on button press in azimuth0.
function azimuth_record(hObject, handles)
% hObject    handle to azimuth0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i val1 whileCnt state;

while(i <= 36)
    if(i<1);i=1;end
    [xx, yy, key] = ginputt(1, @() angleUIUpdate());
    if(key==8||key==127||key==3)
%         print('../latex/interface_azim', '-dpdf');
        continue;
    elseif(key~=1)
        continue;
    end
    if(~state);continue;end
    [curAngle, l_x, l_y] = calcAzim(xx, yy);
    draw = plot(l_x,l_y,'k','linewidth',3);
    pause(0.1);
    delete(draw)

    handles.azi.String = num2str(curAngle);
    if(i<=36)
        set(handles.NEXT,'Enable','on');
    end
    guidata(hObject, handles);
    try
        val1(i,1)=curAngle;
    catch
        error('azimuth error')
    end
%     if i > 36
%         error('i > 36')
%     end
end
whileCnt = whileCnt - 1;


% --- Executes on button press in NEXT.
function NEXT_Callback(hObject, eventdata, handles)
% hObject    handle to NEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hrir; global fs;
global i p;
i=get(handles.NEXT,'userdata')+1;
set(handles.NEXT,'userdata',i);
handles.azi.String = '';
% handles.azi.String = num2str(i);
if i <= 1
    error('ERROR!')
elseif i < 36
    set(handles.NEXT,'Enable','off')
elseif i == 36
    handles.NEXT.String = 'Done';
    set(handles.NEXT,'Enable','off')
elseif i == 37
    Done(handles)
    handles.NEXT.String = 'OK';
    set(handles.NEXT,'Enable','off')
    set(handles.PLAY,'Enable','off')
else
    error('wrong i')
end
guidata(hObject, handles);
if i > 1 && i <= 36
    FilePath = getFile(handles);
    playAudio(FilePath);
end

% --- Executes on button press in PLAY.
function PLAY_Callback(hObject, eventdata, handles)
% hObject    handle to PLAY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hrir fs whileCnt;
global i p;
if get(handles.NEXT,'userdata')==0
    i=get(handles.NEXT,'userdata')+1;
    set(handles.NEXT,'userdata',i);
end
guidata(hObject, handles);
FilePath = getFile(handles);
playAudio(FilePath);
if(whileCnt==0)
    whileCnt = 1;
    azimuth_record(hObject, handles);
end
% if i > 36
%     error('i > 36')
% end


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


function FilePath = getFile(handles)
global subjectName ang dir_els;
global index1 index2 i;
subjectName = get(handles.edit1,'String');

eleValue = get(handles.el0, 'value') + get(handles.el22_5, 'value')*2 + get(handles.el45, 'value')*3;
testValue = get(handles.Test1, 'value') + get(handles.Test2, 'value')*2 + get(handles.Test3, 'value')*3;
switch eleValue
    case {1, 2, 3}
    otherwise
        error('wrong elevation');
end
switch testValue
    case 1
        tail = ['dir' num2str(dir_els(eleValue, index1(i))) '_KEMAR.wav'];
    case {2, 3}
        tail = ['azi_', num2str(floor(handles.elevs(eleValue))), '_dir', ...
    num2str(ang(index1(i))), '_' subjectName handles.methods{testValue} '.wav'];
    otherwise
        error('test error');
end
FilePath = strcat('../sound source/azimuth/', tail);


function Done(handles)
global i val1;
global index1;
global subjectName;
subjectName = get(handles.edit1,'String');
% if i ~=37 %gzs
%     error('ERROR')
% end
val=val1;
index=index1;

eleValue = get(handles.el0, 'value') + get(handles.el22_5, 'value')*2 + get(handles.el45, 'value')*3;
testValue = get(handles.Test1, 'value') + get(handles.Test2, 'value')*2 + get(handles.Test3, 'value')*3;
try
    save(strcat('../GUI data/',subjectName,'_elev',num2str(floor(handles.elevs(eleValue))),...
        '_test',num2str(testValue),'.mat'),'val')
    save(strcat('../GUI data/',subjectName,'_elev',num2str(floor(handles.elevs(eleValue))),...
        '_test',num2str(testValue),'_index.mat'),'index')
catch
    error('wrong elevation/test');
end


% --- Executes on button press in train.
function train_Callback(hObject, eventdata, handles)
% hObject    handle to train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get the value of elevation and kind of test
global subjectName;
subjectName = get(handles.edit1,'String');
if(isempty(subjectName) || strcmp(subjectName, ''))
    warndlg('被试姓名为空', '警告', 'modal');
    return;
end

eleValue = get(handles.el0, 'value') + get(handles.el22_5, 'value')*2 + get(handles.el45, 'value')*3;
testValue = get(handles.Test1, 'value') + get(handles.Test2, 'value')*2 + get(handles.Test3, 'value')*3;
global valueElev; global valueTest;
valueElev = eleValue;
valueTest = testValue;
% run('stAzimTrain');
stAzimTrain;


% --- Executes on button press in el45.
function el45_Callback(hObject, eventdata, handles)
% hObject    handle to el45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of el45
set(handles.NEXT,'Enable','off')
set(handles.NEXT,'userdata',0);
handles.NEXT.String = 'NEXT';
set(handles.PLAY,'Enable','off');
guidata(hObject, handles);

function [agl, l_x, l_y] = calcAzim(xx, yy)
angl = atan2(yy, xx);
r = linspace(0, 1, 10);
l_x = r*cos(angl);
l_y = r*sin(angl);
agl = pi/2 - angl;
if(agl<0)
    agl = agl + pi*2;
end
agl = round(agl*180/pi*10)/10;
if(agl==360);agl=0;end
    
    
function angleUIUpdate()
global hT draw state;
state = 1;
pt = get(gca, 'CurrentPoint');
xx = pt(1,1);
yy = pt(1,2);
if(exist('hT', 'var'))
    delete(hT);
end
if(exist('draw', 'var'))
    delete(draw);
end
if(xx^2+yy^2>1)
    state = 0;
    return;
end
[curAngle, l_x, l_y] = calcAzim(xx, yy);
draw = plot(l_x,l_y,'b--','linewidth',0.5);
hT = text(xx+0.05, yy+0.03, [num2str(curAngle) '°']);
pause(0.01);
