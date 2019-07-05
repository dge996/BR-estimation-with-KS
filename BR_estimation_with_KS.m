function varargout = BR_estimation_with_KS(varargin)
% BR_ESTIMATION_WITH_KS MATLAB code for BR_estimation_with_KS.fig
%      BR_ESTIMATION_WITH_KS, by itself, creates a new BR_ESTIMATION_WITH_KS or raises the existing
%      singleton*.
%
%      H = BR_ESTIMATION_WITH_KS returns the handle to a new BR_ESTIMATION_WITH_KS or the handle to
%      the existing singleton*.
%
%      BR_ESTIMATION_WITH_KS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BR_ESTIMATION_WITH_KS.M with the given input arguments.
%
%      BR_ESTIMATION_WITH_KS('Property','Value',...) creates a new BR_ESTIMATION_WITH_KS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BR_estimation_with_KS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BR_estimation_with_KS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%

% Edit the above text to modify the response to help BR_estimation_with_KS

% Last Modified by GUIDE v2.5 04-Jul-2019 09:11:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BR_estimation_with_KS_OpeningFcn, ...
                   'gui_OutputFcn',  @BR_estimation_with_KS_OutputFcn, ...
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

% --- Executes just before BR_estimation_with_KS is made visible.
function BR_estimation_with_KS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BR_estimation_with_KS (see VARARGIN)

% Choose default command line output for BR_estimation_with_KS
handles.output = hObject;
handles.appPath=fileparts(which(mfilename));

% Update handles structure
guidata(hObject, handles);
cd(handles.appPath)
addpath(genpath('./'));


% UIWAIT makes BR_estimation_with_KS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BR_estimation_with_KS_OutputFcn(hObject, ~, handles) 
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
handlesCopy=handles;
handles=rmfield2(handles,'RPA','RRI','AQRS','QRA','RPA_filt','RRI_filt',...
    'AQRS_filt','QRA_filt','indx_RQI','bw_brut','bw_filt',...
    'ecg_filt','Q_i','S_i','ttot_sansfusion','ttot_t','R_i',...
    'ttot_fusion');
loadECG
if file ~= 0
    %Remise a zero des tracés
    clear handlesCopy
    set(handles.plotRQI,'Value',0);
    set(handles.plotRef,'Value',0);
    set(handles.plot_tQRS,'Value',0);
    arrayfun(@reset,(findall(0,'type','axes')));
    arrayfun(@cla,(findall(0,'type','axes')));

    handles.ECGpath = path;
    handles.ECGfile = file;
    
    % Changement des noms PPG->ECG
    set(handles.textFecg,'String', 'ECG fs :');
    set(handles.text4,'String', 'ECG filtering (Butterworth) :');
    set(handles.filtreECG,'String', 'Filter ECG');
    set(handles.plot_tQRS,'String', 'plot R peaks');
    set(handles.plot_tQRS,'Visible', 'on');
    set(handles.EDR_1,'String', 'RPA');
    set(handles.EDR_4,'String', 'QRA');
    set(handles.EDR_2,'String', 'RRI');
    set(handles.EDR_3,'Value', 1);
    set(handles.EDR_3,'Visible', 'on');
    set(handles.AQRSaxes,'Visible', 'on');
    
    % Tracé
    ecgfs=str2double(get(handles.ecgfs,'String'));
    ecg_brut=handles.ecg_brut;
    t=[0:1/ecgfs:1/ecgfs*(length(ecg_brut)-1)];
    guidata(hObject, handles);
    plotECG
    
    handles.sigType='ECG';
else
    handles=handlesCopy;
end

guidata(hObject, handles);

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

if strcmp(handles.sigType, 'ECG')
    R_i=handles.R_i;
    detection_Q_S
    EDRfs=str2double(get(handles.EDRfs,'String'));
    [handles.RPA,handles.QRA,handles.RRI,handles.AQRS] = EDR_derived_ECG(handles);
    plotEDR_ECG
