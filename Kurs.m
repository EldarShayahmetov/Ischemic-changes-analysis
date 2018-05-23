function varargout = Kurs(varargin)
% KURS MATLAB code for Kurs.fig
%      KURS, by itself, creates a new KURS or raises the existing
%      singleton*.
%
%      H = KURS returns the handle to a new KURS or the handle to
%      the existing singleton*.
%
%      KURS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KURS.M with the given input arguments.
%
%      KURS('Property','Value',...) creates a new KURS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Kurs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Kurs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Kurs

% Last Modified by GUIDE v2.5 15-Oct-2017 22:04:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Kurs_OpeningFcn, ...
                   'gui_OutputFcn',  @Kurs_OutputFcn, ...
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


% --- Executes just before Kurs is made visible.
function Kurs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Kurs (see VARARGIN)
arrayfun(@cla,findall(0,'type','axes'));
InitGlobals();
% Choose default command line output for Kurs
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes Kurs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Kurs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MakeFullScreen();
ShowEnterPanel(handles);
% Get default command line output from handles structure
varargout{1} = handles.output;

function MakeFullScreen()
robot = java.awt.Robot; 
if ismac
robot.keyPress(java.awt.event.KeyEvent.VK_META);      %// send COMMAND
robot.keyPress(java.awt.event.KeyEvent.VK_CONTROL);    %// send SPACE  
robot.keyPress(java.awt.event.KeyEvent.VK_F); %// send F
robot.keyRelease(java.awt.event.KeyEvent.VK_META);      %// send COMMAND
robot.keyRelease(java.awt.event.KeyEvent.VK_CONTROL);    %// send SPACE  
robot.keyRelease(java.awt.event.KeyEvent.VK_F);    %// send F
elseif ispc
robot.keyPress(java.awt.event.KeyEvent.VK_ALT);      %// send ALT
robot.keyPress(java.awt.event.KeyEvent.VK_SPACE);    %// send SPACE
robot.keyRelease(java.awt.event.KeyEvent.VK_SPACE);  %// release SPACE
robot.keyRelease(java.awt.event.KeyEvent.VK_ALT);    %// release ALT
robot.keyPress(java.awt.event.KeyEvent.VK_X);        %// send X
robot.keyRelease(java.awt.event.KeyEvent.VK_X);      %// release X
else
disp('Platform not supported'); 
end

% --- Properties(gloabal vars)

function InitGlobals()
        global ECG; ECG=[]; %clear signal
        global ECG1; ECG1=[]; %without baseline
        global ECG2; ECG2=[]; %synchrone meaned signal
        global Emax; Emax=[]; % ECG max; for unnormilize results to mv;
        global t; t=[]; %time range
        global Fd; Fd =250; % sampling frequency be default
        global Dur; Dur=[]; %signal duration counts;
        global  MaxDur; MaxDur = 60000;
        global st60; st60=[]; % 60 milliseconds after R-edge point
        global st80; st80=[];% 80 milliseconds after R-edge point
        global st100; st100=[];% 100 milliseconds after R-edge point
        global ast60; ast60=[];% normilized array of st60 changes
        global ast80; ast80=[];% normilized array of st80 changes
        global ast100; ast100=[];% normilized array of st100 changes
        global st60ind; st60ind=[];
        global st80ind; st80ind=[];
        global st100ind; st100ind=[];
        global stint; stint=[]; % array of integral st-changes
        global rrint; rrint=100;% interval between 2 R-edge;
        global rdur; rdur=20;% R-edge duration;
        global rhlvl; rhlvl=0.3; % level of detecting R-edge after Pan-Tomp Alg. This var can take [0,1]
        global window; window=[];
        global pan; pan=1;
        global FileN; FileN =[];
        global FN; FN =[];
        global Results; Results =[];
        
        
 % --- Functions //Eldar Shayahmetov
function outputData = ImportData(MaxDur)
    global FN;
            [FileName, PathName] = uigetfile('*.mat','Select the ECG record');
            File = fullfile(PathName, FileName);
            FN=FileName;
            if(~isempty(File))
                try
            outputData = load(File);
            outputData = outputData.val(1,:);
            outputData = outputData(1:MaxDur);  
                catch
                   outputData = [];  
                 warning('ECG data not found!');
                end
            end
 
    function ShowMainMenuPanelGroup(handles)
