function [handles] = plot_ppg(handles)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

ecgfs=str2double(get(handles.ecgfs,'String'));
if isfield(handles,'ecg_filt')
    Legend{1}="filtered PPG";
    ecg=handles.ecg_filt;
else 
    Legend{1}="PPG";
    ecg=handles.ecg_brut-mean(handles.ecg_brut);
end
t=[0:1/ecgfs:1/ecgfs*(length(ecg)-1)];

axes(handles.ecgAxes)
cla reset
plot(t, ecg)
xlabel('time [s]')
ylabel('ppg')
set(handles.ecgAxes,'XMinorTick','on')
set(get(gca,'YLabel'), 'Rotation',0, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
grid on
axis tight
set(gcf,'UserData',axis);
legend(Legend)

end