elseif strcmp(handles.sigType, 'PPG')
    EDRfs=str2double(get(handles.EDRfs,'String'));
    [handles.RPA,handles.QRA,handles.RRI] = EDR_derived_PPG(handles);
    plotEDR_PPG
end
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

EDRfs=str2double(get(handles.EDRfs,'String'));
win.duration=str2double(get(handles.winLength,'String'));
win.overlap=str2double(get(handles.overlap,'String'))/100;
win.points=win.duration*EDRfs;
win.step=win.points*(1-win.overlap);
win.N=fix((length(handles.RPA)-win.overlap*win.points)/win.step);
if isfield(handles,'RPA_filt')
    RPA=handles.RPA_filt;
    QRA=handles.QRA_filt;
    RRI=handles.RRI_filt;
    if strcmp(handles.sigType, 'ECG')
        AQRS=handles.AQRS_filt;
    end
else
    RPA=handles.RPA;
    QRA=handles.QRA;
    RRI=handles.RRI;
    if strcmp(handles.sigType, 'ECG')
        AQRS=handles.AQRS;
    end
end

switch get(handles.flagRQI,'Value')
    case 1
        fld='RQI_fft_';
        seuil=0.25;
    case 2 
        fld='RQI_autocorr_';
        seuil=0.25;   
    case 3 
        fld='RQI_sum_fft_autocorr_';
        seuil=0.5; 
    case 4 
        fld='RQI_NRMSE_';
        seuil=1; 
    case 5 
        fld='RQI_periodicite_';
    case 6 
        fld='RQI_FFT_autocorr_';      
end

warning off
calculateRQI
selectRQI
warning on
ttot_est=handles.ttot_sansfusion;
indx_lowqual=handles.indx_lowqual;
plotFR
guidata(hObject, handles);


% --- Executes on button press in FRfusion.
function FRfusion_Callback(hObject, eventdata, handles)
% hObject    handle to FRfusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'RPA_filt')
    RPA=handles.RPA_filt;
    QRA=handles.QRA_filt;
    RRI=handles.RRI_filt;
    if strcmp(handles.sigType, 'ECG')
        AQRS=handles.AQRS_filt;
    end
else
    RPA=handles.RPA;
    QRA=handles.QRA;
    RRI=handles.RRI;
    if strcmp(handles.sigType, 'ECG')
        AQRS=handles.AQRS;
    end
end

RPA=RPA-mean(RPA);
QRA=QRA-mean(QRA);
RRI=RRI-mean(RRI);
if strcmp(handles.sigType, 'ECG')
    AQRS=AQRS-mean(AQRS);
end

switch get(handles.flagRQI,'Value')
    case 1
        fld='RQI_fft_';
         seuil=0.25;
    case 2 
        fld='RQI_autocorr_';
         seuil=0.25;    
    case 3 
        fld='RQI_sum_fft_autocorr_';
         seuil=0.5; 
    case 4 
        fld='RQI_NRMSE_';
         seuil=1; 
    case 5 
        fld='RQI_periodicite_';
    case 6 
        fld='RQI_FFT_autocorr_'    
end

EDRfs=str2double(get(handles.EDRfs,'String'));
win.duration=str2double(get(handles.winLength,'String'));
win.overlap=str2double(get(handles.overlap,'String'))/100;
win.points=win.duration*EDRfs;
win.step=win.points*(1-win.overlap);
win.N=fix((length(RPA)-win.overlap*win.points)/win.step);
nbChannels=get(handles.nbChannels,'Value');
warning off
calculateRQI
fusionRQI
warning on

ttot_est=handles.ttot_fusion;
indx_lowqual=handles.indx_lowqual;
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
if strcmp(handles.sigType, 'ECG')
    plotECG
elseif strcmp(handles.sigType, 'PPG')
    plotPPG
