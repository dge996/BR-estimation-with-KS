function [handles, hObject] = edr_filter(handles, hObject)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

fMin=str2double(get(handles.fMinEDR,'String'));
fMax=str2double(get(handles.fMaxEDR,'String'));
ordre=str2double(get(handles.ordreEDR,'String'));
EDRfs=str2double(get(handles.EDRfs,'String'));
[handles.RPA_filt] = butterfilt(double(handles.RPA),EDRfs,fMin,fMax,ordre);
[handles.QRA_filt] = butterfilt(double(handles.QRA),EDRfs,fMin,fMax,ordre);
[handles.RRI_filt] = butterfilt(double(handles.RRI),EDRfs,fMin,fMax,ordre);
if strcmp(handles.sigType, 'ECG')
    [handles.AQRS_filt] = butterfilt(double(handles.AQRS),EDRfs,fMin,fMax,ordre);
end
if isfield(handles,'bw_brut')
    bwfs=str2double(get(handles.bwfs,'String'));
    handles.bw_filt = butterfilt(double(handles.bw_brut),bwfs,fMin,fMax,ordre);
end
if strcmp(handles.sigType, 'ECG')
    [handles, hObject] = plot_edr_ecg(handles,hObject);
elseif strcmp(handles.sigType, 'PPG')
    [handles, hObject] = plot_edr_ppg(handles,hObject);
end

end

