function varargout = EstimationFR(varargin)
% ESTIMATIONFR MATLAB code for EstimationFR.fig
%      ESTIMATIONFR, by itself, creates a new ESTIMATIONFR or raises the existing
%      singleton*.
%
%      H = ESTIMATIONFR returns the handle to a new ESTIMATIONFR or the handle to
%      the existing singleton*.
%
%      ESTIMATIONFR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESTIMATIONFR.M with the given input arguments.
%
%      ESTIMATIONFR('Property','Value',...) creates a new ESTIMATIONFR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EstimationFR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EstimationFR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%

% Edit the above text to modify the response to help EstimationFR

% Last Modified by GUIDE v2.5 07-Jun-2019 17:14:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EstimationFR_OpeningFcn, ...
                   'gui_OutputFcn',  @EstimationFR_OutputFcn, ...
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

% --- Executes just before EstimationFR is made visible.
function EstimationFR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EstimationFR (see VARARGIN)

% Choose default command line output for EstimationFR
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
cd(fileparts(which(mfilename)))
addpath(genpath('./'));


% UIWAIT makes EstimationFR wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EstimationFR_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ECG_Callback(hObject, eventdata, handles)
% hObject    handle to ECG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
linkaxes(findall(0,'type','axes'),'x');
loadECG
if file ~= 0
    set(handles.plotRQI,'Value',0);
    plotRQI_Callback(handles.plotRQI, eventdata, handles);
    handles=rmfield2(handles,'RPA','RRI','AQRS','QRA','RPA_filt','RRI_filt',...
        'AQRS_filt','QRA_filt','indx_RQI','bw_brut','bw_filt','plot_RQI',...
        'ecg_filt','plottQRS','R_i','Q_i','S_i','ttot_sansfusion','ttot_t');
    arrayfun(@reset,(findall(0,'type','axes')));
end

handles.ECGpath = path;
handles.ECGfile = file;

ecgfs=str2double(get(handles.ecgfs,'String'));
ecg_brut=handles.ecg_brut;
t=[0:1/ecgfs:1/ecgfs*(length(ecg_brut)-1)];
guidata(hObject, handles);

plotECG
guidata(hObject, handles);

% wp2 = .8/(handles.bwfs/2);
% ws2 = 1/(handles.bwfs/2);
% [order,wn] = buttord(wp2,ws2,3,20); % Passe-band Butterworth
% [A,B] = butter(order,wn, 'low');
% bw_F = filtfilt(A,B,handles.bw);
% bw_F = sgolayfilt(bw,3,43);
% handles.bw_T = (0:length(bw_F)-1)./handles.bwfs;

