function varargout = st_elev_test(varargin)
% ELEV_TEST MATLAB code for st_elev_test.fig
%      ELEV_TEST, by itself, creates a new ELEV_TEST or raises the existing
%      singleton*.
%
%      H = ELEV_TEST returns the handle to a new ELEV_TEST or the handle to
%      the existing singleton*.
%   
%      ELEV_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ELEV_TEST.M with the given input arguments.
%
%      ELEV_TEST('Property','Value',...) creates a new ELEV_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before st_elev_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to st_elev_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help st_elev_test

% Last Modified by GUIDE v2.5 19-Jul-2018 14:47:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @st_elev_test_OpeningFcn, ...
                   'gui_OutputFcn',  @st_elev_test_OutputFcn, ...
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


% --- Executes just before st_elev_test is made visible.
function st_elev_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to st_elev_test (see VARARGIN)

% Choose default command line output for st_elev_test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes st_elev_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axes(handles.axes1)
t=0:0.01:2*pi; x=sin(t); y=cos(t);
xx=sin(t); yy=0.37*cos(t); i1=find(yy<=0);
global p1 p2 p3;
global l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12;
plot(x,y,'k','linewidth',2)
hold on;
plot(xx(i1),yy(i1),'k')
hold on;
plot(xx(i1),abs(yy(i1)),'k--')
hold on;
plot(0.18*x,0.18*y,'k')
axis equal;
axis off;

p1=plot(0.08,0.055,'ko');
p2=plot(0.17,0,'k>');
p3=plot(0.12:-0.01:0.07,[-0.12*ones(1,4) -0.11 -0.1],'k');
for il = 1:12
    eval(sprintf('l%d = drawLine(%f);', il, (il-4)*pi/6));
    eval(sprintf('set(l%d,''visible'',''off'');', il));
end

global b1 b2 b3 b4 b5 b6 b7 fb f1 f2 f3 f4 f5;
b1=plot(0.04,0.05,'ko');
b2=plot(0.14,0.05,'ko');
b3=plot(0.13,-0.02,'k>');
b4=plot(0.13:-0.01:0.06,[-0.09 -0.1 -0.11 -0.12 -0.11 -0.11 -0.1 -0.09],'k');
b5=plot(0:0.01:sin(120/180*pi),(0:0.01:sin(120/180*pi))/tan(120/180*pi)*0.37,'k--');
fb=plot(0:0.01:1,zeros(1,101),'k--');
f1=plot(0.145,0.05,'ko');
f2=plot(0.13:0.01:0.15,[-0.09 -0.1 -0.11],'k');
f3=plot(0:0.01:sin(60/180*pi),(0:0.01:sin(60/180*pi))/tan(60/180*pi)*0.37,'k--');
x1=0.885*sin(t); y1=cos(t); ff1=find(x1>0);
b6=plot(x1(ff1),y1(ff1),'k');
b7=plot(-x1(ff1),y1(ff1),'k--');
x2=0.88*sin(t); y2=cos(t); ff2=find(x2>0);
f4=plot(x2(ff2),y2(ff2),'k--');
f5=plot(-x2(ff2),y2(ff2),'k');
set(b1,'visible','off');
set(b2,'visible','off');
set(b3,'visible','off');
set(b4,'visible','off');
set(b5,'visible','off');
set(b6,'visible','off');
set(b7,'visible','off');
set(fb,'visible','off');
set(f1,'visible','off');
set(f2,'visible','off');
set(f3,'visible','off');
set(f4,'visible','off');
set(f5,'visible','off');

set(handles.NEXT,'Enable','off');
set(handles.NEXT,'userdata',0);
set(handles.PLAY,'Enable','off');
set(handles.Train,'Enable','off');
global ang1; global ang2 whileCnt;
ang1 = [90 73.125 50.625 22.5 0 -22.5 -45];
ang2 = [90 106.875 129.375 157.5 180 202.5 225];
whileCnt = 0;


function h = drawLine( theta )
r = linspace(0.2, 1, 5);
h = plot(r*cos(theta), r*sin(theta), 'k--', 'linewidth', 1);


% --- Outputs from this function are returned to the command line.
function varargout = st_elev_test_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in PLAY.
function PLAY_Callback(hObject, eventdata, handles)
% hObject    handle to PLAY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global whileCnt;
global i p;
if get(handles.NEXT,'userdata')==0
    i=get(handles.NEXT,'userdata')+1;
    set(handles.NEXT,'userdata',i);
