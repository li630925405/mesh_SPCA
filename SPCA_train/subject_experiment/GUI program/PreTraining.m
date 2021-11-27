function varargout = PreTraining(varargin)
% PRETRAINING MATLAB code for PreTraining.fig
%      PRETRAINING, by itself, creates a new PRETRAINING or raises the existing
%      singleton*.
%
%      H = PRETRAINING returns the handle to a new PRETRAINING or the handle to
%      the existing singleton*.
%
%      PRETRAINING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRETRAINING.M with the given input arguments.
%
%      PRETRAINING('Property','Value',...) creates a new PRETRAINING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PreTraining_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PreTraining_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PreTraining

% Last Modified by GUIDE v2.5 10-May-2019 22:50:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PreTraining_OpeningFcn, ...
                   'gui_OutputFcn',  @PreTraining_OutputFcn, ...
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



% --- Executes just before PreTraining is made visible.
function PreTraining_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PreTraining (see VARARGIN)

% Choose default command line output for PreTraining
handles.output = hObject;

% Update handles structure
global test_flag whileCnt flag horizAngle elevAngle
flag = 0;
whileCnt = 0;
test_flag = 0;
axis off;
handles.elList = [0, 20, 45];%, -15, -30, -45];
handles.azList = [30, 150];%, 45, 135, 15, 165];
horizAngle = handles.azList(1);
elevAngle = handles.elList(1);
% handles.HRIR = load('HRIR_FABIAN');
% handles.indListEachElev = zeros(72, length(handles.elList));
% handles.indListEachAzim = zeros(37, length(handles.azList));
handles.elevList.String = [];
handles.horizList.String = [];
for i = 1:length(handles.elList)
    handles.elevList.String{i} = num2str(handles.elList(i));
%     handles.indListEachElev(:, i) = find(handles.HRIR.elev == handles.elList(i));
end
for i = 1:length(handles.azList)
    handles.horizList.String{i} = num2str(handles.azList(i));
%     handles.indListEachAzim(2:end-1, i) = find(handles.HRIR.azim == handles.azList(i));
%     handles.indListEachAzim([1 end], i) = [1, 2522];
end
% handles.azLists = handles.HRIR.azim(handles.indListEachElev);
% handles.elLists = handles.HRIR.elev(handles.indListEachAzim);
handles.fs = 44100;
wn = zeros(0.3*handles.fs, 5);
wn(1:handles.fs*0.2, :) = rand(handles.fs*0.2, 5)-0.5;
handles.wn = wn(:)/8;
handles.progress.String = '';
handles.errLabel.String = '';
handles.elevList.Enable = 'on';
handles.horizList.Enable = 'on';
handles.Lib.Enable = 'on';
handles.Lib.Value = 1;
handles.elevList.Value = 1;
handles.horizList.Value = 1;
handles.testNum = 10;
guidata(hObject, handles);

% UIWAIT makes PreTraining wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = PreTraining_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in trainBtn.
function trainBtn_Callback(hObject, eventdata, handles)
% hObject    handle to trainBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global test_flag i whileCnt Path horizAngle elevAngle flag
if(whileCnt==0)
    whileCnt = 1;
    test_flag = 0;
    i = 0;
    handles.elevList.Enable = 'off';
    handles.horizList.Enable = 'off';
    handles.Lib.Enable = 'off';
    handles.progress.String = '';
    handles.errLabel.String = '';
    Path = getFile(handles);
    guidata(hObject, handles);
    if(flag)
        cla;
        drawShpere(handles, horizAngle);
        elevation_record(hObject, handles, horizAngle);
    else
        cla;
        drawCircle(handles);
        azimuth_record(hObject, handles, elevAngle);
    end
else
    warndlg('请先在角度选择区域点击鼠标右键退出当前过程', '警告', 'modal');
end


% --- Executes on button press in testBtn.
function testBtn_Callback(hObject, eventdata, handles)
% hObject    handle to testBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global test_flag i whileCnt flag horizAngle elevAngle
if(whileCnt==0)
    whileCnt = 1;
    test_flag = 1;
    i = 1;
    handles.progress.String = ['0 / ' num2str(handles.testNum)];
    handles.errLabel.String = '平均误差：';
    handles.elevList.Enable = 'off';
    handles.horizList.Enable = 'off';
    handles.Lib.Enable = 'off';
    if(flag)
        cla;
        drawShpere(handles, horizAngle);
        elevation_record(hObject, handles, horizAngle);
    else
        cla;
        drawCircle(handles);
        azimuth_record(hObject, handles, elevAngle);
    end
else
    warndlg('请先在角度选择区域点击鼠标右键退出当前过程', '警告', 'modal');
end