% axes(handles.RespAxes)
% plot(bw_T, bw_F)
% hold on
% plot(bw_T, handles.bw)
%guidata(hObject, handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=rmfield2(handles,'RPA','RRI','AQRS','QRA','RPA_filt','RRI_filt',...
    'AQRS_filt','QRA_filt','indx_RQI','plot_RQI');
    
ecg_brut=handles.ecg_brut;
ecgfs=str2double(get(handles.ecgfs,'String'));
bwfs=str2double(get(handles.bwfs,'String'));
%if ~isfield(handles,'R_i')
    calculateR_i
    R_i=handles.R_i;
%end
% axes(handles.ecgAxes)
% hold on 
% pR=plot((handles.R_i-1)./ecgfs,ecg_brut(handles.R_i)-mean(ecg_brut),'o');
%     pause()
%     set(pR, 'Visible','off')
%if ~isfield(handles,'S_i') | ~isfield(handles,'Q_i')
    detection_Q_S
%end


[ handles.RPA,handles.QRA,handles.RRI,handles.AQRS] = EDR_derived(handles);

bw_T=[0:1/bwfs:1/ecgfs*(length(ecg_brut)-1)];
RPA=handles.RPA;
QRA=handles.QRA;
RRI=handles.RRI;
AQRS=handles.AQRS;
plotEDR
guidata(hObject, handles);


% --- Executes on button press in EDR_1.
function EDR_1_Callback(hObject, eventdata, handles)
% hObject    handle to EDR_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.checkEDR(1)=get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in EDR_2.
function EDR_2_Callback(hObject, eventdata, handles)
% hObject    handle to EDR_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.checkEDR(2)=get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in EDR_3.
function EDR_3_Callback(hObject, eventdata, handles)
% hObject    handle to EDR_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.checkEDR(3)=get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in EDR_4.
function EDR_4_Callback(hObject, eventdata, handles)
% hObject    handle to EDR_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.checkEDR(4)=get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in FRnoFusion.
function FRnoFusion_Callback(hObject, eventdata, handles)
% hObject    handle to FRnoFusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

bwfs=str2double(get(handles.bwfs,'String'));
win.duration=str2double(get(handles.winLength,'String'));
win.overlap=str2double(get(handles.overlap,'String'))/100;
win.points=win.duration*bwfs;
win.step=win.points*(1-win.overlap);
win.N=fix((length(handles.RPA)-win.overlap*win.points)/win.step);
if isfield(handles,'RPA_filt')
    RPA=handles.RPA_filt;
    QRA=handles.QRA_filt;
    RRI=handles.RRI_filt;
    AQRS=handles.AQRS_filt;
else
    RPA=handles.RPA;
    QRA=handles.QRA;
    RRI=handles.RRI;
    AQRS=handles.AQRS;
end

switch get(handles.flagRQI,'Value')
    case 1
        fld='RQI_fft_';
         seuil=0.14;
    case 2 
        fld='RQI_autocorr_';
         seuil=0.1;    
    case 3 
        fld='RQI_sum_fft_autocorr_';
         seuil=0.5; 
    case 4 
        fld='RQI_NRMSE_';
         seuil=0.49; 
    case 5 
        fld='RQI_periodicite_';
        %seuil=0;
    case 6 
        fld='RQI_FFT_autocorr_';
        %seuil=0.25;        
end

warning off
[handles.RPA,handles.QRA,handles.RRI,handles.AQRS] = EDR_derived(handles);
calculateRQI
selectRQI
warning on
ttot_est=handles.ttot_sansfusion;
plotFR
guidata(hObject, handles);


% --- Executes on button press in FRfusion.
function FRfusion_Callback(hObject, eventdata, handles)
% hObject    handle to FRfusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

bwfs=10;

if isfield(handles,'RPA_filt')
    RPA=handles.RPA_filt;
    QRA=handles.QRA_filt;
    RRI=handles.RRI_filt;
    AQRS=handles.AQRS_filt;
else
    RPA=handles.RPA;
    QRA=handles.QRA;
    RRI=handles.RRI;
    AQRS=handles.AQRS;
end

RPA=RPA-mean(RPA);
QRA=QRA-mean(QRA);
RRI=RRI-mean(RRI);
AQRS=AQRS-mean(AQRS);

switch get(handles.flagRQI,'Value')
    case 1
        fld='RQI_fft_';
%         seuil=0.25;
    case 2 
        fld='RQI_autocorr_';
%         seuil=0.25;    
    case 3 
        fld='RQI_sum_fft_autocorr_';
%         seuil=0.5; 
    case 4 
        fld='RQI_NRMSE_';
%         seuil=0.1; 
    case 5 
        fld='RQI_periodicite_';
        %seuil=0;
    case 6 
        fld='RQI_FFT_autocorr_'
        %seuil=0.25;        
end

ecg_brut=handles.ecg_brut;
ecgfs=str2double(get(handles.ecgfs,'String'));
old_T=[0:1/str2double(get(handles.bwfs,'String')):1/ecgfs*(length(ecg_brut)-1)];
bw_T=[0:1/bwfs:1/ecgfs*(length(ecg_brut)-1)];
RPA = interp1(old_T, RPA, bw_T,'pchip');
QRA = interp1(old_T, QRA, bw_T,'pchip');
RRI = interp1(old_T, RRI, bw_T,'pchip');
AQRS = interp1(old_T, AQRS, bw_T, 'pchip');
win.duration=str2double(get(handles.winLength,'String'));
win.overlap=str2double(get(handles.overlap,'String'))/100;
win.points=win.duration*bwfs;
win.step=win.points*(1-win.overlap);
win.N=fix((length(RPA)-win.overlap*win.points)/win.step);
warning off
calculateRQI
fusionRQI
warning on

ttot_est=handles.ttot_fusion;
indx_lowqual=[];
plotFR
guidata(hObject, handles);

% --------------------------------------------------------------------
function tQRS_Callback(hObject, eventdata, handles)
% hObject    handle to tQRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function resp_Callback(hObject, eventdata, handles)
% hObject    handle to resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loadBW
if file ~= 0
    set(handles.plotRef,'Value',1);
    set(handles.plotRQI,'Value',0);
    handles=rmfield2(handles,'bw_filt');
end

handles.BWpath = path;
handles.BWfile = file;

bwfs=str2double(get(handles.bwfs,'String'));
fMin=str2double(get(handles.fMinEDR,'String'));
fMax=str2double(get(handles.fMaxEDR,'String'));
ordre=str2double(get(handles.ordreEDR,'String'));
wp2 = fMin/(bwfs/2);
ws2 = fMax/(bwfs/2);
wn = [wp2 ws2];
[A,B] = butter(ordre,wn);
handles.bw_filt = filtfilt(A,B,double(handles.bw_brut));
bwfs_Callback(handles.bwfs, eventdata, handles)
if isfield(handles,'ttot_sansfusion')
    ttot_t=handles.ttot_t;
    ttot_est=handles.ttot_sansfusion;
    if isfield(handles,'indx_lowqual')
        indx_lowqual=handles.indx_lowqual;
    else
        indx_lowqual=[];
    end
    plotFR
end
guidata(hObject, handles);





function fMinECG_Callback(hObject, eventdata, handles)
% hObject    handle to fMinECG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fMinECG as text
%        str2double(get(hObject,'String')) returns contents of fMinECG as a double
if isempty(str2num(get(hObject,'String')))
    set(handles.fminECG,'String',string(0.1));
    warndlg('Input must be numerical');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function fMinECG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fMinECG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fMaxECG_Callback(hObject, eventdata, handles)
% hObject    handle to fMaxECG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fMaxECG as text
%        str2double(get(hObject,'String')) returns contents of fMaxECG as a double
if isempty(str2num(get(hObject,'String')))
    set(handles.fMaxECG,'String',string(40));
    warndlg('Input must be numerical');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function fMaxECG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fMaxECG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ordreECG_Callback(hObject, eventdata, handles)
% hObject    handle to ordreECG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ordreECG as text
%        str2double(get(hObject,'String')) returns contents of ordreECG as a double
if isempty(str2num(get(hObject,'String')))
    set(handles.ordreECG,'String',string(2));
    warndlg('Input must be numerical');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ordreECG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ordreECG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filtreECG.
function filtreECG_Callback(hObject, eventdata, handles)
% hObject    handle to filtreECG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecg_brut=handles.ecg_brut;
ecgfs=str2double(get(handles.ecgfs,'String'));
fMin=str2double(get(handles.fMinECG,'String'));
fMax=str2double(get(handles.fMaxECG,'String'));
ordre=str2double(get(handles.ordreECG,'String'));
wp2 = fMin/(ecgfs/2);
ws2 = fMax/(ecgfs/2);
wn = [wp2 ws2];
[A,B] = butter(ordre,wn);
handles.ecg_filt = filtfilt(A,B,ecg_brut);
guidata(hObject, handles);
plotECG


function fMinEDR_Callback(hObject, eventdata, handles)
% hObject    handle to fMinEDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fMinEDR as text
%        str2double(get(hObject,'String')) returns contents of fMinEDR as a double
if isempty(str2num(get(hObject,'String')))
    set(handles.fminEDR,'String',string(0.1));
    warndlg('Input must be numerical');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fMinEDR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fMinEDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fMaxEDR_Callback(hObject, eventdata, handles)
% hObject    handle to fMaxEDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fMaxEDR as text
%        str2double(get(hObject,'String')) returns contents of fMaxEDR as a double
if isempty(str2num(get(hObject,'String')))
    set(handles.fMaxEDR,'String',string(1));
    warndlg('Input must be numerical');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fMaxEDR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fMaxEDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ordreEDR_Callback(hObject, eventdata, handles)
% hObject    handle to ordreEDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ordreEDR as text
%        str2double(get(hObject,'String')) returns contents of ordreEDR as a double
if isempty(str2num(get(hObject,'String')))
    set(handles.ordreERD,'String',string(5));
    warndlg('Input must be numerical');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ordreEDR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ordreEDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filtreEDR.
function filtreEDR_Callback(hObject, eventdata, handles)
% hObject    handle to filtreEDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles=rmfield2(handles,'indx_RQI');
RPA=handles.RPA;
bwfs=str2double(get(handles.bwfs,'String'));
fMin=str2double(get(handles.fMinEDR,'String'));
fMax=str2double(get(handles.fMaxEDR,'String'));
ordre=str2double(get(handles.ordreEDR,'String'));
wp2 = fMin/(bwfs/2);
ws2 = fMax/(bwfs/2);
wn = [wp2 ws2];
[A,B] = butter(ordre,wn);
handles.RPA_filt = filtfilt(A,B,double(handles.RPA));
handles.QRA_filt = filtfilt(A,B,double(handles.QRA));
handles.RRI_filt = filtfilt(A,B,double(handles.RRI));
handles.AQRS_filt = filtfilt(A,B,double(handles.AQRS));
if isfield(handles,'bw_brut')
    handles.bw_filt = filtfilt(A,B,double(handles.bw_brut));
end
plotEDR



function ecgfs_Callback(hObject, eventdata, handles)
% hObject    handle to ecgfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ecgfs as text
if isempty(str2num(get(hObject,'String')))
    set(hObject,'string','1');
    warndlg('Input must be numerical');
end
plotECG
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ecgfs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ecgfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bwfs_Callback(hObject, eventdata, handles)
% hObject    handle to bwfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(str2num(get(hObject,'String')))
    set(hObject,'string','1');
    warndlg('Input must be numerical');
end
bwfs=str2double(get(hObject,'String'));

if isfield(handles,'RPA')
    [ handles.RPA,handles.QRA,handles.RRI,handles.AQRS] = EDR_derived(handles);
    bw_T=[0:1/bwfs:1/bwfs*(length(handles.RPA)-1)];
    RPA=handles.RPA;
    QRA=handles.QRA;
    RRI=handles.RRI;
    AQRS=handles.AQRS;
    if isfield(handles,'RPA_filt')
        filtreEDR_Callback(hObject, eventdata, handles)
    else
        plotEDR
    end
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of bwfs as text
%        str2double(get(hObject,'String')) returns contents of bwfs as a double


% --- Executes during object creation, after setting all properties.
function bwfs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bwfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in flagRQI.
function flagRQI_Callback(hObject, eventdata, handles)
% hObject    handle to flagRQI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns flagRQI contents as cell array
%        contents{get(hObject,'Value')} returns selected item from flagRQI
bwfs=str2double(get(handles.bwfs,'String'));
win.duration=str2double(get(handles.winLength,'String'));
win.overlap=str2double(get(handles.overlap,'String'))/100;
win.points=win.duration*bwfs;
win.step=win.points*(1-win.overlap);
win.N=fix((length(handles.RPA)-win.overlap*win.points)/win.step);

if isfield(handles,'RPA_filt')
    RPA=handles.RPA_filt;
    QRA=handles.QRA_filt;
    RRI=handles.RRI_filt;
    AQRS=handles.AQRS_filt;
else
    RPA=handles.RPA;
    QRA=handles.QRA;
    RRI=handles.RRI;
    AQRS=handles.AQRS;
end
RPA=RPA-mean(RPA);
QRA=QRA-mean(QRA);
RRI=RRI-mean(RRI);
AQRS=AQRS-mean(AQRS);
switch get(handles.flagRQI,'Value')
    case 1
        fld='RQI_fft_';
%         seuil=0.25;
    case 2 
        fld='RQI_autocorr_';
%         seuil=0.25;    
    case 3 
        fld='RQI_sum_fft_autocorr_';
%         seuil=0.5; 
    case 4 
        fld='RQI_NRMSE_';
%         seuil=0.1; 
    case 5 
        fld='RQI_periodicite_';
        %seuil=0;
    case 6 
        fld='RQI_FFT_autocorr_';
        %seuil=0.25;        
end
warning off
calculateRQI;
warning on
plotEDR

% --- Executes during object creation, after setting all properties.
function flagRQI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flagRQI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function winLength_Callback(hObject, eventdata, handles)
% hObject    handle to winLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of winLength as text
%        str2double(get(hObject,'String')) returns contents of winLength as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'string','30');
    warndlg('Input must be numerical');