end
guidata(hObject, handles);
FilePath = getFile(handles);
% playAudio(FilePath);
if(whileCnt==0)
    whileCnt = 1;
    elevation_record(hObject, handles);
end


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
global subjectName;  global front_back;
global ang1; global ang2;
global index1 i;
subjectName = get(handles.edit1,'String');
if front_back
    ang = ang1;
else
    ang = ang2;
end
testValue = get(handles.Test1, 'value') + get(handles.Test2, 'value')*2 + get(handles.Test3, 'value')*3;
m = testValue;
if m == 1
    FilePath = strcat('../sound source/elevation/dir', num2str(ang(index1(i))), '_KEMAR.wav');
elseif m==2
    FilePath = strcat('../sound source/elevation/dir', num2str(ang(index1(i))), '_',subjectName,'.wav');
elseif m ==3
    FilePath = strcat('../sound source/elevation/dir', num2str(ang(index1(i))), '_',subjectName,'_pca.wav');
else
    error('wrong test');
end


% --- Executes on button press in NEXT.
function NEXT_Callback(hObject, eventdata, handles)
% hObject    handle to NEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hrir; global fs;
global i p;
i=get(handles.NEXT,'userdata')+1;
set(handles.NEXT,'userdata',i);
handles.elev.String = '';
if i <= 1
    error('ERROR!')
elseif i < 21
    set(handles.NEXT,'Enable','off')
elseif i == 21
    handles.NEXT.String = 'Done';
    set(handles.NEXT,'Enable','off')
elseif i == 22
    Done(handles)
    handles.NEXT.String = 'OK';
    set(handles.NEXT,'Enable','off')
%     set(handles.PLAY,'Enable','off')
else
    error('wrong i')
end
guidata(hObject, handles);
if i > 1 && i <= 21
    FilePath = getFile(handles);
    playAudio(FilePath);
end


function Done(handles)
global val1;
global index1;
global subjectName; global front_back;
subjectName = get(handles.edit1,'String');

testValue = get(handles.Test1, 'value') + get(handles.Test2, 'value')*2 + get(handles.Test3, 'value')*3;
val=val1;
index=index1;
test=testValue;
try
    save(strcat('../GUI data/elevation data/',subjectName,'_fb',num2str(front_back),'_test',num2str(test),'.mat'),'val')
    save(strcat('../GUI data/elevation data/',subjectName,'_fb',num2str(front_back),'_test',num2str(test),'_index.mat'),'index')
catch
    error('wrong test');
end

% --- Executes on button press in Train.
function Train_Callback(hObject, eventdata, handles)
% hObject    handle to Train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global subjectName valueTest;
subjectName = get(handles.edit1,'String');

testValue = get(handles.Test1, 'value') + get(handles.Test2, 'value')*2 + get(handles.Test3, 'value')*3;
valueTest = testValue;
run('st_elev_train');

% --- Executes on button press in back_42.
function elevation_record(hObject, handles)
% hObject    handle to back_42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i val1 whileCnt state;

while(i <= 21)
    if(i<1);i=1;end
    [xx, yy, key] = ginputt(1, @() angleUIUpdate());
    if(key==8||key==127||key==3)
        i = i-1;
        continue;
    elseif(key~=1)
        continue;
    end
    if(~state);continue;end
    [curAngle, l_x, l_y] = calcElev(xx, yy);
    draw = plot(l_x,l_y,'k','linewidth',3);
    pause(0.1);
    delete(draw)

    handles.elev.String = num2str(curAngle);
    if(i<=21)
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



% --- Executes on button press in Test1.
function Test1_Callback(hObject, eventdata, handles)
% hObject    handle to Test1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Test1
global index1;
global val1;
index1  = [randperm(7) randperm(7) randperm(7)];
val1 = zeros(21,1);
set(handles.NEXT,'Enable','off')
set(handles.NEXT,'userdata',0);
handles.NEXT.String = 'NEXT';
guidata(hObject, handles);


% --- Executes on button press in Test2.
function Test2_Callback(hObject, eventdata, handles)
% hObject    handle to Test2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Test2
global index1;
global val1;
index1  = [randperm(7) randperm(7) randperm(7)];
val1 = zeros(21,1);
set(handles.NEXT,'Enable','off')
set(handles.NEXT,'userdata',0);
handles.NEXT.String = 'NEXT';
guidata(hObject, handles);


