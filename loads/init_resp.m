function [handles, hObject]=init_resp(handles,hObject,path,file)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

set(handles.plotRef,'Value',1);
set(handles.plotRQI,'Value',0);
handles=rmfield2(handles,'bw_filt');

handles.BWpath = path;
handles.BWfile = file;

%filtre
bwfs=str2double(get(handles.bwfs,'String'));
fMin=str2double(get(handles.fMinEDR,'String'));
fMax=str2double(get(handles.fMaxEDR,'String'));
ordre=str2double(get(handles.ordreEDR,'String'));
handles.bw_filt = butterfilt(double(handles.bw_brut),bwfs,fMin,fMax,ordre);
guidata(hObject, handles);

bwfs=str2double(get(handles.bwfs,'String'));
if strcmp(handles.sigType, 'ECG')
    [handles, hObject] = plot_edr_ecg(handles,hObject);
elseif strcmp(handles.sigType, 'PPG')
    [handles, hObject] = plot_edr_ppg(handles,hObject);
end
guidata(hObject, handles);

end

