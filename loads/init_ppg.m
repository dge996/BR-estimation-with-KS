function [handles, hObject] = init_ppg(handles, hObject, path, file)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    % Remise a zero des tracés
    arrayfun(@reset,(findall(0,'type','axes')));
    arrayfun(@cla,(findall(0,'type','axes')));
    axesToDel=findall(0,'type','axes');
    axesToDel=axesToDel(find(axesToDel~=handles.RPAaxes & ...
        axesToDel~=handles.QRAaxes & axesToDel~=handles.AQRSaxes & ...
        axesToDel~=handles.RRIaxes & axesToDel~=handles.ecgAxes & ...
        axesToDel~=handles.RespAxes));
    delete(axesToDel);
    set(handles.plotRQI,'Value',0);
    set(handles.plotRef,'Value',0);
    set(handles.plot_tQRS,'Value',0);
    handles.ECGpath = path;
    handles.ECGfile = file;
    
    % Changement des noms ECG->PPG
    set(handles.textFecg,'String', 'PPG fs :');
    set(handles.text4,'String', 'PPG filtering (Butterworth) :');
    set(handles.filtreECG,'String', 'Filter PPG');
    set(handles.plot_tQRS,'Visible', 'off');
    set(handles.EDR_1,'String', 'RIAV');
    set(handles.EDR_4,'String', 'RIIV');
    set(handles.EDR_2,'String', 'RIFV');
    set(handles.EDR_3,'Value', 0);
    set(handles.EDR_3,'Visible', 'off');
    set(handles.AQRSaxes,'Visible', 'off');
    
    % Tracé
    guidata(hObject, handles);
    [handles] = plot_ppg(handles);
    
    handles.sigType='PPG';
    
end

