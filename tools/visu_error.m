function [] = visu_error(handles)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if isfield(handles,'bw_filt')
    [RPA,QRA,RRI,AQRS,EDRfs,win,fld,seuil] = init_rqi_calculation(handles);
    seuilCD=0.5;
    [ttot_RPA] = ttot_from_edr(RPA,EDRfs,win,seuilCD);
    [ttot_QRA] = ttot_from_edr(QRA,EDRfs,win,seuilCD);
    [ttot_RRI] = ttot_from_edr(RRI,EDRfs,win,seuilCD);
    if strcmp(handles.sigType, 'ECG')
        [ttot_AQRS] = ttot_from_edr(AQRS,EDRfs,win,seuilCD)
    end
    
   [ttot_ref] = ttot_from_resp(handles,seuilCD);
    
    if isfield(handles,'ttot_sansfusion')
        ttot_sansfusion=handles.ttot_sansfusion;
    else
        ttot_sansfusion=nan(1,length(ttot_ref));
    end
    if isfield(handles,'ttot_fusion')
        ttot_fusion=handles.ttot_fusion;
    else
        ttot_fusion=nan(1,length(ttot_ref));
    end
    
    [RMSE_RPA,MAE_RPA] = calcul_erreur(ttot_ref,ttot_RPA);
    [RMSE_QRA,MAE_QRA] = calcul_erreur(ttot_ref,ttot_QRA);
    [RMSE_RRI,MAE_RRI] = calcul_erreur(ttot_ref,ttot_RRI);
    if strcmp(handles.sigType, 'ECG')
        [RMSE_AQRS,MAE_AQRS] = calcul_erreur(ttot_ref,ttot_AQRS);
    else
        RMSE_AQRS=[];
        MAE_AQRS=[];
    end
    [RMSE_sansfusion,MAE_sansfusion] = calcul_erreur(ttot_ref,ttot_sansfusion);
    [RMSE_fusion,MAE_fusion] = calcul_erreur(ttot_ref,ttot_fusion);
    
    plot_erreur(MAE_RPA,MAE_RRI,MAE_QRA,MAE_AQRS,MAE_sansfusion,MAE_fusion,handles.sigType)
end
end
