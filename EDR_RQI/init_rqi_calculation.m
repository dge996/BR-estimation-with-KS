function [RPA,QRA,RRI,AQRS,EDRfs,win,fld,seuil] = init_rqi_calculation(handles)
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here

AQRS=[];

if isfield(handles,'RPA_filt')
    RPA=handles.RPA_filt;
    QRA=handles.QRA_filt;
    RRI=handles.RRI_filt;
    if strcmp(handles.sigType, 'ECG')
        AQRS=handles.AQRS_filt;
    end
else
    RPA=handles.RPA-mean(handles.RPA);
    QRA=handles.QRA-mean(handles.QRA);
    RRI=handles.RRI-mean(handles.RRI);
    if strcmp(handles.sigType, 'ECG')
        AQRS=handles.AQRS-mean(handles.AQRS);
    end
end

EDRfs=str2double(get(handles.EDRfs,'String'));
win.duration=str2double(get(handles.winLength,'String'));
win.overlap=str2double(get(handles.overlap,'String'))/100;
win.points=win.duration*EDRfs;
win.step=win.points*(1-win.overlap);
win.N=fix((length(handles.RPA)-win.overlap*win.points)/win.step);
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
        seuil=0.1;
    case 5
        fld='RQI_periodicite_';
        seuil=0;
    case 6
        fld='RQI_FFT_autocorr_';
        seuil=0.25;
end

end

