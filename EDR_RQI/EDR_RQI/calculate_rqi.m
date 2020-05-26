function [indx_RQI, ttot_t, indx_erreur,all_EDR_noWin] = calculate_rqi(handles)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here

[RPA,QRA,RRI,AQRS,EDRfs,win,fld] = init_rqi_calculation(handles);

if isfield(handles,'RPA_filt')
    fRange=[str2double(get(handles.fMinEDR,'String')) ...
        str2double(get(handles.fMaxEDR,'String'))];
else
    fRange=[0.1 1];
end

indx_RQI =[];
indx_erreur=[];
all_EDR_noWin=[];

[res.RQI_fft_RPA, res.RQI_autocorr_RPA, res.RQI_periodicite_RPA,...
    res.RQI_NRMSE_RPA, res.RQI_FFT_autocorr_RPA, erreur_RPA] = ...
    indice_RQI_overlap(RPA,EDRfs,win,fRange);
res.RQI_sum_fft_autocorr_RPA=res.RQI_fft_RPA+res.RQI_autocorr_RPA;
indx_RQI=[indx_RQI ; getfield(res,[fld 'RPA'])];
indx_erreur=[indx_erreur; erreur_RPA] ;
all_EDR_noWin=[all_EDR_noWin; RPA];

if strcmp(handles.sigType, 'ECG')
    [res.RQI_fft_AQRS, res.RQI_autocorr_AQRS, res.RQI_periodicite_AQRS,...
        res.RQI_NRMSE_AQRS, res.RQI_FFT_autocorr_AQRS, erreur_AQRS] = ...
        indice_RQI_overlap(AQRS,EDRfs,win,fRange);
    res.RQI_sum_fft_autocorr_AQRS=res.RQI_fft_AQRS+res.RQI_autocorr_AQRS;
    indx_RQI=[indx_RQI ; getfield(res,[fld 'AQRS'])];
    indx_erreur  =[indx_erreur; erreur_AQRS] ;
    all_EDR_noWin=[all_EDR_noWin; AQRS];
end

[res.RQI_fft_RRI, res.RQI_autocorr_RRI, res.RQI_periodicite_RRI,...
    res.RQI_NRMSE_RRI, res.RQI_FFT_autocorr_RRI, erreur_RRI ] = ...
    indice_RQI_overlap(RRI,EDRfs,win,fRange);
res.RQI_sum_fft_autocorr_RRI=res.RQI_fft_RRI+res.RQI_autocorr_RRI;
indx_RQI=[indx_RQI ; getfield(res,[fld 'RRI'])];
indx_erreur  =[indx_erreur; erreur_RRI] ;
all_EDR_noWin=[all_EDR_noWin; RRI];

[res.RQI_fft_QRA, res.RQI_autocorr_QRA, res.RQI_periodicite_QRA,...
    res.RQI_NRMSE_QRA, res.RQI_FFT_autocorr_QRA, erreur_QRA] = ...
    indice_RQI_overlap(QRA,EDRfs,win,fRange);
res.RQI_sum_fft_autocorr_QRA=res.RQI_fft_QRA+res.RQI_autocorr_QRA;
indx_RQI=[indx_RQI ; getfield(res,[fld 'QRA'])];
indx_erreur  =[indx_erreur; erreur_QRA] ;
all_EDR_noWin=[all_EDR_noWin; QRA];


decalage=win.points/2;
ttot_t=[(decalage)/EDRfs:win.step/EDRfs:((win.N-1)*win.step+decalage)/EDRfs];

end