% --- Executes on selection change in elevList.
function elevList_Callback(hObject, eventdata, handles)
% hObject    handle to elevList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns elevList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from elevList
global flag elevAngle
% handles.elevList.Enable = 'off';
% handles.horizList.Enable = 'off';
% handles.Lib.Enable = 'off';
flag = 0;
% guidata(hObject, handles);
elevCase = get(handles.elevList, 'value');
elevAngle = handles.elList(elevCase);
delete(allchild(handles.axes1));
drawCircle(handles);
% azimuth_record(hObject, handles, elevAngle);

% --- Executes during object creation, after setting all properties.
function elevList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elevList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in horizList.
function horizList_Callback(hObject, eventdata, handles)
% hObject    handle to horizList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns horizList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from horizList
global flag front_back horizAngle
% handles.elevList.Enable = 'off';
% handles.horizList.Enable = 'off';
% handles.Lib.Enable = 'off';
flag = 1;
% guidata(hObject, handles);
horizCase = get(handles.horizList, 'value');
horizAngle = handles.azList(horizCase);
if(horizAngle>90)
    front_back = 0;
else
    front_back = 1;
end
% delete(allchild(handles.axes1));
cla;
drawShpere(handles, horizAngle);
% elevation_record(hObject, handles, horizAngle);


% --- Executes during object creation, after setting all properties.
function horizList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to horizList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function drawCircle(handles)
t=0:0.01:2*pi; x=sin(t); y=cos(t);
plot(handles.axes1, x,y,'k','linewidth', 1);
hold on;
for i = 1:12
    plot([0.15 1]*cos(pi/6*i), [0.15 1]*sin(pi/6*i), 'k--');
end
plot(handles.axes1, 0.1*x,0.1*y,'k');
plot(handles.axes1, 0,0.11,'k^');
plot(handles.axes1, -0.11,0,'ks');
plot(handles.axes1, 0.11,0,'ks');
axis equal;
axis off;

function drawShpere(handles, horizAngle)
% global b1 b2 b3 b4 b5 b6 b7 fb f1 f2 f3 f4 f5
% global p1 p2 p3;
% global l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12
axes(handles.axes1)
t=linspace(-pi/2, 3/2*pi, 201);
x=cos(t);
y=sin(t);
xx=sin(t); yy=0.37*cos(t); i1=find(yy<=0);
plot(x,y,'k','linewidth',1);
% fill(x, y, 'k', 'facealpha', 0.05);
hold on;
plot(xx(i1),yy(i1),'k');
plot(xx(i1),abs(yy(i1)),'k--');
axis equal;
axis off;

plot(0.1*x,0.1*y,'k')
plot(0.05,0.025,'ko');
plot(0.1,-0.01,'k>');

horizAngle = horizAngle*pi/180;
plot(x(1:101)*cos(horizAngle), y(1:101), 'k-', 'linewidth', 1);
fill(x(1:101)*cos(horizAngle), y(1:101), 'k', 'facealpha', 0.08, 'edgecolor', 'none');
fill([x(1:101)*cos(horizAngle) x(100:-1:1)*sign(cos(horizAngle))], ...
    [y(1:101) y(100:-1:1)], 'k', 'facealpha', 0.2, 'edgecolor', 'none');
for i = 1:7
    plot(cos((-120+i*30)/180*pi)*[0.15*sign(cos(horizAngle)), cos(horizAngle)], ...
        sin((-120+i*30)/180*pi)*[0.15, 1], 'k--', 'linewidth', 1);
end

function azimuth_record(hObject, handles, elevAngle)
% hObject    handle to azimuth0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i whileCnt state flag test_flag Path;
whileCnt = 1;
Path = getFile(handles);
handles = loadHrtf(hObject, handles, Path);
if (~test_flag)
    hori = 0: 30: 359;
    for j = 1: length(hori)
        playAudio(handles, hori(j), elevAngle);
        axes(handles.axes1);
        aglRef = (90-hori(j))*pi/180;
        h_ref = plot([0 1]*cos(aglRef), [0 1]*sin(aglRef), 'r', 'linewidth', 2);
        pause(2.5)
        delete(h_ref);
    end