set(handles.EnterPanel, 'Visible', 'Off');
set(handles.MainPanelGroup, 'Visible', 'On');


 function ShowEnterPanel(handles)
 set(handles.EnterPanel, 'Visible', 'On');
 set(handles.MainPanelGroup, 'Visible', 'Off');
 set(handles.DataLoadPanel, 'Visible', 'On');
set(handles.SettingsPanel, 'Visible', 'Off');


     function ShowTab(handles, tab)
         switch tab
             case 1
                 set(handles.tab1, 'BackgroundColor', [0.3,0.75,0.93]);
                 set(handles.tab2, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.tab3, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.tab4, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.BaselinePanel, 'Visible', 'On');
                 set(handles.ResultsPanel, 'Visible', 'Off');
                 set(handles.STAnalysPanel, 'Visible', 'Off');
                 set(handles.AveragingPanel, 'Visible', 'Off');
             case 2
                 set(handles.tab1, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.tab2, 'BackgroundColor', [0.3,0.75,0.93]);
                 set(handles.tab3, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.tab4, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.BaselinePanel, 'Visible', 'Off');
                 set(handles.ResultsPanel, 'Visible', 'Off');
                 set(handles.STAnalysPanel, 'Visible', 'Off');
                 set(handles.AveragingPanel, 'Visible', 'On');
             case 3
                 set(handles.tab1, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.tab2, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.tab3, 'BackgroundColor', [0.3,0.75,0.93]);
                 set(handles.tab4, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.BaselinePanel, 'Visible', 'Off');
                 set(handles.ResultsPanel, 'Visible', 'Off');
                 set(handles.STAnalysPanel, 'Visible', 'On');
                 set(handles.AveragingPanel, 'Visible', 'Off');
             case 4
                 set(handles.tab1, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.tab2, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.tab3, 'BackgroundColor', [0.94,0.94,0.94]);
                 set(handles.tab4, 'BackgroundColor', [0.3,0.75,0.93]);
                 set(handles.BaselinePanel, 'Visible', 'Off');
                 set(handles.ResultsPanel, 'Visible', 'On');
                 set(handles.STAnalysPanel, 'Visible', 'Off');
                 set(handles.AveragingPanel, 'Visible', 'Off');
         end

            
    function InitSettings(handles)
            global t;
            global Fd;
            global MaxDur;
            global Dur;
            T=1/Fd;
            L=MaxDur;
            t = 0:T:T*(L-1);     
            ind=round((length(t))/3);
            a=int2str(t(ind)); b=int2str(t(ind*2));c=int2str(t((ind-1)*3));
            s=char(a,b,c);
            set(handles.TimePM,'String',s)
            set(handles.FdEdit,'String', int2str(Fd));
        
    function SetECGParams(handles)
        global Dur;
        global ECG;
        global Emax;
        global st60;
        global st80;
        global st100;
        global Fd;
        ECG = ECG(1:Dur-1);
        Emax = max(ECG);
        ECG = ECG/Emax;
        fil = get(handles.checkbox1, 'Value');
        if(fil==1)
        %[b,a] = butter(8,70/200,'low');
        %ECG = filter(b,a,ECG);
        end
        
         st60 = round(60/(1/Fd*1000));
         st80 = round(80/(1/Fd*1000));
         st100 = round(100/(1/Fd*1000));
         
   function graph = GetPanTompkinsAlgorithm(sig)
       global Fd;
            df = diff(sig);
            df = df/max(df);
            df2 = df.*df;
            L = length(df2);
            i=1;
            p=1/25;
            M = Fd*p;
            while i<=L-(M-1)
             a(i)=0;
                for j=0:M-1
                a(i)=a(i)+df2(i+j);
                end
                a(i)=a(i)/M;
             i=i+1;
            end
            graph = a;
                
            
  function rindexes = GetRPeacksIndexes(a, lvl, so)
      global rdur;
      global rrint;
         s=0;
         r=[];
         k=1;
         for i=1+so:length(a)
            s=s-1;
                if(a(i)>lvl && s<=0)
                span = i-2:1:i+rdur-1;
                r(k)= IndexOfMax(a, span);
                k=k+1;
                s=rrint+rdur;
                end
         end
        % r=r(1:length(r)-1);
         r(r==0) =[];
         rindexes = r;
        
 function tindexes = GetTPeacksIndexes(rpeacks)
     global ECG;
            ts=[];
            k=1;
            for i=1:length(rpeacks)
            g=rpeacks(i);
            span = [g+50:g+150];
            ts(i)=IndexOfMax(ECG, span);
            end 
            ts(ts==0) = [];
            tindexes = ts;
         
 function out = IndexOfMax(a, span)
        ind=0;
        maxi=0;
        if(span(end)<length(a))
        maxi = a(span(2));
        end
            for i=span(2):span(end)
                if(i<length(a))
                    if(a(i)>maxi)
                     maxi = a(i);
                    ind = i;
                    end
                end
            end
            out = ind;
            
 function SyncMean(r)
     global ECG1;
     global ECG2;
            r2 = r;
            cspan = [];
            aver = [];
            ECG2 = ECG1(r(1)-10:r(1));
            buff = ECG1(r(1):r(2));
            ECG2= cat(2,ECG2,buff);
            rspan = buff;
            for i=3:length(r)
            int = r(i) - r(i-1);
            cspan = ECG1(r(i-1):r(i));
                if(length(cspan)<length(rspan))
                rspan = rspan(1:length(cspan))+cspan;
                buff = (rspan(1:length(cspan))+cspan)/(i-1);
                else
                rspan = rspan+cspan(1:length(rspan));
                buff = (rspan+cspan(1:length(rspan)))/(i-1);
                end
            ECG2 = cat(2,ECG2, buff); 
            end
        offset = mean(buff(round(length(buff)*8/9):length(buff)-5));
        ECG2 = ECG2-offset;
        ECG1 = ECG1 - offset;
        
 function STAnalyse(r2)
        global st60;
        global st80;
        global st100;
        global ast60;
        global ast80;
        global ast100;
        global st60ind;
        global st80ind;
        global st100ind;
        global ECG2;
            for i=1:length(r2)
                if(r2(i)+st100<length(ECG2))
            st60ind(i) = r2(i)+st60;
            st80ind(i) = r2(i)+st80;
            st100ind(i) = r2(i)+st100;
            ast60(i) = ECG2(st60ind(i));
            ast80(i) = ECG2(st80ind(i));
            ast100(i) = ECG2(st100ind(i));
                end
            end
            
     function Refresh()
         InitGlobals();
         arrayfun(@cla,findall(0,'type','axes'));
         
         
           function MakeResults(handles)
        global ast60;
        global ast80;
        global ast100;
        global Emax;
        global Results;
        global FileN;
        global FN;
        d = date;
        ind = round(length(ast60)/2);
        m60 = mean(ast60(ind:length(ast60)));
        m80 = mean(ast80(ind:length(ast80)));
        m100 = mean(ast100(ind:length(ast100)));
        max60 = max(ast60(ind:length(ast60)));
        max80 = max(ast80(ind:length(ast80)));
        max100 = max(ast100(ind:length(ast100)));
        min60 = min(ast60(ind:length(ast60)));
        min80 = min(ast80(ind:length(ast80)));
        min100 = min(ast100(ind:length(ast100)));
        
        if(abs(max60)<abs(min60))
            max60 = min60;
        end
         if(abs(max80)<abs(min80))
            max80 = min80;
         end
        
       if(abs(max100)<abs(min100))
            max100 = min100;
        end
        
        a = strcat('ST60 change = ',num2str(m60*Emax), ' mV');
        b = strcat('ST80 change = ',num2str(m80*Emax), ' mV');
        c = strcat('ST100 change = ',num2str(m100*Emax), ' mV');
        f = strcat('Max ST60 change = ',num2str(max60*Emax), ' mV' );
        g = strcat('Max ST80 change = ',num2str(max80*Emax), ' mV' );
        h = strcat('Max ST100 change = ',num2str(max100*Emax), ' mV' );
        
        fn = strcat('Name:  ',FileN);
        fn1 = strcat('FileName:  ', FN);
        
        e='Ischemic changes(type not found)';
        
        if(m60<0 && m80<0 && m100<0)
            e = 'Result : ST-Depression'
        end
                if(m60>0 && m80>0 && m100>0)
            e = 'Result : ST-Elevation'
                end
                
           if(m60<0 && m80>0 || m100>0)
            e = 'Result :Ascendant ST-Depression'
           end
        
      
        str=char(d,fn1,fn,a,b,c,f,g,h,e);
        Results = str;
        set(handles.ResultsText, 'String', str);
         
                       
            
