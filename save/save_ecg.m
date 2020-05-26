function [] = save_ecg(handles, pathsave, filename)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

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
isFiltered=0;
if isfield(handles,'RPA_filt')
    EDR_RPA=handles.RPA_filt;
    EDR_QRA=handles.QRA_filt;
    EDR_RRI=handles.RRI_filt;
    EDR_AQRS=handles.AQRS_filt;
    save([pathsave filename],'EDR_RPA','EDR_QRA','EDR_RRI','EDR_AQRS',...
        '-append');
    isFiltered=1;
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
if isFiltered==1
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

end