end
while(i <= handles.testNum && ~flag)
    if(test_flag)
        if(i<=1)
            i=1;
            testInds = randperm(72);
            testInds = testInds(1:handles.testNum);
            elCase = get(handles.elevList, 'value');
            testAngles = handles.azLists(testInds, elCase);
            userAgls = testAngles;
        end
        handles.progress.String = sprintf('%d / %d', i, handles.testNum);
        p = playAudio(handles, testAngles(i), elevAngle);
        axes(handles.axes1);
    end
    try
        axes(handles.axes1);
        [xx, yy, key] = ginputt(1, @() angleUIUpdate());
    catch
        continue;
    end
    if(key==8||key==127||key==3)
        if(~test_flag)
            break;
        else
            continue;
        end
    elseif(key~=1)
        continue;
    end
    if(~state);continue;end
    if(test_flag)
        if(i==0);continue;end
        delete(p);
        aglRef = (90 - testAngles(i))*pi/180;
        h_ref = plot([0 1]*cos(aglRef), [0 1]*sin(aglRef), 'r', 'linewidth', 2);
    end
    [curAngle, l_x, l_y] = calcAzim(xx, yy);
    draw = plot(l_x,l_y,'k','linewidth',2);
    if(test_flag)
        pause(0.4);
    else
        pause(0.1);
        if(exist('p', 'var'));delete(p);end
    end
    delete(draw)
    if(test_flag);delete(h_ref);end

