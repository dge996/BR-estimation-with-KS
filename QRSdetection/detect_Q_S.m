function [handles] = detect_Q_S(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%- Detecte les pic Q et S à partir des pics R

sig=handles.ecg_brut; 
ecgfs=str2double(get(handles.ecgfs,'String'));
R_i=handles.R_i;
Q_i=[];
S_i=[];
delFirst=0;

% detection of pic Q
window1=30/1000; 
for ii=1:length(R_i)
    if R_i(ii)-round(window1*ecgfs) < 0
        % Cas ou le pic Q est en dehors du signal ecg 
        delFirst=1;
    else
        vecteur = sig(R_i(ii)-round(window1*ecgfs):R_i(ii));
        indice_min = find(vecteur ==min(vecteur));  % trouve indice de min dns le vcteur
        Q_i(ii) =indice_min(end)+R_i(ii)-round(window1*ecgfs)-1; % mettre indice de min dans le signal original ECG
    end
end
if delFirst==1
    R_i=R_i(2:end);
    Q_i=Q_i(2:end);
end

% detection of pic S
window2=30/1000;
for ii=1:length(R_i)
    if R_i(ii)+round(window2*ecgfs) > length(sig)
        % Cas ou le pic S est en dehors du signal ecg
        R_i=R_i(1:end-1);
        Q_i=Q_i(1:end-1);
        break;
    end
    vecteur = sig(R_i(ii):R_i(ii)+round(window2*ecgfs));
    indice_min = find(vecteur == min(vecteur));  % trouve indice de min dns le vcteur
    S_i(ii) =indice_min(1)+R_i(ii)-1; % mettre indice de min dans le signal original ECG
end

handles.Q_i=Q_i;
handles.S_i=S_i;
handles.R_i=R_i;

end

