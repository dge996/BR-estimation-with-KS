function [handles] = plot_br(handles,ttot_est,ttot_t,indx_lowqual)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

axes(handles.RespAxes)
cla reset
plot(ttot_t,60./ttot_est)
Legend{1}="Estimated";
xlabel('time [s]')
ylabel('BR (bpm)')
hold on
idLegend=2;
if ~isempty(indx_lowqual)
    plot(ttot_t(indx_lowqual),60./ttot_est(indx_lowqual),'ro')
    Legend{2}="Low quality EDR";
    idLegend=idLegend+1;
end

if isfield(handles,'bw_filt')
    bwfs=str2double(get(handles.bwfs,'String'));
    win.duration=str2double(get(handles.winLength,'String'));
    win.overlap=str2double(get(handles.overlap,'String'))/100;
    win.points=win.duration*bwfs;
    win.step=win.points*(1-win.overlap);
    win.N=fix((length(handles.bw_filt)-win.overlap*win.points)/win.step);
    [mntab_respi,mxtab_respi]=cycledet_filt(handles.bw_filt,0.15,bwfs);
    [ttot_ref, ttot_t] = calcul_ttot(mntab_respi,bwfs,1,win);
    plot(ttot_t,60./ttot_ref)
    Legend{idLegend}="Reference";
elseif isfield(handles,'ttot_ref')
    %- plot ttot ref ici
end
legend(Legend)
set(handles.RespAxes,'XMinorTick','on')
%set(get(gca,'YLabel'), 'Rotation',0, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
grid on
axis tight

end

