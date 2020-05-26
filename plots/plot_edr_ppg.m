function [handles, hObject] = plot_edr_ppg(handles,hObject)
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here

if isfield(handles,'RPA')
    EDRfs=str2double(get(handles.EDRfs,'String'));
    EDR_T=[0:1/EDRfs:1/EDRfs*(length(handles.RPA)-1)];
    
    if isfield(handles,'RPA_filt')
        RPA=handles.RPA_filt;
        QRA=handles.QRA_filt;
        RRI=handles.RRI_filt;
    else
        RPA=handles.RPA-mean(handles.RPA);
        QRA=handles.QRA-mean(handles.QRA);
        RRI=handles.RRI-mean(handles.RRI);
    end
    
    if get(handles.plotRQI,'Value')==1
        if ~isfield(handles,'RQI_indx')
            warning off
            [handles.indx_RQI,handles.ttot_t] = calculate_rqi(handles);
            warning on
        end
        
        % display
        myplotyy(handles.RPAaxes,EDR_T,RPA-mean(RPA),EDRfs,handles.ttot_t,handles.indx_RQI(1,:),'RIAV');
        legend("EDR","RQI")
        myplotyy(handles.RRIaxes,EDR_T,RRI-mean(RRI),EDRfs,handles.ttot_t,handles.indx_RQI(2,:),'RIFV');
        myplotyy(handles.QRAaxes,EDR_T,QRA-mean(QRA),EDRfs,handles.ttot_t,handles.indx_RQI(3,:),'RIIV');
    elseif get(handles.plotRef,'Value')==1 && isfield(handles,'bw_filt')
        bw=handles.bw_filt;
        bwfs=str2double(get(handles.bwfs,'String'));
        bw_T=[0:1/bwfs:1/bwfs*(length(bw)-1)];
        
        %display
        myplotyy(handles.RPAaxes,EDR_T,RPA-mean(RPA),EDRfs,bw_T,bw,'RIAV');
        legend("EDR","reference")
        myplotyy(handles.RRIaxes,EDR_T,RRI-mean(RRI),EDRfs,bw_T,bw,'RIFV');
        myplotyy(handles.QRAaxes,EDR_T,QRA-mean(QRA),EDRfs,bw_T,bw,'RIIV'); 
        
    else
        % display
        myplotyy(handles.RPAaxes,EDR_T,RPA-mean(RPA),EDRfs,[],[],'RIAV');
        myplotyy(handles.RRIaxes,EDR_T,RRI-mean(RRI),EDRfs,[],[],'RIFV');
        myplotyy(handles.QRAaxes,EDR_T,QRA-mean(QRA),EDRfs,[],[],'RIIV'); 
       
    end
end

end

