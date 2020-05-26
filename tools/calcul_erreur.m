function [RMSE,erreur_absolue,nan_indice,erreur] = calcul_erreur(x,y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    nan_indice_x =find(isnan(x));
    x(nan_indice_x)=[];
    y(nan_indice_x)=[];
    
    nan_indice_y =find(isnan(y));
    x(nan_indice_y)=[];
    y(nan_indice_y)=[];
    nan_indice = [nan_indice_x nan_indice_y ];
%   erreur_absolue =abs((60./x)-(60./y))/(60./x);  % erreur BR 
    erreur_absolue =abs((60./x)-(60./y));  % absolute error breath/min
    erreur =(60./x)-(60./y);  % absolute error breath/min
%   erreur_absolue =abs((x-y));  % erreur BR 

    SE = ((60./x )- (60./y)).^2;
    RMSE = sqrt(mean(SE));

end