% --- CALLBACKS


% --- Executes on button press in LoadDataButton.
function LoadDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Refresh();
global ECG;
global MaxDur;
ECG = ImportData(MaxDur);
set(handles.TimePM, 'Value', 1);
if(~isempty(ECG))
    InitSettings(handles);
    TimePM_Callback(hObject, eventdata, handles);
    set(handles.DataLoadPanel, 'Visible', 'Off');
    set(handles.SettingsPanel, 'Visible', 'On');
end

        
        


% --- Executes on button press in OkButton.
function OkButton_Callback(hObject, eventdata, handles)
% hObject    handle to OkButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ECG;
global ECG1;
global ECG2;
global rhlvl;
global Dur;
global Fd;
global Emax;
global st60;
global st80;
global st100;
global ast60;
global ast80;
global ast100;
global st60ind;
global st80ind;
global st100ind;
global FileN;
ShowMainMenuPanelGroup(handles);
ShowTab(handles,1);
set(handles.IndicatorButton, 'BackgroundColor', [0.93,0.69,0.13]);
set(handles.IndicatorButton, 'String', 'Processing...');
FileN = get(handles.edit3, 'String');
try
            T=1/Fd;
            SetECGParams(handles);
            a=GetPanTompkinsAlgorithm(ECG);
            lvl = max(a(1:200));
            r=GetRPeacksIndexes(a,lvl/3,0);
            ts=GetTPeacksIndexes(r);
            cs = spline(ts,ECG(ts),1:1:Dur-1);
            ECG1 = ECG-cs;
            SyncMean(r);
            r1=GetRPeacksIndexes(ECG2,rhlvl,0);
            STAnalyse(r1);
            MakeResults(handles);
            
            %Plots
            
            L=length(ECG);
            t = 0:T:T*(L-1);  
            axes(handles.axes_1);
            plot(t, ECG);
            title('ECG(normalized) physionet.org');
            ylabel('Amplitude');
            xlabel('Time(sec)');
            set(handles.axes_1, 'XLim', [0,T*(L-1)]);
            
            L=length(a);
            t = 0:T:T*(L-1); 
            axes(handles.axes_2);
            plot(t,a);
            hold on;
            stem(r*T, a(r(1:length(r))));
            title('Pan-Tompkins algorithm, detect R-edge');
            ylabel('Amplitude')
            xlabel('Time(sec)')
            set(handles.axes_2, 'XLim', [0,T*(L-1)]);
            
            
            L=length(ECG);
            t = 0:T:T*(L-1);  
            axes(handles.axes_3);
            plot(t,ECG);
            hold on;
            stem(ts*T,ECG(ts(1:length(ts))));
            title('óharacteristic points of T-edge');
            ylabel('Amplitude');
            xlabel('Time(sec)');
            set(handles.axes_3, 'XLim', [0,T*(L-1)]);

            axes(handles.axes_4);
            plot(ts*T,ECG(ts(1:length(ts))),'o',(1:length(cs))*T,cs)
            title('Cubic spline interpolation');
            ylabel('Amplitude');
            xlabel('Time(sec)');
            set(handles.axes_4, 'XLim', [0,T*(L-1)]);
            
            
            L=length(ECG1);
            t = 0:T:T*(L-1);  
            axes(handles.axes_5);
            plot(t,ECG1);
            title('Baseline removal');
            ylabel('Amplitude')
            xlabel('Time(sec)')
            set(handles.axes_5, 'XLim', [0,T*(L-1)]);
            
            
            L=length(ECG2);
            t = 0:T:T*(L-1); 
            axes(handles.axes_6);
            plot(t ,ECG2());
            hold on;
            stem(st60ind*T, ECG2(st60ind(1:length(st60ind))));
            stem(st80ind*T, ECG2(st80ind(1:length(st80ind))));
            stem(st100ind*T, ECG2(st100ind(1:length(st100ind))));
            title('st-change analyse using st60, st80, st100 points');
            ylabel('Amplitude')
            xlabel('Time(sec)')
            set(handles.axes_6, 'XLim', [0,T*(L-1)]);
            
            axes(handles.axes_7);
             plot(Emax*ast60(3:length(ast60)))
            title('st60 change');
            ylabel('Amplitude, mV');
            xlabel('ST-segment number');
            
             axes(handles.axes_8);
             plot(Emax*ast80(3:length(ast80)))
            title('st80 change');
            ylabel('Amplitude, mV');
            xlabel('ST-segment number');
            
              axes(handles.axes_9);
             plot(Emax*ast100(3:length(ast100)))
            title('st100 change');
            ylabel('Amplitude, mV');
            xlabel('ST-segment number');
            
 set(handles.IndicatorButton, 'BackgroundColor', [0.47,0.67,0.19]);
