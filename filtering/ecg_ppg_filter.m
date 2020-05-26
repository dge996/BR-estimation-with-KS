function [handles] = ecg_ppg_filter(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

ecg_brut=handles.ecg_brut;
ecgfs=str2double(get(handles.ecgfs,'String'));
fMin=str2double(get(handles.fMinECG,'String'));
fMax=str2double(get(handles.fMaxECG,'String'));
ordre=str2double(get(handles.ordreECG,'String'));
handles.ecg_filt = butterfilt(ecg_brut,ecgfs,fMin,fMax,ordre);
if strcmp(handles.sigType, 'ECG')
    [handles] = plot_ecg(handles);
elseif strcmp(handles.sigType, 'PPG')
    [handles] = plot_ppg(handles);
end

end

