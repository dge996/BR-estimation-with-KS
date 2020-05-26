function [] = save_ppg(handles, pathsave, filename)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

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