% --- Executes on button press in Test3.
function Test3_Callback(hObject, eventdata, handles)
% hObject    handle to Test3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Test3
global index1;
global val1;
index1  = [randperm(7) randperm(7) randperm(7)];
val1 = zeros(21,1);
set(handles.NEXT,'Enable','off')
set(handles.NEXT,'userdata',0);
handles.NEXT.String = 'NEXT';
guidata(hObject, handles);


function elev_Callback(hObject, eventdata, handles)
% hObject    handle to elev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elev as text
%        str2double(get(hObject,'String')) returns contents of elev as a double


% --- Executes during object creation, after setting all properties.
function elev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Front.
function Front_Callback(hObject, eventdata, handles)
% hObject    handle to Front (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p1 p2 p3 b1 b2 b3 b4 b5 b6 b7 fb f1 f2 f3 f4 f5;
global l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12;
global front_back;
front_back = 1;
axes(handles.axes1)
% plot(zeros(1,74),0.27:0.01:1,'k--','linewidth',1)
set(p1,'visible','off');
set(p2,'visible','off');
set(p3,'visible','off');
set(b1,'visible','off');
set(b2,'visible','off');
set(b3,'visible','off');
set(b4,'visible','off');
set(b5,'visible','off');
set(b6,'visible','off');
set(b7,'visible','off');
for il = 1:12
    if(il<8)
        eval(sprintf('set(l%d, ''visible'', ''on'');', il));
    else
        eval(sprintf('set(l%d, ''visible'', ''off'');', il));
    end
end
set(fb,'visible','on');
set(f1,'visible','on');
set(f2,'visible','on');
set(f3,'visible','on');
set(f4,'visible','on');
set(f5,'visible','on');
set(handles.Front,'Enable','off');
set(handles.Front, 'visible', 'off');
global index1 val1;
index1  = [randperm(7) randperm(7) randperm(7)];
val1 = zeros(21,1);
set(handles.NEXT,'Enable','off')
set(handles.NEXT,'userdata',0);
handles.NEXT.String = 'NEXT';
set(handles.Train,'Enable','on');
set(handles.PLAY,'Enable','on');
guidata(hObject, handles);

% --- Executes on button press in Back.
function Back_Callback(hObject, eventdata, handles)
% hObject    handle to Back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p1 p2 p3 b1 b2 b3 b4 b5 b6 b7 fb f1 f2 f3 f4 f5;
global l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12;
global front_back;
front_back = 0;
axes(handles.axes1)
% plot(zeros(1,74),0.27:0.01:1,'k--','linewidth',1)
set(p1,'visible','off');
set(p2,'visible','off');
set(p3,'visible','off');
set(f1,'visible','off');
set(f2,'visible','off');
set(f3,'visible','off');
set(f4,'visible','off');
set(f5,'visible','off');
set(b1,'visible','on');
set(b2,'visible','on');
set(b3,'visible','on');
set(b4,'visible','on');
set(b5,'visible','on');
set(b6,'visible','on');
set(b7,'visible','on');
set(fb,'visible','on');
for il = 1:12
    if(il<7 && il>1)
        eval(sprintf('set(l%d, ''visible'', ''off'');', il));
    else
        eval(sprintf('set(l%d, ''visible'', ''on'');', il));
    end
end
set(handles.Back,'Enable','off');
global index1 val1;
index1  = [randperm(7) randperm(7) randperm(7)];
val1 = zeros(21,1);
set(handles.NEXT,'Enable','off')
set(handles.NEXT,'userdata',0);
handles.NEXT.String = 'NEXT';
set(handles.Train,'Enable','on');
set(handles.PLAY,'Enable','on');
guidata(hObject, handles);


function [agl, l_x, l_y] = calcElev(xx, yy)
angl = atan2(yy, xx);
r = linspace(0, 1, 10);
l_x = r*cos(angl);
l_y = r*sin(angl);
agl = angl;
if(agl<-pi/2)
    agl = agl + pi*2;
end
if(agl>3*pi/2)
    agl = agl - pi*2;
end
agl = round(agl*180/pi*10)/10;
if(agl==360);agl=0;end
    
    
function angleUIUpdate()
global hT draw state front_back;
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
if(xx^2+yy^2>1 || xx*(2*front_back-1)<-0.005)
%     xx*(2*front_back-1)
    state = 0;
    return;
end
[curAngle, l_x, l_y] = calcElev(xx, yy);
draw = plot(l_x,l_y,'b--','linewidth',0.5);
if(curAngle>90)
    curAngle = 180 - curAngle;
end
hT = text(xx+0.05, yy+0.03, [num2str(curAngle) 'бу']);
pause(0.01);