%     handles.azi.String = num2str(curAngle);
    if(~test_flag)
        p = playAudio(handles, curAngle, elevAngle);
        axes(handles.axes1);
    else
        userAgls(i) = curAngle;
        [res, ud, fb] = confuseRemove([testAngles(1:i), userAgls(1:i)]');
        handles.errLabel.String = ['平均误差：', ...
            num2str(mean(abs(res(1, :) - res(2, :))), '%.2f')];
        i = i + 1;
    end
end
if(test_flag)
    fprintf('elev: %d  %s: %f\n', elevAngle, handles.Lib.String{handles.Lib.Value}, ...
        mean(abs(res(1, :) - res(2, :))));
end
i = 0;
handles.elevList.Enable = 'on';
handles.horizList.Enable = 'on';
handles.Lib.Enable = 'on';
whileCnt = 0;

function elevation_record(hObject, handles, horizAngle)
% hObject    handle to back_42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i whileCnt state flag test_flag front_back Path;
whileCnt = 1;
Path = getFile(handles);
handles = loadHrtf(hObject, handles, Path);
if (~test_flag)
    elev = -90: 15: 90;
    for j = 1: length(elev)
        playAudio(handles, horizAngle, elev(j));
        axes(handles.axes1);
        aglRef = elev(j)*pi/180;
        h_ref = plot([0 1]*cos(aglRef)*cos(horizAngle*pi/180), [0 1]*sin(aglRef), 'r', 'linewidth', 2);
        pause(2.5)
        delete(h_ref);
    end
end
while(i <= handles.testNum && flag)
    if(test_flag)
        if(i<=1)
            i=1;
            testInds = randperm(37);
            testInds = testInds(1:handles.testNum);
            azCase = get(handles.horizList, 'value');
            testAngles = handles.elLists(testInds, azCase);
            userAgls = testAngles;
        end
        p = playAudio(handles, horizAngle, testAngles(i));
        axes(handles.axes1);
    end
    try
        axes(handles.axes1);
        [xx, yy, key] = ginputt(1, @() elevUIUpdate());
        key = key(1);
    catch
        continue;
    end
    if(key==8||key==127||key==3)
        if(~test_flag)
            break;
        else
            continue;
        end
    elseif(key~=1)
        continue;
    end
    if(~state);continue;end
    if(test_flag)
        if(i==0);continue;end
        delete(p);
        aglRef = testAngles(i)*pi/180;
        h_ref = plot([0 1]*cos(aglRef)*cos(horizAngle*pi/180), [0 1]*sin(aglRef), 'r', 'linewidth', 2);
    end
    [curAngle, l_x, l_y] = calcElev(xx*(front_back*2-1), yy);
    draw = plot(l_x*cos(horizAngle*pi/180),l_y,'k','linewidth',2);
    if(test_flag)
        pause(0.4);
    else
        pause(0.1);
        if(exist('p', 'var'));delete(p);end
    end
    delete(draw)
    if(test_flag);delete(h_ref);end

    if(~test_flag)
        p = playAudio(handles, horizAngle, curAngle);
        axes(handles.axes1);
    else
        userAgls(i) = curAngle;
        [res, ud, fb] = confuseRemove([testAngles(1:i), userAgls(1:i)]');
        handles.errLabel.String = ['平均误差：', ...
            num2str(mean(abs(res(1, :) - res(2, :))), '%.2f')];
        i = i + 1;
    end
end
if(test_flag)
    fprintf('azim: %d  %s: %f\n', horizAngle, handles.Lib.String{handles.Lib.Value}, ...
        mean(abs(res(1, :) - res(2, :))));
end
i = 0;
handles.elevList.Enable = 'on';
handles.horizList.Enable = 'on';
handles.Lib.Enable = 'on';
whileCnt = 0;

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

function [agl, l_x, l_y] = calcAzim(xx, yy)
angl = atan2(yy, xx);
r = linspace(0, 1, 10);
angl = angl*180/pi;
angl = round(angl/5)*5*pi/180;
l_x = r*cos(angl);
l_y = r*sin(angl);
agl = pi/2 - angl;
if(agl<0)
    agl = agl + pi*2;
end
agl = round(agl*180/pi*10)/10;
if(agl==360);agl=0;end

function [agl, l_x, l_y] = calcElev(xx, yy)
angl = atan2(yy, xx);
r = linspace(0, 1, 10);
angl = angl*180/pi;
angl = round(angl/5)*5*pi/180;
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
    
    
function elevUIUpdate()
global hT draw state front_back horizAngle;
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
draw = plot(l_x*abs(cos(horizAngle*pi/180)),l_y,'b--','linewidth',0.5);
if(curAngle>90)
    curAngle = 180 - curAngle;
end
hT = text(xx+0.05, yy+0.03, [num2str(curAngle) '°']);
pause(0.01);

function p = playAudio(handles, horizAngle, elevAngle)
global subjectName
load(['../HpTFcomp/HpFilts/' subjectName '.mat']);
if(fs_filt~=handles.fs)
    HpFilt = resample(HpFilt, handles.fs, fs_filt);
end
horizAngle = round(horizAngle/5) * 5;
elevAngle = round(elevAngle/5) * 5;
ind = find(handles.HRIR.azim == horizAngle & handles.HRIR.elev == elevAngle);
% horizAngle, elevAngle
% figure;
% plot([handles.HRIR.HR_L(:, ind) handles.HRIR.HR_R(:, ind)]);
wav(:, 1) = conv(handles.wn, handles.HRIR.HR_L(:, ind));
wav(:, 2) = conv(handles.wn, handles.HRIR.HR_R(:, ind));
wav(:, 1) = filter(HpFilt(:, 1), 1, wav(:, 1));
wav(:, 2) = filter(HpFilt(:, 2), 1, wav(:, 2));
p = audioplayer(wav/max(abs(wav(:)))/1.2, handles.fs);
p.play();

function [res, ud, fb] = confuseRemove(data)
global flag
% sz = size(data);
num = numel(data)/2;
ud = 0;
fb = 0;
if flag
    ud_inds = (90-abs(data(1,:)-90)).*(90-abs(data(2,:)-90))<0;
    ud = sum(ud_inds)/num*100;
    data(2,ud_inds) = -data(2,ud_inds);
else
    adj = data(:)>270;
    data(adj) = data(adj)-360;
    fb_inds = ((data(1,:)-90).*(data(2,:)-90))<0;
    fb = sum(fb_inds)/num*100;
    data(2,fb_inds) = 180 - data(2,fb_inds);
end
res = data;

function Path = getFile(handles)
global subjectName libName ;
subjectName = get(handles.name,'String');
libName = handles.Lib.String{handles.Lib.Value};
if(handles.Lib.Value ~= 1)
    tail = ['../HR/' subjectName, '/hrir_', libName];
else
    tail = ['../HR/kemar/hrir_', libName];
end
Path = tail;


function name_Callback(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name as text
%        str2double(get(hObject,'String')) returns contents of name as a double


% --- Executes during object creation, after setting all properties.
function name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
function handles = loadHrtf(hObject, handles, hrtfPath)
handles.HRIR = load(hrtfPath);
handles.HRIR.HR_L = handles.HRIR.HR_L';
handles.HRIR.HR_R = handles.HRIR.HR_R';
handles.indListEachElev = zeros(72, length(handles.elList));
handles.indListEachAzim = zeros(37, length(handles.azList));
for i = 1:length(handles.elList)
    handles.indListEachElev(:, i) = find(handles.HRIR.elev == handles.elList(i));
end
for i = 1:length(handles.azList)
    handles.indListEachAzim(:, i) = find(handles.HRIR.azim == handles.azList(i));
end
%FOR FABIAN DATABASE
% for i = 1:length(handles.azList)
%     handles.horizList.String{i} = num2str(handles.azList(i));
%     handles.indListEachAzim(2:end-1, i) = find(handles.HRIR.azim == handles.azList(i));
%     handles.indListEachAzim([1 end], i) = [1, 2522];
% end
handles.azLists = handles.HRIR.azim(handles.indListEachElev);
handles.elLists = handles.HRIR.elev(handles.indListEachAzim);
guidata(hObject, handles);



% --- Executes on selection change in Lib.
function Lib_Callback(hObject, eventdata, handles)
% hObject    handle to Lib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Lib contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Lib


% --- Executes during object creation, after setting all properties.
function Lib_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
