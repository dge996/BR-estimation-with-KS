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

% Last Modified by GUIDE v2.5 23-May-2020 10:54:04

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

%% Fonctions relatives au fonctionnement du menu "More"
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
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run("Help.m")

%% Fonctions relatives au fonctionnement du menu "Open" et au chargement des différents signaux
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
[handles,handlesCopy] = init_handles_and_axes(handles);
guidata(hObject, handles);
[handles, file, path] = load_sig(handles,'ECG');
if file ~= 0
    clear handlesCopy
    [handles, hObject]=init_ecg(handles,hObject,path,file);
else
    handles=handlesCopy;
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function PPG_Callback(hObject, eventdata, handles)
% hObject    handle to PPG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles,handlesCopy] = init_handles_and_axes(handles);
[handles, file, path] = load_sig(handles,'PPG');
if file ~= 0
    clear handlesCopy
    [handles, hObject]=init_ppg(handles,hObject,path,file);
else
    handles=handlesCopy;
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function resp_Callback(hObject, eventdata, handles)
% hObject    handle to resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, path, file] = load_ref(handles);
if file ~= 0
    [handles, hObject]=init_resp(handles,hObject,path,file);
end

guidata(hObject, handles);

%% Fonctions relatives à l'affichage et au filtrage de l'ECG ou du PPG
% % --------------------------------------------------------------------
% function tQRS_Callback(hObject, eventdata, handles)
% % hObject    handle to tQRS (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in plot_tQRS.
function plot_tQRS_Callback(hObject, eventdata, handles)
% hObject    handle to plot_tQRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_tQRS
if strcmp(handles.sigType, 'ECG')
    [handles] = plot_ecg(handles);
elseif strcmp(handles.sigType, 'PPG')
    [handles] = plot_ppg(handles);
end

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
[handles] = ecg_ppg_filter(handles);
guidata(hObject, handles);

%% Fonctions relatives au calcul et filtrage des EDR
% --- Executes on button press in calculEDR.
function calculEDR_Callback(hObject, eventdata, handles)
% hObject    handle to calculEDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=rmfield2(handles,'RPA','RRI','AQRS','QRA','RPA_filt','RRI_filt',...
    'AQRS_filt','QRA_filt','indx_RQI','plot_RQI');

if strcmp(handles.sigType, 'ECG')
    [handles] = detect_Q_S(handles);
    [handles] = EDR_derived_ECG(handles);
    [handles, hObject] = plot_edr_ecg(handles,hObject);
elseif strcmp(handles.sigType, 'PPG')
    [handles] = EDR_derived_PPG(handles);
    [handles, hObject] = plot_edr_ppg(handles,hObject);
end
guidata(hObject, handles);

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
[handles, hObject] = edr_filter(handles, hObject);
guidata(hObject, handles);

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
    [handles, hObject] = plot_edr_ecg(handles,hObject);
elseif strcmp(handles.sigType, 'PPG')
    [handles, hObject] = plot_edr_ppg(handles,hObject);
end

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
    [handles, hObject] = plot_edr_ecg(handles,hObject);
elseif strcmp(handles.sigType, 'PPG')
    [handles, hObject] = plot_edr_ppg(handles,hObject);
end

%% Options pour l'estimation de la freq respiratoire
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

% --- Executes on selection change in flagRQI.
function flagRQI_Callback(hObject, eventdata, handles)
% hObject    handle to flagRQI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns flagRQI contents as cell array
%        contents{get(hObject,'Value')} returns selected item from flagRQI
warning off
[handles.indx_RQI,handles.ttot_t] = calculate_rqi(handles);
warning on
if strcmp(handles.sigType, 'ECG')
    [handles, hObject] = plot_edr_ecg(handles,hObject);
elseif strcmp(handles.sigType, 'PPG')
    [handles, hObject] = plot_edr_ppg(handles,hObject);
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

% --- Executes on button press in FRnoFusion.
function FRnoFusion_Callback(hObject, eventdata, handles)
% hObject    handle to FRnoFusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'RPA')
    if strcmp(handles.sigType, 'ECG')
        if ~isfield(handles,'Q_i')
            [handles] = detect_Q_S(handles);
        end
        [handles] = EDR_derived_ECG(handles);
    elseif strcmp(handles.sigType, 'PPG')
        [handles] = EDR_derived_PPG(handles);
    end
