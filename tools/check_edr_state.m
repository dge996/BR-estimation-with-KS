function [indx_RQI,indx_erreur,all_EDR_noWin] = check_edr_state(hEDR,iedr,indx_RQI,indx_erreur,all_EDR_noWin)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if get(hEDR,'Value')==0
    indx_RQI(iedr,:)=[];
    indx_erreur(iedr,:)=[];
    all_EDR_noWin(iedr,:)=[];
end
    
end

