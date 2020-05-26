function [handles] = plot_ecg(handles)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

ecgfs=str2double(get(handles.ecgfs,'String'));
if isfield(handles,'ecg_filt')
    Legend{1}="filtered ECG";
    ecg=handles.ecg_filt;
else 
    Legend{1}="ECG";
    ecg=handles.ecg_brut-mean(handles.ecg_brut);
end
t=[0:1/ecgfs:1/ecgfs*(length(ecg)-1)];

axes(handles.ecgAxes)
cla reset
plot(t, ecg)
xlabel('time [s]')
ylabel('ecg')
set(handles.ecgAxes,'XMinorTick','on')
set(get(gca,'YLabel'), 'Rotation',0, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
grid on
axis tight
set(gcf,'UserData',axis);
    
if get(handles.plot_tQRS,'Value')==1 && isfield(handles,'R_i')
    R_i=handles.R_i;
    hold on 
    handles.plottQRS(1)=plot((R_i-1)./ecgfs,ecg(R_i),'*');
    Legend{2}="R";
    if isfield(handles,'Q_i')
        Q_i=handles.Q_i;
        S_i=handles.S_i;
        handles.plottQRS(2)=plot((Q_i-1)./ecgfs,ecg(Q_i),'*');
    	handles.plottQRS(3)=plot((S_i-1)./ecgfs,ecg(S_i),'*');
        Legend{3}="Q";
        Legend{4}="S";
    end
end
legend(Legend)

end

