function [ttot] = ttot_from_resp(handles,seuilCD)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


bwfs=str2double(get(handles.bwfs,'String'));
bw_filt=handles.bw_filt;
win.duration=str2double(get(handles.winLength,'String'));
win.overlap=str2double(get(handles.overlap,'String'))/100;
win.points=win.duration*bwfs;
win.step=win.points*(1-win.overlap);
win.N=fix((length(handles.bw_filt)-win.overlap*win.points)/win.step);
[mntab_respi,mxtab_respi]=cycledet_filt(bw_filt,seuilCD,bwfs);
[ttot, ttot_t] = calcul_ttot(mntab_respi,bwfs,1,win);

end