end


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
fMin=str2double(get(handles.fMinEDR,'String'));
fMax=str2double(get(handles.fMaxEDR,'String'));
ordre=str2double(get(handles.ordreEDR,'String'));
EDRfs=str2double(get(handles.EDRfs,'String'));
wp2 = fMin/(EDRfs/2);
ws2 = fMax/(EDRfs/2);
wn = [wp2 ws2];
[A,B] = butter(ordre,wn);
handles.RPA_filt = filtfilt(A,B,double(handles.RPA));
handles.QRA_filt = filtfilt(A,B,double(handles.QRA));
handles.RRI_filt = filtfilt(A,B,double(handles.RRI));
if strcmp(handles.sigType, 'ECG')
    handles.AQRS_filt = filtfilt(A,B,double(handles.AQRS));
end
if isfield(handles,'bw_brut')
    bwfs=str2double(get(handles.bwfs,'String'));
    wp2 = fMin/(bwfs/2);
    ws2 = fMax/(bwfs/2);
    wn = [wp2 ws2];
    [A,B] = butter(ordre,wn);
    handles.bw_filt = filtfilt(A,B,double(handles.bw_brut));
end
if strcmp(handles.sigType, 'ECG')
    plotEDR_ECG
elseif strcmp(handles.sigType, 'PPG')
    plotEDR_PPG
end




function ecgfs_Callback(hObject, eventdata, handles)
% hObject    handle to ecgfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ecgfs as text
if isempty(str2num(get(hObject,'String')))
    set(hObject,'string','1');
    warndlg('Input must be numerical');
end
if strcmp(handles.sigType, 'ECG')
    plotECG
elseif strcmp(handles.sigType, 'PPG')
    plotPPG
end
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

if strcmp(handles.sigType, 'ECG')
   plotEDR_ECG
elseif strcmp(handles.sigType, 'PPG')
    plotEDR_PPG
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
EDRfs=str2double(get(handles.EDRfs,'String'));
win.duration=str2double(get(handles.winLength,'String'));
win.overlap=str2double(get(handles.overlap,'String'))/100;
win.points=win.duration*EDRfs;
win.step=win.points*(1-win.overlap);
win.N=fix((length(handles.RPA)-win.overlap*win.points)/win.step);

if isfield(handles,'RPA_filt')
    RPA=handles.RPA_filt;
    QRA=handles.QRA_filt;
    RRI=handles.RRI_filt;
    if strcmp(handles.sigType, 'ECG')
        AQRS=handles.AQRS_filt;
    end
else
    RPA=handles.RPA;
    QRA=handles.QRA;
    RRI=handles.RRI;
    if strcmp(handles.sigType, 'ECG')
        AQRS=handles.AQRS;
    end
end
RPA=RPA-mean(RPA);
QRA=QRA-mean(QRA);
RRI=RRI-mean(RRI);
if strcmp(handles.sigType, 'ECG')
    AQRS=AQRS-mean(AQRS);
end
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
if strcmp(handles.sigType, 'ECG')
    plotEDR_ECG
elseif strcmp(handles.sigType, 'PPG')
    plotEDR_PPG
end

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
handles=rmfield2(handles,'ttot_fusion','ttot_sansfusion');
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
handles=rmfield2(handles,'ttot_fusion','ttot_sansfusion');
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
if strcmp(handles.sigType, 'ECG')
    plotECG
elseif strcmp(handles.sigType, 'PPG')
    plotPPG
end
    

% --- Executes on button press in plotRQI.
function plotRQI_Callback(hObject, eventdata, handles)
% hObject    handle to plotRQI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotRQI
if get(hObject,'Value')==1
    set(handles.plotRef,'Value',0)
end
if strcmp(handles.sigType, 'ECG')
    plotEDR_ECG
elseif strcmp(handles.sigType, 'PPG')
    plotEDR_PPG
end


    

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

