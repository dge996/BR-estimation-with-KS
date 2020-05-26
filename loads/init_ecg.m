function [handles, hObject] = init_ecg(handles, hObject, path, file)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    %Remise a zero des tracés
    set(handles.plotRQI,'Value',0);
    set(handles.plotRef,'Value',0);
    set(handles.plot_tQRS,'Value',0);
    arrayfun(@reset,(findall(0,'type','axes')));
    arrayfun(@cla,(findall(0,'type','axes')));

    handles.ECGpath = path;
    handles.ECGfile = file;
    
    % Changement des noms PPG->ECG
    set(handles.textFecg,'String', 'ECG fs :');
    set(handles.text4,'String', 'ECG filtering (Butterworth) :');
    set(handles.filtreECG,'String', 'Filter ECG');
    set(handles.plot_tQRS,'String', 'plot R peaks');
    set(handles.plot_tQRS,'Visible', 'on');
    set(handles.EDR_1,'String', 'RPA');
    set(handles.EDR_4,'String', 'QRA');
    set(handles.EDR_2,'String', 'RRI');
    set(handles.EDR_3,'Value', 1);
    set(handles.EDR_3,'Visible', 'on');
    set(handles.AQRSaxes,'Visible', 'on');
    
    % Tracé
    guidata(hObject, handles);
    [handles] = plot_ecg(handles);
    
    handles.sigType='ECG';
    
end