end
warning off
[handles.indx_RQI,handles.ttot_t, indx_erreur,all_EDR_noWin] = calculate_rqi(handles);
warning on
[EDRfs,win,fld,indx_RQI,indx_erreur,all_EDR_noWin,seuilCD,seuil] = init_select_fusion(handles,all_EDR_noWin,indx_erreur);
[handles.ttot_sansfusion,handles.indx_lowqual] = select_rqi(indx_RQI,all_EDR_noWin,indx_erreur,EDRfs,win,fld,seuilCD);
%[handles.ttot_sansfusion,handles.indx_lowqual] = select_rqi(indx_RQI,all_EDR_noWin,indx_erreur,EDRfs,win,fld,seuilCD,seuil);

ttot_est=handles.ttot_sansfusion;
indx_lowqual=handles.indx_lowqual;
ttot_t=handles.ttot_t;
[handles] = plot_br(handles,ttot_est,ttot_t,indx_lowqual);

guidata(hObject, handles);

% --- Executes on button press in FRfusion.
function FRfusion_Callback(hObject, eventdata, handles)
% hObject    handle to FRfusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'RPA')
    if strcmp(handles.sigType, 'ECG')
        if ~isfield(handles,'Q_i')
            [handles] = detect_Q_S(handles);
        end
        [handles] = EDR_derived_ECG(handles);
    elseif strcmp(handles.sigType, 'PPG')
        [handles] = EDR_derived_PPG(handles);
    end
end

nbChannels=get(handles.nbChannels,'Value');
if isfield(handles,'RPA_filt')
    fRange=[str2double(get(handles.fMinEDR,'String')) ...
        str2double(get(handles.fMaxEDR,'String'))];
else
    fRange=[0.1 1];
end
warning off
[handles.indx_RQI,handles.ttot_t, indx_erreur,all_EDR_noWin] = calculate_rqi(handles);
warning on
[EDRfs,win,fld,indx_RQI,indx_erreur,all_EDR_noWin,seuilCD,seuil] = init_select_fusion(handles,all_EDR_noWin,indx_erreur);
[handles.ttot_fusion,handles.indx_lowqual] = fusion_rqi(indx_RQI,all_EDR_noWin,EDRfs,win,fld,seuilCD,fRange,nbChannels);
%[handles.ttot_fusion,handles.indx_lowqual] = fusion_rqi(indx_RQI,all_EDR_noWin,EDRfs,win,fld,seuilCD,fRange,nbChannels,seuil);

ttot_est=handles.ttot_fusion;
indx_lowqual=handles.indx_lowqual;
ttot_t=handles.ttot_t;
[handles] = plot_br(handles,ttot_est,ttot_t,indx_lowqual);
guidata(hObject, handles);

% --- Executes on button press in visuError.
function visuError_Callback(hObject, eventdata, handles)
% hObject    handle to visuError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

visu_error(handles)
guidata(hObject, handles);

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
    [handles] = plot_ecg(handles);
elseif strcmp(handles.sigType, 'PPG')
    [handles] = plot_ppg(handles);
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
if strcmp(handles.sigType, 'ECG')
    [handles, hObject] = plot_edr_ecgg(handles,hObject);
elseif strcmp(handles.sigType, 'PPG')
    [handles, hObject] = plot_edr_ppg(handles,hObject);
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
        [handles] = EDR_derived_ECG(handles);
        if isfield(handles,'RPA_filt')
            filtreEDR_Callback(hObject, eventdata, handles)
        else
            [handles, hObject] = plot_edr_ecg(handles,hObject);
        end
    elseif strcmp(handles.sigType, 'PPG')
        [handles] = EDR_derived_PPG(handles);
        if isfield(handles,'RPA_filt')
            filtreEDR_Callback(hObject, eventdata, handles)
        else
            [handles, hObject] = plot_edr_ppg(handles,hObject);
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
    save_ecg(handles, pathsave, filename);
elseif strcmp(handles.sigType, 'PPG')
    save_ppg(handles, pathsave, filename);
end

% --------------------------------------------------------------------
function saveCSV_Callback(hObject, eventdata, handles)
% hObject    handle to saveCSV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