linkaxes(findall(0,'type','axes'),'x');
handlesCopy=handles;
handles=rmfield2(handles,'RPA','RRI','AQRS','QRA','RPA_filt','RRI_filt',...
    'AQRS_filt','QRA_filt','indx_RQI','bw_brut','bw_filt',...
    'ecg_filt','Q_i','S_i','ttot_sansfusion','ttot_t','R_i',...
    'ttot_fusion');
loadPPG
if file ~= 0
    % Remise a zero des tracés
    clear handlesCopy
    arrayfun(@reset,(findall(0,'type','axes')));
    arrayfun(@cla,(findall(0,'type','axes')));
    axesToDel=findall(0,'type','axes');
    axesToDel=axesToDel(find(axesToDel~=handles.RPAaxes & ...
        axesToDel~=handles.QRAaxes & axesToDel~=handles.AQRSaxes & ...
        axesToDel~=handles.RRIaxes & axesToDel~=handles.ecgAxes & ...
        axesToDel~=handles.RespAxes));
    delete(axesToDel);
    set(handles.plotRQI,'Value',0);
    set(handles.plotRef,'Value',0);
    set(handles.plot_tQRS,'Value',0);
%     plotRQI_Callback(handles.plotRQI, eventdata, handles);
%     plotRef_Callback(handles.plotRQI, eventdata, handles);
%     plot_tQRS_Callback(handles.plotRQI, eventdata, handles);
    handles.ECGpath = path;
    handles.ECGfile = file;
    
    % Changement des noms ECG->PPG
    set(handles.textFecg,'String', 'PPG fs :');
    set(handles.text4,'String', 'PPG filtering (Butterworth) :');
    set(handles.filtreECG,'String', 'Filter PPG');
    set(handles.plot_tQRS,'Visible', 'off');
    set(handles.EDR_1,'String', 'RIAV');
    set(handles.EDR_4,'String', 'RIIV');
    set(handles.EDR_2,'String', 'RIFV');
    set(handles.EDR_3,'Value', 0);
    set(handles.EDR_3,'Visible', 'off');
    set(handles.AQRSaxes,'Visible', 'off');
    
    % Tracé
    ecgfs=str2double(get(handles.ecgfs,'String'));
    ecg_brut=handles.ecg_brut;
    t=[0:1/ecgfs:1/ecgfs*(length(ecg_brut)-1)];
    guidata(hObject, handles);
    plotPPG
    
    handles.sigType='PPG';
else
    handles=handlesCopy;
end

guidata(hObject, handles);

% --- Executes on button press in plotRef.
function plotRef_Callback(hObject, eventdata, handles)
% hObject    handle to plotRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotRef
if get(hObject,'Value')==1
    set(handles.plotRQI,'Value',0)
end
if strcmp(handles.sigType, 'ECG')
    plotEDR_ECG
elseif strcmp(handles.sigType, 'PPG')
    plotEDR_PPG
end