set(handles.IndicatorButton, 'String', 'Done!');

catch
    set(handles.IndicatorButton, 'BackgroundColor', [1,0,0]);
set(handles.IndicatorButton, 'String', 'Error!');
end
            
            

            
            



function FdEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fd;
Fd = str2double(get(hObject, 'String'));
InitSettings(handles);

% Hints: get(hObject,'String') returns contents of FdEdit as text
%        str2double(get(hObject,'String')) returns contents of FdEdit as a double


% --- Executes during object creation, after setting all properties.
function FdEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function TimePM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimePM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TimePM.
function TimePM_Callback(hObject, eventdata, handles)
% hObject    handle to TimePM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Dur;
global t;
contents = get(hObject,'Value');
ind=round((length(t))/3);

switch contents
    case 1
        Dur = ind;
    case 2
        Dur = 2*ind;
    case 3
        Dur = 3*ind;
end
        
% Hints: contents = cellstr(get(hObject,'String')) returns TimePM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TimePM


% --- Executes on button press in tab1.
function tab1_Callback(hObject, eventdata, handles)
% hObject    handle to tab1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ShowTab(handles,1);



% --- Executes on button press in tab2.
function tab2_Callback(hObject, eventdata, handles)
% hObject    handle to tab2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ShowTab(handles,2);


