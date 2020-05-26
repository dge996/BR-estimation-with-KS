function [handles] = load_capno(handles, path, file, sigtype)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

title='CapnoBase file';
if strcmpi(sigtype,'ecg')
    message='CapnoBase file recognized. ECG sample frequency, ECG peaks and reference respiratory signal loaded';
    uiwait(msgbox(message,title,'modal'));
    load([path file],'param');
    set(handles.ecgfs,'String',string(param.samplingrate.ecg))
    set(handles.bwfs,'String',string(param.samplingrate.co2))
    load([path file],'labels');
    handles.R_i=labels.ecg.peak.x;
    load([path file],'signal');
    handles.bw_brut=signal.co2.y;
elseif strcmpi(sigtype,'ppg')
    message='CapnoBase file recognized. PPG sample frequency and reference respiratory signal loaded';
    uiwait(msgbox(message,title,'modal'));
    load([path file],'param');
    set(handles.ecgfs,'String',string(param.samplingrate.pleth))
    set(handles.bwfs,'String',string(param.samplingrate.co2))
    load([path file],'labels');
    handles.R_i=labels.pleth.peak.x;
    load([path file],'signal');
    handles.bw_brut=signal.co2.y;
else
    error('wrong sigtype, must be ecg or ppg')
end

end