% --- Executes on button press in visuError.
function visuError_Callback(hObject, eventdata, handles)
% hObject    handle to visuError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'bw_filt')
    EDRfs=str2double(get(handles.EDRfs,'String'));
    win.duration=str2double(get(handles.winLength,'String'));
    win.overlap=str2double(get(handles.overlap,'String'))/100;
    win.points=win.duration*EDRfs;
    win.step=win.points*(1-win.overlap);
    win.N=fix((length(handles.RPA)-win.overlap*win.points)/win.step);
    if strcmp(handles.sigType, 'ECG')
        seuilCD=0.5;
    else
        seuilCD=0.5;
    end
    if isfield(handles,'RPA_filt')
        RPA=handles.RPA_filt;
        QRA=handles.QRA_filt;
        RRI=handles.RRI_filt;
        if strcmp(handles.sigType, 'ECG')
            AQRS=handles.AQRS_filt;
        end
    else
        RPA=handles.RPA;
        QRA=handles.QRA;
        RRI=handles.RRI;
        if strcmp(handles.sigType, 'ECG')
            AQRS=handles.AQRS;
        end
    end
    RPA=RPA-mean(RPA);
    QRA=QRA-mean(QRA);
    RRI=RRI-mean(RRI);
    
    [mntab_RPA,mxtab_RPA]=cycledet_filt(RPA,seuilCD,EDRfs); 
    [mntab_QRA,mxtab_QRA]=cycledet_filt(QRA,seuilCD,EDRfs);  
    [mntab_RRI,mxtab_RRI]=cycledet_filt(RRI,seuilCD,EDRfs);
    
    mxtab_RPA = mxtab_RPA(2:end,:);
    mxtab_QRA = mxtab_QRA(2:end,:);
    mxtab_RRI = mxtab_RRI(2:end,:);
    
    [ttot_RPA,x_RPA] = calcul_ttot(mxtab_RPA,EDRfs,1,win);
    [ttot_QRA,x_QRA] = calcul_ttot(mxtab_QRA,EDRfs,1,win);
    [ttot_RRI,x_RRI] = calcul_ttot(mxtab_RRI,EDRfs,1,win);
    
    if strcmp(handles.sigType, 'ECG')
        AQRS=AQRS-mean(AQRS);
        [mntab_AQRS,mxtab_AQRS]=cycledet_filt(AQRS,seuilCD,EDRfs);
        mxtab_AQRS = mxtab_AQRS(2:end,:);
        [ttot_AQRS,x_AQRS] = calcul_ttot(mxtab_AQRS,EDRfs,1,win);
    end
    
    bwfs=str2double(get(handles.bwfs,'String'));
    bw_filt=handles.bw_filt;
    win.duration=str2double(get(handles.winLength,'String'));
    win.overlap=str2double(get(handles.overlap,'String'))/100;
    win.points=win.duration*bwfs;
    win.step=win.points*(1-win.overlap);
    win.N=fix((length(handles.bw_filt)-win.overlap*win.points)/win.step);
    [mntab_respi,mxtab_respi]=cycledet_filt(bw_filt,seuilCD,bwfs);
    [ttot_ref, ttot_t] = calcul_ttot(mntab_respi,bwfs,1,win);
    
    if isfield(handles,'ttot_sansfusion')
        ttot_sansfusion=handles.ttot_sansfusion;
    else
        ttot_sansfusion=nan(1,length(ttot_ref));
    end
    if isfield(handles,'ttot_fusion')
        ttot_fusion=handles.ttot_fusion;
    else
        ttot_fusion=nan(1,length(ttot_ref));
    end
    [RMSE_RPA,MAE_RPA] = calcul_erreur(ttot_ref,ttot_RPA);
    [RMSE_QRA,MAE_QRA] = calcul_erreur(ttot_ref,ttot_QRA);
    [RMSE_RRI,MAE_RRI] = calcul_erreur(ttot_ref,ttot_RRI);
    if strcmp(handles.sigType, 'ECG')
        [RMSE_AQRS,MAE_AQRS] = calcul_erreur(ttot_ref,ttot_AQRS);
    else
        RMSE_AQRS=[];
        MAE_AQRS=[];
    end
    [RMSE_sansfusion,MAE_sansfusion] = calcul_erreur(ttot_ref,ttot_sansfusion);
    [RMSE_fusion,MAE_fusion] = calcul_erreur(ttot_ref,ttot_fusion);
    figure('name','Erreur Absolue')
    C = [MAE_RPA MAE_RRI MAE_QRA MAE_AQRS MAE_sansfusion MAE_fusion];
    if strcmp(handles.sigType, 'ECG')
        grp = [repmat("RPA",1,length(MAE_RPA)),repmat("RRI",1,length(MAE_RRI)), ...
            repmat("QRA",1,length(MAE_QRA)),repmat("AQRS",1,length(MAE_AQRS)),...
            repmat("no fusion",1,length(MAE_sansfusion)),repmat("fusion",1,length(MAE_fusion))];
    elseif strcmp(handles.sigType, 'PPG')
        grp = [repmat("RIAV",1,length(MAE_RPA)),repmat("RIFV",1,length(MAE_RRI)), ...
            repmat("RIIV",1,length(MAE_QRA)),repmat("AQRS",1,length(MAE_AQRS)),...
            repmat("no fusion",1,length(MAE_sansfusion)),repmat("fusion",1,length(MAE_fusion))];
    end
    positions = [1 2 3 4 5 6];
    set(gcf,'Color','white')
    boxplot(C',grp')
    set(gca,'xtick',[mean(positions(1)) mean(positions(2)) mean(positions(3)) mean(positions(4)) mean(positions(5)) mean(positions(6))])
    ylabel('absolute error [bpm]','fontsize',25)
    % figure('name','hist')
    % hist(err)
    
    handles.ttot_ref=ttot_ref;
    handles.ttot_RPA=ttot_RPA;
    handles.ttot_QRA=ttot_QRA;
    handles.ttot_RRI=ttot_RRI;
    if strcmp(handles.sigType, 'ECG')
        handles.ttot_AQRS=ttot_AQRS;
    end
    guidata(hObject, handles);
