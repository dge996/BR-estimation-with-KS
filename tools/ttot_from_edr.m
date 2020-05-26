function [ttot] = ttot_from_edr(sig,sigfs,win,seuilCD)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[mntab,mxtab]=cycledet_filt(sig,seuilCD,sigfs);
mxtab = mxtab(2:end,:);
[ttot] = calcul_ttot(mxtab,sigfs,1,win);

end

