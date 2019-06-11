function [mntab,mxtab]=cycledet_filt(r,th,fs)
% CYCLEDET filtered detection : 
% Entr?es
%       r: vecteur Nx1 d'amplitudes d 
%       th: seuil relatif ??l'amp pr?c?dent
%       fs : freq d'?chant.
% Sorties: 
%  mntab, mxtab: matrices Nx2 contenant les indices d'?chantillons (temps /fs) des minima et maxima


mxtab = [];
mntab = [];

r = r(:); 

% -------------------- Detection de max et min  ---------------------------
 % Init : find the first max and min 
r_test = r(1:fs*10); % 5-sec period to initialize  
delta=iqr(r_test)*.10;
mn = Inf; mx = -Inf;
mnpos = NaN; mxpos = NaN;
lookformax = 1; 

j=1; 
while isempty(mntab ) && j< length(r)
  pnt = r(j);
  if pnt > mx, mx = pnt; mxpos = j; end
  if pnt < mn, mn = pnt; mnpos = j; end
  if lookformax % recherche de max suivant
    if pnt < mx-delta
      mxtab = [mxtab ; mxpos mx];
      mn = pnt; mnpos = j;
      lookformax = 0;
    end  
  else
    if pnt > mn+delta  % recherche min suivant
      mntab = [mntab ; mnpos mn];
      mx = pnt; mxpos = j;
      lookformax = 1;
    end
  end
     j=j+1; 
end

if isempty(mntab)
    return;  % sort de la fonction
 
end
% init delta
delta = abs(mxtab(1,2) - mntab(1,2))*th; 

% filter from j : length(r)
for i=j:length(r)
  pnt = r(i);
  if pnt > mx, mx = pnt; mxpos = i; end
  if pnt < mn, mn = pnt; mnpos = i; end
  if lookformax % recherche de max suivant
    if pnt < mx-delta
      mxtab = [mxtab ; mxpos mx];
      mn = pnt; mnpos = i;
      delta = delta*.8+.2*(abs(mxtab(end,2) - mntab(end,2))*th); 
      lookformax = 0;
    end  
  else
    if pnt > mn+delta  % recherche min suivant
      mntab = [mntab ; mnpos mn];
      mx = pnt; mxpos = i;
      delta = delta*.8+.2*(abs(mxtab(end,2) - mntab(end,2))*th); 
      lookformax = 1;
    end
  end
end
end