end



function EDRfs_Callback(hObject, eventdata, handles)
% hObject    handle to EDRfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDRfs as text
%        str2double(get(hObject,'String')) returns contents of EDRfs as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'string','10');
    warndlg('Input must be numerical');
end
if isfield(handles,'RPA')
    if strcmp(handles.sigType, 'ECG')
        [ handles.RPA,handles.QRA,handles.RRI,handles.AQRS] = ...
                                                EDR_derived_ECG(handles);
        RPA=handles.RPA;
        QRA=handles.QRA;
        RRI=handles.RRI;
        AQRS=handles.AQRS;
        if isfield(handles,'RPA_filt')
            filtreEDR_Callback(hObject, eventdata, handles)
        else
            plotEDR_ECG
        end
    elseif strcmp(handles.sigType, 'PPG')
        [handles.RPA,handles.QRA,handles.RRI] = EDR_derived_PPG(handles);
        RPA=handles.RPA;
        QRA=handles.QRA;
        RRI=handles.RRI;
        if isfield(handles,'RPA_filt')
            filtreEDR_Callback(hObject, eventdata, handles)
        else
            plotEDR_PPG
        end
    end
end

% --- Executes during object creation, after setting all properties.
function EDRfs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDRfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run("Help.m")


% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveMat_Callback(hObject, eventdata, handles)
% hObject    handle to saveMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathsave] = uiputfile('.mat', 'Save Workspace as');

guidata(hObject, handles);

