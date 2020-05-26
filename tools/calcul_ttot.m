function [ ttot1,x1 ] = calcul_ttot(mntab,bwfs,b_med,window)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%  b_med = 0 : all ttot are calculated
%  b_med = 1 : only the median value is provided
   
    
    decalage = window.points/2; % les points positionn�s au milieu de la fenetre ex si windows_duration =10 => 10/2 =5
    ttot1=[];
    x1=[];
    
    for i=1:window.N

        indx = find(mntab(:,1)>(i-1)*window.step+1 & mntab(:,1)<=(i-1)*window.step+window.points);
        if i>1 & min(indx)~=1
            indx = [min(indx)-1; indx];  % pour completer le cycle
        end
        v= mntab(indx,1)/bwfs;
        ttot =diff(v);
        
  
%       std_ttot = std(ttot);
%       std_ttot_vector = [std_ttot_vector std_ttot];
%       kurt_ttot = kurtosis(ttot);
%       kurt_ttot_vector = [kurt_ttot_vector kurt_ttot];

       if b_med==1   % calcul median des cycles respiratoires (ttot)
           ttot = median(ttot);
           x1=[x1 ((i-1)*window.step+1+decalage)/bwfs];
        else
           x1 = [ x1 (ones(1,length(ttot))*(i-1)*window.step+1+decalage)./bwfs]; % on sort l'axe de temps (correspondre entre fenetre et ttot)
        
        end
        ttot1= [ttot1 ttot'];  % sort vector ttot en ligne
    end
    

%x1 = (1:length(ttot1))*10-5; 


end
