function [] = plot_erreur(MAE_RPA,MAE_RRI,MAE_QRA,MAE_AQRS,MAE_sansfusion,MAE_fusion,stype)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

figure('name','Erreur Absolue')
C = [MAE_RPA MAE_RRI MAE_QRA MAE_AQRS MAE_sansfusion MAE_fusion];
if strcmp(stype, 'ECG')
    grp = [repmat("RPA",1,length(MAE_RPA)),repmat("RRI",1,length(MAE_RRI)), ...
        repmat("QRA",1,length(MAE_QRA)),repmat("AQRS",1,length(MAE_AQRS)),...
        repmat("no fusion",1,length(MAE_sansfusion)),repmat("fusion",1,length(MAE_fusion))];
elseif strcmp(stype, 'PPG')
    grp = [repmat("RIAV",1,length(MAE_RPA)),repmat("RIFV",1,length(MAE_RRI)), ...
        repmat("RIIV",1,length(MAE_QRA)),repmat("AQRS",1,length(MAE_AQRS)),...
        repmat("no fusion",1,length(MAE_sansfusion)),repmat("fusion",1,length(MAE_fusion))];
end
positions = [1 2 3 4 5 6];
set(gcf,'Color','white')
boxplot(C',grp')
set(gca,'xtick',[mean(positions(1)) mean(positions(2)) mean(positions(3)) mean(positions(4)) mean(positions(5)) mean(positions(6))])
ylabel('absolute error [bpm]','fontsize',25)

end