if strcmp(handles.sigType, 'ECG')
    ecg_raw=handles.ecg_brut;
    ecgfs=str2double(get(handles.ecgfs,'String'));
    save([pathsave filename],'ecg_raw','ecgfs');
    if isfield(handles,'ecg_filt')
        ecg_filt=handles.ecg_filt;
        save([pathsave filename],'ecg_filt','-append');
    end
    R_i=handles.R_i;
    save([pathsave filename],'R_i','-append');
    if isfield(handles,'S_i')
        S_i=handles.S_i;
        Q_i=handles.Q_i;
        save([pathsave filename],'S_i','Q_i','-append');
    end
    isFiltre=0;
    if isfield(handles,'RPA_filt')
        EDR_RPA=handles.RPA_filt;
        EDR_QRA=handles.QRA_filt;
        EDR_RRI=handles.RRI_filt;
        EDR_AQRS=handles.AQRS_filt;
        save([pathsave filename],'EDR_RPA','EDR_QRA','EDR_RRI','EDR_AQRS',...
                                                                '-append');
        isFiltre=1;
    elseif isfield(handles,'RPA')
        EDR_RPA=handles.RPA;
        EDR_QRA=handles.QRA;
        EDR_RRI=handles.RRI;
        EDR_AQRS=handles.AQRS;
        save([pathsave filename],'EDR_RPA','EDR_QRA','EDR_RRI','EDR_AQRS',...
                                                                '-append');
    end
    if isfield(handles,'indx_RQI')
        RQI_RPA=handles.indx_RQI(1,:);
        RQI_QRA=handles.indx_RQI(4,:);
        RQI_RRI=handles.indx_RQI(3,:);
        RQI_AQRS=handles.indx_RQI(2,:);
        save([pathsave filename],'RQI_RPA','RQI_QRA','RQI_RRI','RQI_AQRS',...
                                                                '-append');
    end
    edrfs=str2double(get(handles.EDRfs,'String'));
    save([pathsave filename],'edrfs','-append');
    if isFiltre==1 
        param.filter.flow=str2double(get(handles.fMinEDR,'String'));
        param.filter.fhigh=str2double(get(handles.fMaxEDR,'String'));
        param.filter.order=str2double(get(handles.ordreEDR,'String'));
    end
    param.win.duration=str2double(get(handles.winLength,'String'));
    param.win.overlap=str2double(get(handles.overlap,'String'));
    idx = get(handles.flagRQI,'Value');
    items = get(handles.flagRQI,'String');
    param.RQI=items{idx};
    param.selectedEDR={'RPA','QRA','RRI','AQRS'};
    if get(handles.EDR_3,'Value')==0
        param.selectedEDR(4)=[];
    end
    if get(handles.EDR_2,'Value')==0
        param.selectedEDR(3)=[];
    end
    if get(handles.EDR_4,'Value')==0
        param.selectedEDR(2)=[];
    end
    if get(handles.EDR_1,'Value')==0
        param.selectedEDR(1)=[];
    end
    param.nbChannels=get(handles.nbChannels,'Value')+1;
    save([pathsave filename],'param','-append');
    if isfield(handles,'bw_brut')
        bw_raw=handles.bw_brut;
        bwfs=str2double(get(handles.bwfs,'String'));
        save([pathsave filename],'bw_raw','bwfs','-append');
    elseif isfield(handles,'bw_filt')
        bw_filt=handles.bw_brut;
        bwfs=str2double(get(handles.bwfs,'String'));
        save([pathsave filename],'bw_filt','bwfs','-append');
    end
    if isfield(handles,'ttot_t')
        ttot_time=handles.ttot_t;
        save([pathsave filename],'ttot_time','-append');
    end
    if isfield(handles,'ttot_sansfusion')
        ttot_nofusion=handles.ttot_sansfusion;
        save([pathsave filename],'ttot_nofusion','-append');
    end
    if isfield(handles,'ttot_fusion')
        ttot_fusion=handles.ttot_fusion;
        save([pathsave filename],'ttot_fusion','-append');
    end
    if isfield(handles,'ttot_ref')
        ttot_ref=handles.ttot_ref;
        save([pathsave filename],'ttot_ref','-append');
    end
    if isfield(handles,'ttot_QRA')
        ttot_QRA=handles.ttot_QRA;
        ttot_RPA=handles.ttot_RPA;
        ttot_RRI=handles.ttot_RRI;
        ttot_AQRS=handles.ttot_AQRS;
        save([pathsave filename],'ttot_RPA','ttot_QRA','ttot_RRI',...
                                                'ttot_AQRS','-append');
    end