% --- Executes on button press in tab3.
function tab3_Callback(hObject, eventdata, handles)
% hObject    handle to tab3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ShowTab(handles,3);


% --- Executes on button press in tab4.
function tab4_Callback(hObject, eventdata, handles)
% hObject    handle to tab4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ShowTab(handles,4);


% --- Executes on button press in LoadNew.
function LoadNew_Callback(hObject, eventdata, handles)
% hObject    handle to LoadNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ShowEnterPanel(handles);



% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SaveResultsButton.
function SaveResultsButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveResultsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Results;
[FileName, PathName, FilterIndex] = uiputfile('*.txt', 'Save as:');
if ~ischar(FileName)
  disp('User aborted the dialog');
  return;
end
File = fullfile(PathName, FileName);

    CellArray = strcat(Results); 
    fid = fopen(File,'w');
    for r=1:size(CellArray,1)
        fprintf(fid,'%s\n',CellArray(r,:));
    end
    fclose(fid);



% --- Executes on button press in IndicatorButton.
function IndicatorButton_Callback(hObject, eventdata, handles)
% hObject    handle to IndicatorButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in SavePlotButton.
function SavePlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to SavePlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName, FilterIndex] = uiputfile('*.png', 'Save as:');
if ~ischar(FileName)
  disp('User aborted the dialog');
  return;
end
File = fullfile(PathName, FileName);
saveas(gcf,File,'png');


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName, FilterIndex] = uiputfile('*.png', 'Save as:');
if ~ischar(FileName)
  disp('User aborted the dialog');
  return;
end
File = fullfile(PathName, FileName);
saveas(gcf,File,'png');
