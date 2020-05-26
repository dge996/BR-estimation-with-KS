function [handles,handlesCopy] = init_handles_and_axes(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

linkaxes(findall(0,'type','axes'),'x');
handlesCopy=handles;
handles=rmfield2(handles,'RPA','RRI','AQRS','QRA','RPA_filt','RRI_filt',...
    'AQRS_filt','QRA_filt','indx_RQI','bw_brut','bw_filt',...
    'ecg_filt','Q_i','S_i','ttot_sansfusion','ttot_t','R_i',...
    'ttot_fusion');

end