elseif strcmp(handles.sigType, 'PPG')
    ppg_raw=handles.ecg_brut;
    ppgfs=str2double(get(handles.ecgfs,'String'));
    save([pathsave filename],'ppg_raw','ppgfs');
    if isfield(handles,'ecg_filt')
        ppg_filt=handles.ecg_filt;
        save([pathsave filename],'ppg_filt','-append');
    end
    peaks=handles.R_i;
    save([pathsave filename],'peaks','-append');
    isFiltre=0;
    if isfield(handles,'RPA_filt')
        EDR_RIAV=handles.RPA_filt;
        EDR_RIIV=handles.QRA_filt;
        EDR_RIFV=handles.RRI_filt;
        save([pathsave filename],'EDR_RIAV','EDR_RIIV','EDR_RIFV','-append');
        isFiltre=1;
    elseif isfield(handles,'RPA')
        EDR_RIAV=handles.RPA;
        EDR_RIIV=handles.QRA;
        EDR_RIFV=handles.RRI;
        save([pathsave filename],'EDR_RIAV','EDR_RIIV','EDR_RIFV','-append');
    end
    if isfield(handles,'indx_RQI')
        RQI_RIAV=handles.indx_RQI(1,:);
        RQI_RIIV=handles.indx_RQI(3,:);
        RQI_RIFV=handles.indx_RQI(2,:);
        save([pathsave filename],'RQI_RIAV','RQI_RIIV','RQI_RIFV','-append');
    end
    edrfs=str2double(get(handles.EDRfs,'String'));
    save([pathsave filename],'edrfs','-append');
    if isFiltre==1 
        param.filter.flow=str2double(get(handles.fMinEDR,'String'));
        param.filter.fhigh=str2double(get(handles.fMaxEDR,'String'));
        param.filter.order=str2double(get(handles.ordreEDR,'String'));
    end
    param.win.duration=str2double(get(handles.winLength,'String'));
    param.win.overlap=str2double(get(handles.overlap,'String'));
    idx = get(handles.flagRQI,'Value');
    items = get(handles.flagRQI,'String');
    param.RQI=items{idx};
    param.selectedEDR={'RIAV','RIIV','RIFV'};
    if get(handles.EDR_2,'Value')==0
        param.selectedEDR(3)=[];
    end
    if get(handles.EDR_4,'Value')==0
        param.selectedEDR(2)=[];
    end
    if get(handles.EDR_1,'Value')==0
        param.selectedEDR(1)=[];
    end
    param.nbChannels=get(handles.nbChannels,'Value')+1;
    save([pathsave filename],'param','-append');
    if isfield(handles,'bw_brut')
        bw_raw=handles.bw_brut;
        bwfs=str2double(get(handles.bwfs,'String'));
        save([pathsave filename],'bw_raw','bwfs','-append');
    elseif isfield(handles,'bw_filt')
        bw_filt=handles.bw_brut;
        bwfs=str2double(get(handles.bwfs,'String'));
        save([pathsave filename],'bw_filt','bwfs','-append');
    end
    if isfield(handles,'ttot_t')
        ttot_time=handles.ttot_t;
        save([pathsave filename],'ttot_time','-append');
    end
    if isfield(handles,'ttot_sansfusion')
        ttot_nofusion=handles.ttot_sansfusion;
        save([pathsave filename],'ttot_nofusion','-append');
    end
    if isfield(handles,'ttot_fusion')
        ttot_fusion=handles.ttot_fusion;
        save([pathsave filename],'ttot_fusion','-append');
    end
    if isfield(handles,'ttot_ref')
        ttot_ref=handles.ttot_ref;
        save([pathsave filename],'ttot_ref','-append');
    end
    if isfield(handles,'ttot_QRA')
        ttot_RIIV=handles.ttot_QRA;
        ttot_RIAV=handles.ttot_RPA;
        ttot_RIFV=handles.ttot_RRI;
        save([pathsave filename],'ttot_RIAV','ttot_RIIV','ttot_RIFV','-append');
    end
end

% --------------------------------------------------------------------
function saveCSV_Callback(hObject, eventdata, handles)
% hObject    handle to saveCSV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in nbChannels.
function nbChannels_Callback(hObject, eventdata, handles)
% hObject    handle to nbChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nbChannels contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nbChannels


% --- Executes during object creation, after setting all properties.
function nbChannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