end
winLength=str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function winLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function overlap_Callback(hObject, eventdata, handles)
% hObject    handle to overlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of overlap as text
%        str2double(get(hObject,'String')) returns contents of overlap as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'string','0');
    warndlg('Input must be numerical');
end
overlap=str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function overlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_tQRS.
function plot_tQRS_Callback(hObject, eventdata, handles)
% hObject    handle to plot_tQRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_tQRS
if ~isfield(handles,'R_i') && get(hObject,'Value')==1
    ecg_brut=handles.ecg_brut;
    ecgfs=str2double(get(handles.ecgfs,'String'));
    calculateR_i
end
plotECG


% --- Executes on button press in plotRQI.
function plotRQI_Callback(hObject, eventdata, handles)
% hObject    handle to plotRQI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotRQI
if get(hObject,'Value')==1
    set(handles.plotRef,'Value',0)
end
plotEDR


    

% --------------------------------------------------------------------
function More_Callback(hObject, eventdata, handles)
% hObject    handle to More (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('About.m')

% --------------------------------------------------------------------
function PPG_Callback(hObject, eventdata, handles)
% hObject    handle to PPG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function refTtot_Callback(hObject, eventdata, handles)
% hObject    handle to refTtot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plotRef.
function plotRef_Callback(hObject, eventdata, handles)
% hObject    handle to plotRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotRef
if get(hObject,'Value')==1
    set(handles.plotRQI,'Value',0)
end
plotEDR

% --- Executes on button press in visuError.
function visuError_Callback(hObject, eventdata, handles)
% hObject    handle to visuError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bwfs=str2double(get(handles.bwfs,'String'));
win.duration=str2double(get(handles.winLength,'String'));
win.overlap=str2double(get(handles.overlap,'String'))/100;
win.points=win.duration*bwfs;
win.step=win.points*(1-win.overlap);
win.N=fix((length(handles.RPA)-win.overlap*win.points)/win.step);
seuil_cycledet=0.15;
if isfield(handles,'RPA_filt')
    RPA=handles.RPA_filt;
    QRA=handles.QRA_filt;
    RRI=handles.RRI_filt;
    AQRS=handles.AQRS_filt;
else
    RPA=handles.RPA;
    QRA=handles.QRA;
    RRI=handles.RRI;
    AQRS=handles.AQRS;
end
RPA=RPA-mean(RPA);
QRA=QRA-mean(QRA);
RRI=RRI-mean(RRI);
AQRS=AQRS-mean(AQRS);

[mntab_RPA,mxtab_RPA]=cycledet_filt(RPA,seuil_cycledet,bwfs); % signal EDR, RPA
[mntab_QRA,mxtab_QRA]=cycledet_filt(QRA,seuil_cycledet,bwfs);  % signal respi zephy[mntab_respi1,mxtab_respi1]=cycledet_filt(x,th,bwfs);  % signal respi zephyr
[mntab_RRI,mxtab_RRI]=cycledet_filt(RRI,seuil_cycledet,bwfs); % signal EDR,RRI
[mntab_AQRS,mxtab_AQRS]=cycledet_filt(AQRS,seuil_cycledet,bwfs); % signal EDR,AQRS

mxtab_RPA = mxtab_RPA(2:end,:);
mxtab_QRA = mxtab_QRA(2:end,:);
mxtab_RRI = mxtab_RRI(2:end,:);
mxtab_AQRS = mxtab_AQRS(2:end,:);

[ ttot_RPA,x_RPA ] = calcul_ttot(mxtab_RPA,bwfs,1,win);
[ ttot_QRA,x_QRA] = calcul_ttot(mxtab_QRA,bwfs,1,win);
[ ttot_RRI,x_RRI] = calcul_ttot(mxtab_RRI,bwfs,1,win);
[ ttot_AQRS,x_AQRS ] = calcul_ttot(mxtab_AQRS,bwfs,1,win);

[mntab_respi,mxtab_respi]=cycledet_filt(handles.bw_filt,0.15,bwfs);
[ttot_ref, ttot_t] = calcul_ttot(mntab_respi,bwfs,1,win);

ttot_sansfusion=handles.ttot_sansfusion;
[RMSE_RPA,MAE_RPA] = calcul_erreur(ttot_ref,ttot_RPA);
[RMSE_QRA,MAE_QRA] = calcul_erreur(ttot_ref,ttot_QRA);
[RMSE_RRI,MAE_RRI] = calcul_erreur(ttot_ref,ttot_RRI);
[RMSE_AQRS,MAE_AQRS] = calcul_erreur(ttot_ref,ttot_AQRS);
[RMSE_sansfusion,MAE_sansfusion,nanidx,err] = calcul_erreur(ttot_ref,ttot_sansfusion);
figure('name','Erreur Absolue')
C = [MAE_RPA MAE_RRI MAE_QRA MAE_AQRS MAE_sansfusion];
grp = [zeros(1,length(MAE_RPA)),ones(1,length(MAE_RRI)), ...
    2*ones(1,length(MAE_QRA)),3*ones(1,length(MAE_AQRS)),...
    4*ones(1,length(MAE_sansfusion))];
positions = [1 2 3 4 5 6 ];
set(gcf,'Color','white')
boxplot(C',grp')
set(gca,'xtick',[mean(positions(1)) mean(positions(2)) mean(positions(3)) mean(positions(4)) mean(positions(5)) mean(positions(6))])
set(gca,'xticklabel',{'RPA','RRI','QRA', 'AQRS', 'no fusion'})
ylabel('absolute error [bpm]','fontsize',25)
figure('name','hist')
hist(err)